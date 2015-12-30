/*
 * Copyright 2015 WebAssembly Community Group participants
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

#include "support/command-line.h"

namespace {
bool optionIs(const char *arg, const char *LongOpt, const char *ShortOpt) {
  return strcmp(arg, LongOpt) == 0 || strcmp(arg, ShortOpt) == 0;
}
}  // anonymous namespace

void wasm::processCommandLine(int argc, const char *argv[], Options *options,
                              const char *help) {
  assert(argc > 0 && "expect at least program name as an argument");
  for (size_t i = 1, e = argc; i != e; ++i) {
    if (optionIs(argv[i], "--help", "-h")) {
      std::cerr << help;
      exit(EXIT_SUCCESS);
    } else if (optionIs(argv[i], "--debug", "-d")) {
      options->debug = true;
    } else if (optionIs(argv[i], "--output", "-o")) {
      if (i + 1 == e) {
        std::cerr << "No output file" << std::endl;
        exit(EXIT_FAILURE);
      }
      if (options->outfile.size()) {
        std::cerr << "Expected only one output file, got '" << options->outfile
                  << "' and '" << argv[i] << "'" << std::endl;
        exit(EXIT_FAILURE);
      }
      options->outfile = argv[++i];
    } else if (argv[i][0] == '-' && argv[i][1] == '-') {
      size_t j = 2;
      std::string name;
      while (argv[i][j] && argv[i][j] != '=') {
        name += argv[i][j];
        j++;
      }
      options->extra[name] = argv[i][j] == '=' ? &argv[i][j + 1] : "(no value)";
    } else {
      if (options->infile.size()) {
        std::cerr << "Expected only one input file, got '" << options->infile
                  << "' and '" << argv[i] << "'" << std::endl;
        exit(EXIT_FAILURE);
      }
      options->infile = argv[i];
    }
  }
}
