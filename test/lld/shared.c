int puts(const char* str);
extern int external_var;

int print_message() {
  puts("Hello, world");
  return external_var;
}
