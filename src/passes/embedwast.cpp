#include <string>
#include <fstream>
#include <streambuf>

int main(int argc, char **argv) {
  std::ifstream t("wasm-intrinsics.wast");
  std::string contents((std::istreambuf_iterator<char>(t)),
                       std::istreambuf_iterator<char>());

  std::ofstream out(argv[1]);
  auto len = contents.size() + 1;
  out << "namespace wasm {\n";
  out << "extern const char* IntrinsicsModule;\n";
  out << "const char theModule[" << len << "] = {\n";
  for (char c : contents) {
    out << (int) c;
    out << ", ";
  }
  out << 0;
  out << "\n};\n";
  out << "const char* IntrinsicsModule = theModule;\n";
  out << "}\n";
  out.close();
}
