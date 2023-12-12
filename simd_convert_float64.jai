
__32_to_float64 :: (a: *s32, b: *float64) -> int #expand {
    if context.simd_type == {
    case .sse;
        #asm SSE {
            movdqu.x      xmm0: vec, [a];
            movdqu.x      xmm1: vec, [a + 8];
            cvtdq2pd.x    xmm0, xmm0;
            cvtdq2pd.x    xmm1, xmm1;
            movupd.x      [b], xmm0;
            movupd.x      [b + 16], xmm1;
        }

        return 4;
    case .avx;
    #through;
    case .avx2;
        #asm AVX, AVX2 {
            movups.y      ymm0: vec, [a];
            movups.y      ymm1: vec, [a + 16];
            cvtdq2pd.y    ymm0, ymm0;
            cvtdq2pd.y    ymm1, ymm1;
            movupd.y      [b], ymm0;
            movupd.y      [b + 32], ymm1;
        }

        return 8;
    }

    return 0;
}

__float32_to_float64 :: (a: *float32, b: *float64) -> int #expand {
    if context.simd_type == {
    case .sse;
        #asm SSE {
            movups.x      xmm0: vec, [a];
            movups.x      xmm1: vec, [a + 8];
            movups.x      xmm2: vec, [a + 16];
            movups.x      xmm3: vec, [a + 24];
            cvtps2pd.x    xmm0, xmm0;
            cvtps2pd.x    xmm1, xmm1;
            cvtps2pd.x    xmm2, xmm2;
            cvtps2pd.x    xmm3, xmm3;
            movupd.x      [b], xmm0;
            movupd.x      [b + 16], xmm1;
            movupd.x      [b + 32], xmm2;
            movupd.x      [b + 48], xmm3;
        }

        return 4;
    case .avx;
    #through;
    case .avx2;
        #asm AVX, AVX2 {
            movups.y      ymm0: vec, [a];
            movups.y      ymm1: vec, [a + 16];
            cvtps2pd.y    ymm0, ymm0;
            cvtps2pd.y    ymm1, ymm1;
            movupd.y      [b], ymm0;
            movupd.y      [b + 32], ymm1;
        }

        return 8;
    }

    return 0;
}

// s32, float64, u32, and (maybe) s64 should be able to be converted to float32
__convert_to_float64 :: (a: *$T1, b: *float64) -> int #expand {
    #if T1 == s32 {
        return __32_to_float64(a, b);
    } else #if T1 == float32 {
        return __float32_to_float64(a, b);
    } else {
        assert(false);
    }

    return 0;
}