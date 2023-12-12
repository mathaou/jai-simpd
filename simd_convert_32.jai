
__16_to_32 :: (a: *$T1, b: *$T2) -> int #expand {
    if context.simd_type == {
    case .avx;
    #through;
    case .avx2;
        #if T1 == s16 {
            #asm AVX, AVX2 {
                // load 16 bit short
                movups.y      ymm0: vec, [a];
                movups.y      ymm1: vec, [a + 8];
                movups.y      ymm2: vec, [a + 16];
                // convert to 32 bit ints
                pmovsxwd.y    ymm0, ymm0;
                pmovsxwd.y    ymm1, ymm1;
                pmovsxwd.y    ymm2, ymm2;
                movupd.y      [b], ymm0;
                movupd.y      [b + 16], ymm1;
                movupd.y      [b + 32], ymm2;
            }
        } else {
            #asm AVX, AVX2 {
                // load 16 bit short
                movups.y      ymm0: vec, [a];
                movups.y      ymm1: vec, [a + 8];
                movups.y      ymm2: vec, [a + 16];
                // convert to 32 bit ints
                pmovzxwd.y    ymm0, ymm0;
                pmovzxwd.y    ymm1, ymm1;
                pmovzxwd.y    ymm2, ymm2;
                movupd.y      [b], ymm0;
                movupd.y      [b + 16], ymm1;
                movupd.y      [b + 32], ymm2;
            }
        }

        return 16;
    case .sse;
        #if T1 == s16 {
            #asm SSE { // @help may be a way to do 8 at a time but IDK
                movups.x      xmm0: vec, [a];
                pmovsxwd.x    xmm0, xmm0;
                movdqu.x      [b], xmm0;
            }
        } else {
            #asm SSE { // @help may be a way to do 8 at a time but IDK
                movups.x      xmm0: vec, [a];
                pmovzxwd.x    xmm0, xmm0;
                movdqu.x      [b], xmm0;
            }
        }

        return 4;
    }

    return 0;
}

__float64_to_32 :: (a: *float64, b: *s32) -> int #expand {
    if context.simd_type == {
    case .sse;
        #asm SSE {
            movups.x      xmm0: vec, [a];
            movups.x      xmm1: vec, [a + 16];
            cvtpd2dq.x    xmm0, xmm0;
            cvtpd2dq.x    xmm1, xmm1;
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
            movups.y      ymm2: vec, [a + 64];
            movups.y      ymm3: vec, [a + 96];
            cvtpd2dq.y    ymm0, ymm0;
            cvtpd2dq.y    ymm1, ymm1;
            cvtpd2dq.y    ymm2, ymm2;
            cvtpd2dq.y    ymm3, ymm3;
            movupd.y      [b], ymm0;
            movupd.y      [b + 16], ymm1;
            movupd.y      [b + 32], ymm1;
            movupd.y      [b + 48], ymm1;
        }

        return 4;
    }

    return 0;
}

__u8_to_32 :: (a: *u8, b: *u32) -> int #expand {
    if context.simd_type == {
    case .sse;
        #asm SSE {
            movups.x      xmm0: vec, [a];
            movups.x      xmm1: vec, [a + 4];
            movups.x      xmm2: vec, [a + 8];
            movups.x      xmm3: vec, [a + 12];
            pmovzxbd.x    xmm0, xmm0;
            pmovzxbd.x    xmm1, xmm1;
            pmovzxbd.x    xmm2, xmm2;
            pmovzxbd.x    xmm3, xmm3;
            movupd.x      [b], xmm0;
            movupd.x      [b + 16], xmm1;
            movupd.x      [b + 32], xmm2;
            movupd.x      [b + 48], xmm3;
        }

        return 16;
    case .avx;
    #through;
    case .avx2;
        #asm AVX, AVX2 {
            movups.y      ymm0: vec, [a];
            movups.y      ymm1: vec, [a + 8];
            movups.y      ymm2: vec, [a + 16];
            movups.y      ymm3: vec, [a + 24];
            pmovzxbd.y    ymm0, ymm0;
            pmovzxbd.y    ymm1, ymm1;
            pmovzxbd.y    ymm2, ymm2;
            pmovzxbd.y    ymm3, ymm3;
            movupd.y      [b], ymm0;
            movupd.y      [b + 32], ymm1;
            movupd.y      [b + 64], ymm2;
            movupd.y      [b + 96], ymm3;
        }

        return 32;
    }

    return 0;
}

__s8_to_32 :: (a: *s8, b: *s32) -> int #expand {
    if context.simd_type == {
    case .sse;
        #asm SSE {
            movups.x      xmm0: vec, [a];
            movups.x      xmm1: vec, [a + 4];
            movups.x      xmm2: vec, [a + 8];
            movups.x      xmm3: vec, [a + 12];
            pmovsxbd.x    xmm0, xmm0;
            pmovsxbd.x    xmm1, xmm1;
            pmovsxbd.x    xmm2, xmm2;
            pmovsxbd.x    xmm3, xmm3;
            movupd.x      [b], xmm0;
            movupd.x      [b + 16], xmm1;
            movupd.x      [b + 32], xmm2;
            movupd.x      [b + 48], xmm3;
        }

        return 16;
    case .avx;
    #through;
    case .avx2;
        #asm AVX, AVX2 {
            movups.y      ymm0: vec, [a];
            movups.y      ymm1: vec, [a + 8];
            movups.y      ymm2: vec, [a + 16];
            movups.y      ymm3: vec, [a + 24];
            pmovsxbd.y    ymm0, ymm0;
            pmovsxbd.y    ymm1, ymm1;
            pmovsxbd.y    ymm2, ymm2;
            pmovsxbd.y    ymm3, ymm3;
            movupd.y      [b], ymm0;
            movupd.y      [b + 32], ymm1;
            movupd.y      [b + 64], ymm2;
            movupd.y      [b + 96], ymm3;
        }

        return 32;
    }

    return 0;
}

__float32_to_32 :: (a: *float32, b: *s32) -> int #expand {
    if context.simd_type == {
    case .sse;
        #asm SSE {
            movups.x      xmm0: vec, [a];
            cvttps2dq.x   xmm0, xmm0;
            movupd.x      [b], xmm0;
        }

        return 4;
    case .avx;
    #through;
    case .avx2;
        #asm AVX, AVX2 {
            movups.y      ymm0: vec, [a];
            cvtps2dq.y    ymm0, ymm0;
            movupd.y      [b], ymm0;
        }

        return 8;
    }

    return 0;
}

// u8, s8, u16, s16, float32, float64 should all be able to convert to 32 bit. float always goes to signed 32 I believe
__convert_to_32 :: (a: *$T1, b: *$T2) -> int #modify { return T2 == s32 || T2 == u32; } #expand {
    #if T1 == s16 || T1 == u16 {
        return __16_to_32(a, b);
    } else #if T1 == float64 {
        return __float64_to_32(a, b);
    } else #if T1 == u8 {
        return __u8_to_32(a ,b);
    } else #if T1 == s8 {
        return __s8_to_32(a ,b);
    } else #if T1 == float32 {
        return __float32_to_32(a, b);
    } else {
        assert(false);
    }

    return 0;
}