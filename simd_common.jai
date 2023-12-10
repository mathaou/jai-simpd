#scope_export

SIMD_Type :: enum {
    sse;
    avx;
    avx2;
    neon;
    cpu;
}

#add_context simd_type: SIMD_Type = .cpu;

#if 0 {
    #run () {
        cpu_info := get_cpu_info();

        if check_feature(cpu_info.feature_leaves, .AVX2) {
            context.simd_type = .avx2;
        } else if check_feature(cpu_info.feature_leaves, .AVX) {
            context.simd_type = .avx;
        } else if check_feature(cpu_info.feature_leaves, .SSE) {
            context.simd_type = .sse;
        }
    }();
}

// god bless how_to
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