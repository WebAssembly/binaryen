/*
 * Copyright 2026 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
// Automatically batch calls to imports. This can be useful to reduce overhead
// on the wasm/JS boundary. For example, consider this code:
//
//   gl_bind_buffer(10, 20);
//   gl_run_shader(123);
//
// If each of these is a call to a JS import, then we cross the wasm/JS
// boundary twice. Instead, we can serialize the commands we want to run on the
// JS side, and call out once to JS, then read the buffer and execute them both,
// doing a single boundary crossing. If there are very many crossings, this
// batching can be worthwhile.
//
// The idea of batching Web API calls is used in Emscripten's GL proxying,
//
//   https://github.com/emscripten-core/emscripten/tree/main/system/lib/gl
//
// where most functions are proxied in an async way to the main thread, which
// means the calling thread effectively only "flushes" the command buffer when
// we need to execute a synchronous method. The WebCC project does this as well,
//
//   https://github.com/io-eric/webcc/blob/main/docs/architecture.md#architecture
//
// This AutoBatch pass is different in that it *automatically* batches calls,
// without a fixed set of APIs that it recognizes. Whenever it sees an import,
//
//   * If the import has no return value, it wraps it in a function that
//     serializes it to the command buffer.
//   * If the import does have a return value, the wrapper flushes the command
//     buffer before calling it.
//
// The serialization format, and the code to serialize in wasm and deserialize
// in JS, is all generated based on the actual imports seen in the wasm. This
// avoids the "big switch of calls" problem that such proxying/serialization
// implementations usually have, where they map integer IDs to functions to be
// called, which has the result of keeping all those functions alive (since it
// doesn't see the integer IDs actually used at runtime).
//
// A flush() import is added, which is called to flush the command buffer. This
// receives two parameters, one to the start of the buffer and one to the
// location just past the end.
//
//   --pass-arg=autobatch-js@filename
//
//      A filename to write the JS code for deserialization, that is, the
//      implementation of flush() which flushes the command buffer. This code
//      assumes the following variables are available:
//
//        * imports: The import object the wasm is instantiated with, so it can
//                   call imports.
//        * HEAP32: A Uint32Array view on the memory the wasm uses, so we can
//                  read the command buffer.
//        * HEAP64: A BigInt64Array view on the memory.
//        * HEAPF32: A Float32Array view on the memory.
//        * HEAPF64: A Float64Array view on the memory.
//
//   --pass-arg=autobatch-asserts
//
//      This enables extra asserts in the output, like checking if we exceed the
//      size of the command buffer.
//
// TODO: flags to control special exports etc.
//

#include "ir/module-utils.h"
#include "ir/names.h"
#include "pass.h"
#include "support/file.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

struct AutoBatch : public Pass {
  AutoBatch() {}

  // The function imports, in order. This maps ids to names.
  std::vector<Name> imports; /// XXX needed?
  // The reverse map of import names to ids.
  std::unordered_map<Name, Index> importIds;

  // The original imports, before we wrapped them, in order of ids.
  std::vector<Function*> originalImports;

  bool asserts;

  std::unique_ptr<Builder> builder;

  // The name of the global containing the command buffer's base.
  Name commandBufferBaseGlobal;
  // The name of the global containing the command buffer current position
  // relative to the base.
  Name commandBufferPosGlobal;
  // TODO: add a size as well, and a new export to users can set the pos+size.

  // The memory we serialize to.
  Name memory;

  // The internal name of the flush import.
  Name flushName;

  void run(Module* module) override {
    asserts = hasArgument("autobatch-asserts");

    builder = std::make_unique<Builder>(*module);

    // Add the flush import, which receives start, end params.
    flushName = Names::getValidFunctionName(*module, "flush");
    auto flushType =
      Type(Signature({Type::i32, Type::i32}, Type::none), NonNullable, Inexact);
    auto* flushFunc = module->addFunction(
      builder->makeFunction(flushName, flushType, {}, nullptr));
    // TODO: flags?
    flushFunc->module = "autobatch";
    flushFunc->base = "flush";

    // Use the first memory. TODO: use multi-memory?
    assert(!module->memories.empty());
    memory = module->memories[0]->name;

    // Add the command buffer base global.
    commandBufferBaseGlobal = Names::getValidGlobalName(*module, "cmdbufbase");
    // TODO: allow setting a non-0 value here, right now we just use the start
    //       of the memory
    module->addGlobal(builder->makeGlobal(commandBufferBaseGlobal,
                                          Type::i32,
                                          builder->makeConst(int32_t(0)),
                                          Builder::Mutable));

    // Add the command buffer position global.
    commandBufferPosGlobal = Names::getValidGlobalName(*module, "cmdbufpos");
    // TODO: support 64-bit offsets?
    module->addGlobal(builder->makeGlobal(commandBufferPosGlobal,
                                          Type::i32,
                                          builder->makeConst(int32_t(0)),
                                          Builder::Mutable));

    // Build the mapping of integer ID to imports.
    for (auto& func : module->functions) {
      Index id = imports.size();
      imports.push_back(func->name);
      originalImports.push_back(func.get());
      importIds[func->name] = id;
    }

    // Wrap every import (but leave our new import alone).
    for (auto& func : module->functions) {
      if (func->imported() && func->name != flushName) {
        // Copy the original import to create the actual import that the wrapper
        // calls. Doing it this way avoids needing to update callers: we replace
        // the original import in-place, so existing calls go to the wrapper
        // now.
        auto newImportName = Names::getValidFunctionName(*module, func->name);
        ModuleUtils::copyFunction(func.get(), *module, newImportName);

        // This one is no longer an import.
        func->module = func->base = Name();
        assert(!func->imported());
        func->type = func->type.with(Exact);

        // Fill in the wrapper body.
        if (func->getResults() == Type::none) {
          wrapNonReturning(func.get(), newImportName);
        } else {
          wrapReturning(func.get(), newImportName);
        }
      }
    }

    // Emit the JS.
    auto jsFile = getArgumentOrDefault("autobatch-js", "");
    if (jsFile.empty()) {
      std::cerr << "warning: not emitting JS. Use "
                << "--pass-arg=autobatch-js@FILENAME\n";
    } else {
      emitJS(jsFile, module);
    }
  }

  // Serialize a given value to the command buffer. Receives the offset at
  // which to do it, and returns the code to serialize. Updates the offset to
  // the place for the thing after it.
  Expression* serialize(Expression* value, Index& offset) {
    auto type = value->type;
    if (!type.isBasic()) {
      // TODO: if we cannot serialize something, return an error, and the
      // caller can flush and call, giving up on batching.
      Fatal() << "AutoBatch: unsupported compound type " << type;
    }
    switch (type.getBasic()) {
      case Type::i32:
      case Type::i64:
      case Type::f32:
      case Type::f64: {
        auto size = type.getByteSize();
        // Ensure values are aligned.
        auto miss = offset % size;
        if (miss) {
          offset += size - miss;
        }
        auto* ptr = builder->makeGlobalGet(commandBufferBaseGlobal, Type::i32);
        auto* ret =
          builder->makeStore(size, offset, size, ptr, value, type, memory);
        offset += size;
        return ret;
        break;
      }
      default: {
        Fatal() << "AutoBatch: unsupported serialization type " << type;
      }
    }
  }

  // Wrap a function that does not return a result. We add it to the command
  // buffer.
  void wrapNonReturning(Function* func, Name importToCall) {
    std::vector<Expression*> body;

    // Stash the command buffer's position before our additions.
    auto posBefore = Builder::addVar(func, Type::i32);
    body.push_back(builder->makeLocalSet(
      posBefore, builder->makeGlobalGet(commandBufferPosGlobal, Type::i32)));

    Index offset = 0;

    // Serialize the id.
    // TODO: we could use an 8 or 16 bit id when the # of imports is small
    body.push_back(
      serialize(builder->makeConst(int32_t(importIds[func->name])), offset));

    // Serialize the params.
    auto params = func->getParams();
    for (Index i = 0; i < params.size(); i++) {
      body.push_back(serialize(builder->makeLocalGet(i, params[i]), offset));
    }

    // Update the command buffer position.
    auto* total =
      builder->makeBinary(AddInt32,
                          builder->makeLocalGet(posBefore, Type::i32),
                          builder->makeConst(int32_t(offset)));
    body.push_back(builder->makeGlobalSet(commandBufferPosGlobal, total));

    // TODO: add assertion here when asserts

    func->body = builder->makeBlock(body);
  }

  // Wrap a function that returns a result. We flush the command buffer, then
  // call it. TODO: we could also add it to the command buffer itself, to save
  // a call.
  void wrapReturning(Function* func, Name importToCall) {
    std::vector<Expression*> body;

    // Flush the command buffer and rest the position, if we have anything.
    auto* check = builder->makeGlobalGet(commandBufferPosGlobal, Type::i32);
    auto* start = builder->makeGlobalGet(commandBufferBaseGlobal, Type::i32);
    auto* end = builder->makeGlobalGet(commandBufferPosGlobal, Type::i32);
    auto* flush = builder->makeCall(flushName, {start, end}, Type::none);
    auto* reset = builder->makeGlobalSet(commandBufferPosGlobal,
                                         builder->makeConst(int32_t(0)));
    auto* iff = builder->makeIf(check, builder->makeSequence(flush, reset));
    body.push_back(iff);

    // Call the import.
    auto params = func->getParams();
    std::vector<Expression*> args;
    for (Index i = 0; i < params.size(); i++) {
      args.push_back(builder->makeLocalGet(i, params[i]));
    }
    body.push_back(builder->makeCall(importToCall, args, func->getResults()));

    func->body = builder->makeBlock(body);
  }

  void emitJS(const std::string& jsFile, Module* module) {
    Output out(jsFile, Flags::Text);

    // The main loop goes over commands, each time switching over which function
    // to call.
    out << R"(
function flush(pos, end) {
  while (pos != end) {
    auto funcId = HEAP32[pos >> 2];
    pos += 4;
    switch (funcId) {
    }
  }
}
)";

    // Emit deserialization code for each function.
    for (Index id = 0; id < imports.size(); id++) {
      auto* import = originalImports[id];

      // Emit a case for the function.
      out << "\n";
      out << "      case ";
      out << std::to_string(id);
      out << ": {\n";

      // Emit a call to the function.
      out << "        imports[";
      out << "'" << import->module << "'";
      out << "][";
      out << "'" << import->base << "'";
      out << "](";

      // Emit deserialization for each param.
      auto params = import->getParams();
      for (Index i = 0; i < params.size(); i++) {
        auto type = params[i];
        switch (type.getBasic()) {
          case Type::i32:
          case Type::i64:
          case Type::f32:
          case Type::f64: {
            auto size = type.getByteSize();
            // Ensure values are aligned.
            auto miss = offset % size;
            if (miss) {
              offset += size - miss;
            }
            auto* ptr = builder->makeGlobalGet(commandBufferBaseGlobal, Type::i32);
            auto* ret =
              builder->makeStore(size, offset, size, ptr, value, type, memory);
            offset += size;
            return ret;
            break;
          }
          default: {
            Fatal() << "AutoBatch: unsupported serialization type " << type;
          }
        }

      
        body.push_back(serialize(builder->makeLocalGet(i, params[i]), offset));
      }
      out << "      }\n";
    }

    // End the switch, loop, and function.
    out << R"(
    }
  }
}
)";

  }
};

} // anonymous namespace

Pass* createAutoBatchPass() { return new AutoBatch(); }

} // namespace wasm
