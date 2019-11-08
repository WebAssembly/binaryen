extern "C" int puts(const char* str);
extern "C" int external_var;

int print_message() {
  puts("Hello, world");
  return external_var;
}

void* ptr_puts = (void*)&puts;
void* ptr_local_func = (void*)&print_message;
