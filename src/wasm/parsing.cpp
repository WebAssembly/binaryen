/*
 * Copyright 2021 WebAssembly Community Group participants
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

#include "parsing.h"
#include "ir/branch-utils.h"
#include "support/small_set.h"

namespace wasm {

void ParseException::dump(std::ostream& o) const {
  Colors::magenta(o);
  o << "[";
  Colors::red(o);
  o << "parse exception: ";
  Colors::green(o);
  o << text;
  if (line != size_t(-1)) {
    Colors::normal(o);
    o << " (at " << line << ":" << col << ")";
  }
  Colors::magenta(o);
  o << "]";
  Colors::normal(o);
}

void MapParseException::dump(std::ostream& o) const {
  Colors::magenta(o);
  o << "[";
  Colors::red(o);
  o << "map parse exception: ";
  Colors::green(o);
  o << text;
  Colors::magenta(o);
  o << "]";
  Colors::normal(o);
}

// UniqueNameMapper

Name UniqueNameMapper::getPrefixedName(Name prefix) {
  if (reverseLabelMapping.find(prefix) == reverseLabelMapping.end()) {
    return prefix;
  }
  // make sure to return a unique name not already on the stack
  while (1) {
    Name ret = prefix.toString() + std::to_string(otherIndex++);
    if (reverseLabelMapping.find(ret) == reverseLabelMapping.end()) {
      return ret;
    }
  }
}

Name UniqueNameMapper::pushLabelName(Name sName) {
  Name name = getPrefixedName(sName);
  labelStack.push_back(name);
  labelMappings[sName].push_back(name);
  reverseLabelMapping[name] = sName;
  return name;
}

void UniqueNameMapper::popLabelName(Name name) {
  assert(labelStack.back() == name);
  labelStack.pop_back();
  labelMappings[reverseLabelMapping[name]].pop_back();
}

Name UniqueNameMapper::sourceToUnique(Name sName) {
  // DELEGATE_CALLER_TARGET is a fake target used to denote delegating to the
  // caller. We do not need to modify it, as it has no definitions, only uses.
  if (sName == DELEGATE_CALLER_TARGET) {
    return DELEGATE_CALLER_TARGET;
  }
  if (labelMappings.find(sName) == labelMappings.end()) {
    throw ParseException("bad label in sourceToUnique: " + sName.toString());
  }
  if (labelMappings[sName].empty()) {
    throw ParseException("use of popped label in sourceToUnique: " +
                         sName.toString());
  }
  return labelMappings[sName].back();
}

Name UniqueNameMapper::uniqueToSource(Name name) {
  if (reverseLabelMapping.find(name) == reverseLabelMapping.end()) {
    throw ParseException("label mismatch in uniqueToSource");
  }
  return reverseLabelMapping[name];
}

void UniqueNameMapper::clear() {
  labelStack.clear();
  labelMappings.clear();
  reverseLabelMapping.clear();
}

namespace {

struct DuplicateNameScanner
  : public PostWalker<DuplicateNameScanner,
                      UnifiedExpressionVisitor<DuplicateNameScanner>> {

  // Whether things are ok. If not, we need to fix things up.
  bool ok = true;

  // It is rare to have many nested names in general, so track the seen names
  // as we go in an efficient way.
  SmallUnorderedSet<Name, 10> seen;

  void visitExpression(Expression* curr) {
    BranchUtils::operateOnScopeNameDefs(curr, [&](Name& name) {
      if (!name.is()) {
        return;
      }
      // TODO: This could be done in a single insert operation that checks
      //       whether we actually inserted, if we improved
      //       SmallSetBase::insert to return a value like std::set does.
      if (seen.count(name)) {
        // A name has been defined more than once; we'll need to fix that.
        ok = false;
      } else {
        seen.insert(name);
      }
    });
  }
};

} // anonymous namespace

void UniqueNameMapper::uniquify(Expression* curr) {
  // First, scan the code to see if anything needs to be fixed up, since in the
  // common case nothing needs fixing, and we can verify that very quickly.
  DuplicateNameScanner scanner;
  scanner.walk(curr);
  if (scanner.ok) {
    return;
  }

  struct Walker
    : public ControlFlowWalker<Walker, UnifiedExpressionVisitor<Walker>> {
    UniqueNameMapper mapper;

    static void doPreVisitControlFlow(Walker* self, Expression** currp) {
      BranchUtils::operateOnScopeNameDefs(*currp, [&](Name& name) {
        if (name.is()) {
          name = self->mapper.pushLabelName(name);
        }
      });
    }

    static void doPostVisitControlFlow(Walker* self, Expression** currp) {
      BranchUtils::operateOnScopeNameDefs(*currp, [&](Name& name) {
        if (name.is()) {
          self->mapper.popLabelName(name);
        }
      });
    }

    void visitExpression(Expression* curr) {
      BranchUtils::operateOnScopeNameUses(curr, [&](Name& name) {
        if (name.is()) {
          name = mapper.sourceToUnique(name);
        }
      });
    }
  } walker;

  walker.walk(curr);
}

} // namespace wasm
