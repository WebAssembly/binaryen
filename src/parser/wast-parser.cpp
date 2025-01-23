/*
 * Copyright 2024 WebAssembly Community Group participants
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

#include "lexer.h"
#include "literal.h"
#include "wat-parser.h"

namespace wasm::WATParser {

using namespace std::string_view_literals;

namespace {

Result<Literal> const_(Lexer& in) {
  if (in.takeSExprStart("ref.extern"sv)) {
    auto n = in.takeI32();
    if (!n) {
      return in.err("expected host reference payload");
    }
    if (!in.takeRParen()) {
      return in.err("expected end of ref.extern");
    }
    // Represent host references as externalized i31s.
    return Literal::makeI31(*n, Unshared).externalize();
  }
  return parseConst(in);
}

Result<Literals> consts(Lexer& in) {
  Literals lits;
  while (!in.peekRParen()) {
    auto l = const_(in);
    CHECK_ERR(l);
    lits.push_back(*l);
  }
  return lits;
}

MaybeResult<Action> maybeAction(Lexer& in) {
  if (in.takeSExprStart("invoke"sv)) {
    auto id = in.takeID();
    auto name = in.takeName();
    if (!name) {
      return in.err("expected export name");
    }
    auto args = consts(in);
    CHECK_ERR(args);
    if (!in.takeRParen()) {
      return in.err("expected end of invoke action");
    }
    return InvokeAction{id, *name, *args};
  }

  if (in.takeSExprStart("get"sv)) {
    auto id = in.takeID();
    auto name = in.takeName();
    if (!name) {
      return in.err("expected export name");
    }
    if (!in.takeRParen()) {
      return in.err("expected end of get action");
    }
    return GetAction{id, *name};
  }

  return {};
}

Result<Action> action(Lexer& in) {
  if (auto a = maybeAction(in)) {
    CHECK_ERR(a);
    return *a;
  }
  return in.err("expected action");
}

// (module id? binary string*)
// (module id? quote string*)
// (module ...)
Result<WASTModule> wastModule(Lexer& in, bool maybeInvalid = false) {
  Lexer reset = in;
  if (!in.takeSExprStart("module"sv)) {
    return in.err("expected module");
  }
  // TODO: use ID?
  [[maybe_unused]] auto id = in.takeID();
  QuotedModuleType type;
  if (in.takeKeyword("quote"sv)) {
    type = QuotedModuleType::Text;
  } else if (in.takeKeyword("binary")) {
    type = QuotedModuleType::Binary;
  } else if (maybeInvalid) {
    // This is not a quoted text or binary module, so it must be a normal inline
    // module, but we might not be able to parse it. Treat it as through it were
    // a quoted module instead.
    int count = 1;
    while (count && in.takeUntilParen()) {
      if (in.takeLParen()) {
        ++count;
      } else if (in.takeRParen()) {
        --count;
      } else {
        return in.err("unexpected end of script");
      }
    }
    std::string mod(reset.next().substr(0, in.getPos() - reset.getPos()));
    return QuotedModule{QuotedModuleType::Text, mod};
  } else {
    // This is a normal inline module that should be parseable. Reset to the
    // start and parse it normally.
    in = std::move(reset);
    auto wasm = std::make_shared<Module>();
    CHECK_ERR(parseModule(*wasm, in));
    return wasm;
  }

  // We have a quote or binary module. Collect its contents.
  std::stringstream ss;
  while (auto s = in.takeString()) {
    ss << *s;
  }

  if (!in.takeRParen()) {
    return in.err("expected end of module");
  }

  return QuotedModule{type, ss.str()};
}

Result<NaNKind> nan(Lexer& in) {
  if (in.takeKeyword("nan:canonical"sv)) {
    return NaNKind::Canonical;
  }
  if (in.takeKeyword("nan:arithmetic"sv)) {
    return NaNKind::Arithmetic;
  }
  return in.err("expected NaN result pattern");
}

Result<ExpectedResult> result(Lexer& in) {
  Lexer constLexer = in;
  auto c = const_(constLexer);
  // TODO: Generating and discarding errors like this can lead to quadratic
  // behavior. Optimize this if necessary.
  if (!c.getErr()) {
    in = constLexer;
    return *c;
  }

  // If we failed to parse a constant, we must have either a nan pattern or a
  // reference.
  if (in.takeSExprStart("f32.const"sv)) {
    auto kind = nan(in);
    CHECK_ERR(kind);
    if (!in.takeRParen()) {
      return in.err("expected end of f32.const");
    }
    return NaNResult{*kind, Type::f32};
  }

  if (in.takeSExprStart("f64.const"sv)) {
    auto kind = nan(in);
    CHECK_ERR(kind);
    if (!in.takeRParen()) {
      return in.err("expected end of f64.const");
    }
    return NaNResult{*kind, Type::f64};
  }

  if (in.takeSExprStart("v128.const"sv)) {
    LaneResults lanes;
    if (in.takeKeyword("f32x4"sv)) {
      for (int i = 0; i < 4; ++i) {
        if (auto f = in.takeF32()) {
          lanes.push_back(Literal(*f));
        } else {
          auto kind = nan(in);
          CHECK_ERR(kind);
          lanes.push_back(NaNResult{*kind, Type::f32});
        }
      }
    } else if (in.takeKeyword("f64x2"sv)) {
      for (int i = 0; i < 2; ++i) {
        if (auto f = in.takeF64()) {
          lanes.push_back(Literal(*f));
        } else {
          auto kind = nan(in);
          CHECK_ERR(kind);
          lanes.push_back(NaNResult{*kind, Type::f64});
        }
      }
    } else {
      return in.err("unexpected vector shape");
    }
    if (!in.takeRParen()) {
      return in.err("expected end of v128.const");
    }
    return lanes;
  }

  if (in.takeSExprStart("ref.extern")) {
    if (!in.takeRParen()) {
      return in.err("expected end of ref.extern");
    }
    return RefResult{HeapType::ext};
  }

  if (in.takeSExprStart("ref.func")) {
    if (!in.takeRParen()) {
      return in.err("expected end of ref.func");
    }
    return RefResult{HeapType::func};
  }

  if (in.takeSExprStart("ref.struct")) {
    if (!in.takeRParen()) {
      return in.err("expected end of ref.struct");
    }
    return RefResult{HeapType::struct_};
  }

  if (in.takeSExprStart("ref.array")) {
    if (!in.takeRParen()) {
      return in.err("expected end of ref.array");
    }
    return RefResult{HeapType::array};
  }

  if (in.takeSExprStart("ref.eq")) {
    if (!in.takeRParen()) {
      return in.err("expected end of ref.eq");
    }
    return RefResult{HeapType::eq};
  }

  if (in.takeSExprStart("ref.i31")) {
    if (!in.takeRParen()) {
      return in.err("expected end of ref.i31");
    }
    return RefResult{HeapType::i31};
  }

  if (in.takeSExprStart("ref.i31_shared")) {
    if (!in.takeRParen()) {
      return in.err("expected end of ref.i31_shared");
    }
    return RefResult{HeapTypes::i31.getBasic(Shared)};
  }

  return in.err("unrecognized result");
}

Result<ExpectedResults> results(Lexer& in) {
  ExpectedResults res;
  while (!in.peekRParen()) {
    auto r = result(in);
    CHECK_ERR(r);
    res.emplace_back(std::move(*r));
  }
  return res;
}

// (assert_return action result*)
MaybeResult<AssertReturn> assertReturn(Lexer& in) {
  if (!in.takeSExprStart("assert_return"sv)) {
    return {};
  }
  auto a = action(in);
  CHECK_ERR(a);
  auto expected = results(in);
  CHECK_ERR(expected);
  if (!in.takeRParen()) {
    return in.err("expected end of assert_return");
  }
  return AssertReturn{*a, *expected};
}

// (assert_exception action)
MaybeResult<AssertAction> assertException(Lexer& in) {
  if (!in.takeSExprStart("assert_exception"sv)) {
    return {};
  }
  auto a = action(in);
  CHECK_ERR(a);
  if (!in.takeRParen()) {
    return in.err("expected end of assert_exception");
  }
  return AssertAction{ActionAssertionType::Exception, *a};
}

// (assert_exhaustion action msg)
MaybeResult<AssertAction> assertAction(Lexer& in) {
  ActionAssertionType type;
  if (in.takeSExprStart("assert_exhaustion"sv)) {
    type = ActionAssertionType::Exhaustion;
  } else {
    return {};
  }

  auto a = action(in);
  CHECK_ERR(a);
  auto msg = in.takeString();
  if (!msg) {
    return in.err("expected error message");
  }
  if (!in.takeRParen()) {
    return in.err("expected end of assertion");
  }
  return AssertAction{type, *a};
}

// (assert_malformed module msg)
// (assert_invalid module msg)
// (assert_unlinkable module msg)
MaybeResult<AssertModule> assertModule(Lexer& in) {
  ModuleAssertionType type;
  if (in.takeSExprStart("assert_malformed"sv)) {
    type = ModuleAssertionType::Malformed;
  } else if (in.takeSExprStart("assert_invalid"sv)) {
    type = ModuleAssertionType::Invalid;
  } else if (in.takeSExprStart("assert_unlinkable"sv)) {
    type = ModuleAssertionType::Unlinkable;
  } else {
    return {};
  }

  auto mod = wastModule(in, type == ModuleAssertionType::Invalid);
  CHECK_ERR(mod);
  auto msg = in.takeString();
  if (!msg) {
    return in.err("expected error message");
  }
  if (!in.takeRParen()) {
    return in.err("expected end of assertion");
  }
  return AssertModule{type, *mod};
}

// (assert_trap action msg)
// (assert_trap module msg)
MaybeResult<Assertion> assertTrap(Lexer& in) {
  if (!in.takeSExprStart("assert_trap"sv)) {
    return {};
  }
  auto pos = in.getPos();
  if (auto a = maybeAction(in)) {
    CHECK_ERR(a);
    auto msg = in.takeString();
    if (!msg) {
      return in.err("expected error message");
    }
    if (!in.takeRParen()) {
      return in.err("expected end of assertion");
    }
    return Assertion{AssertAction{ActionAssertionType::Trap, *a}};
  }
  auto mod = wastModule(in);
  if (mod.getErr()) {
    return in.err(pos, "expected action or module");
  }
  auto msg = in.takeString();
  if (!msg) {
    return in.err("expected error message");
  }
  if (!in.takeRParen()) {
    return in.err("expected end of assertion");
  }
  return Assertion{AssertModule{ModuleAssertionType::Trap, *mod}};
}

MaybeResult<Assertion> assertion(Lexer& in) {
  if (auto a = assertReturn(in)) {
    CHECK_ERR(a);
    return Assertion{*a};
  }
  if (auto a = assertException(in)) {
    CHECK_ERR(a);
    return Assertion{*a};
  }
  if (auto a = assertAction(in)) {
    CHECK_ERR(a);
    return Assertion{*a};
  }
  if (auto a = assertModule(in)) {
    CHECK_ERR(a);
    return Assertion{*a};
  }
  if (auto a = assertTrap(in)) {
    CHECK_ERR(a);
    return *a;
  }
  return {};
}

// (register name id?)
MaybeResult<Register> register_(Lexer& in) {
  if (!in.takeSExprStart("register"sv)) {
    return {};
  }
  auto name = in.takeName();
  if (!name) {
    return in.err("expected name");
  }

  // TODO: Do we need to use this optional id?
  in.takeID();

  if (!in.takeRParen()) {
    // TODO: handle optional module id.
    return in.err("expected end of register command");
  }
  return Register{*name};
}

// module | register | action | assertion
Result<WASTCommand> command(Lexer& in) {
  if (auto cmd = register_(in)) {
    CHECK_ERR(cmd);
    return *cmd;
  }
  if (auto cmd = maybeAction(in)) {
    CHECK_ERR(cmd);
    return *cmd;
  }
  if (auto cmd = assertion(in)) {
    CHECK_ERR(cmd);
    return *cmd;
  }
  auto mod = wastModule(in);
  CHECK_ERR(mod);
  return *mod;
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"

Result<WASTScript> wast(Lexer& in) {
  WASTScript cmds;
  while (!in.empty()) {
    size_t line = in.position().line;
    auto cmd = command(in);
    if (auto* err = cmd.getErr(); err && cmds.empty()) {
      // The entire script might be a single module comprising a sequence of
      // module fields with a top-level `(module ...)`.
      auto wasm = std::make_shared<Module>();
      auto parsed = parseModule(*wasm, in.buffer);
      if (parsed.getErr()) {
        // No, that wasn't the problem. Return the original error.
        return Err{err->msg};
      }
      cmds.push_back({WASTModule{std::move(wasm)}, line});
      return cmds;
    }
    CHECK_ERR(cmd);
    cmds.push_back(ScriptEntry{std::move(*cmd), line});
  }
  return cmds;
}

#pragma GCC diagnostic pop

} // anonymous namespace

Result<WASTScript> parseScript(std::string_view in) {
  Lexer lexer(in);
  return wast(lexer);
}

} // namespace wasm::WATParser
