/*
 * Copyright 2025 WebAssembly Community Group participants
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

#include "ir/principal-type.h"
#include "wasm-type.h"

#include "gtest/gtest.h"

using namespace wasm;

void expectCompose(const char* file,
                   int line,
                   PrincipalType a,
                   PrincipalType b,
                   PrincipalType c) {
  std::stringstream ss;
  ss << a << " + " << b << " = " << c;
  testing::ScopedTrace trace(file, line, ss.str());
  EXPECT_TRUE(a.compose(b));
  EXPECT_EQ(a, c);
}

#define COMPOSE(a, b, c)                                                       \
  expectCompose(                                                               \
    __FILE__, __LINE__, PrincipalType a, PrincipalType b, PrincipalType c)

void expectNoCompose(const char* file,
                     int line,
                     PrincipalType a,
                     PrincipalType b) {
  std::stringstream ss;
  ss << a << " + " << b << " = X";
  testing::ScopedTrace trace(file, line, ss.str());
  auto original = a;
  EXPECT_FALSE(a.compose(b));
  EXPECT_EQ(a, original);
}

#define NO_COMPOSE(a, b)                                                       \
  expectNoCompose(__FILE__, __LINE__, PrincipalType a, PrincipalType b)

TEST(PrincipalTypeTest, ComposeBasic) {
  Type i32 = Type::i32;
  Type i64 = Type::i64;
  Type f32 = Type::f32;
  Type f64 = Type::f64;

  // Empty types with all combinations of unreachability.
  // []->[] + []->[] = []->[]
  COMPOSE(({}, {}), ({}, {}), ({}, {}));
  // []->[] + []*->[] = []*->[]
  COMPOSE(({}, {}), ({}, {}, true), ({}, {}, true));
  // []*->[] + []->[] = []*->[]
  COMPOSE(({}, {}, true), ({}, {}), ({}, {}, true));
  // []*->[] + []*->[] = []*->[]
  COMPOSE(({}, {}, true), ({}, {}, true), ({}, {}, true));

  // i32 in all positions with all combinations of unreachability.
  // [i32]->[] + []->[] = [i32]->[]
  COMPOSE(({i32}, {}), ({}, {}), ({i32}, {}));
  // []->[i32] + []->[] = []->[i32]
  COMPOSE(({}, {i32}), ({}, {}), ({}, {i32}));
  // []->[] + [i32]->[] = [i32]->[]
  COMPOSE(({}, {}), ({i32}, {}), ({i32}, {}));
  // []->[] + []->[i32] = []->[i32]
  COMPOSE(({}, {}), ({}, {i32}), ({}, {i32}));

  // [i32]*->[] + []->[] = [i32]*->[]
  COMPOSE(({i32}, {}, true), ({}, {}), ({i32}, {}, true));
  // []*->[i32] + []->[] = []*->[i32]
  COMPOSE(({}, {i32}, true), ({}, {}), ({}, {i32}, true));
  // []*->[] + [i32]->[] = []*->[]
  COMPOSE(({}, {}, true), ({i32}, {}), ({}, {}, true));
  // []*->[] + []->[i32] = []*->[i32]
  COMPOSE(({}, {}, true), ({}, {i32}), ({}, {i32}, true));

  // [i32]->[] + []*->[] = [i32]*->[]
  COMPOSE(({i32}, {}), ({}, {}, true), ({i32}, {}, true));
  // []->[i32] + []*->[] = []*->[]
  COMPOSE(({}, {i32}), ({}, {}, true), ({}, {}, true));
  // []->[] + [i32]*->[] = [i32]*->[]
  COMPOSE(({}, {}), ({i32}, {}, true), ({i32}, {}, true));
  // []->[] + []*->[i32] = []*->[i32]
  COMPOSE(({}, {}), ({}, {i32}, true), ({}, {i32}, true));

  // [i32]*->[] + []*->[] = [i32]*->[]
  COMPOSE(({i32}, {}, true), ({}, {}, true), ({i32}, {}, true));
  // []*->[i32] + []*->[] = []*->[]
  COMPOSE(({}, {i32}, true), ({}, {}, true), ({}, {}, true));
  // []*->[] + [i32]*->[] = []*->[]
  COMPOSE(({}, {}, true), ({i32}, {}, true), ({}, {}, true));
  // []*->[] + []*->[i32] = []*->[i32]
  COMPOSE(({}, {}, true), ({}, {i32}, true), ({}, {i32}, true));

  // A second type (f64) in all possible positions.
  // [i32]->[i64] + [i64]->[f32] = [i32]->[f32]
  COMPOSE(({i32}, {i64}), ({i64}, {f32}), ({i32}, {f32}));
  // [f64 i32]->[i64] + [i64]->[f32] = [f64 i32]->[f32]
  COMPOSE(({f64, i32}, {i64}), ({i64}, {f32}), ({f64, i32}, {f32}));
  // [i32 f64]->[i64] + [i64]->[f32] = [f64 i32]->[f32]
  COMPOSE(({i32, f64}, {i64}), ({i64}, {f32}), ({i32, f64}, {f32}));
  // [i32]->[f64 i64] + [i64]->[f32] = [i32]->[f64 f32]
  COMPOSE(({i32}, {f64, i64}), ({i64}, {f32}), ({i32}, {f64, f32}));
  // [i32]->[i64 f64] + [i64]->[f32] = X
  NO_COMPOSE(({i32}, {i64, f64}), ({i64}, {f32}));
  // [i32]->[i64] + [f64 i64]->[f32] = [f64 i32]->[f32]
  COMPOSE(({i32}, {i64}), ({f64, i64}, {f32}), ({f64, i32}, {f32}));
  // [i32]->[i64] + [i64 f64]->[f32] = X
  NO_COMPOSE(({i32}, {i64}), ({i64, f64}, {f32}));
  // [i32]->[i64] + [i64]->[f64 f32] = [i32]->[f64 f32]
  COMPOSE(({i32}, {i64}), ({i64}, {f64, f32}), ({i32}, {f64, f32}));
  // [i32]->[i64] + [i64]->[f32 f64] = [i32]->[f32 f64]
  COMPOSE(({i32}, {i64}), ({i64}, {f32, f64}), ({i32}, {f32, f64}));
}

TEST(PrincipalTypeTest, MatchSubtypes) {
  Type anyref = Type(HeapType::any, Nullable);
  Type eqref = Type(HeapType::eq, Nullable);

  // []->[eqref] + [anyref]->[] = []
  COMPOSE(({}, {eqref}), ({anyref}, {}), ({}, {}));
  // []->[anyref] + [eqref]->[] = X
  NO_COMPOSE(({}, {anyref}), ({eqref}, {}));
}

TEST(PrincipalTypeTest, MatchTypeVariables) {
  Type i32 = Type::i32;
  Type i64 = Type::i64;
  Type f32 = Type::f32;
  VarType t0 = {0u};
  VarType t1 = {1u};
  VarType t2 = {2u};

  // Match type variables with nothing or other type variables.
  // []->[] + [t0]->[] = [t0]->[]
  COMPOSE(({}, {}), ({t0}, {}), ({t0}, {}));
  // []->[] + [t0]->[t0] = [t0]->[t0]
  COMPOSE(({}, {}), ({t0}, {t0}), ({t0}, {t0}));
  // [t0]->[] + []->[] = [t0]->[]
  COMPOSE(({t0}, {}), ({}, {}), ({t0}, {}));
  // [t0]->[] + [t0]->[] = [t1 t0]->[]
  COMPOSE(({t0}, {}), ({t0}, {}), ({t1, t0}, {}));
  // [t0]->[] + [t0]->[t0] = [t1 t0]->[t1]
  COMPOSE(({t0}, {}), ({t0}, {t0}), ({t1, t0}, {t1}));
  // [t0]->[t0] + []->[] = [t0]->[t0]
  COMPOSE(({t0}, {t0}), ({}, {}), ({t0}, {t0}));
  // [t0]->[t0] + [t0]->[] = [t0]->[]
  COMPOSE(({t0}, {t0}), ({t0}, {}), ({t0}, {}));
  // [t0]->[t0] + [t0]->[t0] = [t0]->[t0]
  COMPOSE(({t0}, {t0}), ({t0}, {t0}), ({t0}, {t0}));

  // Match a concrete type.
  // []->[i32] + [t0]->[] = []->[]
  COMPOSE(({}, {i32}), ({t0}, {}), ({}, {}));
  // []->[i32] + [t0]->[t0] = []->[i32]
  COMPOSE(({}, {i32}), ({t0}, {t0}), ({}, {i32}));
  // [t0]->[i32] + [t0']->[t0'] = [t0]->[i32]
  COMPOSE(({t0}, {i32}), ({t0}, {t0}), ({t0}, {i32}));
  // [i32]->[i32] + [t0]->[t0] = [i32]->[i32]
  COMPOSE(({i32}, {i32}), ({t0}, {t0}), ({i32}, {i32}));
  // [t0]->[] + [i32]->[] = [i32 t0]->[]
  COMPOSE(({t0}, {}), ({i32}, {}), ({i32, t0}, {}));
  // [t0]->[t0] + [i32]->[] = [i32]->[]
  COMPOSE(({t0}, {t0}), ({i32}, {}), ({i32}, {}));
  // [t0]->[t0] + [i32]->[i32] = [i32]->[i32]
  COMPOSE(({t0}, {t0}), ({i32}, {i32}), ({i32}, {i32}));
  // [t0]->[t0] + [t0']->[i32] = [t0]->[i32]
  COMPOSE(({t0}, {t0}), ({t0}, {i32}), ({t0}, {i32}));

  // Match bottom.
  // []*->[] + [t0]->[t0] = []*->[]
  COMPOSE(({}, {}, true), ({t0}, {t0}), ({}, {}, true));
  // [t0]->[t0] + []*->[] = [t0]*->[]
  COMPOSE(({t0}, {t0}), ({}, {}, true), ({t0}, {}, true));

  // Multiple variables.
  // []->[i32 i64 f32] + [t2 t1 t0]->[t0 t1 t2] = []->[f32 i64 i32]
  COMPOSE(
    ({}, {i32, i64, f32}), ({t2, t1, t0}, {t0, t1, t2}), ({}, {f32, i64, i32}));
}

TEST(PrincipalTypeTest, MatchHeapTypeVariables) {
  VarType refAny = Type(HeapType::any, NonNullable);
  VarType refNullAny = Type(HeapType::any, Nullable);
  VarType refT0 = VarRef{NonNullable, {0u}};
  VarType refNullT0 = VarRef{Nullable, {0u}};
  VarType refBot = VarRef{NonNullable, BottomHeapType{}};
  VarType refNullBot = VarRef{Nullable, BottomHeapType{}};

  // Forward match a concrete type.
  // []->[(ref any)] + [(ref t0)]->[(ref t0)] = []->[(ref any)]
  COMPOSE(({}, {refAny}), ({refT0}, {refT0}), ({}, {refAny}));
  // []->[(ref any)] + [(ref null t0)]->[(ref t0)] = []->[(ref any)]
  COMPOSE(({}, {refAny}), ({refNullT0}, {refT0}), ({}, {refAny}));
  // []->[(ref null any)] + [(ref t0)]->[(ref t0)] = X
  NO_COMPOSE(({}, {refNullAny}), ({refT0}, {refT0}));
  // []->[(ref null any)] + [(ref null t0)]->[(ref t0)] = []->[(ref any)]
  COMPOSE(({}, {refNullAny}), ({refNullT0}, {refT0}), ({}, {refAny}));
  // []->[(ref bot)] + [(ref t0)]->[(ref t0)] = []->[(ref bot)]
  COMPOSE(({}, {refBot}), ({refT0}, {refT0}), ({}, {refBot}));
  // []->[(ref bot)] + [(ref null t0)]->[(ref t0)] = []->[(ref bot)]
  COMPOSE(({}, {refBot}), ({refNullT0}, {refT0}), ({}, {refBot}));
  // []->[(ref null bot)] + [(ref t0)]->[(ref t0)] = X
  NO_COMPOSE(({}, {refNullBot}), ({refT0}, {refT0}));
  // []->[(ref null bot)] + [(ref null t0)]->[(ref t0)] = []->[(ref bot)]
  COMPOSE(({}, {refNullBot}), ({refNullT0}, {refT0}), ({}, {refBot}));

  // Backward match a concrete type.
  // [(ref t0)]->[(ref t0)] + [(ref any)]->[] = [(ref any)]->[]
  COMPOSE(({refT0}, {refT0}), ({refAny}, {}), ({refAny}, {}));
  // [(ref t0)]->[(ref null t0)] + [(ref any)]->[] = X
  NO_COMPOSE(({refT0}, {refNullT0}), ({refAny}, {}));
  // [(ref t0)]->[(ref t0)] + [(ref null any)]->[] = [(ref any)]->[]
  COMPOSE(({refT0}, {refT0}), ({refNullAny}, {}), ({refAny}, {}));
  // [(ref t0)]->[(ref null t0)] + [(ref null any)]->[] = [(ref any)]->[]
  COMPOSE(({refT0}, {refNullT0}), ({refNullAny}, {}), ({refAny}, {}));
  // [(ref t0)]->[(ref t0)] + [(ref bot)]->[] = [(ref bot)]->[]
  COMPOSE(({refT0}, {refT0}), ({refBot}, {}), ({refBot}, {}));
  // [(ref t0)]->[(ref null t0)] + [(ref bot)]->[] = X
  NO_COMPOSE(({refT0}, {refNullT0}), ({refBot}, {}));
  // [(ref t0)]->[(ref t0)] + [(ref null bot)]->[] = [(ref bot)]->[]
  COMPOSE(({refT0}, {refT0}), ({refNullBot}, {}), ({refBot}, {}));
  // [(ref t0)]->[(ref null t0)] + [(ref null bot)]->[] = [(ref bot)]->[]
  COMPOSE(({refT0}, {refNullT0}), ({refNullBot}, {}), ({refBot}, {}));

  // Match another variable.
  // [(ref null t0)]->[(ref t0)] + [(ref t0')]->[(ref t0')]
  //     = [(ref null t0)]->[(ref t0)]
  COMPOSE(({refNullT0}, {refT0}), ({refT0}, {refT0}), ({refNullT0}, {refT0}));

  // Match bottom.
  // []*->[] + [(ref t0)]->[(ref t0)] = []*->[(ref bot))]
  COMPOSE(({}, {}, true), ({refT0}, {refT0}), ({}, {refBot}, true));
  // [(ref t0)]->[(ref t0)] + []*->[] = [(ref t0)]*->[]
  COMPOSE(({refT0}, {refT0}), ({}, {}, true), ({refT0}, {}, true));
}

TEST(PrincipalTypeTest, MatchNullabilityVariables) {
  VarType refAny = Type(HeapType::any, NonNullable);
  VarType refNullAny = Type(HeapType::any, Nullable);
  VarType refN0Any = VarRef{{0u}, VarAbsHeapType{Unshared, HeapType::any}};
  VarType refEq = Type(HeapType::eq, NonNullable);
  VarType refNullEq = Type(HeapType::eq, Nullable);
  VarType refN0Eq = VarRef{{0u}, VarAbsHeapType{Unshared, HeapType::eq}};

  // Forward match a concrete nullability.
  // []->[(ref any)] + [(ref n0 any)]->[(ref n0 eq)] = []->[(ref eq)]
  COMPOSE(({}, {refAny}), ({refN0Any}, {refN0Eq}), ({}, {refEq}));
  // []->[(ref null any)] + [(ref n0 any)]->[(ref n0 eq)] = []->[(ref null eq)]
  COMPOSE(({}, {refNullAny}), ({refN0Any}, {refN0Eq}), ({}, {refNullEq}));
  // []->[(ref eq)] + [(ref n0 any)]->[(ref n0 eq)] = []->[(ref eq)]
  COMPOSE(({}, {refEq}), ({refN0Any}, {refN0Eq}), ({}, {refEq}));
  // []->[(ref null eq)] + [(ref n0 any)]->[(ref n0 eq)] = []->[(ref null eq)]
  COMPOSE(({}, {refNullEq}), ({refN0Any}, {refN0Eq}), ({}, {refNullEq}));
  // []->[(ref any)] + [(ref n0 eq)]->[(ref n0 eq)] = X
  NO_COMPOSE(({}, {refAny}), ({refN0Eq}, {refN0Eq}));
  // []->[(ref null any)] + [(ref n0 eq)]->[(ref n0 eq)] = X
  NO_COMPOSE(({}, {refNullAny}), ({refN0Eq}, {refN0Eq}));

  // Backward match a concrete nullability.
  // [(ref n0 eq)]->[(ref n0 any)] + [(ref any)]->[] = [(ref eq)]->[]
  COMPOSE(({refN0Eq}, {refN0Any}), ({refAny}, {}), ({refEq}, {}));
  // [(ref n0 eq)]->[(ref n0 any)] + [(ref null any)]->[] = [(ref null eq)]->[]
  COMPOSE(({refN0Eq}, {refN0Any}), ({refNullAny}, {}), ({refNullEq}, {}));
  // [(ref n0 eq)]->[(ref n0 any)] + [(ref eq)]->[] = X
  NO_COMPOSE(({refN0Eq}, {refN0Any}), ({refEq}, {}));
  // [(ref n0 eq)]->[(ref n0 any)] + [(ref null eq)]->[] = X
  NO_COMPOSE(({refN0Eq}, {refN0Any}), ({refNullEq}, {}));
  // [(ref n0 eq)]->[(ref n0 eq)] + [(ref any)]->[] = [(ref eq)]->[]
  COMPOSE(({refN0Eq}, {refN0Eq}), ({refAny}, {}), ({refEq}, {}));
  // [(ref n0 eq)]->[(ref n0 eq)] + [(ref null any)]->[] = [(ref null eq)]->[]
  COMPOSE(({refN0Eq}, {refN0Eq}), ({refNullAny}, {}), ({refNullEq}, {}));

  // Match another variable.
  // [(ref n0 eq)]->[(ref n0 eq)] + [(ref n0' eq)]->[(ref n0' eq)]
  //     = [(ref n0 eq)]->[(ref n0 eq)]
  COMPOSE(
    ({refN0Eq}, {refN0Eq}), ({refN0Eq}, {refN0Eq}), ({refN0Eq}, {refN0Eq}));

  // Match bottom.
  // []*->[] + [(ref n0 any)]->[(ref n0 any)] = []*->[(ref any))]
  COMPOSE(({}, {}, true), ({refN0Any}, {refN0Any}), ({}, {refAny}, true));
  // [(ref n0 any)]->[(ref n0 any)] + []*->[] = [(ref n0 any)]*->[]
  COMPOSE(({refN0Any}, {refN0Any}), ({}, {}, true), ({refN0Any}, {}, true));
}

TEST(PrincipalTypeTest, MatchExactnessVariables) {
  TypeBuilder builder(2);
  builder[0] = Struct{};
  builder[0].setOpen();
  builder[1] = Struct();
  builder[1].subTypeOf(builder[0]);
  auto built = builder.build();
  HeapType foo = (*built)[0];
  VarType refFoo = Type(foo, NonNullable);
  VarType refExactFoo = Type(foo, NonNullable, Exact);
  VarType refE0Foo = VarRef{NonNullable, VarDefHeapType{{0u}, foo}};
  HeapType bar = (*built)[1];
  VarType refBar = Type(bar, NonNullable);
  VarType refExactBar = Type(bar, NonNullable, Exact);
  VarType refE0Bar = VarRef{NonNullable, VarDefHeapType{{0u}, bar}};
  VarType refBot = VarRef{NonNullable, BottomHeapType{}};

  // Forward match a concrete exactness.
  // []->[(ref foo)] + [(ref (e0 foo))]->[(ref (e0 foo))] = []->[(ref foo)]
  COMPOSE(({}, {refFoo}), ({refE0Foo}, {refE0Foo}), ({}, {refFoo}));
  // []->[(ref (exact foo))] + [(ref (e0 foo))]->[(ref (e0 foo))]
  //     = []->[(ref (exact foo))]
  COMPOSE(({}, {refExactFoo}), ({refE0Foo}, {refE0Foo}), ({}, {refExactFoo}));
  // []->[(ref bar)] + [(ref (e0 foo))]->[(ref (e0 foo))] = []->[(ref foo)]
  COMPOSE(({}, {refBar}), ({refE0Foo}, {refE0Foo}), ({}, {refFoo}));
  // []->[(ref (exact bar))] + [(ref (e0 foo))]->[(ref (e0 foo))]
  //     = []->[(ref foo)]
  COMPOSE(({}, {refExactBar}), ({refE0Foo}, {refE0Foo}), ({}, {refFoo}));
  // []->[(ref foo)] + [(ref (e0 bar))]->[(ref (e0 foo))] = X
  NO_COMPOSE(({}, {refFoo}), ({refE0Bar}, {refE0Foo}));
  // []->[(ref (exact foo))] + [(ref (e0 bar))]->[(ref (e0 foo))] = X
  NO_COMPOSE(({}, {refExactFoo}), ({refE0Bar}, {refE0Foo}));

  // Backward match a concrete nullability.
  // [(ref (e0 foo))]->[(ref (e0 foo))] + [(ref foo)]->[] = [(ref foo)]->[]
  COMPOSE(({refE0Foo}, {refE0Foo}), ({refFoo}, {}), ({refFoo}, {}));
  // [(ref (e0 foo))]->[(ref (e0 foo))] + [(ref (exact foo))]->[]
  //     = [(ref (exact foo))]->[]
  COMPOSE(({refE0Foo}, {refE0Foo}), ({refExactFoo}, {}), ({refExactFoo}, {}));
  // [(ref (e0 foo))]->[(ref (e0 foo))] + [(ref bar)]->[] = X
  NO_COMPOSE(({refE0Foo}, {refE0Foo}), ({refBar}, {}));
  // [(ref (e0 foo))]->[(ref (e0 foo))] + [(ref (exact bar))]->[] = X
  NO_COMPOSE(({refE0Foo}, {refE0Foo}), ({refExactBar}, {}));
  // [(ref (e0 foo))]->[(ref (e0 bar))] + [(ref foo)]->[] = [(ref foo)]->[]
  COMPOSE(({refE0Foo}, {refE0Bar}), ({refFoo}, {}), ({refFoo}, {}));
  // [(ref (e0 foo))]->[(ref (e0 bar))] + [(ref (exact foo))]->[] = X
  NO_COMPOSE(({refE0Foo}, {refE0Bar}), ({refExactFoo}, {}));

  // Match another variable.
  // [(ref (e0 foo))]->[(ref (e0 foo))] + [(ref (e0' foo))]->[(ref (e0' foo))]
  //     = [(ref (e0 foo))]->[(ref (e0 foo))]
  COMPOSE(({refE0Foo}, {refE0Foo}),
          ({refE0Foo}, {refE0Foo}),
          ({refE0Foo}, {refE0Foo}));
  // [(ref (e0 foo))]->[(ref (e0 bar))] + [(ref (e0' foo))]->[(ref (e0' foo))]
  //     = [(ref foo)]->[(ref foo)]
  COMPOSE(
    ({refE0Foo}, {refE0Bar}), ({refE0Foo}, {refE0Foo}), ({refFoo}, {refFoo}));
  // [(ref (e0 foo))]->[(ref (e0 foo))] + [(ref (e0' bar))]->[(ref (e0' foo))]
  //     = X
  NO_COMPOSE(({refE0Foo}, {refE0Foo}), ({refE0Bar}, {refE0Foo}));

  // Match bottom.
  // []->[(ref bot)] + [(ref (e0 foo))]->[(ref (e0 foo))]
  //     = []->[(ref (exact foo))]
  COMPOSE(({}, {refBot}), ({refE0Foo}, {refE0Foo}), ({}, {refExactFoo}));
  // [(ref (e0 foo))]->[(ref (e0 foo))] + [(ref bot)]->[] = X
  NO_COMPOSE(({refE0Foo}, {refE0Foo}), ({refBot}, {}));
  // []*->[] + [(ref (e0 foo))]->[(ref (e0 foo))] = []*->[(ref (exact foo))]
  COMPOSE(({}, {}, true), ({refE0Foo}, {refE0Foo}), ({}, {refExactFoo}, true));
  // [(ref (e0 foo))]->[(ref (e0 foo))] + []*->[] = [(ref (e0 foo))]*->[]
  COMPOSE(({refE0Foo}, {refE0Foo}), ({}, {}, true), ({refE0Foo}, {}, true));
}

TEST(PrincipalTypeTest, MatchSharednessVariables) {
  HeapType any = HeapType::any;
  VarType refAny = Type(any, NonNullable);
  VarType refSharedAny = Type(any.getBasic(Shared), NonNullable);
  VarType refBotAny = VarRef{NonNullable, VarAbsHeapType{BottomShare{}, any}};
  VarType refS0Any = VarRef{NonNullable, VarAbsHeapType{{0u}, any}};
  HeapType eq = HeapType::eq;
  VarType refEq = Type(eq, NonNullable);
  VarType refSharedEq = Type(eq.getBasic(Shared), NonNullable);
  VarType refBotEq = VarRef{NonNullable, VarAbsHeapType{BottomShare{}, eq}};
  VarType refS0Eq = VarRef{NonNullable, VarAbsHeapType{{0u}, eq}};
  VarType refBot = VarRef{NonNullable, BottomHeapType{}};

  // Forward match a concrete sharedness.
  // []->[(ref any)] + [(ref (s0 any))]->[(ref (s0 any))] = []->[(ref any)]
  COMPOSE(({}, {refAny}), ({refS0Any}, {refS0Any}), ({}, {refAny}));
  // []->[(ref (shared any))] + [(ref (s0 any))]->[(ref (s0 any))]
  //     = []->[(ref (shared any))]
  COMPOSE(({}, {refSharedAny}), ({refS0Any}, {refS0Any}), ({}, {refSharedAny}));
  // []->[(ref (bot-share any))] + [(ref (s0 any))]->[(ref (s0 any))]
  //     = []->[(ref (bot-share any))]
  COMPOSE(({}, {refBotAny}), ({refS0Any}, {refS0Any}), ({}, {refBotAny}));
  // []->[(ref eq)] + [(ref (s0 any))]->[(ref (s0 any))] = []->[(ref any)]
  COMPOSE(({}, {refEq}), ({refS0Any}, {refS0Any}), ({}, {refAny}));
  // []->[(ref (shared eq))] + [(ref (s0 any))]->[(ref (s0 any))]
  //     = []->[(ref (shared any))]
  COMPOSE(({}, {refSharedEq}), ({refS0Any}, {refS0Any}), ({}, {refSharedAny}));
  // []->[(ref (bot-share eq))] + [(ref (s0 any))]->[(ref (s0 any))]
  //     = []->[(ref (bot-share any))]
  COMPOSE(({}, {refBotEq}), ({refS0Any}, {refS0Any}), ({}, {refBotAny}));
  // []->[(ref any)] + [(ref (s0 eq))]->[(ref (s0 any))] = X
  NO_COMPOSE(({}, {refAny}), ({refS0Eq}, {refS0Any}));
  // []->[(ref (shared any))] + [(ref (s0 eq))]->[(ref (s0 any))] = X
  NO_COMPOSE(({}, {refSharedAny}), ({refS0Eq}, {refS0Any}));
  // []->[(ref (bot-share any))] + [(ref (s0 eq))]->[(ref (s0 any))] = X
  NO_COMPOSE(({}, {refBotAny}), ({refS0Eq}, {refS0Any}));

  // Backward match a concrete sharedness.
  // [(ref (s0 any))]->[(ref (s0 any))] + [(ref any)]->[] = [(ref any)]->[]
  COMPOSE(({refS0Any}, {refS0Any}), ({refAny}, {}), ({refAny}, {}));
  // [(ref (s0 any))]->[(ref (s0 any))] + [(ref (shared any))]->[]
  //     = [(ref (shared any))]->[]
  COMPOSE(({refS0Any}, {refS0Any}), ({refSharedAny}, {}), ({refSharedAny}, {}));
  // [(ref (s0 any))]->[(ref (s0 any))] + [(ref (bot-share any))]->[]
  //     = [(ref (bot-share any))]->[]
  COMPOSE(({refS0Any}, {refS0Any}), ({refBotAny}, {}), ({refBotAny}, {}));
  // [(ref (s0 any))]->[(ref (s0 eq))] + [(ref any)]->[] = [(ref any)]->[]
  COMPOSE(({refS0Any}, {refS0Eq}), ({refAny}, {}), ({refAny}, {}));
  // [(ref (s0 any))]->[(ref (s0 eq))] + [(ref (shared any))]->[]
  //     = [(ref (shared any))]->[]
  COMPOSE(({refS0Any}, {refS0Eq}), ({refSharedAny}, {}), ({refSharedAny}, {}));
  // [(ref (s0 any))]->[(ref (s0 eq))] + [(ref (bot-share any))]->[]
  //     = [(ref (bot-share any))]->[]
  COMPOSE(({refS0Any}, {refS0Eq}), ({refBotAny}, {}), ({refBotAny}, {}));
  // [(ref (s0 any))]->[(ref (s0 any))] + [(ref eq)]->[] = X
  NO_COMPOSE(({refS0Any}, {refS0Any}), ({refEq}, {}));
  // [(ref (s0 any))]->[(ref (s0 any))] + [(ref (shared eq))]->[] = X
  NO_COMPOSE(({refS0Any}, {refS0Any}), ({refSharedEq}, {}));
  // [(ref (s0 any))]->[(ref (s0 any))] + [(ref (bot-share eq))]->[] = X
  NO_COMPOSE(({refS0Any}, {refS0Any}), ({refBotEq}, {}));

  // Match another variable.
  // [(ref (s0 eq))]->[(ref (s0 eq))] + [(ref (s0' eq))]->[(ref (s0' eq))]
  //     = [(ref (s0 eq))]->[(ref (s0 eq))]
  COMPOSE(
    ({refS0Eq}, {refS0Eq}), ({refS0Eq}, {refS0Eq}), ({refS0Eq}, {refS0Eq}));

  // Match bottom.
  // []->[(ref bot)] + [(ref (s0 any))]->[(ref (s0 any))]
  //     = []->[(ref (bot-share any))]
  COMPOSE(({}, {refBot}), ({refS0Any}, {refS0Any}), ({}, {refBotAny}));
  // [(ref (s0 any))]->[(ref (s0 any))] + [(ref bot)]->[] = X
  NO_COMPOSE(({refS0Any}, {refS0Any}), ({refBot}, {}));
  // []*->[] + [(ref (s0 any))]->[(ref (s0 any))] = []*->[(ref (bot-share any))]
  COMPOSE(({}, {}, true), ({refS0Any}, {refS0Any}), ({}, {refBotAny}, true));
  // [(ref (s0 any))]->[(ref (s0 any))] + []*->[] = [(ref (s0 any))]*->[]
  COMPOSE(({refS0Any}, {refS0Any}), ({}, {}, true), ({refS0Any}, {}, true));
}

TEST(PrincipalTypeTest, UnifyVariables) {
  Type i32 = Type::i32;
  HeapType any = HeapType::any;
  Type anyref = Type(any, Nullable);
  Type refAny = Type(any, NonNullable);
  Type refSharedAny = Type(any.getBasic(Shared), NonNullable);
  VarType refBotAny = VarRef{NonNullable, VarAbsHeapType{BottomShare{}, any}};
  VarType refS0Any = VarRef{NonNullable, VarAbsHeapType{{0u}, any}};
  HeapType eq = HeapType::eq;
  Type eqref = Type(eq, Nullable);
  Type refEq = Type(eq, NonNullable);
  Type refSharedEq = Type(eq.getBasic(Shared), NonNullable);
  VarType refBotEq = VarRef{NonNullable, VarAbsHeapType{BottomShare{}, eq}};
  VarType refS0Eq = VarRef{NonNullable, VarAbsHeapType{{0u}, eq}};
  VarType t0 = {0u};
  VarType t1 = {1u};
  VarType t2 = {2u};
  VarType refN0T0 = VarRef{{0u}, {0u}};

  TypeBuilder builder(2);
  builder[0] = Struct{};
  builder[0].setOpen();
  builder[1] = Struct();
  builder[1].subTypeOf(builder[0]);
  auto built = builder.build();
  HeapType foo = (*built)[0];
  VarType refFoo = Type(foo, NonNullable);
  VarType refExactFoo = Type(foo, NonNullable, Exact);
  VarType refE0Foo = VarRef{NonNullable, VarDefHeapType{{0u}, foo}};
  HeapType bar = (*built)[1];
  VarType refBar = Type(bar, NonNullable);
  VarType refExactBar = Type(bar, NonNullable, Exact);

  // Unify multiple variables.
  // []->[t2 t2 t1 t1 t0] + [t2' t1' t1' t0' t0']->[t0' t1' t2']
  //     = []->[t0 t0 t0]
  COMPOSE(({}, {t2, t2, t1, t1, t0}),
          ({t2, t1, t1, t0, t0}, {t0, t1, t2}),
          ({}, {t0, t0, t0}));
  // []->[t1 t1 t0 t0 i32] + [t2' t1' t1' t0' t0']->[t0' t1' t2']
  //     = []->[i32 i32 i32]
  COMPOSE(({}, {t1, t1, t0, t0, i32}),
          ({t2, t1, t1, t0, t0}, {t0, t1, t2}),
          ({}, {i32, i32, i32}));

  // Join multiple type variables.
  // []->[eqref (ref any)] + [t0 t0]->[t0] = []->[anyref]
  COMPOSE(({}, {eqref, refAny}), ({t0, t0}, {t0}), ({}, {anyref}));
  // []->[eqref (ref any)] + [(ref n0 t0) (ref n0 t0)]->[(ref n0 t0)]
  //     = []->[anyref]
  COMPOSE(
    ({}, {eqref, refAny}), ({refN0T0, refN0T0}, {refN0T0}), ({}, {anyref}));
  // TODO: Join abstract and defined heap types.

  // Join sharedness assignments.
  // []->[(ref any) (ref any)]
  //     + [(ref (s0 any)) (ref (s0 any))]->[(ref (s0 eq))] = []->[(ref eq)]
  COMPOSE(
    ({}, {refAny, refAny}), ({refS0Any, refS0Any}, {refS0Eq}), ({}, {refEq}));
  // []->[(ref any) (ref (shared any))]
  //     + [(ref (s0 any)) (ref (s0 any))]->[(ref (s0 eq))] = X
  NO_COMPOSE(({}, {refAny, refSharedAny}), ({refS0Any, refS0Any}, {refS0Eq}));
  // []->[(ref any) (ref (bot-share any))]
  //     + [(ref (s0 any)) (ref (s0 any))]->[(ref (s0 eq))] = []->[(ref eq)]
  COMPOSE(({}, {refAny, refBotAny}),
          ({refS0Any, refS0Any}, {refS0Eq}),
          ({}, {refEq}));
  // []->[(ref (shared any)) (ref any)]
  //     + [(ref (s0 any)) (ref (s0 any))]->[(ref (s0 eq))] = X
  NO_COMPOSE(({}, {refSharedAny, refAny}), ({refS0Any, refS0Any}, {refS0Any}));
  // []->[(ref (shared any)) (ref (shared any))]
  //     + [(ref (s0 any)) (ref (s0 any))]->[(ref (s0 eq))]
  //     = []->[(ref (shared eq))]
  COMPOSE(({}, {refSharedAny, refSharedAny}),
          ({refS0Any, refS0Any}, {refS0Eq}),
          ({}, {refSharedEq}));
  // []->[(ref (shared any)) (ref (bot-share any))]
  //     + [(ref (s0 any)) (ref (s0 any))]->[(ref (s0 eq))]
  //     = []->[(ref (shared eq))]
  COMPOSE(({}, {refSharedAny, refBotAny}),
          ({refS0Any, refS0Any}, {refS0Eq}),
          ({}, {refSharedEq}));
  // []->[(ref (bot-share any)) (ref any)]
  //     + [(ref (s0 any)) (ref (s0 any))]->[(ref (s0 eq))] = []->[(ref eq)]
  COMPOSE(({}, {refBotAny, refAny}),
          ({refS0Any, refS0Any}, {refS0Eq}),
          ({}, {refEq}));
  // []->[(ref (bot-share any)) (ref (shared any))]
  //     + [(ref (s0 any)) (ref (s0 any))]->[(ref (s0 eq))]
  //     = []->[(ref (shared eq)))
  COMPOSE(({}, {refBotAny, refSharedAny}),
          ({refS0Any, refS0Any}, {refS0Eq}),
          ({}, {refSharedEq}));
  // []->[(ref (bot-share any)) (ref (bot-share any))]
  //     + [(ref (s0 any)) (ref (s0 any))]->[(ref (s0 eq))]
  //     = []->[(ref (bot-share eq))]
  COMPOSE(({}, {refBotAny, refBotAny}),
          ({refS0Any, refS0Any}, {refS0Eq}),
          ({}, {refBotEq}));

  // Join exactness assignments.
  // []->[(ref foo) (ref foo)]
  //     + [(ref (e0 foo)) (ref (e0 foo))]->[(ref (e0 foo))] = []->[(ref foo)]
  COMPOSE(
    ({}, {refFoo, refFoo}), ({refE0Foo, refE0Foo}, {refE0Foo}), ({}, {refFoo}));
  // []->[(ref (exact foo)) (ref (exact foo))]
  //     + [(ref (e0 foo)) (ref (e0 foo))]->[(ref (e0 foo))]
  //     = []->[(ref (exact foo))]
  COMPOSE(({}, {refExactFoo, refExactFoo}),
          ({refE0Foo, refE0Foo}, {refE0Foo}),
          ({}, {refExactFoo}));
  // []->[(ref (exact foo)) (ref foo)]
  //     + [(ref (e0 foo)) (ref (e0 foo))]->[(ref (e0 foo))] = []->[(ref foo)]
  COMPOSE(({}, {refExactFoo, refFoo}),
          ({refE0Foo, refE0Foo}, {refE0Foo}),
          ({}, {refFoo}));
  // []->[(ref foo) (ref (exact foo))]
  //     + [(ref (e0 foo)) (ref (e0 foo))]->[(ref (e0 foo))] = []->[(ref foo)]
  COMPOSE(({}, {refFoo, refExactFoo}),
          ({refE0Foo, refE0Foo}, {refE0Foo}),
          ({}, {refFoo}));
  // []->[(ref bar) (ref foo)]
  //     + [(ref (e0 foo)) (ref (e0 foo))]->[(ref (e0 foo))] = []->[(ref foo)]
  COMPOSE(
    ({}, {refBar, refFoo}), ({refE0Foo, refE0Foo}, {refE0Foo}), ({}, {refFoo}));
  // []->[(ref (exact bar)) (ref (exact foo))]
  //     + [(ref (e0 foo)) (ref (e0 foo))]->[(ref (e0 foo))] = []->[(ref foo)]
  COMPOSE(({}, {refExactBar, refExactFoo}),
          ({refE0Foo, refE0Foo}, {refE0Foo}),
          ({}, {refFoo}));
  // []->[(ref (exact bar)) (ref foo)]
  //     + [(ref (e0 foo)) (ref (e0 foo))]->[(ref (e0 foo))] = []->[(ref foo)]
  COMPOSE(({}, {refExactBar, refFoo}),
          ({refE0Foo, refE0Foo}, {refE0Foo}),
          ({}, {refFoo}));
  // []->[(ref bar) (ref (exact foo))]
  //     + [(ref (e0 foo)) (ref (e0 foo))]->[(ref (e0 foo))] = []->[(ref foo)]
  COMPOSE(({}, {refBar, refExactFoo}),
          ({refE0Foo, refE0Foo}, {refE0Foo}),
          ({}, {refFoo}));
  // []->[(ref foo) (ref bar)]
  //     + [(ref (e0 foo)) (ref (e0 foo))]->[(ref (e0 foo))] = []->[(ref foo)]
  COMPOSE(
    ({}, {refFoo, refBar}), ({refE0Foo, refE0Foo}, {refE0Foo}), ({}, {refFoo}));
  // []->[(ref (exact foo)) (ref (exact bar))]
  //     + [(ref (e0 foo)) (ref (e0 foo))]->[(ref (e0 foo))] = []->[(ref foo)]
  COMPOSE(({}, {refExactFoo, refExactBar}),
          ({refE0Foo, refE0Foo}, {refE0Foo}),
          ({}, {refFoo}));
  // []->[(ref (exact foo)) (ref bar)]
  //     + [(ref (e0 foo)) (ref (e0 foo))]->[(ref (e0 foo))] = []->[(ref foo)]
  COMPOSE(({}, {refExactFoo, refBar}),
          ({refE0Foo, refE0Foo}, {refE0Foo}),
          ({}, {refFoo}));
  // []->[(ref foo) (ref (exact bar))]
  //     + [(ref (e0 foo)) (ref (e0 foo))]->[(ref (e0 foo))] = []->[(ref foo)]
  COMPOSE(({}, {refFoo, refExactBar}),
          ({refE0Foo, refE0Foo}, {refE0Foo}),
          ({}, {refFoo}));
}

// Signature interop

// Test that round-tripping works of a signature to a principal type.
static void testSignatureRoundTrip(const Signature& sig) {
  SCOPED_TRACE("Testing signature: " + sig.toString());

  PrincipalType pt(sig);
  std::optional<Signature> maybeSig = pt.getSignature();
  ASSERT_TRUE(maybeSig.has_value());
  EXPECT_EQ(*maybeSig, sig);
}

TEST(PrincipalTypeTest, SignatureRoundTrip) {
  testSignatureRoundTrip(Signature(Type::none, Type::none));
  testSignatureRoundTrip(Signature({Type::i32, Type::f64}, Type::none));
  testSignatureRoundTrip(Signature(Type::none, {Type::i64, Type::f32}));
  testSignatureRoundTrip(
    Signature({Type::i32, Type::f32}, {Type::i64, Type::f64}));
}

TEST(PrincipalTypeTest, GetSignatureFailure) {
  // Failure due to a type variable (Index) in parameters or results.
  {
    PrincipalType pt({0u}, {});
    EXPECT_FALSE(pt.getSignature().has_value());
  }
  {
    PrincipalType pt({}, {0u});
    EXPECT_FALSE(pt.getSignature().has_value());
  }

  // Failure due to a heap type variable (VarRef) in parameters or results.
  {
    PrincipalType pt({VarRef{NonNullable, {0u}}}, {});
    EXPECT_FALSE(pt.getSignature().has_value());
  }
  {
    PrincipalType pt({}, {VarRef{NonNullable, {0u}}});
    EXPECT_FALSE(pt.getSignature().has_value());
  }
}
