#include <stdio.h>

int main() {
    int a = 12345;
    unsigned b = 123456;
    long c = 1234567;
    unsigned long d = 12345678;
    long long e = 1234567891011;
    unsigned long long f = 123456789101112;

    printf(
        "int a = %d\n"
        "unsigned b = %u\n"
        "long c = %ld\n"
        "unsigned long d = %lu\n"
        "long long e = %lld\n"
        "unsigned long long f = %llu\n"
        , a, b, c, d, e, f);
    return 0;
}
