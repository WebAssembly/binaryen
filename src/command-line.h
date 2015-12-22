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

//
// Command line helpers.
//

#include "wasm.h"

namespace wasm {

struct Options {
  bool debug;
  std::string infile;
  std::string outfile;
  Options() : debug(false) {}
};

bool optionIs(const char *arg, const char *LongOpt, const char *ShortOpt) {
  return strcmp(arg, LongOpt) == 0 || strcmp(arg, ShortOpt) == 0;
}

// TODO(jfb) Make this configurable: callers should pass in option handlers.
void processCommandLine(int argc, const char *argv[], Options *options) {
  for (size_t i = 1; i != argc; ++i) {
    if (optionIs(argv[i], "--help", "-h")) {
      std::cerr << "s2wasm INFILE\n\n"
                   "Link .s file into .wast\n\n"
                   "Optional arguments:\n"
                   "  -n, --help    Show this help message and exit\n"
                   "  -d, --debug   Print debug information to stderr\n"
                   "  -o, --output  Output file (stdout if not specified)\n"
                << std::endl;
      exit(EXIT_SUCCESS);
    } else if (optionIs(argv[i], "--debug", "-d")) {
      options->debug = true;
    } else if (optionIs(argv[i], "--output", "-o")) {
      if (i + 1 == argc) {
        std::cerr << "No output file" << std::endl;
        exit(EXIT_FAILURE);
      }
      if (options->outfile.size()) {
        std::cerr << "Expected only one output file, got '" << options->outfile
                  << "' and '" << argv[i] << "'" << std::endl;
        exit(EXIT_FAILURE);
      }
      options->outfile = argv[++i];
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

}  // namespace wasm
