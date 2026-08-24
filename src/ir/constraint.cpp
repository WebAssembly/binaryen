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

#include <optional>

#include "ir/constraint.h"
#include "ir/properties.h"
#include "wasm.h"

namespace wasm::constraint {

namespace {

std::optional<Span<IU64>>
getSpanInternal(const Constraint& c, std::optional<Type> type, bool exact) {
  using namespace Abstract;

  auto* cc = std::get_if<Literal>(&c.term);
  if (cc) {
    // If passed in, the type must be right.
    assert(!type || *type == cc->type);

    type = cc->type;
  }

  if (type && !type->isInteger()) {
    // References etc. do not convert to spans.
    return {};
  }

  auto minSigned = type && *type == Type::i32
                     ? std::numeric_limits<int32_t>::min()
                     : std::numeric_limits<int64_t>::min();
  auto maxSigned = type && *type == Type::i32
                     ? std::numeric_limits<int32_t>::max()
                     : std::numeric_limits<int64_t>::max();
  auto maxUnsigned = type && *type == Type::i32
                       ? std::numeric_limits<uint32_t>::max()
                       : std::numeric_limits<uint64_t>::max();

  if (!cc) {
    // Not comparing to a constant, so we can't infer anything exact, but might
    // if we just need something we can prove, and if we know the type.
    if (exact || !type) {
      return {};
    }

    switch (c.op) {
      // x < y, i.e., x is less than *something*, proves x < MAX_INT.
      case LtS:
        return Span<IU64>{minSigned, maxSigned - 1};
      case LtU:
        return Span<IU64>{0, maxUnsigned - 1};

      // Similarly, x > y proves x > MIN_INT.
      case GtS:
        return Span<IU64>{minSigned + 1, maxSigned};
      case GtU:
        return Span<IU64>{1, maxUnsigned};

      default: {
      }
    }

    return {};
  }

  switch (c.op) {
    case Eq: {
      auto x = cc->getUnsigned();
      if (x <= uint64_t(maxSigned)) {
        // This is in the range of both signed and unsigned values, so there is
        // no ambiguity. That is, we cannot convert the bit pattern
        // 0xffffffff into a Span, as it might be either uint32_t(-1)
        // or actually negative (but a bit pattern like 0x00000001 is
        // always fine as it can only ever be "1").
        return Span<IU64>{x, x};
      }
      break;
    }

    case LtS:
      if (cc->getInteger() == minSigned) {
        // Less than the lowest possible number is an empty span.
        return Span<IU64>::empty();
      } else {
        return Span<IU64>{minSigned, cc->getInteger() - 1};
      }
      break;
    case LtU:
      if (cc->getInteger() == 0) {
        // Less than the lowest possible number is an empty span.
        return Span<IU64>::empty();
      } else {
        return Span<IU64>{0, cc->getUnsigned() - 1};
      }
      break;
    case LeS:
      return Span<IU64>{minSigned, cc->getInteger()};
    case LeU:
      return Span<IU64>{0, cc->getUnsigned()};

    case GtS:
      if (cc->getInteger() == maxSigned) {
        // Greater than the highest possible number is an empty span.
        return Span<IU64>::empty();
      } else {
        return Span<IU64>{cc->getInteger() + 1, maxSigned};
      }
      break;
    case GtU:
      if (cc->getUnsigned() == maxUnsigned) {
        // Greater than the highest possible number is an empty span.
        return Span<IU64>::empty();
      } else {
        return Span<IU64>{cc->getUnsigned() + 1, maxUnsigned};
      }
      break;
    case GeS:
      return Span<IU64>{cc->getInteger(), maxSigned};
    case GeU:
      return Span<IU64>{cc->getUnsigned(), maxUnsigned};

    default: {
    }
  }

  return {};
}

} // anonymous namespace

std::optional<Span<IU64>> Constraint::getSpan(std::optional<Type> type) const {
  return getSpanInternal(*this, type, true);
}

std::optional<Span<IU64>>
Constraint::getProvenSpan(std::optional<Type> type) const {
  return getSpanInternal(*this, type, false);
}

namespace {

Result TrueFalse(bool x) { return x ? True : False; }

Result TrueFalse(Literal x) { return TrueFalse(x.getUnsigned()); }

// Evaluate whether a => b, where a and b are operations on constants.
Result provesConstantPair(Abstract::Op aOp,
                          const Literal& aConstant,
                          Abstract::Op bOp,
                          const Literal& bConstant,
                          bool recursing = false) {
  using namespace Abstract;

  // a == A =?=> a op B. Simply apply A to the operation against B.
  if (aOp == Eq) {
    switch (bOp) {
      case Eq:
        return TrueFalse(aConstant == bConstant);
      case Ne:
        return TrueFalse(aConstant != bConstant);
      case LtS:
        return TrueFalse(aConstant.ltS(bConstant));
      case LeS:
        return TrueFalse(aConstant.leS(bConstant));
      case GtS:
        return TrueFalse(aConstant.gtS(bConstant));
      case GeS:
        return TrueFalse(aConstant.geS(bConstant));
      case LtU:
        return TrueFalse(aConstant.ltU(bConstant));
      case LeU:
        return TrueFalse(aConstant.leU(bConstant));
      case GtU:
        return TrueFalse(aConstant.gtU(bConstant));
      case GeU:
        return TrueFalse(aConstant.geU(bConstant));
      default: {
      }
    }
  }

  // a != A =?=> a == B. False if A = B, else unknown.
  if (aOp == Ne && bOp == Eq) {
    if (aConstant == bConstant) {
      return False;
    }
  }

  // a != A =?=> a != B. True if A = B, else unknown.
  if (aOp == Ne && bOp == Ne) {
    if (aConstant == bConstant) {
      return True;
    }
  }

  if (!recursing) {
    // The flipped operation may tell us something:  y ==> !x  implies
    // x ==> y  is false (because if not, then x would prove y, and y would
    // prove !x, a contradiction).
    if (provesConstantPair(bOp, bConstant, aOp, aConstant, true) == False) {
      return False;
    }
  }

  // TODO: handle all the rest of >, >=, <, and <=
  return Unknown;
}

// Core comparison of two constraints: whether a => b
Result provesPair(const Constraint& a, const Constraint& b) {
  // A thing always implies itself.
  if (a == b) {
    return True;
  }

  // A thing always implies its negation is false.
  if (a == b.negate()) {
    return False;
  }

  // Comparisons of two constants.
  auto* aConstant = std::get_if<Literal>(&a.term);
  auto* bConstant = std::get_if<Literal>(&b.term);
  if (aConstant && bConstant) {
    auto result = provesConstantPair(a.op, *aConstant, b.op, *bConstant);
    if (result != Unknown) {
      return result;
    }
  }

  // If we can represent both as spans, we can calculate that way. At least one
  // must be a constant in this case, so that we know the type.
  if (aConstant || bConstant) {
    auto type = aConstant ? aConstant->type : bConstant->type;
    // Use a proven span for a, and an exact one for b. This allows us to do
    // a => proven span for a => exact span for b => b.
    if (auto aSpan = a.getProvenSpan(type)) {
      if (auto bSpan = b.getSpan(type)) {
        if (aSpan->isEmpty()) {
          // An empty span implies a contradiction (e.g. x > MAX_INT), as it
          // means no possible number can apply. And contradictions prove
          // anything.
          return True;
        }
        if (bSpan->isEmpty()) {
          // Anything that is not a contradiction can prove a contradiction.
          return False;
        }
        if (bSpan->contains(*aSpan)) {
          // b's values contains a's, e.g., b = { 0 < x < 10 } and
          // a = { 3 < x < 7 }, so a => b.
          return True;
        }
        if (!bSpan->hasOverlap(*aSpan)) {
          // There is no overlap at all, e.g., { 0 < x < 10 } vs { 20 < x < 30
          // }, both cannot be true and each proves the other false.
          return False;
        }
      }
    }
  }

  return Unknown;
}

} // anonymous namespace

Result AndedConstraintSet::proves(const Constraint& condition) const {
  if (provesEverything()) {
    return True;
  }
  // Note we do not need to handle the provesNothing case in a special way: the
  // loop below finds nothing.

  // Sometimes a single constraint is enough to determine the condition.
  for (auto& c : *this) {
    auto result = provesPair(c, condition);
    if (result != Unknown) {
      return result;
    }
  }

  // TODO smarts for multiple constraints

  // Otherwise, who knows.
  return Unknown;
}

Result AndedConstraintSet::proves(const AndedConstraintSet& other) const {
  if (provesEverything()) {
    return True;
  }

  if (other.provesEverything()) {
    // We are not a contradiction, but other is, so we prove it false.
    return False;
  }

  bool hasUnknown = false;

  for (auto& c : other) {
    auto result = proves(c);
    if (result == False) {
      // The entire conjunction is proven false.
      return False;
    }
    if (result == Unknown) {
      hasUnknown = true;
    }
  }

  return hasUnknown ? Unknown : True;
}

namespace {

// Do an AND on a pair of constraints, looking for a way to fuse them together
// into a single constraint that represents them both, while assuming the
// constraints have an equal term. If we fail, return nullopt.
std::optional<Constraint> fusedApproximateAndTermEqualPair(
  const Abstract::Op aOp, const Abstract::Op bOp, const Term& term) {
  using namespace Abstract;

  // x < C && x <= C  ===  x < C
  if (aOp == LtS && bOp == LeS) {
    return Constraint{LtS, term};
  }
  if (aOp == LtU && bOp == LeU) {
    return Constraint{LtU, term};
  }

  // TODO: all the rest

  return {};
}

// Do an AND on a pair of constraints, looking for a way to fuse them together
// into a single constraint that represents them both. If we fail, return
// nullopt.
std::optional<Constraint> fusedApproximateAndPair(const Constraint& a,
                                                  const Constraint& b,
                                                  bool recursing = false) {
  // If a proves b is true, all we need is a (e.g. { x == 5 && x > 0 } => x == 5
  if (provesPair(a, b) == True) {
    return a;
  }

  if (a.term == b.term) {
    if (auto result = fusedApproximateAndTermEqualPair(a.op, b.op, a.term)) {
      return result;
    }
  }

  if (!recursing) {
    // The flipped form may be recognized.
    return fusedApproximateAndPair(b, a, true);
  }

  return {};
}

bool isImmediateContradiction(const Constraint& c) {
  using namespace Abstract;

  auto* cc = std::get_if<Literal>(&c.term);
  if (!cc) {
    // Only operations on constants can be immediate contradictions.
    return false;
  }

  auto minSigned = cc->type == Type::i32 ? std::numeric_limits<int32_t>::min()
                                         : std::numeric_limits<int64_t>::min();
  auto maxSigned = cc->type == Type::i32 ? std::numeric_limits<int32_t>::max()
                                         : std::numeric_limits<int64_t>::max();
  auto maxUnsigned = cc->type == Type::i32
                       ? std::numeric_limits<uint32_t>::max()
                       : std::numeric_limits<uint64_t>::max();

  switch (c.op) {
    case LtS:
      if (cc->getInteger() == minSigned) {
        // Less than the lowest possible number.
        return true;
      }
      break;
    case LtU:
      if (cc->getInteger() == 0) {
        // Less than the lowest possible number.
        return true;
      }
      break;
    case GtS:
      if (cc->getInteger() == maxSigned) {
        // Greater than the highest possible number.
        return true;
      }
      break;
    case GtU:
      if (cc->getUnsigned() == maxUnsigned) {
        // Greater than the highest possible number.
        return true;
      }
      break;
    default: {
    }
  }

  return false;
}

} // anonymous namespace

void AndedConstraintSet::approximateAnd(const Constraint& c) {
  if (provesEverything()) {
    // Nothing to add.
    return;
  }

  // We don't store contradictions: identify them and mark us as such.
  if (isImmediateContradiction(c)) {
    setProvesEverything();
    return;
  }

  auto result = proves(c);
  if (result == True) {
    // We already prove c to be true, so it adds nothing.
    return;
  } else if (result == False) {
    // We are now a contradiction.
    setProvesEverything();
    return;
  }

  for (auto& existing : *this) {
    // Some ANDed constraints fuse together into a new constraint.
    if (auto fused = fusedApproximateAndPair(existing, c)) {
      existing = *fused;

      // Sort to ensure we are in the right place.
      std::sort(begin(), end());

      return;
    }
  }

  // TODO: use Spans here when possible

  if (size() < MaxConstraints) {
    // Insert into the right place, keeping us sorted.
    insert(std::upper_bound(begin(), end(), c), c);
    return;
  }

  // Otherwise, just do not add this one.
  // TODO: We could try to be clever and see if one of the existing ones makes
  //       more sense to drop. In particular, we should prefer "better" ones
  //       like > over >= and so forth (sorting more precise ones earlier may be
  //       useful to implement that).
}

namespace {

// Do an OR of a pair of constraints where the terms are known to be equal. If
// we can't find a good way to express their ORing, return nullopt.
std::optional<Constraint> approximateOrTermEqualPair(const Abstract::Op aOp,
                                                     const Abstract::Op bOp,
                                                     const Term& term) {
  using namespace Abstract;

  // x == C || x > C  ===  x >= C
  if (aOp == Eq && bOp == GtS) {
    return Constraint{GeS, term};
  }
  if (aOp == Eq && bOp == GtU) {
    return Constraint{GeU, term};
  }

  // x > C || x >= C  ===  x >= C
  if (aOp == GtS && bOp == GeS) {
    return Constraint{GeS, term};
  }
  if (aOp == GtU && bOp == GeU) {
    return Constraint{GeU, term};
  }

  // TODO: all the rest

  return {};
}

// Do an OR of a pair of constraints where the terms are adjacent constants: a
// operates on C, and b on C+1.
std::optional<Constraint> approximateOrAdjacentConstantPair(
  const Abstract::Op aOp, const Literal& aConstant, const Abstract::Op bOp) {
  using namespace Abstract;

  // x == C || x >= C+1  ===  x >= C, if C+1 does not overflow.
  if (aOp == Eq && bOp == GeS && !aConstant.isSignedMax()) {
    return Constraint{GeS, {aConstant}};
  }
  if (aOp == Eq && bOp == GeU && !aConstant.isUnsignedMax()) {
    return Constraint{GeU, {aConstant}};
  }

  // x > C || x >= C+1  ===  x > C, if C+1 does not overflow.
  if (aOp == GtS && bOp == GeS && !aConstant.isSignedMax()) {
    return Constraint{GtS, {aConstant}};
  }
  if (aOp == GtU && bOp == GeU && !aConstant.isUnsignedMax()) {
    return Constraint{GtU, {aConstant}};
  }

  // TODO: all the rest

  return {};
}

// Do an OR of a pair of constraints. If we can't find a good way to express
// their ORing, return nullopt.
std::optional<Constraint> approximateOrPair(const Constraint& a,
                                            const Constraint& b,
                                            bool recursing = false) {
  if (a.term == b.term) {
    if (auto result = approximateOrTermEqualPair(a.op, b.op, a.term)) {
      return result;
    }
  }

  // See if we operate on constants N, N+1.
  if (auto* ac = std::get_if<Literal>(&a.term)) {
    if (auto* bc = std::get_if<Literal>(&b.term)) {
      if (ac->type == bc->type && ac->type.isInteger() &&
          ac->add(Literal::makeFromInt32(1, ac->type)) == *bc) {
        if (auto result = approximateOrAdjacentConstantPair(a.op, *ac, b.op)) {
          return result;
        }
      }
    }
  }

  // If a proves b, e.g. x = 5 proves x >= 0 is true, then the OR is b.
  if (provesPair(a, b) == True) {
    return b;
  }

  // TODO: more smarts

  if (!recursing) {
    // The flipped form may be recognized.
    return approximateOrPair(b, a, true);
  }

  return {};
}

// Do an OR in full detail, looking at every constraint in each of the given
// sets.
AndedConstraintSet detailedApproximateOr(const AndedConstraintSet& a,
                                         const AndedConstraintSet& b) {
  // We can process this in full detail by looking at all the combinations of
  // individual constraints, because of the distributive property:
  //
  // (A & B) | (C & D) == ((A & B) | C) & ((A & B) | D)
  //                   == (A | C) & (B | C) & (A | D) & (B | D)
  //
  // This is quadratic, but constraint sets are limited to a very small size,
  // making this reasonable.
  //
  // Also, note that we don't need to worry about new contradictions here: ORing
  // things never leads to a contradiction, and we can assume the inputs are
  // not contradictions.
  assert(!a.provesEverything() && !b.provesEverything());

  auto result = AndedConstraintSet::makeProvesNothing();
  for (auto& ac : a) {
    for (auto& bc : b) {
      if (auto combined = approximateOrPair(ac, bc)) {
        // We found something useful by ORing them, keep it.
        result.approximateAnd(*combined);
      }
    }
  }
  return result;
}

} // anonymous namespace

bool AndedConstraintSet::approximateOr(const AndedConstraintSet& other) {
  // If one proves everything, the only thing that matters is the other.
  if (other.provesEverything()) {
    return false;
  }
  if (provesEverything()) {
    *this = other;
    return true;
  }

  // If this is already implied by current constraints, then it is redundant.
  // E.g. if we are { x = 10 } and other is { x >= 0 } then all we need is
  // { x >= 0 } as the result of the OR.
  if (other.proves(*this) == True) {
    return false;
  }
  if (proves(other) == True) {
    *this = other;
    return true;
  }

  // TODO: use Spans here when possible

  // For more complex cases, do a detailed analysis.
  auto result = detailedApproximateOr(*this, other);
  auto changed = (result != *this);
  *this = result;
  return changed;
}

std::optional<LocalConstraint> LocalConstraint::parse(Expression* curr) {
  auto parseEqZArgument =
    [&](Expression* value) -> std::optional<LocalConstraint> {
    if (auto* get = value->dynCast<LocalGet>()) {
      // Canonicalize EqZ to Eq of 0.
      auto value = Literal::makeZero(get->type);
      return LocalConstraint{get->index, Constraint{Abstract::Eq, {value}}};
    }
    // TODO: Recursively parse and reverse a constraint
    return {};
  };

  if (auto* unary = curr->dynCast<Unary>()) {
    if (Abstract::getUnary(unary->value->type, Abstract::EqZ) == unary->op) {
      return parseEqZArgument(unary->value);
    }
    return {};
  }

  if (auto* refIsNull = curr->dynCast<RefIsNull>()) {
    return parseEqZArgument(refIsNull->value);
  }

  // Parse a get or a constant.
  auto parseTerm = [&](Expression* expr) -> std::optional<Term> {
    if (auto* get = expr->dynCast<LocalGet>()) {
      return Term{get->index};
    }
    if (Properties::isSingleConstantExpression(expr)) {
      return Term{Properties::getLiteral(expr)};
    }
    return {};
  };

  auto parseBinaryArguments =
    [&](Abstract::Op op,
        Expression* left,
        Expression* right) -> std::optional<LocalConstraint> {
    // The left must be a get.
    if (auto* get = left->dynCast<LocalGet>()) {
      // The right can be any term.
      if (auto value = parseTerm(right)) {
        return LocalConstraint{get->index, Constraint{op, *value}};
      }
    }
    return {};
  };

  if (auto* binary = curr->dynCast<Binary>()) {
    // The operation must be one we recognize.
    for (auto op : {Abstract::Eq,
                    Abstract::Ne,
                    Abstract::LtS,
                    Abstract::LtU,
                    Abstract::LeS,
                    Abstract::LeU,
                    Abstract::GtS,
                    Abstract::GtU,
                    Abstract::GeS,
                    Abstract::GeU}) {
      if (Abstract::getBinary(binary->left->type, op) == binary->op) {
        return parseBinaryArguments(op, binary->left, binary->right);
      }
    }
    return {};
  }

  if (auto* refEq = curr->dynCast<RefEq>()) {
    return parseBinaryArguments(Abstract::Eq, refEq->left, refEq->right);
  }

  return {};
}

std::optional<LocalConstraint>
LocalConstraint::parseCondition(Expression* curr) {
  // A get by itself is a check for not being null.
  if (auto* get = curr->dynCast<LocalGet>()) {
    auto value = Literal::makeZero(get->type);
    return LocalConstraint{get->index, Constraint{Abstract::Ne, {value}}};
  }

  // Otherwise, parse normally.
  return parse(curr);
};

void LocalConstraint::flip() {
  auto other = std::get<Index>(constraint.term);
  constraint.term = Term{local};
  local = other;
  if (Abstract::isRelationalAntisymmetric(constraint.op)) {
    constraint.op = Abstract::flipRelational(constraint.op);
  } else {
    // All we support for now are symmetric and antisymmetric operations.
    assert(Abstract::isRelationalSymmetric(constraint.op));
  }
}

void BasicBlockConstraintMap::set(Index index, const Constraint& c) {
  set(index, AndedConstraintSet{c});
}

void BasicBlockConstraintMap::set(Index index,
                                  const AndedConstraintSet& constraints) {
  // We should not set values in unreachable code.
  assert(!unreachable);

  // Clear the old state.
  eraseStaleRefs(index);
  map.erase(index);

  // Apply the constraints, if there are any.
  if (constraints.provesNothing()) {
    setProvesNothing(index);
  } else {
    for (auto& c : constraints) {
      approximateAnd(index, c);
    }
  }
}

void BasicBlockConstraintMap::set(Index index, Expression* value) {
  using namespace Match;
  using namespace Abstract;

  // Apply a constraint to a value, x = C.
  if (Properties::isSingleConstantExpression(value)) {
    auto c = Properties::getLiteral(value);
    set(index, Constraint{Eq, {c}});
    return;
  }

  // Apply a constraint to a local, x = y.
  if (auto* get = value->dynCast<LocalGet>()) {
    set(index, Constraint{Eq, {get->index}});
    return;
  }
  if (auto* tee = value->dynCast<LocalSet>()) {
    set(index, Constraint{Eq, {tee->index}});
    return;
  }

  // Apply an increment of a local, x = y + 1.
  Index y;
  if (matches(value, binary(Add, local(&y), ival(1)))) {
    // The local y must have old constraints that we know how to increment and
    // transform into new ones.
    const auto old = get(y);
    auto new_ = old;

    // If we see an unsigned upper bound but not a lower one, we can add a
    // lower one (if we do not overflow). That is, if we see x < 100, x++, then
    // we can not only update x < 100 to x <= 100, but also add x > 0 (since 0
    // is impossible after the ++). This is not possible for signed operations,
    // since x++ does not prove x > 0 there (0 is not the only value that is
    // <= 0).
    bool hasUnsignedUpperBound = false;
    Type type;

    // Iterate over the old constraints and increment each one.
    for (auto iter = new_.begin(); iter != new_.end();) {
      auto& c = *iter;
      auto* N = std::get_if<Literal>(&c.term);
      if (!N) {
        // A non-constant term, which we don't know how to increment. Simply
        // remove it: we are losing proving power here, but doing so is never
        // invalid.
        iter = new_.erase(iter);
        continue;
      }
      type = N->type;

      switch (c.op) {
        // x == N, x++  =>  x == N+1.
        case Eq:
          *N = N->add(Literal::makeFromInt32(1, N->type));
          break;
        // x >= N, x++  =>  x > N if no overflow
        case GeS:
          if (old.proves({LtS, Literal::makeSignedMax(N->type)}) != True) {
            iter = new_.erase(iter);
            continue;
          }
          c.op = GtS;
          break;
        case GeU:
          if (old.proves({LtU, Literal::makeUnsignedMax(N->type)}) != True) {
            iter = new_.erase(iter);
            continue;
          }
          c.op = GtU;
          break;
        // x < N, x++  =>  x <= N
        case LtS:
          c.op = LeS; // do we need it on non-constants too?
          break;
        case LtU:
          c.op = LeU;
          hasUnsignedUpperBound = true;
          break;
        // x <= N, x++ => x <= N+1 if no overflow
        case LeS:
          if (N->isSignedMax()) {
            iter = new_.erase(iter);
            continue;
          }
          *N = N->add(Literal::makeFromInt32(1, N->type));
          break;
        case LeU:
          if (N->isUnsignedMax()) {
            iter = new_.erase(iter);
            continue;
          }
          *N = N->add(Literal::makeFromInt32(1, N->type));
          hasUnsignedUpperBound = true;
          break;
        default:
          // Something we don't recognize.
          iter = new_.erase(iter);
          continue;
      }

      ++iter;
    }

    if (hasUnsignedUpperBound) {
      // We know we did not overflow (we are bounded from above), so add x > 0.
      new_.approximateAnd({GtU, {Literal::makeFromInt32(0, type)}});
    }

    set(index, new_);
    return;
  }

  // We know and can prove nothing.
  setProvesNothing(index);
}

void BasicBlockConstraintMap::setProvesNothing(Index index) {
  assert(!unreachable);
  eraseStaleRefs(index);
  map.erase(index);
}

bool BasicBlockConstraintMap::approximateOr(
  const BasicBlockConstraintMap& other) {
  // If one is unreachable, it adds nothing to the other.
  if (other.unreachable) {
    return false;
  }
  if (unreachable) {
    *this = other;
    return true;
  }

  // We only need to loop on our locals, as any local that is missing in us is
  // one that would end up proving nothing (and get removed).
  bool changed = false;
  for (auto& [local, constraints] : map) {
    changed |= constraints.approximateOr(other.get(local));
  }

  // Anything that became trivial after the OR must be removed.
  std::erase_if(map, [&](const auto& item) {
    const auto& [local, constraints] = item;
    // We do not store contradictions.
    assert(!constraints.provesEverything());
    if (constraints.provesNothing()) {
      changed = true;
      return true;
    }
    return false;
  });

  return changed;
}

void BasicBlockConstraintMap::approximateAndInternal(Index index,
                                                     const Constraint& c,
                                                     bool flip,
                                                     bool isCopy) {
  // We should not be applying constraints when already unreachable.
  assert(!unreachable);

  Constraint actual = c;
  if (flip) {
    LocalConstraint flipped{index, c};
    flipped.flip();
    index = flipped.local;
    actual = flipped.constraint;
  }

  if (auto* other = std::get_if<Index>(&actual.term)) {
    // Never add constraints to ourselves (x == x, etc., which can happen due to
    // copying/flipping).
    if (*other == index) {
      return;
    }

    // If we are applying a constraint to another local, and we know that
    // local's value, propagate it. That is, if x == 42, then if we try to apply
    // y < x we instead apply y < 42, which is better.
    auto otherConstraints = get(*other);
    if (auto lit = otherConstraints.getLiteral()) {
      actual.term = Term{*lit};
    }
  }

  // Refer to the constraints for this index. If this is the first access of
  // the local, then we insert a new item into the map, which has a default of
  // proxesEverything, which we need to flip (provesEverything cannot otherwise
  // be found in the map, as we never store it).
  auto [iter, _] = map.insert({index, AndedConstraintSet::makeProvesNothing()});
  auto& indexConstraints = iter->second;
  // As in ::set(), this makes the map temporarily invalid until the
  // approximateAnd, as we don't store proves-nothing in the map, normally.

  indexConstraints.approximateAnd(actual);

  if (indexConstraints.provesEverything()) {
    // We just proved we are in unreachable code.
    unreachable = true;
    map.clear();
    return;
  }

  // We just added a constraint, so we can prove something (we may lose some
  // information as this is an approximate AND, but we cannot lose it all).
  assert(!indexConstraints.provesNothing());

  // Add a ref of what we are adding. Note that the approximation above may end
  // up not actually adding this, or adding only part of this, but it is safe to
  // always add a ref (at the cost of minor wasted work).
  noteRefs(index, actual);

  // If this is not the flipped version, and it refers to a local, add the
  // flipped one too.
  if (!flip && std::holds_alternative<Index>(actual.term)) {
    approximateAndInternal(index, actual, true, isCopy);
    if (unreachable) {
      // We just found a contradiction.
      return;
    }
  }

  // If this constraint is simply "== x", then we are equal to that other local
  // x, and can copy its constraints (if we are not already such a copy).
  if (!isCopy) {
    if (auto* other = std::get_if<Index>(&actual.term)) {
      if (actual.op == Abstract::Eq) {
        for (auto& otherC : get(*other)) {
          approximateAndInternal(index, otherC, false, true);
          if (unreachable) {
            return;
          }
        }
      }
    }
  }
}

void BasicBlockConstraintMap::noteRefs(Index index, const Constraint& c) {
  if (auto* i = std::get_if<Index>(&c.term)) {
    refs[*i].insert(index);
  }
}

void BasicBlockConstraintMap::eraseStaleRefs(Index index) {
  auto iter = refs.find(index);
  if (iter == refs.end()) {
    return;
  }

  auto& refIndexes = iter->second;

  for (auto refIndex : refIndexes) {
    if (auto iter = map.find(refIndex); iter != map.end()) {
      auto& refConstraints = iter->second;
      std::erase_if(refConstraints, [&](const auto& c) {
        if (auto* i = std::get_if<Index>(&c.term)) {
          if (*i == index) {
            return true;
          }
        }
        return false;
      });
      if (refConstraints.empty()) {
        // This became trivial.
        map.erase(iter);
      }
    }
  }
}

std::ostream& operator<<(std::ostream& o, const Constraint& c) {
  o << "Constraint{" << c.op << ", ";
  if (auto* cc = std::get_if<Literal>(&c.term)) {
    o << *cc;
  } else if (auto* i = std::get_if<Index>(&c.term)) {
    o << "$" << *i;
  }
  o << '}';
  return o;
}

std::ostream& operator<<(std::ostream& o, const AndedConstraintSet& set) {
  if (set.provesEverything()) {
    o << "AndedConstraintSet(contradiction)";
    return o;
  }
  o << "AndedConstraintSet{";
  bool first = true;
  for (auto& constraint : set) {
    if (first) {
      first = false;
    } else {
      o << ", ";
    }
    o << constraint;
  }
  o << '}';
  return o;
}

std::ostream& operator<<(std::ostream& o, const BasicBlockConstraintMap& map) {
  if (map.unreachable) {
    o << "BasicBlockConstraintMap(unreachable)";
    return o;
  }
  o << "BasicBlockConstraintMap{";
  bool first = true;
  for (auto& [local, constraints] : map.map) {
    if (first) {
      first = false;
    } else {
      o << ", ";
    }
    o << local << ": " << constraints;
  }
  o << '}';
  return o;
}

} // namespace wasm::constraint
