#include <stdint.h>

struct big {
	float a;
	double b;
	int32_t c;
};

float extern_fd(double);
void extern_vj(uint64_t);
void extern_v(void);
int32_t extern_ijidf(int64_t, int32_t, double, float);
void extern_struct(struct big);
struct big extern_sret(void);

intptr_t bar() {
  float (*fd)(double) = &extern_fd;
  void (*vj)(uint64_t) = &extern_vj;
  vj(1ULL);
  void (*v)(void) = &extern_v;
  v();
  int32_t (*ijidf)(int64_t, int32_t, double, float) = &extern_ijidf;
  ijidf(1LL, 2, 3.0, 4.0f);
  void (*vs)(struct big) = &extern_struct;
  struct big (*s)(void) = &extern_sret;
    return (intptr_t)fd;
}

intptr_t baz() {
  return (intptr_t)extern_v;
}
