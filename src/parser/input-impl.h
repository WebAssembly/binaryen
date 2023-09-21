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

#include "input.h"

#ifndef parser_input_impl_h
#define parser_input_impl_h

inline std::optional<Token> ParseInput::peek() {
  if (!empty()) {
    return *lexer;
  }
  return {};
}

inline bool ParseInput::takeLParen() {
  auto t = peek();
  if (!t || !t->isLParen()) {
    return false;
  }
  ++lexer;
  return true;
}

inline bool ParseInput::takeRParen() {
  auto t = peek();
  if (!t || !t->isRParen()) {
    return false;
  }
  ++lexer;
  return true;
}

inline bool ParseInput::takeUntilParen() {
  while (true) {
    auto t = peek();
    if (!t) {
      return false;
    }
    if (t->isLParen() || t->isRParen()) {
      return true;
    }
    ++lexer;
  }
}

inline std::optional<Name> ParseInput::takeID() {
  if (auto t = peek()) {
    if (auto id = t->getID()) {
      ++lexer;
      // See comment on takeName.
      return Name(std::string(*id));
    }
  }
  return {};
}

inline std::optional<std::string_view> ParseInput::takeKeyword() {
  if (auto t = peek()) {
    if (auto keyword = t->getKeyword()) {
      ++lexer;
      return *keyword;
    }
  }
  return {};
}

inline bool ParseInput::takeKeyword(std::string_view expected) {
  if (auto t = peek()) {
    if (auto keyword = t->getKeyword()) {
      if (*keyword == expected) {
        ++lexer;
        return true;
      }
    }
  }
  return false;
}

inline std::optional<uint64_t> ParseInput::takeOffset() {
  if (auto t = peek()) {
    if (auto keyword = t->getKeyword()) {
      if (keyword->substr(0, 7) != "offset="sv) {
        return {};
      }
      Lexer subLexer(keyword->substr(7));
      if (subLexer == subLexer.end()) {
        return {};
      }
      if (auto o = subLexer->getU64()) {
        ++subLexer;
        if (subLexer == subLexer.end()) {
          ++lexer;
          return o;
        }
      }
    }
  }
  return std::nullopt;
}

inline std::optional<uint32_t> ParseInput::takeAlign() {
  if (auto t = peek()) {
    if (auto keyword = t->getKeyword()) {
      if (keyword->substr(0, 6) != "align="sv) {
        return {};
      }
      Lexer subLexer(keyword->substr(6));
      if (subLexer == subLexer.end()) {
        return {};
      }
      if (auto a = subLexer->getU32()) {
        ++subLexer;
        if (subLexer == subLexer.end()) {
          ++lexer;
          return a;
        }
      }
    }
  }
  return {};
}

inline std::optional<uint64_t> ParseInput::takeU64() {
  if (auto t = peek()) {
    if (auto n = t->getU64()) {
      ++lexer;
      return n;
    }
  }
  return std::nullopt;
}

inline std::optional<int64_t> ParseInput::takeS64() {
  if (auto t = peek()) {
    if (auto n = t->getS64()) {
      ++lexer;
      return n;
    }
  }
  return {};
}

inline std::optional<int64_t> ParseInput::takeI64() {
  if (auto t = peek()) {
    if (auto n = t->getI64()) {
      ++lexer;
      return n;
    }
  }
  return {};
}

inline std::optional<uint32_t> ParseInput::takeU32() {
  if (auto t = peek()) {
    if (auto n = t->getU32()) {
      ++lexer;
      return n;
    }
  }
  return std::nullopt;
}

inline std::optional<int32_t> ParseInput::takeS32() {
  if (auto t = peek()) {
    if (auto n = t->getS32()) {
      ++lexer;
      return n;
    }
  }
  return {};
}

inline std::optional<int32_t> ParseInput::takeI32() {
  if (auto t = peek()) {
    if (auto n = t->getI32()) {
      ++lexer;
      return n;
    }
  }
  return {};
}

inline std::optional<uint8_t> ParseInput::takeU8() {
  if (auto t = peek()) {
    if (auto n = t->getU32()) {
      if (n <= std::numeric_limits<uint8_t>::max()) {
        ++lexer;
        return uint8_t(*n);
      }
    }
  }
  return {};
}

inline std::optional<double> ParseInput::takeF64() {
  if (auto t = peek()) {
    if (auto d = t->getF64()) {
      ++lexer;
      return d;
    }
  }
  return std::nullopt;
}

inline std::optional<float> ParseInput::takeF32() {
  if (auto t = peek()) {
    if (auto f = t->getF32()) {
      ++lexer;
      return f;
    }
  }
  return std::nullopt;
}

inline std::optional<std::string_view> ParseInput::takeString() {
  if (auto t = peek()) {
    if (auto s = t->getString()) {
      ++lexer;
      return s;
    }
  }
  return {};
}

inline std::optional<Name> ParseInput::takeName() {
  // TODO: Move this to lexer and validate UTF.
  if (auto str = takeString()) {
    // Copy to a std::string to make sure we have a null terminator, otherwise
    // the `Name` constructor won't work correctly.
    // TODO: Update `Name` to use string_view instead of char* and/or to take
    // rvalue strings to avoid this extra copy.
    return Name(std::string(*str));
  }
  return {};
}

inline bool ParseInput::takeSExprStart(std::string_view expected) {
  auto original = lexer;
  if (takeLParen() && takeKeyword(expected)) {
    return true;
  }
  lexer = original;
  return false;
}

inline bool ParseInput::peekSExprStart(std::string_view expected) {
  auto original = lexer;
  if (!takeLParen()) {
    return false;
  }
  bool ret = takeKeyword(expected);
  lexer = original;
  return ret;
}

inline Index ParseInput::getPos() {
  if (auto t = peek()) {
    return lexer.getIndex() - t->span.size();
  }
  return lexer.getIndex();
}

inline Err ParseInput::err(Index pos, std::string reason) {
  std::stringstream msg;
  msg << lexer.position(pos) << ": error: " << reason;
  return Err{msg.str()};
}

#endif // parser_input_impl_h
