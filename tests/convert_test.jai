#import "Simpd";
#import "Basic";
#import "Random";

COUNT :: 128;

convert_random_array :: ($type: Type, $target: Type, min: float64, max: float64) #expand {
    // print("% => %\n", type, target);
    array := NewArray(COUNT, type, allocator=temp, alignment=32);

    for 0..COUNT-1 {
        value: float = random_get_within_range(xx min, xx max);
        array[it] = xx value;
    }

    `result = simd_convert_to(array, target, `scratchpad);
}

test_convert :: (s: SIMD_Type, $type: Type) {
    print("@@@ testing % @@@\n", s);
    context.simd_type = s;


    benchmark :: (a: Type, c: Code) #expand {
        start := to_nanoseconds(current_time_monotonic());

        scratchpad := NewArray(COUNT, `type, allocator=temp, alignment=16);

        result: bool;
        for 0..100 {
            #insert c;
        }

        if result || context.simd_type == .cpu {
            print("% [%=>%] took %ns\n", s, a, type, to_nanoseconds(current_time_monotonic()) - start);
        }
    }

    benchmark(s64, #code convert_random_array(s64, type, -9223372036854775808, 9223372036854775807));
    benchmark(s32, #code convert_random_array(s32, type, -2147483648, 2147483647));
    benchmark(s16, #code convert_random_array(s16, type, -32768, 32767));
    benchmark(s8, #code convert_random_array(s8, type, -128, 127));
    benchmark(u64, #code convert_random_array(u64, type, 0, 18446744073709551615));
    benchmark(u32, #code convert_random_array(u32, type, 0, 4294967295));
    benchmark(u16, #code convert_random_array(u16, type, 0, 65535));
    benchmark(u8, #code convert_random_array(u8, type, 0, 255));
    benchmark(float32, #code convert_random_array(float32, type, -12345678.9, 12345678.9));
    benchmark(float64, #code convert_random_array(float64, type, -12345678.9, 12345678.9));
}

convert_test :: ($type: Type) {
    print("\n# converting every other data type to % #\n", type);
    test_convert(.avx2, type);
    test_convert(.avx, type);
    test_convert(.sse, type);
    test_convert(.cpu, type);
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