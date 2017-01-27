#ifndef WEBASMREADER_H
#define WEBASMREADER_H


#include <sys/stat.h>
#include "support/file.h"
#include "wasm-binary.h"
#include "wasm-s-parser.h"
#include "wasm-printing.h"

using namespace cashew;
using namespace wasm;

struct WebAsmReader
{
  
  bool m_DebugInfo;
  bool m_validateWeb;
  WebAsmReader(bool debugInfo=false,bool valWeb=false):
             m_DebugInfo(debugInfo),m_validateWeb(valWeb){}
                                      
  void write(std::string &inputFileName, 
             std::string &outputFileName,
             bool debug=false)
  {
    if (inputFileName.length()>5)
    {
      auto ext = inputFileName.substr(inputFileName.length()-5);
      if (ext.compare(".wasm")==0)
      {
        writeWast(inputFileName,outputFileName,debug);
        return;
      }
      if (ext.compare(".wast")==0)
      {
        writeWasm(inputFileName,outputFileName);
       
        //m_textInput=read_file<std::string>(fileName, Flags::Text, debug ? Flags::Debug : Flags::Release);
        
        return;
      }
    }
    
    throw ParseException("filename must end in .wast or .wasm");
    
  }

  
  void writeWast(std::string inputFileName,
                 std::string& outputFileName, 
                 bool debug=false)
  {

    auto input= read_file<std::vector<char>>(inputFileName, Flags::Binary, debug ? Flags::Debug : Flags::Release);

    if (debug) std::cerr << "parsing binary..." << std::endl;
    Module webasm;
    // builder throws ParseException - needs to be caught by app
    //try {
      WasmBinaryBuilder parser(webasm, input, debug);
      parser.read();
   // } catch (ParseException& p){
      //p.dump(std::cerr);
     // Fatal() << "error in parsing wasm binary";
     // m_input.clear();
     // throw p;
     // return;
   // }
    if (debug) std::cerr << "Printing..." << std::endl;
    Output output(outputFileName, Flags::Text, debug ? Flags::Debug : Flags::Release);
    WasmPrinter::printModule(&webasm, output.getStream());
    output << '\n';
    if (debug) std::cerr << "Done." << std::endl;
  }
  
  void writeWasm(std::string& inputFileName, 
                 std::string& outputFileName,
                 bool debug=false)
  {
    struct stat st;
    stat(inputFileName.c_str(),&st);
    char *p = new char[st.st_size+1];
    p[st.st_size]=0;
    std::ifstream infile(inputFileName);
    infile.read(p,st.st_size);
    infile.close();
    Module webasm;
    try {
      if (debug) std::cerr << "s-parsing..." << std::endl;
      SExpressionParser parser(const_cast<char*>(p));
      Element& root = *parser.root;
      if (debug) std::cerr << "w-parsing..." << std::endl;
      SExpressionWasmBuilder builder(webasm, *root[0]);
    } catch (ParseException& pex){
      //p.dump(std::cerr);
      //Fatal() << "error in parsing input";
      // awkward but finally not available
      // only catching to delete memory and then rethrow for app
      delete []p;
      throw pex;
    } 
    delete []p;
    
    
    if (m_validateWeb) {
      if (debug) std::cerr << "Validating..." << std::endl;
      if (!wasm::WasmValidator().validate(webasm,m_validateWeb)) {
        throw ParseException("Error: input module not valid for Web");
      }
    }
    
    if (debug) std::cerr << "binarification..." << std::endl;
    BufferWithRandomAccess buffer(debug);
    WasmBinaryWriter writer(&webasm, buffer, debug);
    writer.setDebugInfo(m_DebugInfo);
    writer.write();
    if (debug) std::cerr << "writing to output..." << std::endl;
    Output output(outputFileName, Flags::Binary, debug ? Flags::Debug : Flags::Release);
    buffer.writeTo(output);
    if (debug) std::cerr << "Done." << std::endl;
  }
  
};
#endif
