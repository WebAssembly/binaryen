int atoi(const char *nptr);

void address_taken_func(int a, int b, int c) {}
void address_taken_func2(int a, int b, int c) {}

int main(int argc, char **argv) {
  int fp_v = atoi(argv[1]);
  int fp_vi = atoi(argv[2]);
  int fp_iii = atoi(argv[3]);
  int fp_fffi = atoi(argv[4]);
  int fp_ddi = atoi(argv[5]);

  void (*f_viiii)(int, int, int) = 0;
  if (argc > 3)
    f_viiii = address_taken_func;
  else
    f_viiii = address_taken_func2;

  void (*f_v)() = reinterpret_cast<void (*)()>(fp_v);
  void (*f_vi)(int) = reinterpret_cast<void (*)(int)>(fp_vi);
  int (*f_iii)(int, int) = reinterpret_cast<int (*)(int, int)>(fp_iii);
  float (*f_fffi)(float, float, int) =
      reinterpret_cast<float (*)(float, float, int)>(fp_fffi);
  double (*f_ddi)(double, int) =
      reinterpret_cast<double (*)(double, int)>(fp_ddi);

  f_v();
  f_vi(3);
  f_iii(4, 5);
  f_fffi(3.1f, 4.2f, 5);
  f_ddi(4.2, 5);
  f_viiii(1, 2, 3);
  return 0;
}
