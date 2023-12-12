#import "Simpd";
#import "Basic";
#import "Random";

/*
uncomment any areas of module for prints
*/

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

convert_random_array :: ($type: Type, $target: Type, min: float64, max: float64) {
    // print("% => %\n", type, target);
    array := NewArray(128, type, allocator=temp, alignment=16);

    for 0..127 {
        value: float = random_get_within_range(xx min, xx max);
        array[it] = xx value;
    }

    result := simd_convert_to(array, target);
}

test_convert :: (s: SIMD_Type, $type: Type) {
    print("@@@ testing % @@@\n", s);
    context.simd_type = s;

    start := to_nanoseconds(current_time_monotonic());
    end: float64;
    loops := 1;

    for 0..loops-1 {
        convert_random_array(s64, type, -9223372036854775808, 9223372036854775807);
        convert_random_array(s32, type, -2147483648, 2147483647);
        convert_random_array(s16, type, -32768, 32767);
        convert_random_array(s8, type, -128, 127);
        convert_random_array(u64, type, 0, 18446744073709551615);
        convert_random_array(u32, type, 0, 4294967295);
        convert_random_array(u16, type, 0, 65535);
        convert_random_array(u8, type, 0, 255);
        convert_random_array(float32, type, -12345678.9, 12345678.9);
        convert_random_array(float64, type, -12345678.9, 12345678.9);

        end += to_nanoseconds(current_time_monotonic()) - start;
        start = to_nanoseconds(current_time_monotonic());
    }

    end /= (cast(float32) loops);

    print(" --- took %ns for % X 10 conversions\n", end, loops);
}

int_test :: () {
    print("=== int test ===\n");
    test_ints(.cpu);
    test_ints(.sse);
    test_ints(.avx);
    test_ints(.avx2);
}

convert_test :: ($type: Type) {
    print("\n# converting every other data type to % #\n", type);
    test_convert(.cpu, type);
    test_convert(.avx, type);
    test_convert(.avx2, type);
    test_convert(.sse, type);
}

main :: () {
    // float_test();
    // int_test();
    convert_test(float32);
    convert_test(float64);
    convert_test(s64);
    convert_test(u64);
    convert_test(s32);
    convert_test(u32);
    convert_test(s16);
    convert_test(u16);
}