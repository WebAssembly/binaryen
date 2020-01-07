typedef struct jmp_buf_buf {
  int thing;
} jmp_buf;

void longjmp(jmp_buf env, int val);
int setjmp(jmp_buf env);

int __THREW__;
int __threwValue;

int main() {
  jmp_buf jmp;
  if (setjmp(jmp) == 0) {
    longjmp(jmp, 1);
  }
  return 0;
}
