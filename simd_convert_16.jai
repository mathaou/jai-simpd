
// u8, s8, u16, s16, float32, float64 should all be able to convert to 32 bit. float always goes to signed 32 I believe
__convert_to_16 :: (a: *$T1, b: *$T2) -> int #modify { return T2 == s16 || T2 == u16; } #expand {
    #if T1 == u8 {
        if context.simd_type == {
        case .sse;
            #asm SSE {
                movups.x      xmm0: vec, [a];
                pmovzxbw.x    xmm0, xmm0;
                movupd.x      [b], xmm0;
            }

            return 8;
        case .avx;
        #through;
        case .avx2;
            #asm AVX, AVX2 {
                movups.y      ymm0: vec, [a];
                movups.y      ymm1: vec, [a + 8];
                pmovzxbw.y    ymm0, ymm0;
                pmovzxbw.y    ymm1, ymm1;
                movupd.y      [b], ymm0;
                movupd.y      [b + 32], ymm1;
            }

            return 16;
        }

        return 0;
    } else #if T1 == s8 {
        if context.simd_type == {
        case .sse;
            #asm SSE {
                movups.x      xmm0: vec, [a];
                pmovsxbw.x    xmm0, xmm0;
                movupd.x      [b], xmm0;
            }

            return 8;
        case .avx;
        #through;
        case .avx2;
            #asm AVX, AVX2 {
                movups.y      ymm0: vec, [a];
                movups.y      ymm1: vec, [a + 8];
                pmovsxbw.y    ymm0, ymm0;
                pmovsxbw.y    ymm1, ymm1;
                movupd.y      [b], ymm0;
                movupd.y      [b + 32], ymm1;
            }

            return 16;
        }

        return 0;
    } else {
        assert(false);
    }

    return 0;
}