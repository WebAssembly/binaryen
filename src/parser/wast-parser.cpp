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
  if (in.takeSExprStart("i32.const"sv)) {
    auto i = in.takeI32();
    if (!i) {
      return in.err("expected i32");
    }
    if (!in.takeRParen()) {
      return in.err("expected end of i32.const");
    }
    return Literal(*i);
  }

  if (in.takeSExprStart("i64.const"sv)) {
    auto i = in.takeI64();
    if (!i) {
      return in.err("expected i64");
    }
    if (!in.takeRParen()) {
      return in.err("expected end of i64.const");
    }
    return Literal(*i);
  }

  if (in.takeSExprStart("f32.const"sv)) {
    auto f = in.takeF32();
    if (!f) {
      return in.err("expected f32");
    }
    if (!in.takeRParen()) {
      return in.err("expected end of f32.const");
    }
    return Literal(*f);
  }

  if (in.takeSExprStart("f64.const"sv)) {
    auto f = in.takeF64();
    if (!f) {
      return in.err("expected f64");
    }
    if (!in.takeRParen()) {
      return in.err("expected end of f64.const");
    }
    return Literal(*f);
  }

  if (in.takeSExprStart("v128.const"sv)) {
    Literal vec;
    if (in.takeKeyword("i8x16"sv)) {
      std::array<Literal, 16> lanes;
      for (int i = 0; i < 16; ++i) {
        auto n = in.takeI8();
        if (!n) {
          return in.err("expected i8");
        }
        lanes[i] = Literal(uint32_t(*n));
      }
      vec = Literal(lanes);
    } else if (in.takeKeyword("i16x8"sv)) {
      std::array<Literal, 8> lanes;
      for (int i = 0; i < 8; ++i) {
        auto n = in.takeI16();
        if (!n) {
          return in.err("expected i16");
        }
        lanes[i] = Literal(uint32_t(*n));
      }
      vec = Literal(lanes);
    } else if (in.takeKeyword("i32x4"sv)) {
      std::array<Literal, 4> lanes;
      for (int i = 0; i < 4; ++i) {
        auto n = in.takeI32();
        if (!n) {
          return in.err("expected i32");
        }
        lanes[i] = Literal(*n);
      }
      vec = Literal(lanes);
    } else if (in.takeKeyword("i64x2"sv)) {
      std::array<Literal, 2> lanes;
      for (int i = 0; i < 2; ++i) {
        auto n = in.takeI64();
        if (!n) {
          return in.err("expected i32");
        }
        lanes[i] = Literal(*n);
      }
      vec = Literal(lanes);
    } else if (in.takeKeyword("f32x4"sv)) {
      std::array<Literal, 4> lanes;
      for (int i = 0; i < 4; ++i) {
        auto f = in.takeF32();
        if (!f) {
          return in.err("expected f32");
        }
        lanes[i] = Literal(*f);
      }
      vec = Literal(lanes);
    } else if (in.takeKeyword("f64x2"sv)) {
      std::array<Literal, 2> lanes;
      for (int i = 0; i < 2; ++i) {
        auto f = in.takeF64();
        if (!f) {
          return in.err("expected f64");
        }
        lanes[i] = Literal(*f);
      }
      vec = Literal(lanes);
    } else {
      return in.err("unexpected vector shape");
    }
    if (!in.takeRParen()) {
      return in.err("expected end of v128.const");
    }
    return vec;
  }

  if (in.takeSExprStart("ref.null"sv)) {
    HeapType type;
    if (in.takeKeyword("extern"sv) || in.takeKeyword("noextern"sv)) {
      type = HeapType::noext;
    } else if (in.takeKeyword("func"sv) || in.takeKeyword("nofunc"sv)) {
      type = HeapType::nofunc;
    } else if (in.takeKeyword("any"sv) || in.takeKeyword("none"sv) ||
               in.takeKeyword("eq"sv) || in.takeKeyword("i31"sv) ||
               in.takeKeyword("struct"sv) || in.takeKeyword("array"sv)) {
      type = HeapType::none;
    } else {
      return in.err("unexpected heap type");
    }
    if (!in.takeRParen()) {
      return in.err("expected end of ref.null");
    }
    return Literal::makeNull(type);
  }

  return in.err("expected constant");
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

MaybeResult<Action> action(Lexer& in) {
  if (in.takeSExprStart("invoke"sv)) {
    // TODO: Do we need to use this optional id?
    in.takeID();
    auto name = in.takeName();
    if (!name) {
      return in.err("expected export name");
    }
    auto args = consts(in);
    CHECK_ERR(args);
    if (!in.takeRParen()) {
      return in.err("expected end of invoke action");
    }
    return InvokeAction{*name, *args};
  }

  if (in.takeSExprStart("get"sv)) {
    // TODO: Do we need to use this optional id?
    in.takeID();
    auto name = in.takeName();
    if (!name) {
      return in.err("expected export name");
    }
    if (!in.takeRParen()) {
      return in.err("expected end of get action");
    }
    return GetAction{*name};
  }

  return {};
}

// (module id? binary string*)
// (module id? quote string*)
// (module ...)
Result<WASTModule> wastModule(Lexer& in, bool maybeInvalid = false) {
  Lexer reset = in;
  if (!in.takeSExprStart("module"sv)) {
    return in.err("expected module");
  }
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
MaybeResult<AssertException> assertException(Lexer& in) {
  if (!in.takeSExprStart("assert_exception"sv)) {
    return {};
  }
  auto a = action(in);
  CHECK_ERR(a);
  if (!in.takeRParen()) {
    return in.err("expected end of assert_exception");
  }
  return AssertException{*a};
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
  return AssertAction{type, *a, *msg};
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
  return AssertModule{type, *mod, *msg};
}

// (assert_trap action msg)
// (assert_trap module msg)
MaybeResult<Assertion> assertTrap(Lexer& in) {
  if (!in.takeSExprStart("assert_trap"sv)) {
    return {};
  }
  auto pos = in.getPos();
  if (auto a = action(in)) {
    CHECK_ERR(a);
    auto msg = in.takeString();
    if (!msg) {
      return in.err("expected error message");
    }
    if (!in.takeRParen()) {
      return in.err("expected end of assertion");
    }
    return Assertion{AssertAction{ActionAssertionType::Trap, *a, *msg}};
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
  return Assertion{AssertModule{ModuleAssertionType::Trap, *mod, *msg}};
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
  if (auto cmd = action(in)) {
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

Result<WASTScript> wast(Lexer& in) {
  WASTScript cmds;
  while (!in.empty()) {
    auto cmd = command(in);
    if (cmd.getErr() && cmds.empty()) {
      // The entire script might be a single module comprising a sequence of
      // module fields with a top-level `(module ...)`.
      auto wasm = std::make_shared<Module>();
      CHECK_ERR(parseModule(*wasm, in.buffer));
      cmds.emplace_back(std::move(wasm));
      return cmds;
    }
    CHECK_ERR(cmd);
    cmds.emplace_back(std::move(*cmd));
  }
  return cmds;
}

} // anonymous namespace

Result<WASTScript> parseScript(std::string_view in) {
  Lexer lexer(in);
  return wast(lexer);
}

} // namespace wasm::WATParser
