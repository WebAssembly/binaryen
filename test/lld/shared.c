int puts(const char* str);
extern int external_var;

void* ptr = &puts;

int print_message() {
  puts("Hello, world");
  return external_var;
}
