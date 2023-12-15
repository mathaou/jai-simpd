#scope_file

__simd_subtract_float :: (a: *$T, b: *T) -> int #modify { return T == float32 || T == float64; } #expand {
    #if CPU == .ARM64 {
        assert(false); //not implemented yet
    } else {
        if `simd_type == {
        case .sse;
            #if T == float32 {
                #asm SSE {
                    movups.x xmm0: vec, [a];
                    movups.x xmm1: vec, [b];
                    subps.x  xmm1, xmm0;
                    movups.x [b], xmm1;
                }

                return 4;
            } else {
                #asm SSE {
                    movups.x xmm0: vec, [a];
                    movups.x xmm1: vec, [b];
                    subpd.x  xmm1, xmm0;
                    movupd.x [b], xmm1;
                }

                return 2;
            }
        case .avx;
        #through;
        case .avx2;
            #if T == float32 {
                #asm AVX, AVX2 {
                    movups.y ymm0: vec, [a];
                    movups.y ymm1: vec, [b];
                    subps.y  ymm1, ymm0, ymm1;
                    movups.y [b], ymm1;
                }

                return 8;
            } else {
                #asm AVX, AVX2 {
                    movups.y ymm0: vec, [a];
                    movups.y ymm1: vec, [b];
                    subpd.y  ymm1, ymm0, ymm1;
                    movupd.y [b], ymm1;
                }

                return 4;
            }
        case;
            assert(false);
        }
    }

    return 0;
}

__simd_subtract_8 :: (a: *$T, b: *T) -> int #modify { return T == u8 || T == s8; } #expand {
    #if CPU == .ARM64 {
        assert(false); //not implemented yet
    } else {
        if `simd_type == { // for bytes I guess AVX2 doesn't support
        case .avx; // @note the AVX variant of this function isn't supported yet
        #through;
        case .avx2; // @note assuming that any CPU with AVX/AVX2 also has SSE
        #through;
        case .sse;
            #asm SSE {
                movdqu.x  xmm0: vec, [a];
                movdqu.x  xmm1: vec, [b];
                psubb.x   xmm1, xmm0;
                movdqu.x  [b], xmm1;
            }

            return 16;
        case;
            assert(false);
        }
    }

    return 0;
}

__simd_subtract_16 :: (a: *$T, b: *T) -> int #modify { return T == s16 || T == u16; } #expand {
    if CPU == .ARM64 {
        assert(false);
    } else {
        if `simd_type == { // for bytes I guess AVX2 doesn't support
        case .sse;
            #asm SSE {
                movdqu.x  xmm0: vec, [a];
                movdqu.x  xmm1: vec, [b];
                psubw.x   xmm1, xmm0;
                movdqu.x  [b], xmm1;
            }

            return 8;
        case .avx;
        #through;
        case .avx2;
            #asm AVX, AVX2 { // signed and unsigned have same logic
                movdqu.y  ymm0: vec, [a];
                movdqu.y  ymm1: vec, [b];
                psubw.y   ymm1, ymm0, ymm1;
                movupd.y  [b], ymm1;
            }

            return 16;
        case;
            assert(false);
        }
    }

    return 0;
}

__simd_subtract_32 :: (a: *$T, b: *T) -> int #modify { return T == s32 || T == u32; } #expand {
    if CPU == .ARM64 {
        assert(false);
    } else {
        if `simd_type == { // for bytes I guess AVX2 doesn't support
        case .sse;
            #asm SSE {
                movdqu.x  xmm0: vec, [a];
                movdqu.x  xmm1: vec, [b];
                psubd.x   xmm1, xmm0;
                movdqu.x  [b], xmm1;
            }

            return 4;
        case .avx;
        #through;
        case .avx2;
            #asm AVX, AVX2 { // signed and unsigned have same logic
                movdqu.y  ymm0: vec, [a];
                movdqu.y  ymm1: vec, [b];
                psubd.y   ymm1, ymm0, ymm1;
                movupd.y  [b], ymm1;
            }

            return 8;
        case;
            assert(false);
        }
    }

    return 0;
}

__simd_subtract_64 :: (a: *$T, b: *T) -> int #modify { return T == s64 || T == u64; } #expand {
    if CPU == .ARM64 {
        assert(false);
    } else {
        if `simd_type == { // for bytes I guess AVX2 doesn't support
        case .sse;
            #asm SSE {
                movdqu.x  xmm0: vec, [a];
                movdqu.x  xmm1: vec, [b];
                psubq.x   xmm1, xmm0;
                movdqu.x  [b], xmm1;
            }

            return 2;
        case .avx;
        #through;
        case .avx2;
            #asm AVX, AVX2 { // signed and unsigned have same logic
                movdqu.y  ymm0: vec, [a];
                movdqu.y  ymm1: vec, [b];
                psubq.y   ymm1, ymm0, ymm1;
                movupd.y  [b], ymm1;
            }

            return 4;
        case;
            assert(false);
        }
    }

    return 0;
}

#scope_export

simd_subtract :: inline (src: []$T, dst: []T, simd_type := SIMD_Type.cpu) #modify { return T==u8 || T==s8 || T==u16 || T==s16 || T==u32 || T==s32 || T==u64 || T==s64 || T==float32 || T==float64; } {
    assert(dst.count >= src.count);

    i := 0;

    if simd_type == .cpu {
        loop_unroll(src.count, #code {
            dst[i] -= src[i];
            i += 1;
        });
    } else {
        stride: int;
        __data_width := size_of(T);

        if simd_type == .sse {
            stride = 128 / (__data_width * 8);
        } else {
            stride = 256 / (__data_width * 8);
        }

        while i + stride <= src.count {
            a := src.data + i;
            b := dst.data + i;

            #if T == float32 || T == float64 i += __simd_subtract_float(a, b);
            else #if T == u8 || T == s8 i += __simd_subtract_8(a, b);
            else #if T == s16 || T == u16 i += __simd_subtract_16(a, b);
            else #if T == s32 || T == u32 i += __simd_subtract_32(a, b);
            else #if T == s64 || T == u64 i += __simd_subtract_64(a, b);
            else {
                assert(false); // unimplemented
            }
        }

        // print("%=>", i);
    }

    // print("\n");

    if i <= src.count {
        // print("unrolling remaining %\n", src.count - i);

        // catch spillover
        loop_unroll(src.count - i, #code {
            dst[i] -= src[i];
            i += 1;
        });
    }

    // print("[%] %\n", T, dst);
}