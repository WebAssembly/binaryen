/*
 * Copyright 2023 WebAssembly Community Group participants
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

#include <set>
#include <string>
#include <vector>

#include "shared-constants.h"
#include "support/string.h"
#include "wasm-binary.h"
#include "wasm-builder.h"
#include "wasm-validator.h"
#include "gtest/gtest.h"

using namespace wasm;

// Check that the validator does not crash on missing tags in catch statements
// (invalid parse, so cannot be reproduced with Python test suite)
TEST(ValidatorTest, MissingCatchTag) {
  WasmValidator validator;
  Module module;
  module.features.enable(FeatureSet::ExceptionHandling);
  auto tryExp = module.allocator.alloc<Try>();
  tryExp->name = "tst1";
  auto bodyExp = module.allocator.alloc<Const>();
  bodyExp->value = Literal(1);
  tryExp->body = bodyExp;
  tryExp->catchTags.push_back(wasm::Name("foo"));
  auto catchBodyExp = module.allocator.alloc<Const>();
  catchBodyExp->value = Literal(2);
  tryExp->catchBodies.push_back(catchBodyExp);
  Function function = Function();
  function.body = tryExp;
  WasmValidator::Flags flags =
    WasmValidator::FlagValues::Globally | WasmValidator::FlagValues::Quiet;
  EXPECT_FALSE(validator.validate(&function, module, flags));
}

TEST(ValidatorTest, ReturnUnreachable) {
  Module module;
  Builder builder(module);

  // (return (unreachable)) should be invalid if a function has no return type.
  auto func =
    builder.makeFunction("func",
                         {},
                         Signature(Type::none, Type::none),
                         {},
                         builder.makeReturn(builder.makeUnreachable()));

  auto flags =
    WasmValidator::FlagValues::Globally | WasmValidator::FlagValues::Quiet;
  EXPECT_FALSE(WasmValidator{}.validate(func.get(), module, flags));
}
