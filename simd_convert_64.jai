#scope_module

__32_to_64 :: (a: *$T1, b: *$T2) -> int #expand {
    if `simd_type == {
    case .avx;
    #through;
    case .avx2;
        #if T1 == s32 {
            #asm AVX, AVX2 {
                movups.y      ymm0: vec, [a];
                movups.y      ymm1: vec, [a + 16];
                pmovsxdq.y    ymm0, ymm0;
                pmovsxdq.y    ymm1, ymm1;
                movupd.y      [b], ymm0;
                movupd.y      [b + 32], ymm1;
            }
        } else {
            #asm AVX, AVX2 {
                movups.y      ymm0: vec, [a];
                movups.y      ymm1: vec, [a + 16];
                pmovzxdq.y    ymm0, ymm0;
                pmovzxdq.y    ymm1, ymm1;
                movupd.y      [b], ymm0;
                movupd.y      [b + 32], ymm1;
            }
        }

        return 8;
    case .sse;
        #if T1 == s32 {
            #asm SSE { // @help may be a way to do 8 at a time but IDK
                movups.x      xmm0: vec, [a];
                movups.x      xmm1: vec, [a + 8];
                pmovsxdq.x    xmm0, xmm0;
                pmovsxdq.x    xmm1, xmm1;
                movdqu.x      [b], xmm0;
                movdqu.x      [b + 16], xmm1;
            }
        } else {
            #asm SSE { // @help may be a way to do 8 at a time but IDK
                movups.x      xmm0: vec, [a];
                movups.x      xmm1: vec, [a + 8];
                pmovzxdq.x    xmm0, xmm0;
                pmovzxdq.x    xmm1, xmm1;
                movdqu.x      [b], xmm0;
                movdqu.x      [b + 16], xmm1;
            }
        }

        return 4;
    }

    return 0;
}

__16_to_64 :: (a: *$T1, b: *$T2) -> int #expand {
    if `simd_type == {
    case .avx;
    #through;
    case .avx2;
        #if T1 == s16 {
            #asm AVX, AVX2 {
                // load 16 bit short
                movups.y      ymm0: vec, [a];
                movups.y      ymm1: vec, [a + 8];
                movups.y      ymm2: vec, [a + 16];
                movups.y      ymm3: vec, [a + 24];
                // convert to 32 bit ints
                pmovsxwq.y    ymm0, ymm0;
                pmovsxwq.y    ymm1, ymm1;
                pmovsxwq.y    ymm2, ymm2;
                pmovsxwq.y    ymm3, ymm3;
                movupd.y      [b], ymm0;
                movupd.y      [b + 32], ymm1;
                movupd.y      [b + 64], ymm2;
                movupd.y      [b + 96], ymm3;
            }
        } else {
            #asm AVX, AVX2 {
                // load 16 bit short
                movups.y      ymm0: vec, [a];
                movups.y      ymm1: vec, [a + 8];
                movups.y      ymm2: vec, [a + 16];
                movups.y      ymm3: vec, [a + 24];
                // convert to 32 bit ints
                pmovzxwq.y    ymm0, ymm0;
                pmovzxwq.y    ymm1, ymm1;
                pmovzxwq.y    ymm2, ymm2;
                pmovzxwq.y    ymm3, ymm3;
                movupd.y      [b], ymm0;
                movupd.y      [b + 32], ymm1;
                movupd.y      [b + 64], ymm2;
                movupd.y      [b + 96], ymm3;
            }
        }

        return 16;
    case .sse;
        #if T1 == s16 {
            #asm SSE { // @help may be a way to do 8 at a time but IDK
                movups.x      xmm0: vec, [a];
                movups.x      xmm1: vec, [a + 4];
                movups.x      xmm2: vec, [a + 8];
                pmovsxwq.x    xmm0, xmm0;
                pmovsxwq.x    xmm1, xmm1;
                pmovsxwq.x    xmm2, xmm2;
                movdqu.x      [b], xmm0;
                movdqu.x      [b + 16], xmm1;
                movdqu.x      [b + 32], xmm2;
            }
        } else {
            #asm SSE { // @help may be a way to do 8 at a time but IDK
                movups.x      xmm0: vec, [a];
                movups.x      xmm1: vec, [a + 4];
                pmovzxwq.x    xmm0, xmm0;
                pmovzxwq.x    xmm1, xmm1;
                movdqu.x      [b], xmm0;
                movdqu.x      [b + 16], xmm1;
            }
        }

        return 4;
    }

    return 0;
}

__u8_to_64 :: (a: *u8, b: *u64) -> int #expand {
    if `simd_type == {
    case .sse;
        #asm SSE {
            movups.x      xmm0: vec, [a];
            movups.x      xmm1: vec, [a + 2];
            movups.x      xmm2: vec, [a + 4];
            movups.x      xmm3: vec, [a + 6];
            movups.x      xmm4: vec, [a + 8];
            movups.x      xmm5: vec, [a + 10];
            movups.x      xmm6: vec, [a + 12];
            movups.x      xmm7: vec, [a + 14];
            pmovzxbq.x    xmm0, xmm0;
            pmovzxbq.x    xmm1, xmm1;
            pmovzxbq.x    xmm2, xmm2;
            pmovzxbq.x    xmm3, xmm3;
            pmovzxbq.x    xmm4, xmm4;
            pmovzxbq.x    xmm5, xmm5;
            pmovzxbq.x    xmm6, xmm6;
            pmovzxbq.x    xmm7, xmm7;
            movupd.x      [b], xmm0;
            movupd.x      [b + 16], xmm1;
            movupd.x      [b + 32], xmm2;
            movupd.x      [b + 48], xmm3;
            movupd.x      [b + 64], xmm4;
            movupd.x      [b + 80], xmm5;
            movupd.x      [b + 96], xmm6;
            movupd.x      [b + 112], xmm7;
        }

        return 16;
    case .avx;
    #through;
    case .avx2;
        #asm AVX, AVX2 {
            movups.y      ymm0: vec, [a];
            movups.y      ymm1: vec, [a + 4];
            movups.y      ymm2: vec, [a + 8];
            movups.y      ymm3: vec, [a + 12];
            movups.y      ymm4: vec, [a + 16];
            movups.y      ymm5: vec, [a + 20];
            movups.y      ymm6: vec, [a + 24];
            movups.y      ymm7: vec, [a + 28];
            pmovzxbq.y    ymm0, ymm0;
            pmovzxbq.y    ymm1, ymm1;
            pmovzxbq.y    ymm2, ymm2;
            pmovzxbq.y    ymm3, ymm3;
            pmovzxbq.y    ymm4, ymm4;
            pmovzxbq.y    ymm5, ymm5;
            pmovzxbq.y    ymm6, ymm6;
            pmovzxbq.y    ymm7, ymm7;
            movupd.y      [b], ymm0;
            movupd.y      [b + 32], ymm1;
            movupd.y      [b + 64], ymm2;
            movupd.y      [b + 96], ymm3;
            movupd.y      [b + 128], ymm4;
            movupd.y      [b + 160], ymm5;
            movupd.y      [b + 192], ymm6;
            movupd.y      [b + 224], ymm7;
        }

        return 32;
    }

    return 0;
}

__s8_to_64 :: (a: *s8, b: *s64) -> int #expand {
    if simd_type == {
    case .avx;
    #through;
    case .avx2;
        #asm AVX, AVX2 {
            movups.y      ymm0: vec, [a];
            movups.y      ymm1: vec, [a + 4];
            movups.y      ymm2: vec, [a + 8];
            movups.y      ymm3: vec, [a + 12];
            movups.y      ymm4: vec, [a + 16];
            movups.y      ymm5: vec, [a + 20];
            movups.y      ymm6: vec, [a + 24];
            movups.y      ymm7: vec, [a + 28];
            pmovsxbq.y    ymm0, ymm0;
            pmovsxbq.y    ymm1, ymm1;
            pmovsxbq.y    ymm2, ymm2;
            pmovsxbq.y    ymm3, ymm3;
            pmovsxbq.y    ymm4, ymm4;
            pmovsxbq.y    ymm5, ymm5;
            pmovsxbq.y    ymm6, ymm6;
            pmovsxbq.y    ymm7, ymm7;
            movupd.y      [b], ymm0;
            movupd.y      [b + 32], ymm1;
            movupd.y      [b + 64], ymm2;
            movupd.y      [b + 96], ymm3;
            movupd.y      [b + 128], ymm4;
            movupd.y      [b + 160], ymm5;
            movupd.y      [b + 192], ymm6;
            movupd.y      [b + 224], ymm7;
        }

        return 32;
    case .sse;
        #asm SSE {
            movups.x      xmm0: vec, [a];
            movups.x      xmm1: vec, [a + 2];
            movups.x      xmm2: vec, [a + 4];
            movups.x      xmm3: vec, [a + 6];
            movups.x      xmm4: vec, [a + 8];
            movups.x      xmm5: vec, [a + 10];
            movups.x      xmm6: vec, [a + 12];
            movups.x      xmm7: vec, [a + 14];
            pmovsxbq.x    xmm0, xmm0;
            pmovsxbq.x    xmm1, xmm1;
            pmovsxbq.x    xmm2, xmm2;
            pmovsxbq.x    xmm3, xmm3;
            pmovsxbq.x    xmm4, xmm4;
            pmovsxbq.x    xmm5, xmm5;
            pmovsxbq.x    xmm6, xmm6;
            pmovsxbq.x    xmm7, xmm7;
            movupd.x      [b], xmm0;
            movupd.x      [b + 16], xmm1;
            movupd.x      [b + 32], xmm2;
            movupd.x      [b + 48], xmm3;
            movupd.x      [b + 64], xmm4;
            movupd.x      [b + 80], xmm5;
            movupd.x      [b + 96], xmm6;
            movupd.x      [b + 112], xmm7;
        }

        return 16;
    }

    return 0;
}

// u8, s8, u16, s16, float32, float64 should all be able to convert to 32 bit. float always goes to signed 32 I believe
__convert_to_64 :: (a: *$T1, b: *$T2) -> int #modify { return T2 == s64 || T2 == u64; } #expand {
    #if T1 == s16 || T1 == u16 {
        return __16_to_64(a, b);
    } else #if T1 == s32 || T1 == u32 {
        return __32_to_64(a, b);
    } else #if T1 == u8 {
        return __u8_to_64(a ,b);
    } else #if T1 == s8 {
        return __s8_to_64(a ,b);
    } else {
        assert(false);
    }

    return 0;
}