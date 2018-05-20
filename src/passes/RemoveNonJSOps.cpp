/*
 * Copyright 2018 WebAssembly Community Group participants
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
// Removes all operations in a wasm module that aren't inherently implementable
// in JS. This includes things like 64-bit division, `f32.nearest`,
// `f64.copysign`, etc. Most operations are lowered to a call to an injected
// intrinsic implementation. Intrinsics don't use themselves to implement
// themselves.
//
// You'll find a large wast blob at the end of this module which contains all of
// the injected intrinsics. We manually copy over any needed intrinsics from
// this module into the module that we're optimizing after walking the current
// module.
//

#include <wasm.h>
#include <pass.h>

#include "asmjs/shared-constants.h"
#include "wasm-builder.h"
#include "wasm-s-parser.h"
#include "ir/module-utils.h"

namespace wasm {

namespace {
extern const char *IntrinsicsModule;
}

struct RemoveNonJSOpsPass : public WalkerPass<PostWalker<RemoveNonJSOpsPass>> {
  std::unique_ptr<Builder> builder;
  std::unordered_set<Name> neededIntrinsics;

  bool isFunctionParallel() override { return false; }

  Pass* create() override { return new RemoveNonJSOpsPass; }

  void doWalkModule(Module* module) {
    // Discover all of the intrinsics that we need to inject, lowering all
    // operations to intrinsic calls while we're at it.
    if (!builder) builder = make_unique<Builder>(*module);
    PostWalker<RemoveNonJSOpsPass>::doWalkModule(module);

    if (neededIntrinsics.size() == 0) {
      return;
    }

    // Parse the wast blob we have at the end of this file.
    //
    // TODO: only do this once per invocation of wasm2asm
    Module intrinsicsModule;
    std::string input(IntrinsicsModule);
    SExpressionParser parser(const_cast<char*>(input.c_str()));
    Element& root = *parser.root;
    SExpressionWasmBuilder builder(intrinsicsModule, *root[0]);

    std::set<Name> neededFunctions;

    // Iteratively link intrinsics from `intrinsicsModule` into our destination
    // module, as needed.
    //
    // Note that intrinsics often use one another. For example the 64-bit
    // division intrinsic ends up using the 32-bit ctz intrinsic, but does so
    // via a native instruction. The loop here is used to continuously reprocess
    // injected intrinsics to ensure that they never contain non-js ops when
    // we're done.
    while (neededIntrinsics.size() > 0) {
      // TODO: move popcnt to the wast blob below and avoid special handling of
      // it.
      if (neededIntrinsics.erase(WASM_POPCNT32)) {
        if (module->getFunctionOrNull(WASM_POPCNT32) == nullptr) {
          module->addFunction(createPopcnt());
        }
      }

      // Recursively probe all needed intrinsics for transitively used
      // functions. This is building up a set of functions we'll link into our
      // module.
      for (auto &name : neededIntrinsics) {
        addNeededFunctions(intrinsicsModule, name, neededFunctions);
      }
      neededIntrinsics.clear();

      // Link in everything that wasn't already linked in. After we've done the
      // copy we then walk the function to rewrite any non-js operations it has
      // as well.
      for (auto &name : neededFunctions) {
        doWalkFunction(ModuleUtils::copyFunction(intrinsicsModule, *module, name));
      }
      neededFunctions.clear();
    }
  }

  void addNeededFunctions(Module &m, Name name, std::set<Name> &needed) {
    if (needed.count(name)) {
      return;
    }
    needed.insert(name);

    struct CallFinder: public PostWalker<CallFinder> {
      RemoveNonJSOpsPass *pass;
      Module &module;
      std::set<Name> &needed;

      CallFinder(RemoveNonJSOpsPass *pass, Module &m, std::set<Name> &needed)
        : pass(pass), module(m), needed(needed) {}

      void visitCall(Call *call) {
        pass->addNeededFunctions(module, call->target, needed);
      }
    };

    CallFinder finder(this, m, needed);
    finder.doWalkFunction(m.getFunction(name));
  }

  Function* createPopcnt() {
    // popcnt implemented as:
    // int c; for (c = 0; x != 0; c++) { x = x & (x - 1) }; return c
    Name loopName("l");
    Name blockName("b");
    Break* brIf = builder->makeBreak(
      blockName,
      builder->makeGetLocal(1, i32),
      builder->makeUnary(
        EqZInt32,
        builder->makeGetLocal(0, i32)
      )
    );
    SetLocal* update = builder->makeSetLocal(
      0,
      builder->makeBinary(
        AndInt32,
        builder->makeGetLocal(0, i32),
        builder->makeBinary(
          SubInt32,
          builder->makeGetLocal(0, i32),
          builder->makeConst(Literal(int32_t(1)))
        )
      )
    );
    SetLocal* inc = builder->makeSetLocal(
      1,
      builder->makeBinary(
        AddInt32,
        builder->makeGetLocal(1, i32),
        builder->makeConst(Literal(1))
      )
    );
    Break* cont = builder->makeBreak(loopName);
    Loop* loop = builder->makeLoop(
      loopName,
      builder->blockify(builder->makeDrop(brIf), update, inc, cont)
    );
    Block* loopBlock = builder->blockifyWithName(loop, blockName);
    // TODO: not sure why this is necessary...
    loopBlock->type = i32;
    SetLocal* initCount = builder->makeSetLocal(1, builder->makeConst(Literal(0)));
    return builder->makeFunction(
      WASM_POPCNT32,
      std::vector<NameType>{NameType("x", i32)},
      i32,
      std::vector<NameType>{NameType("count", i32)},
      builder->blockify(initCount, loopBlock)
    );
  }

  void doWalkFunction(Function* func) {
    if (!builder) builder = make_unique<Builder>(*getModule());
    PostWalker<RemoveNonJSOpsPass>::doWalkFunction(func);
  }

  void visitBinary(Binary *curr) {
    Name name;
    switch (curr->op) {
      case CopySignFloat32:
      case CopySignFloat64:
        rewriteCopysign(curr);
        return;

      case RotLInt32:
        name = WASM_ROTL32;
        break;
      case RotRInt32:
        name = WASM_ROTR32;
        break;
      case RotLInt64:
        name = WASM_ROTL64;
        break;
      case RotRInt64:
        name = WASM_ROTR64;
        break;
      case MulInt64:
        name = WASM_I64_MUL;
        break;
      case DivSInt64:
        name = WASM_I64_SDIV;
        break;
      case DivUInt64:
        name = WASM_I64_UDIV;
        break;
      case RemSInt64:
        name = WASM_I64_SREM;
        break;
      case RemUInt64:
        name = WASM_I64_UREM;
        break;

      default: return;
    }
    neededIntrinsics.insert(name);
    replaceCurrent(builder->makeCall(name, {curr->left, curr->right}, curr->type));
  }

  void rewriteCopysign(Binary *curr) {
    Literal signBit, otherBits;
    UnaryOp int2float, float2int;
    BinaryOp bitAnd, bitOr;
    switch (curr->op) {
      case CopySignFloat32:
        float2int = ReinterpretFloat32;
        int2float = ReinterpretInt32;
        bitAnd = AndInt32;
        bitOr = OrInt32;
        signBit = Literal(uint32_t(1 << 31));
        otherBits = Literal(uint32_t(1 << 31) - 1);
        break;

      case CopySignFloat64:
        float2int = ReinterpretFloat64;
        int2float = ReinterpretInt64;
        bitAnd = AndInt64;
        bitOr = OrInt64;
        signBit = Literal(uint64_t(1) << 63);
        otherBits = Literal((uint64_t(1) << 63) - 1);
        break;

      default: return;
    }

    replaceCurrent(
      builder->makeUnary(
        int2float,
        builder->makeBinary(
          bitOr,
          builder->makeBinary(
            bitAnd,
            builder->makeUnary(
              float2int,
              curr->left
            ),
            builder->makeConst(otherBits)
          ),
          builder->makeBinary(
            bitAnd,
            builder->makeUnary(
              float2int,
              curr->right
            ),
            builder->makeConst(signBit)
          )
        )
      )
    );
  }

  void visitUnary(Unary *curr) {
    Name functionCall;
    switch (curr->op) {
      case NearestFloat32:
        functionCall = WASM_NEAREST_F32;
        break;
      case NearestFloat64:
        functionCall = WASM_NEAREST_F64;
        break;

      case TruncFloat32:
        functionCall = WASM_TRUNC_F32;
        break;
      case TruncFloat64:
        functionCall = WASM_TRUNC_F64;
        break;

      case PopcntInt32:
        functionCall = WASM_POPCNT32;
        break;

      case CtzInt32:
        functionCall = WASM_CTZ32;
        break;

      default: return;
    }
    neededIntrinsics.insert(functionCall);
    replaceCurrent(builder->makeCall(functionCall, {curr->value}, curr->type));
  }
};

Pass *createRemoveNonJSOpsPass() {
  return new RemoveNonJSOpsPass();
}

namespace {
// A large WAST blob which contains the implementations of all the intrinsics
// that we inject as part of this module. This blob was generated from a Rust
// program [1] which uses the Rust compiler-builtins project. It's not
// necessarily perfect but gets the job done! The idea here is that we inject
// these pretty early so they can continue to be optimized by further passes
// (aka inlining and whatnot)
//
// [1]: https://gist.github.com/alexcrichton/e7ea67bcdd17ce4b6254e66f77165690
const char *IntrinsicsModule = R"(
(module
 (type $0 (func (param i64 i64) (result i64)))
 (type $1 (func (param f32) (result f32)))
 (type $2 (func (param f64) (result f64)))
 (type $3 (func (param i32) (result i32)))
 (type $4 (func (param i32 i32) (result i32)))
 (import "env" "memory" (memory $0 17))
 (export "__wasm_i64_sdiv" (func $__wasm_i64_sdiv))
 (export "__wasm_i64_udiv" (func $__wasm_i64_udiv))
 (export "__wasm_i64_srem" (func $__wasm_i64_srem))
 (export "__wasm_i64_urem" (func $__wasm_i64_urem))
 (export "__wasm_i64_mul" (func $__wasm_i64_mul))
 (export "__wasm_trunc_f32" (func $__wasm_trunc_f32))
 (export "__wasm_trunc_f64" (func $__wasm_trunc_f64))
 (export "__wasm_ctz_i32" (func $__wasm_ctz_i32))
 (export "__wasm_rotl_i32" (func $__wasm_rotl_i32))
 (export "__wasm_rotr_i32" (func $__wasm_rotr_i32))
 (export "__wasm_rotl_i64" (func $__wasm_rotl_i64))
 (export "__wasm_rotr_i64" (func $__wasm_rotr_i64))
 (export "__wasm_nearest_f32" (func $__wasm_nearest_f32))
 (export "__wasm_nearest_f64" (func $__wasm_nearest_f64))
 (func $__wasm_i64_sdiv (; 0 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (call $_ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E
   (get_local $var$0)
   (get_local $var$1)
  )
 )
 (func $__wasm_i64_udiv (; 1 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (call $_ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E
   (get_local $var$0)
   (get_local $var$1)
  )
 )
 (func $__wasm_i64_srem (; 2 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (call $_ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E
   (get_local $var$0)
   (get_local $var$1)
  )
 )
 (func $__wasm_i64_urem (; 3 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (drop
   (call $_ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E
    (get_local $var$0)
    (get_local $var$1)
   )
  )
  (i64.load
   (i32.const 1024)
  )
 )
 (func $__wasm_i64_mul (; 4 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (call $_ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE
   (get_local $var$0)
   (get_local $var$1)
  )
 )
 (func $__wasm_trunc_f32 (; 5 ;) (type $1) (param $var$0 f32) (result f32)
  (select
   (f32.ceil
    (get_local $var$0)
   )
   (f32.floor
    (get_local $var$0)
   )
   (f32.lt
    (get_local $var$0)
    (f32.const 0)
   )
  )
 )
 (func $__wasm_trunc_f64 (; 6 ;) (type $2) (param $var$0 f64) (result f64)
  (select
   (f64.ceil
    (get_local $var$0)
   )
   (f64.floor
    (get_local $var$0)
   )
   (f64.lt
    (get_local $var$0)
    (f64.const 0)
   )
  )
 )
 (func $__wasm_ctz_i32 (; 7 ;) (type $3) (param $var$0 i32) (result i32)
  (if
   (get_local $var$0)
   (return
    (i32.sub
     (i32.const 31)
     (i32.clz
      (i32.xor
       (i32.add
        (get_local $var$0)
        (i32.const -1)
       )
       (get_local $var$0)
      )
     )
    )
   )
  )
  (i32.const 32)
 )
 (func $__wasm_rotl_i32 (; 8 ;) (type $4) (param $var$0 i32) (param $var$1 i32) (result i32)
  (local $var$2 i32)
  (i32.or
   (i32.shl
    (i32.and
     (i32.shr_u
      (i32.const -1)
      (tee_local $var$2
       (i32.and
        (get_local $var$1)
        (i32.const 31)
       )
      )
     )
     (get_local $var$0)
    )
    (get_local $var$2)
   )
   (i32.shr_u
    (i32.and
     (i32.shl
      (i32.const -1)
      (tee_local $var$1
       (i32.and
        (i32.sub
         (i32.const 0)
         (get_local $var$1)
        )
        (i32.const 31)
       )
      )
     )
     (get_local $var$0)
    )
    (get_local $var$1)
   )
  )
 )
 (func $__wasm_rotr_i32 (; 9 ;) (type $4) (param $var$0 i32) (param $var$1 i32) (result i32)
  (local $var$2 i32)
  (i32.or
   (i32.shr_u
    (i32.and
     (i32.shl
      (i32.const -1)
      (tee_local $var$2
       (i32.and
        (get_local $var$1)
        (i32.const 31)
       )
      )
     )
     (get_local $var$0)
    )
    (get_local $var$2)
   )
   (i32.shl
    (i32.and
     (i32.shr_u
      (i32.const -1)
      (tee_local $var$1
       (i32.and
        (i32.sub
         (i32.const 0)
         (get_local $var$1)
        )
        (i32.const 31)
       )
      )
     )
     (get_local $var$0)
    )
    (get_local $var$1)
   )
  )
 )
 (func $__wasm_rotl_i64 (; 10 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (local $var$2 i64)
  (i64.or
   (i64.shl
    (i64.and
     (i64.shr_u
      (i64.const -1)
      (tee_local $var$2
       (i64.and
        (get_local $var$1)
        (i64.const 63)
       )
      )
     )
     (get_local $var$0)
    )
    (get_local $var$2)
   )
   (i64.shr_u
    (i64.and
     (i64.shl
      (i64.const -1)
      (tee_local $var$1
       (i64.and
        (i64.sub
         (i64.const 0)
         (get_local $var$1)
        )
        (i64.const 63)
       )
      )
     )
     (get_local $var$0)
    )
    (get_local $var$1)
   )
  )
 )
 (func $__wasm_rotr_i64 (; 11 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (local $var$2 i64)
  (i64.or
   (i64.shr_u
    (i64.and
     (i64.shl
      (i64.const -1)
      (tee_local $var$2
       (i64.and
        (get_local $var$1)
        (i64.const 63)
       )
      )
     )
     (get_local $var$0)
    )
    (get_local $var$2)
   )
   (i64.shl
    (i64.and
     (i64.shr_u
      (i64.const -1)
      (tee_local $var$1
       (i64.and
        (i64.sub
         (i64.const 0)
         (get_local $var$1)
        )
        (i64.const 63)
       )
      )
     )
     (get_local $var$0)
    )
    (get_local $var$1)
   )
  )
 )
 (func $__wasm_nearest_f32 (; 12 ;) (type $1) (param $var$0 f32) (result f32)
  (local $var$1 f32)
  (local $var$2 f32)
  (if
   (i32.eqz
    (f32.lt
     (tee_local $var$2
      (f32.sub
       (get_local $var$0)
       (tee_local $var$1
        (f32.floor
         (get_local $var$0)
        )
       )
      )
     )
     (f32.const 0.5)
    )
   )
   (block
    (set_local $var$0
     (f32.ceil
      (get_local $var$0)
     )
    )
    (if
     (f32.gt
      (get_local $var$2)
      (f32.const 0.5)
     )
     (return
      (get_local $var$0)
     )
    )
    (set_local $var$1
     (select
      (get_local $var$1)
      (get_local $var$0)
      (f32.eq
       (f32.sub
        (tee_local $var$2
         (f32.mul
          (get_local $var$1)
          (f32.const 0.5)
         )
        )
        (f32.floor
         (get_local $var$2)
        )
       )
       (f32.const 0)
      )
     )
    )
   )
  )
  (get_local $var$1)
 )
 (func $__wasm_nearest_f64 (; 13 ;) (type $2) (param $var$0 f64) (result f64)
  (local $var$1 f64)
  (local $var$2 f64)
  (if
   (i32.eqz
    (f64.lt
     (tee_local $var$2
      (f64.sub
       (get_local $var$0)
       (tee_local $var$1
        (f64.floor
         (get_local $var$0)
        )
       )
      )
     )
     (f64.const 0.5)
    )
   )
   (block
    (set_local $var$0
     (f64.ceil
      (get_local $var$0)
     )
    )
    (if
     (f64.gt
      (get_local $var$2)
      (f64.const 0.5)
     )
     (return
      (get_local $var$0)
     )
    )
    (set_local $var$1
     (select
      (get_local $var$1)
      (get_local $var$0)
      (f64.eq
       (f64.sub
        (tee_local $var$2
         (f64.mul
          (get_local $var$1)
          (f64.const 0.5)
         )
        )
        (f64.floor
         (get_local $var$2)
        )
       )
       (f64.const 0)
      )
     )
    )
   )
  )
  (get_local $var$1)
 )
 (func $_ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E (; 14 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (local $var$2 i32)
  (local $var$3 i32)
  (local $var$4 i32)
  (local $var$5 i64)
  (local $var$6 i64)
  (local $var$7 i64)
  (local $var$8 i64)
  (block $label$1
   (block $label$2
    (block $label$3
     (block $label$4
      (block $label$5
       (block $label$6
        (block $label$7
         (block $label$8
          (block $label$9
           (block $label$10
            (block $label$11
             (if
              (tee_local $var$2
               (i32.wrap/i64
                (i64.shr_u
                 (get_local $var$0)
                 (i64.const 32)
                )
               )
              )
              (block
               (br_if $label$11
                (i32.eqz
                 (tee_local $var$3
                  (i32.wrap/i64
                   (get_local $var$1)
                  )
                 )
                )
               )
               (br_if $label$9
                (i32.eqz
                 (tee_local $var$4
                  (i32.wrap/i64
                   (i64.shr_u
                    (get_local $var$1)
                    (i64.const 32)
                   )
                  )
                 )
                )
               )
               (br_if $label$8
                (i32.le_u
                 (tee_local $var$2
                  (i32.sub
                   (i32.clz
                    (get_local $var$4)
                   )
                   (i32.clz
                    (get_local $var$2)
                   )
                  )
                 )
                 (i32.const 31)
                )
               )
               (br $label$2)
              )
             )
             (br_if $label$2
              (i64.ge_u
               (get_local $var$1)
               (i64.const 4294967296)
              )
             )
             (i64.store
              (i32.const 1024)
              (i64.extend_u/i32
               (i32.sub
                (tee_local $var$2
                 (i32.wrap/i64
                  (get_local $var$0)
                 )
                )
                (i32.mul
                 (tee_local $var$2
                  (i32.div_u
                   (get_local $var$2)
                   (tee_local $var$3
                    (i32.wrap/i64
                     (get_local $var$1)
                    )
                   )
                  )
                 )
                 (get_local $var$3)
                )
               )
              )
             )
             (return
              (i64.extend_u/i32
               (get_local $var$2)
              )
             )
            )
            (set_local $var$3
             (i32.wrap/i64
              (i64.shr_u
               (get_local $var$1)
               (i64.const 32)
              )
             )
            )
            (br_if $label$7
             (i32.eqz
              (i32.wrap/i64
               (get_local $var$0)
              )
             )
            )
            (br_if $label$6
             (i32.eqz
              (get_local $var$3)
             )
            )
            (br_if $label$6
             (i32.and
              (tee_local $var$4
               (i32.add
                (get_local $var$3)
                (i32.const -1)
               )
              )
              (get_local $var$3)
             )
            )
            (i64.store
             (i32.const 1024)
             (i64.or
              (i64.shl
               (i64.extend_u/i32
                (i32.and
                 (get_local $var$4)
                 (get_local $var$2)
                )
               )
               (i64.const 32)
              )
              (i64.and
               (get_local $var$0)
               (i64.const 4294967295)
              )
             )
            )
            (return
             (i64.extend_u/i32
              (i32.shr_u
               (get_local $var$2)
               (i32.and
                (i32.ctz
                 (get_local $var$3)
                )
                (i32.const 31)
               )
              )
             )
            )
           )
           (unreachable)
          )
          (br_if $label$5
           (i32.eqz
            (i32.and
             (tee_local $var$4
              (i32.add
               (get_local $var$3)
               (i32.const -1)
              )
             )
             (get_local $var$3)
            )
           )
          )
          (set_local $var$3
           (i32.sub
            (i32.const 0)
            (tee_local $var$2
             (i32.sub
              (i32.add
               (i32.clz
                (get_local $var$3)
               )
               (i32.const 33)
              )
              (i32.clz
               (get_local $var$2)
              )
             )
            )
           )
          )
          (br $label$3)
         )
         (set_local $var$3
          (i32.sub
           (i32.const 63)
           (get_local $var$2)
          )
         )
         (set_local $var$2
          (i32.add
           (get_local $var$2)
           (i32.const 1)
          )
         )
         (br $label$3)
        )
        (i64.store
         (i32.const 1024)
         (i64.shl
          (i64.extend_u/i32
           (i32.sub
            (get_local $var$2)
            (i32.mul
             (tee_local $var$4
              (i32.div_u
               (get_local $var$2)
               (get_local $var$3)
              )
             )
             (get_local $var$3)
            )
           )
          )
          (i64.const 32)
         )
        )
        (return
         (i64.extend_u/i32
          (get_local $var$4)
         )
        )
       )
       (br_if $label$4
        (i32.lt_u
         (tee_local $var$2
          (i32.sub
           (i32.clz
            (get_local $var$3)
           )
           (i32.clz
            (get_local $var$2)
           )
          )
         )
         (i32.const 31)
        )
       )
       (br $label$2)
      )
      (i64.store
       (i32.const 1024)
       (i64.extend_u/i32
        (i32.and
         (get_local $var$4)
         (i32.wrap/i64
          (get_local $var$0)
         )
        )
       )
      )
      (br_if $label$1
       (i32.eq
        (get_local $var$3)
        (i32.const 1)
       )
      )
      (return
       (i64.shr_u
        (get_local $var$0)
        (i64.extend_u/i32
         (i32.ctz
          (get_local $var$3)
         )
        )
       )
      )
     )
     (set_local $var$3
      (i32.sub
       (i32.const 63)
       (get_local $var$2)
      )
     )
     (set_local $var$2
      (i32.add
       (get_local $var$2)
       (i32.const 1)
      )
     )
    )
    (set_local $var$5
     (i64.shr_u
      (get_local $var$0)
      (i64.extend_u/i32
       (i32.and
        (get_local $var$2)
        (i32.const 63)
       )
      )
     )
    )
    (set_local $var$0
     (i64.shl
      (get_local $var$0)
      (i64.extend_u/i32
       (i32.and
        (get_local $var$3)
        (i32.const 63)
       )
      )
     )
    )
    (block $label$13
     (if
      (get_local $var$2)
      (block
       (set_local $var$8
        (i64.add
         (get_local $var$1)
         (i64.const -1)
        )
       )
       (loop $label$15
        (set_local $var$5
         (i64.sub
          (tee_local $var$5
           (i64.or
            (i64.shl
             (get_local $var$5)
             (i64.const 1)
            )
            (i64.shr_u
             (get_local $var$0)
             (i64.const 63)
            )
           )
          )
          (i64.and
           (tee_local $var$6
            (i64.shr_s
             (i64.sub
              (get_local $var$8)
              (get_local $var$5)
             )
             (i64.const 63)
            )
           )
           (get_local $var$1)
          )
         )
        )
        (set_local $var$0
         (i64.or
          (i64.shl
           (get_local $var$0)
           (i64.const 1)
          )
          (get_local $var$7)
         )
        )
        (set_local $var$7
         (tee_local $var$6
          (i64.and
           (get_local $var$6)
           (i64.const 1)
          )
         )
        )
        (br_if $label$15
         (tee_local $var$2
          (i32.add
           (get_local $var$2)
           (i32.const -1)
          )
         )
        )
       )
       (br $label$13)
      )
     )
    )
    (i64.store
     (i32.const 1024)
     (get_local $var$5)
    )
    (return
     (i64.or
      (i64.shl
       (get_local $var$0)
       (i64.const 1)
      )
      (get_local $var$6)
     )
    )
   )
   (i64.store
    (i32.const 1024)
    (get_local $var$0)
   )
   (set_local $var$0
    (i64.const 0)
   )
  )
  (get_local $var$0)
 )
 (func $_ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE (; 15 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (local $var$2 i32)
  (local $var$3 i32)
  (local $var$4 i32)
  (local $var$5 i32)
  (local $var$6 i32)
  (i64.or
   (i64.shl
    (i64.extend_u/i32
     (i32.add
      (i32.add
       (i32.add
        (i32.add
         (i32.mul
          (tee_local $var$4
           (i32.shr_u
            (tee_local $var$2
             (i32.wrap/i64
              (get_local $var$1)
             )
            )
            (i32.const 16)
           )
          )
          (tee_local $var$5
           (i32.shr_u
            (tee_local $var$3
             (i32.wrap/i64
              (get_local $var$0)
             )
            )
            (i32.const 16)
           )
          )
         )
         (i32.mul
          (get_local $var$2)
          (i32.wrap/i64
           (i64.shr_u
            (get_local $var$0)
            (i64.const 32)
           )
          )
         )
        )
        (i32.mul
         (i32.wrap/i64
          (i64.shr_u
           (get_local $var$1)
           (i64.const 32)
          )
         )
         (get_local $var$3)
        )
       )
       (i32.shr_u
        (tee_local $var$2
         (i32.add
          (i32.shr_u
           (tee_local $var$6
            (i32.mul
             (tee_local $var$2
              (i32.and
               (get_local $var$2)
               (i32.const 65535)
              )
             )
             (tee_local $var$3
              (i32.and
               (get_local $var$3)
               (i32.const 65535)
              )
             )
            )
           )
           (i32.const 16)
          )
          (i32.mul
           (get_local $var$2)
           (get_local $var$5)
          )
         )
        )
        (i32.const 16)
       )
      )
      (i32.shr_u
       (tee_local $var$2
        (i32.add
         (i32.and
          (get_local $var$2)
          (i32.const 65535)
         )
         (i32.mul
          (get_local $var$4)
          (get_local $var$3)
         )
        )
       )
       (i32.const 16)
      )
     )
    )
    (i64.const 32)
   )
   (i64.extend_u/i32
    (i32.or
     (i32.shl
      (get_local $var$2)
      (i32.const 16)
     )
     (i32.and
      (get_local $var$6)
      (i32.const 65535)
     )
    )
   )
  )
 )
 (func $_ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E (; 16 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (local $var$2 i64)
  (i64.sub
   (i64.xor
    (i64.div_u
     (i64.sub
      (i64.xor
       (tee_local $var$2
        (i64.shr_s
         (get_local $var$0)
         (i64.const 63)
        )
       )
       (get_local $var$0)
      )
      (get_local $var$2)
     )
     (i64.sub
      (i64.xor
       (tee_local $var$2
        (i64.shr_s
         (get_local $var$1)
         (i64.const 63)
        )
       )
       (get_local $var$1)
      )
      (get_local $var$2)
     )
    )
    (tee_local $var$0
     (i64.shr_s
      (i64.xor
       (get_local $var$1)
       (get_local $var$0)
      )
      (i64.const 63)
     )
    )
   )
   (get_local $var$0)
  )
 )
 (func $_ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E (; 17 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (local $var$2 i64)
  (i64.sub
   (i64.xor
    (i64.rem_u
     (i64.sub
      (i64.xor
       (tee_local $var$2
        (i64.shr_s
         (get_local $var$0)
         (i64.const 63)
        )
       )
       (get_local $var$0)
      )
      (get_local $var$2)
     )
     (i64.sub
      (i64.xor
       (tee_local $var$0
        (i64.shr_s
         (get_local $var$1)
         (i64.const 63)
        )
       )
       (get_local $var$1)
      )
      (get_local $var$0)
     )
    )
    (get_local $var$2)
   )
   (get_local $var$2)
  )
 )
 ;; custom section "linking", size 3
)

)";
} // namespace

} // namespace wasm

