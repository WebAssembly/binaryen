int putchar(int c);

int main() {
  try {
    throw 3;
  } catch (int n) {
    putchar(n);
  }
  return 0;
}
