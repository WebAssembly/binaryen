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
// wasm2wasm console tool
//


#include "support/colors.h"
#include "support/command-line.h"
#include "WebAsmReader.h"


int main(int argc, const char *argv[]) {
  bool debugInfo =false;

  Options options("wasm2wasm", "Unassemble .wasm (WebAssembly binary format) to .wast (WebAssembly text format)\n or"
   "\nAssemble .wast (WebAssembly text format) to .wasm (WebAssembly binary format)"
   "\n filename extension determines selection (wast->wasm,wasm->wast) ");
  options.extra["validate"] = "wasm";
  options.add("--output", "-o", "Output file (stdout if not specified)", 
        Options::Arguments::One,
        [](Options *o, const std::string &argument) {
          o->extra["output"] = argument;
          Colors::disable();
        })
        .add("--debuginfo", "-g", "Emit names section and debug info (wasm output only)",
          Options::Arguments::Optional,
          [&](Options *o, const std::string &arguments) {
            debugInfo = true;
          })        
        .add("--validate", "-v", "Control validation of the output module (wasm output only)",
           Options::Arguments::One,
           [](Options *o, const std::string &argument) {
             if (argument != "web" && argument != "none" && argument != "wasm") {
               std::cerr << "Valid arguments for --validate flag are 'wasm', 'web', and 'none'.\n";
               exit(1);
             }
             o->extra["validate"] = argument;
           })  
        .add_positional("INFILE", Options::Arguments::One,
        [](Options *o, const std::string &argument) {
          o->extra["infile"] = argument;
        });
  
  options.parse(argc, argv);
  WebAsmReader wr(debugInfo,options.extra["validate"]=="web");
  try{
  
    wr.write(options.extra["infile"],
             options.extra["output"],
             options.debug);
  } catch(ParseException &p){
    p.dump(std::cerr);
    std::cerr << std::endl;
  }
}
