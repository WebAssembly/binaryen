// This test emits a stack pointer, which tests global importing in object files
// (which are mutable and not normally allowed).

int printf(const char* fmt, ...);

__attribute__((noinline))
int foo(int a, int b) {
    printf("%d:%d\n", a, b);
    return a + b;
}

int main() {
  printf("Result: %d\n", foo(1, 2));
  return 0;
}
