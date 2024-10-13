int my_clz2(uint32_t x)
{
    x |= x >> 1; 
    x |= x >> 2;
    x |= x >> 4;
    x |= x >> 8;
    x |= x >> 16;
    
    //count the ones
    x -= x >> 1 & 0x55555555;
    x = (x >> 2 & 0x33333333) + (x & 0x33333333);
    x = (x >> 4) + x & 0x0f0f0f0f;
    x += x >> 8;
    x += x >> 16;
    return 32 - (x & 0x3f);
}

static inline uint32_t fp16_to_fp32(uint16_t h) {

    const uint32_t w = (uint32_t) h << 16;
    const uint32_t sign = w & 0x80000000;
    const uint32_t nonsign = w & 0x7FFFFFFF;
    uint32_t renorm_shift = my_clz2(nonsign);
    renorm_shift = renorm_shift > 5 ? renorm_shift - 5 : 0;
	printf("renorm_shift=%08X\n", renorm_shift);
    const int32_t inf_nan_mask = ((int32_t)(nonsign + 0x04000000) >> 8) & 0x7F800000;
    const int32_t zero_mask = (int32_t)(nonsign - 1) >> 31;
    return sign | ((((nonsign << renorm_shift >> 3) + ((0x70 - renorm_shift) << 23)) | inf_nan_mask) & ~zero_mask);
}
