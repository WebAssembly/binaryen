#include <stdint.h>

float extern_fd(double);
void extern_vj(uint64_t);
void extern_v(void);
int32_t extern_ijidf(int64_t, int32_t, double, float);

intptr_t bar() {
  float (*fd)(double) = &extern_fd;
  fd(0.0);
  extern_fd(1.0);
  void (*vj)(uint64_t) = &extern_vj;
  vj(1ULL);
  void (*v)(void) = &extern_v;
  v();
  int32_t (*ijidf)(int64_t, int32_t, double, float) = &extern_ijidf;
  ijidf(1LL, 2, 3.0, 4.0f);
  return (intptr_t)fd;
}
