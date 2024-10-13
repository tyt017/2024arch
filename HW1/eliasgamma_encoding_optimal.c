#include <stdio.h>
#include <stdint.h>

int log_with_clz2(uint32_t x)
{
    x |= x >> 1; 
    x |= x >> 2;
    x |= x >> 4;
    x |= x >> 8;
    x |= x >> 16;
    
    //count the ones
    x -= x >> 1 & 0x55555555;
    x = (x >> 2 & 0x33333333) + (x & 0x33333333);
    x = (x >> 4) + x & 0x0F0F0F0F;
    x += x >> 8;
    x += x >> 16;
    return (x & 0x3F);
}
// Elias Gamma encoding
void elias_gamma_encode(uint32_t n) {
    if (n == 0) {
        printf("0\n");
        return;
    }
    int L = log_with_clz2(n);


    for (int i = 0; i < L - 1; i++) {
        printf("0");
    }
    printf("1");


    for (int i = L - 2; i >= 0; i--) {
        printf("%d", (n >> i) & 1);
    }
    printf("\n");
}

int main() {

    printf("Elias Gamma encoding:\n");
    elias_gamma_encode(5);  // output: 00101
    elias_gamma_encode(16);  // output: 000010000
    elias_gamma_encode(278); // output: 00000000100010110

    return 0;
}
