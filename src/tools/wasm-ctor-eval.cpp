/*
 * Copyright 2017 WebAssembly Community Group participants
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
// Loads wasm plus a list of functions that are global ctors, i.e.,
// are to be executed. It then executes as many of them as it can,
// applying their changes to memory as needed, then writes it. In
// other words, this executes code at compile time to speed up
// startup later.
//

#include <memory>

#include "pass.h"
#include "support/command-line.h"
#include "support/file.h"
#include "support/colors.h"
#include "wasm-io.h"
#include "wasm-interpreter.h"

using namespace wasm;

struct FailToEvalException {
  std::string why;
  FailToEvalException(std::string why) : why(why) {}
};

struct CtorEvalExternalInterface : ModuleInstance::ExternalInterface {
  Module* wasm;

  void importGlobals(std::map<Name, Literal>& globals, Module& wasm_) override {
    wasm = &wasm_;
  }

  Literal callImport(Import *import, LiteralList& arguments) override {
    throw FailToEvalException("call import");
  }

  Literal callTable(Index index, LiteralList& arguments, WasmType result, ModuleInstance& instance) override {
    throw FailToEvalException("call table");
  }

  Literal load(Load* load, Address addr) override {
    // load from the memory segments
    switch (load->type) {
      case i32: {
        switch (load->bytes) {
          case 1: return load->signed_ ? Literal((int32_t)doLoad<int8_t>(addr)) : Literal((int32_t)doLoad<uint8_t>(addr));
          case 2: return load->signed_ ? Literal((int32_t)doLoad<int16_t>(addr)) : Literal((int32_t)doLoad<uint16_t>(addr));
          case 4: return load->signed_ ? Literal((int32_t)doLoad<int32_t>(addr)) : Literal((int32_t)doLoad<uint32_t>(addr));
          default: WASM_UNREACHABLE();
        }
        break;
      }
      case i64: {
        switch (load->bytes) {
          case 1: return load->signed_ ? Literal((int64_t)doLoad<int8_t>(addr)) : Literal((int64_t)doLoad<uint8_t>(addr));
          case 2: return load->signed_ ? Literal((int64_t)doLoad<int16_t>(addr)) : Literal((int64_t)doLoad<uint16_t>(addr));
          case 4: return load->signed_ ? Literal((int64_t)doLoad<int32_t>(addr)) : Literal((int64_t)doLoad<uint32_t>(addr));
          case 8: return load->signed_ ? Literal((int64_t)doLoad<int64_t>(addr)) : Literal((int64_t)doLoad<uint64_t>(addr));
          default: WASM_UNREACHABLE();
        }
        break;
      }
      case f32: return Literal(doLoad<float>(addr));
      case f64: return Literal(doLoad<double>(addr));
      default: WASM_UNREACHABLE();
    }
  }

  void store(Store* store, Address addr, Literal value) override {
    // store to the memory segments
    switch (store->valueType) {
      case i32: {
        switch (store->bytes) {
          case 1: doStore<int8_t>(addr, value.geti32()); break;
          case 2: doStore<int16_t>(addr, value.geti32()); break;
          case 4: doStore<int32_t>(addr, value.geti32()); break;
          default: WASM_UNREACHABLE();
        }
        break;
      }
      case i64: {
        switch (store->bytes) {
          case 1: doStore<int8_t>(addr, (int8_t)value.geti64()); break;
          case 2: doStore<int16_t>(addr, (int16_t)value.geti64()); break;
          case 4: doStore<int32_t>(addr, (int32_t)value.geti64()); break;
          case 8: doStore<int64_t>(addr, value.geti64()); break;
          default: WASM_UNREACHABLE();
        }
        break;
      }
      // write floats carefully, ensuring all bits reach memory
      case f32: doStore<int32_t>(addr, value.reinterpreti32()); break;
      case f64: doStore<int64_t>(addr, value.reinterpreti64()); break;
      default: WASM_UNREACHABLE();
    }
  }

  void growMemory(Address /*oldSize*/, Address newSize) override {
    throw FailToEvalException("grow memory");
  }

  void trap(const char* why) override {
    throw FailToEvalException(std::string("trap: ") + why);
  }

private:
  // TODO: handle unaligned too, see shell-interface

  template <typename T>
  T* getMemory(Address address) {
    for (auto& segment : wasm->memory.segments) {
      auto* offset = segment.offset->dynCast<Const>();
      if (!offset) {
        throw FailToEvalException("non-constant segment");
      }
      auto start = offset->value.getInteger();
      if (start <= address && address < start + segment.data.size() - sizeof(T)) {
        return (T*)(&segment.data[address - start]);
      }
      if (address >= start + segment.data.size()) {
        continue; // can be in next segment
      }
      throw FailToEvalException("not in next segment"); // either before, which is impossible, or split among segments TODO merge them
    }
    throw FailToEvalException("no segment"); // no segment found TODO create one
  }

  template <typename T>
  void doStore(Address address, T value) {
    *getMemory<T>(address) = value;
  }

  template <typename T>
  T doLoad(Address address) {
    return *getMemory<T>(address);
  }
};

void evalCtors(Module& wasm, std::vector<std::string> ctors) {
  CtorEvalExternalInterface interface;
  ModuleInstance instance(wasm, &interface);
  // go one by one, in order, until we fail
  // TODO: if we knew priorities, we could reorder?
  for (auto& ctor : ctors) {
    std::cerr << "trying to eval " << ctor << '\n';
    // snapshot memory, as either the entire function is done, or none
    auto memoryBefore = wasm.memory;
    try {
      instance.callExport(ctor);
    } catch (FailToEvalException& fail) {
      // that's it, we failed, so stop here, cleaning up partial
      // memory changes first
      std::cerr << "  ...stopping since could not eval: " << fail.why << "\n";
      wasm.memory = memoryBefore;
      return;
    }
    std::cerr << "  ...success!\n";
    // success, the entire function was evalled!
    auto* exp = wasm.getExport(ctor);
    auto* func = wasm.getFunction(exp->value);
    func->body = wasm.allocator.alloc<Nop>();
  }
}

//
// main
//

int main(int argc, const char* argv[]) {
  Name entry;
  std::vector<std::string> passes;
  PassOptions passOptions;
  bool emitBinary = true;
  bool debugInfo = false;
  std::string ctorsString;

  Options options("wasm-opt", "Optimize .wast files");
  options
      .add("--output", "-o", "Output file (stdout if not specified)",
           Options::Arguments::One,
           [](Options* o, const std::string& argument) {
             o->extra["output"] = argument;
             Colors::disable();
           })
      .add("--emit-text", "-S", "Emit text instead of binary for the output file",
           Options::Arguments::Zero,
           [&](Options *o, const std::string &argument) { emitBinary = false; })
      .add("--debuginfo", "-g", "Emit names section and debug info",
           Options::Arguments::Zero,
           [&](Options *o, const std::string &arguments) { debugInfo = true; })
      .add("--ctors", "-c", "Comma-separated list of global constructor functions to evaluate",
           Options::Arguments::One,
           [&](Options* o, const std::string& argument) {
             ctorsString = argument;
           })
      .add_positional("INFILE", Options::Arguments::One,
                      [](Options* o, const std::string& argument) {
                        o->extra["infile"] = argument;
                      });
  options.parse(argc, argv);

  auto input(read_file<std::string>(options.extra["infile"], Flags::Text, options.debug ? Flags::Debug : Flags::Release));

  Module wasm;

  {
    if (options.debug) std::cerr << "reading...\n";
    ModuleReader reader;
    reader.setDebug(options.debug);

    try {
      reader.read(options.extra["infile"], wasm);
    } catch (ParseException& p) {
      p.dump(std::cerr);
      Fatal() << "error in parsing input";
    }
  }

  // get list of ctors, and eval them
  std::vector<std::string> ctors;
  std::istringstream stream(ctorsString);
  std::string temp;
  while (std::getline(stream, temp, ',')) {
    ctors.push_back(temp);
  }
  evalCtors(wasm, ctors);

  if (options.extra.count("output") > 0) {
    if (options.debug) std::cerr << "writing..." << std::endl;
    ModuleWriter writer;
    writer.setDebug(options.debug);
    writer.setBinary(emitBinary);
    writer.setDebugInfo(debugInfo);
    writer.write(wasm, options.extra["output"]);
  }
}
