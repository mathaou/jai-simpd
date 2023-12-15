#import "Basic";
#import "Simpd";
#import "Random";

loop_unroll :: (n: int, code: Code) #expand {
    UNROLL_SIZE :: 4;

    big_loops   := n / UNROLL_SIZE;
    small_loops := n % UNROLL_SIZE;

    for 1..big_loops {
        // We just paste the code in 4 times, so that we have no overhead between the iterations.
        #insert code;
        #insert code;
        #insert code;
        #insert code;
    }

    for 1..small_loops {
        #insert code;
    }
}

SIZE :: 2048;

main :: () {
    heap_a := NewArray(SIZE, s32, allocator=temp, alignment=32);
    heap_b := NewArray(SIZE, float32, allocator=temp, alignment=32);
    heap_c := NewArray(SIZE, s32, allocator=temp, alignment=32);
    heap_d := NewArray(SIZE, float32, allocator=temp, alignment=32);

    // get it primed
    i := 0;
    loop_unroll(heap_a.count - i, #code {
        heap_a[i] = xx (i + 1); //xx random_get_within_range(xx -10000, 10000);
        heap_c[i] = xx (i + 1); //xx random_get_within_range(xx -10000, 10000);
        heap_d[i] = xx (i + 1); //xx random_get_within_range(xx -10000, 10000);
        heap_d[i] = xx (i + 1); //xx random_get_within_range(xx -10000, 10000);
        i += 1;
    });

    print(" !!! CONVERT TEST !!! \n");

    {
        print(" === CPU ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_convert_to(heap_a, float32, heap_b, .cpu);
    }

    {
        print(" === AVX2 ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_convert_to(heap_a, float32, heap_b, .avx2);
    }

    {
        print(" === SSE ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_convert_to(heap_a, float32, heap_b, .sse);
    }

    {
        print(" === AVX ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_convert_to(heap_a, float32, heap_b, .avx);
    }

    {
        print(" === CPU AGAIN ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_convert_to(heap_a, float32, heap_b, .cpu);
    }

    print(" !!! DIVIDE TEST !!! \n");

    {
        print(" === CPU ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_divide(heap_b, heap_d, .cpu);
        for 0..5 simd_divide(heap_a, heap_c, .cpu);
    }

    {
        print(" === AVX2 ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_divide(heap_b, heap_d, .avx2);
        for 0..5 simd_divide(heap_a, heap_c, .avx2);
    }

    {
        print(" === SSE ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_divide(heap_b, heap_d, .sse);
        for 0..5 simd_divide(heap_a, heap_c, .sse);
    }

    {
        print(" === AVX ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_divide(heap_b, heap_d, .avx);
        for 0..5 simd_divide(heap_a, heap_c, .avx);
    }

    {
        print(" === CPU AGAIN ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_divide(heap_b, heap_d, .cpu);
        for 0..5 simd_divide(heap_a, heap_c, .cpu);
    }

    print(" !!! ADD TEST !!! \n");

    {
        print(" === CPU ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_add(heap_b, heap_d, .cpu);
        for 0..5 simd_add(heap_a, heap_c, .cpu);
    }

    {
        print(" === AVX2 ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_add(heap_b, heap_d, .avx2);
        for 0..5 simd_add(heap_a, heap_c, .avx2);
    }

    {
        print(" === SSE ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_add(heap_b, heap_d, .sse);
        for 0..5 simd_add(heap_a, heap_c, .sse);
    }

    {
        print(" === AVX ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_add(heap_b, heap_d, .avx);
        for 0..5 simd_add(heap_a, heap_c, .avx);
    }

    {
        print(" === CPU AGAIN ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_add(heap_b, heap_d, .cpu);
        for 0..5 simd_add(heap_a, heap_c, .cpu);
    }

    print(" !!! SUBTRACT TEST !!! \n");

    {
        print(" === CPU ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_subtract(heap_b, heap_d, .cpu);
        for 0..5 simd_subtract(heap_a, heap_c, .cpu);
    }

    {
        print(" === AVX2 ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_subtract(heap_b, heap_d, .avx2);
        for 0..5 simd_subtract(heap_a, heap_c, .avx2);
    }

    {
        print(" === SSE ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_subtract(heap_b, heap_d, .sse);
        for 0..5 simd_subtract(heap_a, heap_c, .sse);
    }

    {
        print(" === AVX ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_subtract(heap_b, heap_d, .avx);
        for 0..5 simd_subtract(heap_a, heap_c, .avx);
    }

    {
        print(" === CPU AGAIN ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_subtract(heap_b, heap_d, .cpu);
        for 0..5 simd_subtract(heap_a, heap_c, .cpu);
    }

    print(" !!! MULTIPLY TEST !!! \n");

    {
        print(" === CPU ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_multiply(heap_b, heap_d, .cpu);
        for 0..5 simd_multiply(heap_a, heap_c, .cpu);
    }

    {
        print(" === AVX2 ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_multiply(heap_b, heap_d, .avx2);
        for 0..5 simd_multiply(heap_a, heap_c, .avx2);
    }

    {
        print(" === SSE ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_multiply(heap_b, heap_d, .sse);
        for 0..5 simd_multiply(heap_a, heap_c, .sse);
    }

    {
        print(" === AVX ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_multiply(heap_b, heap_d, .avx);
        for 0..5 simd_multiply(heap_a, heap_c, .avx);
    }

    {
        print(" === CPU AGAIN ===\n");
        start := to_nanoseconds(current_time_monotonic());
        defer print(" --- took %ns\n", to_nanoseconds(current_time_monotonic()) - start);

        for 0..5 simd_multiply(heap_b, heap_d, .cpu);
        for 0..5 simd_multiply(heap_a, heap_c, .cpu);
    }
}