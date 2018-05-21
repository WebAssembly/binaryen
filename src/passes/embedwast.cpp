#include <string>
#include <fstream>
#include <streambuf>

int main(int argc, char **argv) {
  std::ifstream t("wasm-intrinsics.wast");
  std::string contents((std::istreambuf_iterator<char>(t)),
                       std::istreambuf_iterator<char>());

  std::ofstream out(argv[1]);
  auto len = contents.size() + 1;
  out << "#include \"passes/intrinsics-module.h\"\n";
  out << "namespace wasm {\n";
  out << "const char theModule[" << len << "] = {\n";
  for (char c : contents) {
    out << (int) c;
    out << ", ";
  }
  out << 0;
  out << "\n};\n";
  out << "const char* IntrinsicsModuleWast = theModule;\n";
  out << "}\n";
  out.close();
}
