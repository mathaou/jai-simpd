
__32_to_float32 :: (a: *s32, b: *float32) -> int #expand {
    if context.simd_type == {
    case .sse;
        #asm SSE {
            movdqu.x      xmm0: vec, [a];
            cvtdq2ps.x    xmm0, xmm0;
            movupd.x      [b], xmm0;
        }

        return 4;
    case .avx;
    #through;
    case .avx2;
        #asm AVX, AVX2 {
            movups.y      ymm0: vec, [a];
            cvtdq2ps.y    ymm0, ymm0;
            movupd.y      [b], ymm0;
        }

        return 8;
    }

    return 0;
}

__float64_to_float32 :: (a: *float64, b: *float32) -> int #expand {
    if context.simd_type == {
    case .sse;
        #asm SSE {
            movups.x      xmm0: vec, [a];
            movups.x      xmm1: vec, [a + 16];
            cvtpd2ps.x    xmm0, xmm0;
            cvtpd2ps.x    xmm1, xmm1;
            movupd.x      [b], xmm0;
            movupd.x      [b + 8], xmm1;
        }

        return 4;
    case .avx;
    #through;
    case .avx2;
        #asm AVX, AVX2 {
            movups.y      ymm0: vec, [a];
            movups.y      ymm1: vec, [a + 32];
            cvtpd2ps.y    ymm0, ymm0;
            cvtpd2ps.y    ymm1, ymm1;
            movupd.y      [b], ymm0;
            movupd.y      [b + 16], ymm1;
        }

        return 8;
    }

    return 0;
}

// s32, float64, u32, and (maybe) s64 should be able to be converted to float32
__convert_to_float32 :: (a: *$T1, b: *float32) -> int #expand {
    #if T1 == s32 {
        return __32_to_float32(a, b);
    } else #if T1 == float64 {
        return __float64_to_float32(a, b);
    } else {
        assert(false);
    }

    return 0;
}