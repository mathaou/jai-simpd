#import "Simpd";
#import "Basic";
#import "Random";

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

convert_test :: ($type: Type) {
    print("\n# converting every other data type to % #\n", type);
    test_convert(.cpu, type);
    test_convert(.avx, type);
    test_convert(.avx2, type);
    test_convert(.sse, type);
}

main :: () {
    convert_test(float32);
    convert_test(float64);
    convert_test(s64);
    convert_test(u64);
    convert_test(s32);
    convert_test(u32);
    convert_test(s16);
    convert_test(u16);
}