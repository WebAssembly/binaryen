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
// wasm2asm console tool
//

#include "s2wasm.h"

using namespace cashew;
using namespace wasm;

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

int main(int argc, const char *argv[]) {
  Options options;
  processCommandLine(argc, argv, &options);

  std::string input;
  {
    if (options.debug)
      std::cerr << "Loading '" << options.infile << "'..." << std::endl;
    std::ifstream infile(options.infile);
    if (!infile.is_open()) {
      std::cerr << "Failed opening '" << options.infile << "'" << std::endl;
      exit(EXIT_FAILURE);
    }
    infile.seekg(0, std::ios::end);
    size_t insize = infile.tellg();
    input.resize(insize + 1);
    infile.seekg(0);
    infile.read(&input[0], insize);
  }

  std::streambuf *buffer;
  std::ofstream outfile;
  if (options.outfile.size()) {
    if (options.debug) std::cerr << "Opening '" << options.outfile << std::endl;
    outfile.open(options.outfile, std::ofstream::out | std::ofstream::trunc);
    if (!outfile.is_open()) {
      std::cerr << "Failed opening '" << options.outfile << "'" << std::endl;
      exit(EXIT_FAILURE);
    }
    buffer = outfile.rdbuf();
  } else {
    buffer = std::cout.rdbuf();
  }
  std::ostream out(buffer);

  if (options.debug) std::cerr << "Parsing and wasming..." << std::endl;
  AllocatingModule wasm;
  S2WasmBuilder s2wasm(wasm, input.c_str(), options.debug);

  if (options.debug) std::cerr << "Emscripten gluing..." << std::endl;
  std::stringstream meta;
  s2wasm.emscriptenGlue(meta);

  if (options.debug) std::cerr << "Printing..." << std::endl;
  out << wasm << meta.str() << std::endl;

  if (options.debug) std::cerr << "Done." << std::endl;
}
