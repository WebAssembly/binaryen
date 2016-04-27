#include <stdint.h>
#include <stdio.h>

volatile uint64_t x = 0x0101010101010101;
volatile uint32_t u = 0xfefefefe;

int main(void)
{
   putchar('a' + (x >> 60));

   x = u;    // i64.load32_u

   putchar('A' + (x >> 60));
   putchar('\n');
   return 0;
}
