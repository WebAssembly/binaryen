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
    throw ParseException("bad label in sourceToUnique");
  }
  if (labelMappings[sName].empty()) {
    throw ParseException("use of popped label in sourceToUnique");
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

void UniqueNameMapper::uniquify(Expression* curr) {
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
  };

  Walker walker;
  walker.walk(curr);
}

} // namespace wasm
