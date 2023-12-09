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

simd_template_two_arguments :: (src: []$T, dst: []T, unroll := #code,null, process := #code,null) #modify { return T==u8 || T==s8 || T==u16 || T==s16 || T==u32 || T==s32 || T==u64 || T==s64 || T==float32 || T==float64; } {
    assert(dst.count >= src.count);

    i := 0;
    __data_width := size_of(T);
    stride: int;

    if context.simd_type == .cpu {
        stride = __data_width;
    } else if context.simd_type == .sse {
        stride = 128 / (__data_width * 8);
    } else {
        stride = 256 / (__data_width * 8);
    }

    while i + stride <= src.count {
        a := src.data + i;
        b := dst.data + i;

        if context.simd_type == .cpu {
            loop_unroll(__data_width, #insert unroll);
        } else {
            #insert process;
        }

        // print("%=>", i);
    }

    // print("\n");

    if i != src.count {
        // print("unrolling remaining %\n", src.count - i);

        // catch spillover
        loop_unroll(src.count - i, unroll);
    }

    // print("[%] %\n", T, dst);
}