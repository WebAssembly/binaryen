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

#include "support/command-line.h"
#include "wasm-io.h"

#include <iostream>
#include <z3++.h>

using namespace wasm;

struct ToSMT : UnifiedExpressionVisitor<ToSMT, z3::expr> {
  z3::context& ctx;
  Function* func;
  std::vector<z3::expr> params;

  ToSMT(z3::context& ctx, Function* func) : ctx(ctx), func(func) {
    initParams(func);
  }

  void initParams(Function* func) {
    for (Index i = 0; i < func->getNumParams(); ++i) {
      auto type = func->getLocalType(i);
      auto name = func->getLocalNameOrGeneric(i).str.data();
      if (type.isBasic()) {
        switch (type.getBasic()) {
          case Type::none:
          case Type::unreachable:
          case Type::f32:
          case Type::f64:
            break;
          case Type::i32:
            params.push_back(ctx.bv_const(name, 32));
            continue;
          case Type::i64:
            params.push_back(ctx.bv_const(name, 64));
            continue;
          case Type::v128:
            params.push_back(ctx.bv_const(name, 128));
            continue;
        }
      }
      WASM_UNREACHABLE("unimplemented param type");
    }
  }

  z3::expr visitExpression(Expression* curr) {
    WASM_UNREACHABLE("unimplemented expression");
  }

  z3::expr visitLocalGet(LocalGet* curr) {
    assert(curr->index < func->getNumParams() && "TODO");
    return params[curr->index];
  }

  z3::expr visitConst(Const* curr) {
    assert(curr->type.isBasic());
    switch (curr->type.getBasic()) {
      case Type::none:
      case Type::unreachable:
        break;
      case Type::f32:
      case Type::f64:
        WASM_UNREACHABLE("TODO: fp const");
      case Type::i32:
        return ctx.bv_val(curr->value.geti32(), 32);
      case Type::i64:
        return ctx.bv_val(curr->value.geti64(), 64);
      case Type::v128:
        WASM_UNREACHABLE("TODO: v128.const");
    }
    WASM_UNREACHABLE("unexpected type");
  }

  z3::expr visitBinary(Binary* curr) {
    auto lhs = visit(curr->left);
    auto rhs = visit(curr->right);
    switch (curr->op) {
      case MulInt32:
        return lhs * rhs;
      case ShlInt32:
        return z3::shl(lhs, rhs);
      default:
        break;
    }
    WASM_UNREACHABLE("unimplemented binary op");
  }
};

z3::expr funcToSMT(z3::context& ctx, Function* func) {
  return ToSMT(ctx, func).visit(func->body);
}

z3::expr refinedBy(const z3::expr& src, const z3::expr& tgt) {
  // TODO: Something more complicated!
  return tgt == src;
}

void prove(const z3::expr& conjecture) {
  z3::context& ctx = conjecture.ctx();
  z3::solver solver(ctx);
  solver.add(!conjecture);
  std::cout << "Proving conjecture:\n" << conjecture << "\n";
  if (solver.check() == z3::unsat) {
    std::cout << "proved!\n";
  } else {
    std::cout << "counterexample:\n" << solver.get_model() << "\n";
  }
}

void checkRefinement(Function* src, Function* tgt) {
  z3::context ctx;
  auto srcSMT = funcToSMT(ctx, src);
  auto tgtSMT = funcToSMT(ctx, tgt);
  prove(refinedBy(srcSMT, tgtSMT));
}

struct ValidateRefinementOptions : Options {
  std::string source;
  std::string target;
  ValidateRefinementOptions(const std::string& command, const std::string& desc)
    : Options(command, desc) {
    add("--source",
        "-s",
        "The original module",
        "",
        Arguments::One,
        [&](Options*, const std::string& val) { source = val; });
    add("--target",
        "-t",
        "The transformed module",
        "",
        Arguments::One,
        [&](Options*, const std::string& val) { target = val; });
  }
};

int main(int argc, const char* argv[]) {
  ValidateRefinementOptions options(
    "wasm-validate-refinement",
    "Bounded translation validation for WebAssembly");

  options.parse(argc, argv);

  if (options.source.empty()) {
    std::cerr << "Source module must be provided (--source)\n";
    return 1;
  }

  if (options.target.empty()) {
    std::cerr << "Target module must be provided (--target)\n";
    return 1;
  }

  Module src, tgt;

  ModuleReader().read(options.source, src);
  ModuleReader().read(options.target, tgt);

  // TODO: Verify that src and tgt have matching global structures, including
  // function signatures.

  for (size_t i = 0; i < src.functions.size(); ++i) {
    if (src.functions[i]->imported()) {
      continue;
    }

    assert(i < tgt.functions.size() && !tgt.functions[i]->imported());

    checkRefinement(src.functions[i].get(), tgt.functions[i].get());
  }
}
