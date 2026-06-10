#include <vector>
#include <memory>
struct Function {};
struct Module {
  std::vector<std::unique_ptr<Function>> functions;
};
void walkModule(const Module* m) {
  for (auto& f : m->functions) {
    Function* func = f.get();
  }
}
int main() {}
