#import "Simpd";
#import "Basic";
#import "Random";

test_floats :: (s: SIMD_Type) {
    print("testing %\n", s);
    context.simd_type = s;
    a: [10]float32 = float32.[1,2,3,4,5,6,7,8,9,10] #align 16;
    c: [10]float64 = float64.[1,2,3,4,5,6,7,8,9,10] #align 16;
    e: [10]float = float.[1,2,3,4,5,6,7,8,9,10] #align 16;
    g: [5]float = float.[1,2,3,4,5] #align 16;

    simd_clear(a);
    simd_clear(c);
    simd_clear(e);
    simd_clear(g);

    print(" ---\n");
}

float_test :: () {
    print(" === float test ===\n");
    test_floats(.cpu);
    test_floats(.sse);
    test_floats(.avx);
    test_floats(.avx2);
}

test_ints :: (s: SIMD_Type) {
    print("testing %\n", s);
    context.simd_type = s;
    a: [10]u8 = u8.[1,2,3,4,5,6,7,8,9,10] #align 16;
    c: [10]s8 = s8.[1,2,3,4,5,6,7,8,9,10] #align 16;
    e: [10]u16 = u16.[1,2,3,4,5,6,7,8,9,10] #align 16;
    g: [10]s16 = s16.[1,2,3,4,5,6,7,8,9,10] #align 16;
    i: [10]u32 = u32.[1,2,3,4,5,6,7,8,9,10] #align 16;
    k: [10]s32 = s32.[1,2,3,4,5,6,7,8,9,10] #align 16;
    m: [10]u64 = u64.[1,2,3,4,5,6,7,8,9,10] #align 16;
    o: [10]s64 = s64.[1,2,3,4,5,6,7,8,9,10] #align 16;
    q: [10]int = int.[1,2,3,4,5,6,7,8,9,10] #align 16;
    t: [5]int = int.[1,2,3,4,5] #align 16;

    simd_clear(a);
    simd_clear(c);
    simd_clear(e);
    simd_clear(g);
    simd_clear(i);
    simd_clear(k);
    simd_clear(m);
    simd_clear(o);
    simd_clear(q);
    simd_clear(t);

    print(" ---\n");
}

int_test :: () {
    print("=== int test ===\n");
    test_ints(.cpu);
    test_ints(.sse);
    test_ints(.avx);
    test_ints(.avx2);
}

main :: () {
    float_test();
    int_test();
}