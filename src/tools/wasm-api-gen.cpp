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

//
// Auto generate various useful code.
//

#include "support/command-line.h"
#include "wasm.h"

using namespace wasm;

namespace {

// Emit a declaration. If "impl" is true then we emit the beginning of
// the implementation, which is identical to the declaration except it has no
// ";" at the end.
template<typename T> void autogenOneCAPIDecl(bool impl = false) {
  MixedArena allocator;
  T curr(allocator);

  std::cout << '\n';

#define DELEGATE_ID curr._id

#define DELEGATE_START(id)                                                     \
  std::cout << "BINARYEN_API BinaryenExpressionRef\n"                          \
            << "Binaryen" << #id << "(BinaryenModuleRef module";

#define DELEGATE_FIELD_CHILD(id, name)                                         \
  std::cout << ", BinaryenExpressionRef " << #name

#define DELEGATE_FIELD_INT(id, name) std::cout << ", uint32_t " << #name

#define DELEGATE_FIELD_INT_ARRAY(id, name)                                     \
  std::cout << ", const uint8_t mask[16] " << #name

#define DELEGATE_FIELD_LITERAL(id, name)                                       \
  std::cout << ", struct BinaryenLiteral " << #name

#define DELEGATE_FIELD_NAME(id, name) std::cout << ", const char* " << #name

#define DELEGATE_FIELD_NAME_VECTOR(id, name)                                   \
  std::cout << ", const char** " << #name << ", BinaryenIndex num_" << #name;

#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, name)                                \
  std::cout << ", const char* " << #name

#define DELEGATE_FIELD_SCOPE_NAME_USE(id, name)                                \
  std::cout << ", const char* " << #name

#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, name)                         \
  std::cout << ", const char** " << #name << ", BinaryenIndex num_" << #name;

#define DELEGATE_FIELD_SIGNATURE(id, name)                                     \
  std::cout << ", BinaryenType " << #name << "_params, BinaryenType "          \
            << #name "_results";

#define DELEGATE_FIELD_TYPE(id, name) std::cout << ", BinaryenType " << #name

#define DELEGATE_FIELD_ADDRESS(id, name) std::cout << ", uint32_t " << #name

#define DELEGATE_FIELD_CHILD_VECTOR(id, name)                                  \
  std::cout << ", BinaryenExpressionRef* " << #name << ", BinaryenIndex num_"  \
            << #name;

#include "wasm-delegations-fields.h"

  // Some classes have extra fields, like local.get/struct.get etc. must be
  // given their type, as it is not inferred from the operands but from global
  // structures.
  if (std::is_same<T, StructGet>()) {
    std::cout << ", BinaryenType type";
  }
  if (std::is_same<T, RttCanon>() || std::is_same<T, RttSub>()) {
    std::cout << ", BinaryenType heapType";
  }

  std::cout << ')';

  if (!impl) {
    std::cout << ";\n";
  }
}

template<typename T> void autogenOneCAPIImpl() {
  autogenOneCAPIDecl<T>(true /* impl */);
  std::cout << " {\n";

  MixedArena allocator;
  T curr(allocator);

  std::string className;
  std::vector<std::string> params;

#define DELEGATE_ID curr._id

#define DELEGATE_START(id) className = #id;

#define DELEGATE_FIELD_CHILD(id, name) params.push_back(#name);

#define DELEGATE_FIELD_INT(id, name) params.push_back(#name);

#define DELEGATE_FIELD_INT_ARRAY(id, name) params.push_back(#name);

#define DELEGATE_FIELD_LITERAL(id, name) params.push_back(#name);

#define DELEGATE_FIELD_NAME(id, name) params.push_back(#name);

#define DELEGATE_FIELD_NAME_VECTOR(id, name) params.push_back(#name);

#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, name) params.push_back(#name);

#define DELEGATE_FIELD_SCOPE_NAME_USE(id, name) params.push_back(#name);

#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, name) params.push_back(#name);

#define DELEGATE_FIELD_SIGNATURE(id, name) params.push_back(#name);

#define DELEGATE_FIELD_TYPE(id, name) params.push_back("Type(" #name ")");

#define DELEGATE_FIELD_ADDRESS(id, name) params.push_back(#name);

#define DELEGATE_FIELD_CHILD_VECTOR(id, name)                                  \
  std::cout << "  std::vector<Expression*> " #name "_list;\n";                 \
  std::cout << "  for (BinaryenIndex i = 0; i < num_" #name "; i++) {\n";      \
  std::cout << "    " #name "_list.push_back((Expression*)" #name "[i]);\n";   \
  std::cout << "  }\n";                                                        \
  params.push_back(#name "_list");

#include "wasm-delegations-fields.h"

  // Some classes have extra fields, like local.get/struct.get etc. must be
  // given their type, as it is not inferred from the operands but from global
  // structures.
  if (std::is_same<T, StructGet>()) {
    params.push_back("Type(type)");
  }
  if (std::is_same<T, RttCanon>() || std::is_same<T, RttSub>()) {
    params.push_back("HeapType(heapType)");
  }

  std::cout << "  return static_cast<Expression*>(\n";
  std::cout << "    Builder(*(Module*)module).make" << className << '(';

  std::string sep = "";
  for (auto& param : params) {
    std::cout << sep << param;
    sep = ", ";
  }
  std::cout << "));\n";

  std::cout << "}\n";
}

// TODO: convert all Expression classes to be autogenerated. For now, keep the
// existing handwritten code in binaryen-c.h and append specific classes to
// it.
#define applyToRelevantClasses(T)                                              \
  {                                                                            \
    T<RttCanon>();                                                             \
    T<RttSub>();                                                               \
    T<StructNew>();                                                            \
    T<StructGet>();                                                            \
    T<StructSet>();                                                            \
    T<ArrayNew>();                                                             \
    T<ArrayGet>();                                                             \
    T<ArraySet>();                                                             \
    T<ArrayLen>();                                                             \
  }

/*
    CallRefId,
    RefTestId,
    RefCastId,
    BrOnId,
*/

void autogenCAPIDecl() {
  std::cout << "// src/binaryen-c.autogen.h\n";

  applyToRelevantClasses(autogenOneCAPIDecl);
}

void autogenCAPIImpl() {
  std::cout << "// src/binaryen-c.autogen.cpp\n";

  applyToRelevantClasses(autogenOneCAPIImpl);
}

} // anonymous namespace

int main(int argc, const char* argv[]) {
  std::string what;
  Options options("wasm-autogen", "Auto-generate code for Binaryen developers");
  options.add_positional(
    "WHAT",
    Options::Arguments::One,
    [&](Options* o, const std::string& argument) { what = argument; });
  options.parse(argc, argv);

  if (what == "c-api-decl") {
    autogenCAPIDecl();
  } else if (what == "c-api-impl") {
    autogenCAPIImpl();
  } else {
    Fatal() << "Invalid thing to autogenerate: '" << what << "'\n";
  }
}
