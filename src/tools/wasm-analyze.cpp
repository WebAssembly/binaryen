/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Expression analyzer utility
//
// Superoptimization is based on Bansal, Sorav; Aiken, Alex (21–25 October
// 2006): "Automatic Generation of Peephole Superoptimizers".
//

#include "ir/cost.h"
#include "ir/utils.h"
#include "support/colors.h"
#include "support/command-line.h"
#include "support/file.h"
#include "support/hash.h"
#include "support/permutations.h"
#include "wasm-interpreter.h"
#include "wasm-io.h"
#include "wasm-s-parser.h"
#include "wasm-traversal.h"

using namespace cashew;
using namespace wasm;

// limits on what we care about
#define MAX_EXPRESSION_SIZE 20
#define MAX_LOCAL 4

// special values to make sure to consider in execution hashing
#define NUM_LIMITS 6
static int32_t LIMIT_I32S[NUM_LIMITS] = {
  std::numeric_limits<int32_t>::min(),
  std::numeric_limits<int32_t>::max(),
  int32_t(std::numeric_limits<uint32_t>::min()),
  int32_t(std::numeric_limits<uint32_t>::max()),
  0xfffff,
  -0xfffff};
static int64_t LIMIT_I64S[NUM_LIMITS] = {
  std::numeric_limits<int64_t>::min(),
  std::numeric_limits<int64_t>::max(),
  int64_t(std::numeric_limits<uint64_t>::min()),
  int64_t(std::numeric_limits<uint64_t>::max()),
  0xfffffLL,
  -0xfffffLL};
static float LIMIT_F32S[NUM_LIMITS] = {std::numeric_limits<float>::min(),
                                       std::numeric_limits<float>::max(),
                                       std::numeric_limits<float>::quiet_NaN(),
                                       std::numeric_limits<float>::infinity(),
                                       float(0xfffff),
                                       float(-0xfffff)};
static double LIMIT_F64S[NUM_LIMITS] = {
  std::numeric_limits<double>::min(),
  std::numeric_limits<double>::max(),
  std::numeric_limits<double>::quiet_NaN(),
  std::numeric_limits<double>::infinity(),
  double(0xfffff),
  double(-0xfffff)};

#define MAX_SMALL 260
#define NUM_SMALLS                                                             \
  (MAX_SMALL + MAX_SMALL + 1) /* negatives, positives, and zero */

#define NUM_SPECIALS (NUM_LIMITS + NUM_SMALLS)

#define NUM_RANDOMS 1000

#define NUM_EXECUTIONS (NUM_SPECIALS + NUM_RANDOMS)

// An expression with a cached hash value
struct HashedExpression {
  Expression* expr;
  size_t hash;

  HashedExpression(Expression* expr) : expr(expr) {
    if (expr) {
      hash = ExpressionAnalyzer::hash(expr);
    }
  }

  HashedExpression(const HashedExpression& other)
    : expr(other.expr), hash(other.hash) {}
};

struct ExpressionHasher {
  size_t operator()(const HashedExpression value) const { return value.hash; }
};

struct ExpressionComparer {
  bool operator()(const HashedExpression a, const HashedExpression b) const {
    if (a.hash != b.hash)
      return false;
    return ExpressionAnalyzer::equal(a.expr, b.expr);
  }
};

// expression -> a count
class ExpressionIntMap : public std::unordered_map<HashedExpression,
                                                   size_t,
                                                   ExpressionHasher,
                                                   ExpressionComparer> {};

// global expression state
Module global;          // a module that persists til the end
ExpressionIntMap freqs; // expression -> its frequency

// Normalize an expression, replacing irrelevant bits with
// generalizations to get_local, and make get_locals start
// from 0. Returns nullptr if the expression is irrelevant.
static Expression* normalize(Expression* expr, Module& wasm) {
  struct Normalizer {
    Module& wasm;
    Builder builder;
    Index nextLocal = 0;
    std::unordered_map<Index, Index> localMap; // old local index => new

    Normalizer(Module& wasm) : wasm(wasm), builder(wasm) {}

    Expression* parentCopy(Expression* curr) {
      return ExpressionManipulator::flexibleCopy(
        curr, wasm, [&](Expression* curr) { return this->copy(curr); });
    }

    Expression* copy(Expression* curr) {
      // For now, we only handle math-type expressions: having a return value
      // and no side effects
      // TODO: do more stuff, modeling side effects etc.
      if (!curr->type.isConcrete()) {
        return builder.makeUnreachable();
      }
      if (auto* get = curr->dynCast<LocalGet>()) {
        Index newIndex;
        auto iter = localMap.find(get->index);
        if (iter == localMap.end()) {
          newIndex = nextLocal++;
          localMap[get->index] = newIndex;
        } else {
          newIndex = iter->second;
        }
        return builder.makeLocalGet(newIndex, get->type);
      }
      if (curr->is<LocalSet>()) {
        assert(curr->type != Type::none); // this is a tee
        // look through the tee
        return parentCopy(curr->cast<LocalSet>()->value);
      }
      if (curr->is<Load>()) {
        // consider the general case of an arbitrary expression here
        return builder.makeLocalGet(nextLocal++, curr->type);
      }
      if (curr->is<Call>() ||
          curr->is<CallIndirect>() || curr->is<GlobalGet>() ||
          curr->is<Load>() || curr->is<Return>() || curr->is<Break>() ||
          curr->is<Switch>()) {
        return builder.makeUnreachable();
      }
      return nullptr; // allow the default copy to proceed
    }
  } normalizer(wasm);

  auto* ret = ExpressionManipulator::flexibleCopy(
    expr, wasm, [&](Expression* curr) { return normalizer.copy(curr); });

  if (!ret->type.isConcrete() || normalizer.nextLocal >= MAX_LOCAL ||
      Measurer::measure(ret) > MAX_EXPRESSION_SIZE) {
    return nullptr;
  }
  return ret;
}

// Scan an expression for local types. Assumes it has MAX_LOCAL locals at most
struct ScanLocals
  : public WalkerPass<PostWalker<ScanLocals, Visitor<ScanLocals>>> {
  Type localTypes[MAX_LOCAL];

  ScanLocals(Expression* expr) {
    for (Index i = 0; i < MAX_LOCAL; i++) {
      localTypes[i] = Type::none;
    }
    walk(expr);
  }

  void visitLocalGet(LocalGet* curr) {
    assert(curr->index < MAX_LOCAL);
    localTypes[curr->index] = curr->type;
  }
};

// Remap locals
struct RemapLocals
  : public WalkerPass<PostWalker<RemapLocals, Visitor<RemapLocals>>> {
  std::vector<Index>& mapping;

  RemapLocals(Expression* expr, std::vector<Index>& mapping)
    : mapping(mapping) {
    walk(expr);
  }

  void visitLocalGet(LocalGet* curr) {
    curr->index = mapping[curr->index];
    assert(curr->index < MAX_LOCAL);
  }

  void visitLocalSet(LocalSet* curr) {
    curr->index = mapping[curr->index];
    assert(curr->index < MAX_LOCAL);
  }
};

struct ScanSettings {
  Index* totalExpressions;
  bool adviseOnly;
  ScanSettings(Index* totalExpressions, bool adviseOnly)
    : totalExpressions(totalExpressions), adviseOnly(adviseOnly) {}
};

// Scan a module for expressions
struct Scan
  : public WalkerPass<PostWalker<Scan, UnifiedExpressionVisitor<Scan>>> {
  ScanSettings settings;

  Scan(ScanSettings settings) : settings(settings) {}

  void doWalkFunction(Function* func) {
    // std::cout << "  [" << func->name << ']' << '\n';
    walk(func->body);
  }

  void visitExpression(Expression* curr) {
    // normalize the expression, creating a temporary copy in this module,
    // which is ephemeral TODO: avoid keeping them alive til the end of
    // module processing to reduce peak mem usage?
    auto* normalized = normalize(curr, *getModule());
    if (!normalized)
      return;
    if (!settings.adviseOnly) {
      (*settings.totalExpressions)++; // this is relevant, count it
    }
    HashedExpression hashed(normalized);
    auto iter = freqs.find(hashed);
    if (iter != freqs.end()) {
      if (!settings.adviseOnly) {
        iter->second++; // just increment it
      }
    } else {
      // create a persistent copy in the global module TODO: avoid the rehash
      // here
      auto* copy = ExpressionManipulator::copy(normalized, global);
      freqs[HashedExpression(copy)] = settings.adviseOnly ? 0 : 1;
#if 1
      // add the permutations on the locals as well, with freq 0, as we just
      // want to use them as optimization targets, we don't need to optimize
      // them, we optimize the canonical first form.
      ScanLocals scanner(copy);
      if (scanner.localTypes[1] != Type::none) {
        struct PermutationsLister {
          std::vector<std::vector<std::vector<Index>>>
            list; // index => list of permutations of that size
          PermutationsLister() {
            list.resize(MAX_LOCAL + 1);
            for (size_t i = 1; i < MAX_LOCAL + 1; i++) {
              list[i] = makeAllPermutations(i);
            }
          }
        };
        static PermutationsLister permutationsLister;
        Index numLocals = 2;
        while (numLocals < MAX_LOCAL && scanner.localTypes[numLocals] != Type::none) {
          numLocals++;
        }
        assert(numLocals <= MAX_LOCAL);
        auto& perms = permutationsLister.list.at(numLocals);
        // ignore the special first we already handled
        for (size_t i = 0; i < perms.size(); i++) {
          auto* remapped = ExpressionManipulator::copy(copy, global);
          RemapLocals remapper(remapped, perms[i]);
          auto hashed = HashedExpression(remapped);
          if (freqs.find(hashed) == freqs.end()) {
            freqs[hashed] = 0;
          }
        }
      }
#endif
    }
  }
};

// Generate local values deterministically, using a seed
class LocalGenerator {
  Index seed;

public:
  LocalGenerator(Index seed) : seed(seed) {}

  Literal get(Index index, Type type) {
    // use low indexes to ensure we get representation of a few special values
    // TODO: get each of the MAX_LOCALS to all of its NUM_SPECIALS values
    int64_t special =
      seed; // start with 0-NS having them all taking the same value
    if (special >= NUM_SPECIALS) { // then give each a range for itself
      special = int64_t(seed) - int64_t(NUM_SPECIALS * (index + 1));
    }
    if (special >= 0 && special < NUM_SPECIALS) {
      if (special < NUM_LIMITS) {
        if (type == Type::i32) {
          return Literal(LIMIT_I32S[special]);
        } else if (type == Type::i64) {
          return Literal(LIMIT_I64S[special]);
        } else if (type == Type::f32) {
          return Literal(LIMIT_F32S[special]);
        } else if (type == Type::f64) {
          return Literal(LIMIT_F64S[special]);
        } else {
          WASM_UNREACHABLE("bad type");
        }
      } else {
        special -= NUM_LIMITS;
        assert(special >= 0 && special < NUM_SMALLS);
        special -= MAX_SMALL;
        assert(special >= -MAX_SMALL && special <= MAX_SMALL);
        if (type == Type::i32) {
          return Literal(int32_t(special));
        } else if (type == Type::i64) {
          return Literal(int64_t(special));
        } else if (type == Type::f32) {
          return Literal(float(special));
        } else if (type == Type::f64) {
          return Literal(double(special));
        } else {
          WASM_UNREACHABLE("bad type");
        }
      }
    }
    // a general "random"/deterministic value
    auto base = rehash(seed, index);
    switch (type) {
      case i32:
      case f32: {
        auto ret = Literal(rehash(base, Index(type)));
        if (type == f32)
          ret = ret.castToF32();
        return ret;
      }
      case i64:
      case f64: {
        auto ret = Literal(rehash(base, Index(type)) |
                           (int64_t(rehash(base, Index(type + 1000))) << 32));
        if (type == f64)
          ret = ret.castToF64();
        return ret;
      }
      default:
        WASM_UNREACHABLE();
    }
  }
};

struct TrapException {}; // TODO: use a flow label for optimization?

// Execute the expression over a set of local values
class Runner : public ExpressionRunner<Runner> {
  LocalGenerator& localGenerator;

public:
  Runner(LocalGenerator& localGenerator) : localGenerator(localGenerator) {}

  Flow visitLoop(Loop* curr) {
    // loops might be infinite, so must be careful
    // but we can't tell if non-infinite, since we don't have state, so loops
    // are just impossible to optimize for now
    trap("loop");
    WASM_UNREACHABLE();
  }

  Flow visitCall(Call* curr) {
    abort(); // we should not see this
  }
  Flow visitCallIndirect(CallIndirect* curr) {
    abort(); // we should not see this
  }
  Flow visitLocalGet(LocalGet* curr) {
    return Flow(localGenerator.get(curr->index, curr->type));
  }
  Flow visitLocalSet(LocalSet* curr) {
    abort(); // we should not see this
  }
  Flow visitGlobalGet(GlobalGet* curr) {
    abort(); // we should not see this
  }
  Flow visitGlobalSet(GlobalSet* curr) {
    abort(); // we should not see this
  }
  Flow visitLoad(Load* curr) {
    abort(); // we should not see this
  }
  Flow visitStore(Store* curr) {
    abort(); // we should not see this
  }

  void trap(const char* why) override { throw TrapException(); }
};

// Calculate a hash value based on executing an expression
struct ExecutionHasher {
  std::unordered_map<size_t, std::vector<Expression*>>
    hashClasses; // hash value => list of expressions that have it, so they may
                 // be equal

  void note(Expression* expr) {
    size_t hash;
    try {
      hash = doHash(expr);
    } catch (TrapException& e) {
      // we don't bother trying to handle things that trap TODO: maybe abort the
      // whole thing, move try out, for speed?
      return;
    }
    hashClasses[hash].push_back(expr); // we depend on expr being unique, so the
                                       // classes are mathematical sets
  }

  size_t doHash(Expression* expr) {
    // combine the result of multiple executions into the final hash
    size_t hash = 0;
    for (Index i = 0; i < NUM_EXECUTIONS; i++) {
      LocalGenerator localGenerator(i);
      Flow flow = Runner(localGenerator).visit(expr);
      if (flow.breaking()) {
        hash = rehash(hash, 1);
        hash = rehash(hash, 2);
        hash = rehash(hash, 3);
        hash = rehash(hash, size_t(flow.breakTo.str));
      } else {
        hash = rehash(hash, 4);
        hash = rehash(hash, flow.value.type);
        switch (flow.value.type) {
          case f32:
            flow.value = flow.value.castToI32();
            break;
          case f64:
            flow.value = flow.value.castToI64();
            break;
          default: {
          }
        }
        switch (flow.value.type) {
          case Type::none:
            hash = rehash(hash, 5);
            hash = rehash(hash, 6);
            break;
          case i32:
            hash = rehash(hash, flow.value.geti32());
            hash = rehash(hash, 7);
            break;
          case i64:
            hash = rehash(hash, flow.value.geti64());
            hash = rehash(hash, flow.value.geti64() >> 32);
            break;
          default:
            WASM_UNREACHABLE();
        }
      }
    }
    return hash;
  }
};

// calculate the weight of an expression - a value we wish to minimize
Index calcWeight(Expression* expr) {
  return /* CostAnalyzer(expr).cost + */ Measurer::measure(expr);
}

// can our optimizer do better on a than b?
static bool alreadyOptimizable(Expression* input,
                               Type localTypes[MAX_LOCAL],
                               Expression* output) {
  Module temp;
  // make a single function that receives the expressions locals and returns its
  // output
  auto* func = new Function();
  func->name = Name("temp");
  func->result = input->type;
  for (Index i = 0; i < MAX_LOCAL; i++) {
    func->params.push_back(localTypes[i]);
  }
  func->body = ExpressionManipulator::copy(input, temp);
  temp.addFunction(func);
  // export the function, so optimizations don't kill it!
  auto* export_ = new Export();
  export_->name = Name("export");
  export_->value = func->name;
  export_->kind = ExternalKind::Function;
  temp.addExport(export_);
  // run the optimizer
  PassRunner passRunner(&temp);
  passRunner.addDefaultOptimizationPasses();
  passRunner.run();
  // evaluate the output vs b
  return calcWeight(func->body) <= calcWeight(output);
}

// Given two expressions that hashing suggests might be the same, try
// harder directly on the two to prove or disprove equivalence
bool looksValid(Expression* a, Expression* b) {
  if (a->type != b->type)
    return false; // hash collision, these are not even the same type
  // local types must be identical, otherwise the rule isn't even valid to apply
  ScanLocals aScanner(a), bScanner(b);
  for (Index i = 0; i < MAX_LOCAL; i++) {
    if (aScanner.localTypes[i] != bScanner.localTypes[i]) {
      return false; // mismatching local types
    }
  }
  // Let's use brute force: we'll run the same checks we run for hashing,
  // but instead of a single hash summarizing it all, we'll check each
  // case on the two expressions.
  for (Index i = 0; i < NUM_EXECUTIONS; i++) {
    LocalGenerator localGenerator(i);
    Flow aFlow = Runner(localGenerator).visit(a);
    Flow bFlow = Runner(localGenerator).visit(b);
    // TODO: breaking
    if (aFlow.value != bFlow.value)
      return false;
  }
  // let's see if this possible optimization is already something our
  // optimizer can do: if we optimize the input, do we get something
  // as good or better than the output?
  if (alreadyOptimizable(a, aScanner.localTypes, b))
    return false;
  // we see no reason these two should not be joined together in holy optimony
  return true;
}

// Generalize an expression. Currently just generalizes away
// constant values, but we should do more, e.g. maybe fold away
// differences in shifts? TODO

Expression* generalize(Expression* expr, Module& wasm) {
  struct Generalizer {
    Module& wasm;
    Builder builder;

    Generalizer(Module& wasm) : wasm(wasm), builder(wasm) {}

    Expression* copy(Expression* curr) {
      if (curr->is<Const>()) {
        return builder.makeUnreachable();
      }
      return nullptr; // allow the default copy to proceed
    }
  } generalizer(wasm);

  return ExpressionManipulator::flexibleCopy(
    expr, wasm, [&](Expression* curr) { return generalizer.copy(curr); });
}

int main(int argc, const char* argv[]) {
  // receive arguments
  std::vector<std::string> filenames;
  Options options(
    "wasm-analyze",
    "Analyze a set of wasm modules. Provide a set of input files, optionally "
    "split by 'advice:' (in which case files afterwards are just advice, used "
    "to find optimization outputs but not inputs we focus on optimizing)");
  options.add_positional("INFILES",
                         Options::Arguments::N,
                         [&](Options* o, const std::string& argument) {
                           filenames.push_back(argument);
                         });
  options.parse(argc, argv);

  Index totalExpressions = 0;
  bool adviseOnly = false;

  // read inputs
  for (auto& filename : filenames) {
    if (filename == "advice:" || filename == "advise:") {
      adviseOnly = true;
      std::cerr << "[advice-only from here]\n";
      continue;
    }

    auto input(read_file<std::string>(filename, Flags::Text, Flags::Release));
    Module wasm;

    std::cerr << "[processing: " << filename << ']' << '\n';

    try {
      ModuleReader reader;
      reader.read(filename, wasm);
    } catch (ParseException& p) {
      p.dump(std::cerr);
      Fatal() << "error in parsing input " << filename;
    }

    // scan all expressions in all functions, optimized and not
    PassRunner passRunner(&wasm);
    passRunner.add<Scan>(ScanSettings(&totalExpressions, adviseOnly));
    passRunner.addDefaultOptimizationPasses();
    passRunner.add<Scan>(ScanSettings(&totalExpressions, adviseOnly));
    passRunner.run();
  }

  // print frequencies
#if 0
  std::cout << "Frequencies:\n";
  std::vector<HashedExpression> sorted;
  for (auto& iter : freqs) {
    sorted.push_back(iter.first);
  }
  std::sort(sorted.begin(), sorted.end(), [&](const HashedExpression& a, const HashedExpression& b) {
    auto diff = int64_t(freqs[a]) - int64_t(freqs[b]);
    if (diff > 0) return true;
    if (diff < 0) return false;
    return size_t(a.expr) < size_t(b.expr);
  });
  for (auto& item : sorted) {
    std::cout << freqs[item] << " : " << item.expr << '\n';
  }
#endif

  // perform execution hashing, looking for expressions that are functionally
  // equivalent, so one can be optimized to the other

  std::cerr << "[hashing executions]\n";

  ExecutionHasher executionHasher;

  for (auto& iter : freqs) {
    auto* expr = iter.first.expr;
    executionHasher.note(expr);
  }

  // Basic statistics
  std::cerr << "[writing basic output]\n";
  std::cout << "Execution hashing info:\n";
  std::cout << "  num expression nodes in total: " << totalExpressions << '\n';
  std::cout << "  num unique expressions: " << freqs.size() << '\n';
  {
    size_t total = 0;
    for (auto& pair : executionHasher.hashClasses) {
      total += pair.second.size();
    }
    std::cout << "  num relevant expressions: " << total << '\n';
  }
  std::cout << "  num execution classes: " << executionHasher.hashClasses.size()
            << '\n';
  {
    size_t max = 0;
    for (auto& pair : executionHasher.hashClasses) {
      max = std::max(max, pair.second.size());
    }
    std::cout << "  max class size: " << max << '\n';
  }

  // Detailed output
  {
    // a rule is a connection between one pattern and another, which we think
    // may be equivalent to it, and which may provide a measured benefit
    // TODO: test rules on more random inputs, trying to prove they are not
    // equivalent?
    struct Rule {
      Expression* from;
      Expression* to;
      size_t benefit;

      Rule(Expression* from, Expression* to, size_t benefit)
        : from(from), to(to), benefit(benefit) {}
    };

    std::vector<Rule> rules;

    std::cerr << "[finding rules]\n";

    for (auto& pair : executionHasher.hashClasses) {
      auto& clazz = pair.second;
      Index size = clazz.size();
      if (size < 2)
        continue;
      // consider all pairs, since some may be spurious hash collisions
      for (Index i = 0; i < size; i++) {
        auto* iExpr = clazz[i];
        auto iFreq = freqs[iExpr];
        if (iFreq == 0)
          continue; // no frequency means no benefit to optimize it; this
                    // expression is just a target of optimization, not an
                    // origin
        Index iSize = calcWeight(iExpr);
        Expression* best = nullptr;
        Index bestSize = -1;
        for (Index j = 0; j < size; j++) {
          if (i == j)
            continue;
          auto* jExpr = clazz[j];
          Index jSize = calcWeight(jExpr);
          // we are looking for a rule where i => j, so we need j to be smaller
          if (iSize <= jSize)
            continue; // TODO: for equality, look not just at size, but cost
                      // etc.
          // a likely candidate, if direct attempts to prove they differ fail,
          // this is worth reporting to the user
          if (best && jSize >= bestSize)
            continue; // we can't do better
          if (looksValid(iExpr, jExpr)) {
            best = jExpr;
            bestSize = jSize;
          }
        }
        if (best) {
          rules.emplace_back(iExpr, best, (iSize - bestSize) * iFreq);
        }
      }
    }

    // Many rules are part of a more general pattern, for example x + 1 + 1 ===
    // x + 2 is closely related to x + 1 + 2 === x + 3. The generalized rule is
    // what the human would write in the optimizer, so to assess the benefit of
    // rules, we must generalize in our output.

    std::cerr << "[generalizing]\n";

    struct GeneralizedRule : public Rule {
      std::vector<Rule*>
        rules; // the specific rules underlying this generalization

      GeneralizedRule(Expression* from, Rule* rule) : Rule(from, nullptr, 0) {
        addRule(rule);
      }

      void addRule(Rule* rule) {
        benefit += rule->benefit;
        rules.push_back(rule);
      }
    };

    // hashed from expression => the generalized rules for that expression
    std::unordered_map<HashedExpression,
                       GeneralizedRule,
                       ExpressionHasher,
                       ExpressionComparer>
      generalizedRules;

    for (auto& rule : rules) {
      auto generalizedFrom = HashedExpression(generalize(
        rule.from,
        global)); // TODO: save memory, don't use global unless needed?
      auto iter = generalizedRules.find(generalizedFrom);
      if (iter == generalizedRules.end()) {
        generalizedRules.emplace(generalizedFrom,
                                 GeneralizedRule(generalizedFrom.expr, &rule));
      } else {
        iter->second.addRule(&rule);
      }
    }

    // final sorting and output
    std::cerr << "[sorting generalized rules]\n";

    std::vector<GeneralizedRule*> sortedGeneralizedRules;

    for (auto& pair : generalizedRules) {
      sortedGeneralizedRules.push_back(&pair.second);
    }

    auto ruleSorter = [](const Rule* a, const Rule* b) {
      // primary sorting criteria is the size benefit
      auto diff = int64_t(a->benefit) - int64_t(b->benefit);
      if (diff > 0)
        return true;
      if (diff < 0)
        return false;
      return size_t(a->from) < size_t(b->from);
    };

    std::sort(
      sortedGeneralizedRules.begin(),
      sortedGeneralizedRules.end(),
      [&ruleSorter](const GeneralizedRule* a, const GeneralizedRule* b) {
        return ruleSorter(a, b);
      });

    std::cout << "sorted possible optimization rules:\n";

    Index totalWeight = totalExpressions * 2; // Just an estimate FIXME

    size_t i = 0;
    for (auto* item : sortedGeneralizedRules) {
      std::cout << "\n[generalized rule " << (i++)
                << ": benefit: " << item->benefit << ", ("
                << (100 * double(item->benefit) / totalWeight)
                << "%)], input pattern:\n"
                << item->from << '\n';
      // show the specific rules underlying the generalized one
      std::sort(item->rules.begin(), item->rules.end(), ruleSorter);
      for (auto* rule : item->rules) {
        std::cout << "\n[child specific rule benefit: " << rule->benefit
                  << ", (" << (100 * double(rule->benefit) / totalWeight)
                  << "%)], possible rule:\n"
                  << rule->from << "\n =->\n"
                  << rule->to << '\n';
      }
    }
  }

  // TODO TODO: if all execution hashes of expr are the same, it might be
  // constant (avoids needing to have all constants hashed)
}
