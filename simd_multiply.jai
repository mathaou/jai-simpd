#scope_file


__simd_multiply_float :: (a: *$T, b: *T) -> int #modify { return T == float32 || T == float64; } {
    #if CPU == .ARM64 {
        assert(false); //not implemented yet
    } else {
        if context.simd_type == {
        case .sse;
            #if T == float32 {
                #asm SSE {
                    movups.x xmm0: vec, [a];
                    movups.x xmm1: vec, [b];
                    addps.x  xmm1, xmm0;
                    movups.x [b], xmm1;
                }

                return 4;
            } else {
                #asm SSE {
                    movups.x xmm0: vec, [a];
                    movups.x xmm1: vec, [b];
                    addpd.x  xmm1, xmm0;
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
                    addps.y  ymm1, ymm0, ymm1;
                    movups.y [b], ymm1;
                }

                return 8;
            } else {
                #asm AVX, AVX2 {
                    movups.y ymm0: vec, [a];
                    movups.y ymm1: vec, [b];
                    addpd.y  ymm1, ymm0, ymm1;
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

#scope_export

simd_multiply :: (src: []$T, dst: []T) #modify { return T==u8 || T==s8 || T==u16 || T==s16 || T==u32 || T==s32 || T==u64 || T==s64 || T==float32 || T==float64; } {
    assert(dst.count >= src.count);

    i := 0;
    __data_width := size_of(T);

    mask := 0xffffffff;
    bound := src.count;

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
            loop_unroll(__data_width, #code {
                dst[i] += src[i];
                i += 1;
            });
        } else {
            #if T == float32 || T == float64 i += __simd_multiply_float(a, b);
            else {
                assert(false); // unimplemented
            }
        }

        // print("%=>", i);
    }

    // print("\n");

    if i != src.count {
        // print("unrolling remaining %\n", src.count - i);

        // catch spillover
        loop_unroll(ifx src.count > dst.count then dst.count - i else src.count - i, #code {
            dst[i] *= src[i];
            i += 1;
        });
    }

    // print("[%] %\n", T, dst);
}