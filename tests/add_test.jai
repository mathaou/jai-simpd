#import "Simpd";
#import "Basic";

/*
uncomment any areas of module for prints
*/

test_floats :: (s: SIMD_Type) {
    print("testing %\n", s);
    context.simd_type = s;
    a: [10]float32 = float32.[1,2,3,4,5,6,7,8,9,10] #align 16;
    b: [10]float32 = float32.[1,2,3,4,5,6,7,8,9,10] #align 16;
    simd_add(a, b);
    c: [10]float64 = float64.[1,2,3,4,5,6,7,8,9,10] #align 16;
    d: [10]float64 = float64.[1,2,3,4,5,6,7,8,9,10] #align 16;
    simd_add(c, d);
    e: [10]float = float.[1,2,3,4,5,6,7,8,9,10] #align 16;
    f: [10]float = float.[1,2,3,4,5,6,7,8,9,10] #align 16;
    simd_add(e, f);
    g: [5]float = float.[1,2,3,4,5] #align 16;
    h: [10]float = float.[1,2,3,4,5,6,7,8,9,10] #align 16;
    simd_add(g, h);

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
    b: [10]u8 = u8.[1,2,3,4,5,6,7,8,9,10] #align 16;
    simd_add(a, b);
    c: [10]s8 = s8.[1,2,3,4,5,6,7,8,9,10] #align 16;
    d: [10]s8 = s8.[1,2,3,4,5,6,7,8,9,10] #align 16;
    simd_add(c, d);
    e: [10]u16 = u16.[1,2,3,4,5,6,7,8,9,10] #align 16;
    f: [10]u16 = u16.[1,2,3,4,5,6,7,8,9,10] #align 16;
    simd_add(e, f);
    g: [10]s16 = s16.[1,2,3,4,5,6,7,8,9,10] #align 16;
    h: [10]s16 = s16.[1,2,3,4,5,6,7,8,9,10] #align 16;
    simd_add(g, h);
    i: [10]u32 = u32.[1,2,3,4,5,6,7,8,9,10] #align 16;
    j: [10]u32 = u32.[1,2,3,4,5,6,7,8,9,10] #align 16;
    simd_add(i, j);
    k: [10]s32 = s32.[1,2,3,4,5,6,7,8,9,10] #align 16;
    l: [10]s32 = s32.[1,2,3,4,5,6,7,8,9,10] #align 16;
    simd_add(k, l);
    m: [10]u64 = u64.[1,2,3,4,5,6,7,8,9,10] #align 16;
    n: [10]u64 = u64.[1,2,3,4,5,6,7,8,9,10] #align 16;
    simd_add(m, n);
    o: [10]s64 = s64.[1,2,3,4,5,6,7,8,9,10] #align 16;
    p: [10]s64 = s64.[1,2,3,4,5,6,7,8,9,10] #align 16;
    simd_add(o, p);
    q: [10]int = int.[1,2,3,4,5,6,7,8,9,10] #align 16;
    r: [10]int = int.[1,2,3,4,5,6,7,8,9,10] #align 16;
    simd_add(q, r);
    t: [5]int = int.[1,2,3,4,5] #align 16;
    u: [10]int = int.[1,2,3,4,5,6,7,8,9,10] #align 16;
    simd_add(t, u);

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