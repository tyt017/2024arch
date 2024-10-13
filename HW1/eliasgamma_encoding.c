#include <stdio.h>
#include <stdint.h>

static inline int log_with_clz(uint32_t x) {
    int count = 0;
    if (x == 0) return 32;
    while ((x & (1U << 31)) == 0) {
        x <<= 1;
        count++;
    }
    return 32 - count;
}

// Elias Gamma encoding
void elias_gamma_encode(uint32_t n) {
    if (n == 0) {
        printf("0\n");
        return;
    }
    
    int L = log_with_clz(n);
    for (int i = 0; i < L - 1; i++) {
        printf("0");
    }
    
    for (int i = L - 1; i >= 0; i--) {
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
