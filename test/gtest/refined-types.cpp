#include "type-test.h"
#include "wasm-type-printing.h"
#include "wasm-type.h"
#include "gtest/gtest.h"

using namespace wasm;

using TypeRefinementTest = TypeTest;

TEST_F(TypeRefinementTest, DefaultTop) {
  // Test that the default refinement does not add any information.
  Refinement top;
  EXPECT_FALSE(top);
  EXPECT_EQ(top.subtypeDepth, Refinement::UnboundedDepth);

  Refinement anyRefinement = HeapType(HeapType::any).getRefinement();
  EXPECT_FALSE(anyRefinement);
  EXPECT_EQ(anyRefinement, top);

  Refinement sigRefinement = HeapType(Signature()).getRefinement();
  EXPECT_FALSE(sigRefinement);
  EXPECT_EQ(sigRefinement, top);
}

TEST_F(TypeRefinementTest, CanonicalizeTop) {
  // Test that adding the top refinement to a type does not change the type.
  Refinement top;
  Refinement exact(0);

  HeapType any = HeapType::any;
  EXPECT_EQ(any.refined(top), any);

  HeapType exactAny = any.refined(exact);
  EXPECT_NE(any, exactAny);
  EXPECT_EQ(exactAny.refined(top), exactAny);
  EXPECT_EQ(exactAny.getRefinement(), exact);

  HeapType sig = Signature();
  EXPECT_EQ(sig.refined(top), sig);

  HeapType exactSig = sig.refined(exact);
  EXPECT_NE(sig, exactSig);
  EXPECT_EQ(exactSig.refined(top), exactSig);
  EXPECT_EQ(exactSig.getRefinement(), exact);
}

static void testPassthroughAPI() {
  // Test that other HeapType methods correctly "see through" the refinement.
  Refinement exact(0);

  // `isBasic` is an exception: it should be false for refined types.
  HeapType any = HeapType(HeapType::any).refined(exact);
  EXPECT_FALSE(any.isBasic());

  HeapType sig = HeapType(Signature()).refined(exact);
  HeapType func = HeapType(HeapType::func).refined(exact);
  EXPECT_TRUE(sig.isFunction());
  EXPECT_TRUE(func.isFunction());
  ASSERT_TRUE(sig.isSignature());
  EXPECT_FALSE(func.isSignature());
  EXPECT_EQ(sig.getSignature(), Signature());

  HeapType data = HeapType(HeapType::data).refined(exact);
  EXPECT_TRUE(data.isData());

  HeapType struct_ = HeapType(Struct()).refined(exact);
  EXPECT_TRUE(struct_.isData());
  ASSERT_TRUE(struct_.isStruct());
  EXPECT_EQ(struct_.getStruct(), Struct());

  HeapType array = HeapType(Array(Field())).refined(exact);
  EXPECT_TRUE(struct_.isData());
  ASSERT_TRUE(array.isArray());
  EXPECT_EQ(array.getArray(), Array(Field()));

  TypeBuilder builder(2);
  auto ref = builder.getTempRefType(builder[0], Nullable);
  builder.createRecGroup(0, 2);
  builder[0] = Struct{};
  builder[1] = Struct({Field(ref, Mutable), Field(ref, Mutable)});
  builder[1].subTypeOf(builder[0]);
  auto built = *builder.build();

  HeapType super = built[0];
  HeapType sub = built[1];
  HeapType refinedSub = built[1].refined(exact);
  EXPECT_EQ(refinedSub.getSuperType(), super);
  EXPECT_EQ(refinedSub.getDepth(), 1u);
  EXPECT_EQ(refinedSub.getRecGroup(), sub.getRecGroup());
  EXPECT_EQ(refinedSub.getRecGroupIndex(), sub.getRecGroupIndex());
  EXPECT_EQ(refinedSub.getHeapTypeChildren(),
            (std::vector<HeapType>{super, super}));
  EXPECT_EQ(refinedSub.getReferencedHeapTypes(),
            (std::vector<HeapType>{super, super, super}));

  EXPECT_EQ(any.getSuperType(), std::nullopt);
  EXPECT_EQ(any.getDepth(), 0u);
  EXPECT_EQ(any.getDepthFromAny(), 0u);
  EXPECT_EQ(any.getHeapTypeChildren(), std::vector<HeapType>());
  EXPECT_EQ(any.getReferencedHeapTypes(), std::vector<HeapType>());
}

TEST_F(TypeRefinementTest, PassthroughAPI) { testPassthroughAPI(); }

TEST_F(NominalTest, RefinementPassthroughAPI) { testPassthroughAPI(); }

TEST_F(TypeRefinementTest, PrintRefinement) {
  Refinement exact(0);
  Refinement bounded(2);

  std::stringstream str;
  str << exact;
  EXPECT_EQ(str.str(), "exact");

  str.str("");
  str << bounded;
  EXPECT_EQ(str.str(), "depth 2");

  str.str("");
  str << HeapType(HeapType::any).refined(exact);
  EXPECT_EQ(str.str(), "(; exact ;) any");

  str.str("");
  str << HeapType(Struct{}).refined(bounded);
  EXPECT_EQ(str.str(), "(; depth 2 ;) (struct_subtype data)");
}

TEST_F(TypeRefinementTest, RefinedSubtypes) {
  Refinement exact(0);
  Refinement bounded(2);
  HeapType any = HeapType::any;
  EXPECT_TRUE(HeapType::isSubType(any.refined(exact), any));
  EXPECT_TRUE(HeapType::isSubType(any.refined(bounded), any));

  HeapType func = HeapType::func;
  EXPECT_TRUE(HeapType::isSubType(func.refined(exact), func));
  EXPECT_TRUE(HeapType::isSubType(func.refined(bounded), func));
  EXPECT_TRUE(HeapType::isSubType(func.refined(exact), any));
  EXPECT_TRUE(HeapType::isSubType(func.refined(bounded), any));

  HeapType sig = Signature();
  EXPECT_TRUE(HeapType::isSubType(sig.refined(exact), sig));
  EXPECT_TRUE(HeapType::isSubType(sig.refined(bounded), sig));
  EXPECT_TRUE(HeapType::isSubType(sig.refined(exact), func));
  EXPECT_TRUE(HeapType::isSubType(sig.refined(bounded), func));
  EXPECT_TRUE(HeapType::isSubType(sig.refined(exact), any));
  EXPECT_TRUE(HeapType::isSubType(sig.refined(bounded), any));

  TypeBuilder builder(2);
  builder[0] = Struct{};
  builder[1] = Struct{};
  builder[1].subTypeOf(builder[0]);

  auto result = builder.build();
  ASSERT_TRUE(result);

  auto built = *result;
  EXPECT_TRUE(HeapType::isSubType(built[1].refined(exact), built[1]));
  EXPECT_TRUE(HeapType::isSubType(built[1].refined(bounded), built[1]));
  EXPECT_TRUE(HeapType::isSubType(built[1].refined(exact), built[0]));
  EXPECT_TRUE(HeapType::isSubType(built[1].refined(bounded), built[0]));
}

TEST_F(TypeRefinementTest, RefinedSupertypes) {
  Refinement exact(0);
  Refinement one(1);
  Refinement two(2);
  Refinement three(3);

  HeapType any = HeapType::any;
  EXPECT_FALSE(HeapType::isSubType(any, any.refined(exact)));
  EXPECT_FALSE(HeapType::isSubType(any, any.refined(one)));
  EXPECT_TRUE(HeapType::isSubType(any.refined(exact), any.refined(one)));

  HeapType func = HeapType::func;
  EXPECT_FALSE(HeapType::isSubType(func, any.refined(exact)));
  EXPECT_FALSE(HeapType::isSubType(func, any.refined(one)));
  EXPECT_TRUE(HeapType::isSubType(func.refined(exact), any.refined(one)));
  EXPECT_FALSE(HeapType::isSubType(func.refined(one), any.refined(one)));

  HeapType eq = HeapType::eq;
  EXPECT_FALSE(HeapType::isSubType(eq, any.refined(exact)));
  EXPECT_FALSE(HeapType::isSubType(eq, any.refined(one)));
  EXPECT_TRUE(HeapType::isSubType(eq.refined(exact), any.refined(one)));
  EXPECT_FALSE(HeapType::isSubType(eq.refined(one), any.refined(one)));

  HeapType data = HeapType::data;
  EXPECT_FALSE(HeapType::isSubType(data.refined(exact), any.refined(one)));
  EXPECT_TRUE(HeapType::isSubType(data.refined(exact), any.refined(two)));

  TypeBuilder builder(7);
  builder[0] = Signature();
  builder[1] = Signature();
  builder[2] = Struct{};
  builder[3] = Struct{};
  builder[4] = Struct{};
  builder[5] = Array(Field(Type::i32, Immutable));
  builder[6] = Array(Field(Type::i32, Immutable));
  builder[1].subTypeOf(builder[0]);
  builder[3].subTypeOf(builder[2]);
  builder[4].subTypeOf(builder[3]);
  builder[6].subTypeOf(builder[5]);

  auto result = builder.build();
  ASSERT_TRUE(result);
  auto built = *result;

  auto sigA = built[0];
  auto sigB = built[1];
  auto structA = built[2];
  auto structB = built[3];
  auto structC = built[4];
  auto arrayA = built[5];
  auto arrayB = built[6];

  EXPECT_TRUE(HeapType::isSubType(sigA.refined(exact), func.refined(one)));
  EXPECT_FALSE(HeapType::isSubType(sigB.refined(exact), func.refined(one)));
  EXPECT_TRUE(HeapType::isSubType(sigB.refined(exact), func.refined(two)));
  EXPECT_FALSE(HeapType::isSubType(sigB.refined(one), func.refined(two)));
  EXPECT_TRUE(HeapType::isSubType(sigB.refined(one), func.refined(three)));

  EXPECT_TRUE(HeapType::isSubType(sigB.refined(exact), sigA.refined(one)));
  EXPECT_FALSE(HeapType::isSubType(sigB.refined(one), sigA.refined(one)));
  EXPECT_TRUE(HeapType::isSubType(sigB.refined(one), sigA.refined(two)));

  EXPECT_TRUE(HeapType::isSubType(structA.refined(exact), data.refined(one)));
  EXPECT_FALSE(HeapType::isSubType(structB.refined(exact), data.refined(one)));
  EXPECT_TRUE(HeapType::isSubType(structB.refined(exact), data.refined(two)));

  EXPECT_TRUE(
    HeapType::isSubType(structB.refined(exact), structA.refined(one)));
  EXPECT_FALSE(
    HeapType::isSubType(structC.refined(exact), structA.refined(one)));
  EXPECT_TRUE(
    HeapType::isSubType(structC.refined(exact), structA.refined(two)));

  EXPECT_TRUE(HeapType::isSubType(arrayA.refined(exact), data.refined(one)));
  EXPECT_FALSE(HeapType::isSubType(arrayB.refined(exact), data.refined(one)));
  EXPECT_TRUE(HeapType::isSubType(arrayB.refined(exact), data.refined(two)));

  EXPECT_TRUE(HeapType::isSubType(arrayB.refined(exact), arrayA.refined(one)));
}

TEST_F(TypeRefinementTest, RefinedLUBs) {
  Refinement exact(0);
  Refinement one(1);
  Refinement two(2);
  Refinement three(3);

  HeapType any = HeapType::any;
  HeapType func = HeapType::func;
  HeapType i31 = HeapType::i31;

  EXPECT_EQ(HeapType::getLeastUpperBound(any.refined(exact), any), any);
  EXPECT_EQ(HeapType::getLeastUpperBound(any.refined(exact), any.refined(one)),
            any.refined(one));

  EXPECT_EQ(
    HeapType::getLeastUpperBound(any.refined(exact), func.refined(exact)),
    any.refined(one));
  EXPECT_EQ(HeapType::getLeastUpperBound(any.refined(exact), func.refined(one)),
            any.refined(two));
  EXPECT_EQ(
    HeapType::getLeastUpperBound(any.refined(three), func.refined(exact)),
    any.refined(three));

  EXPECT_EQ(
    HeapType::getLeastUpperBound(func.refined(exact), i31.refined(exact)),
    any.refined(two));
}
