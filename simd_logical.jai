#scope_file

#scope_export

simd_clear :: inline (dst: []$T, simd_type := SIMD_Type.cpu) {
    assert(dst.count > 0);

    i := 0;

    if simd_type == .cpu {
        loop_unroll(dst.count, #code {
            dst[i] = 0;
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

        while i + stride <= dst.count {
            b := dst.data + i;

            if simd_type == {
            case .sse;
                #asm SSE {
                    movdqu.x  xmm0: vec, [b];
                    xorps.x xmm0, xmm0;
                    movupd.x  [b], xmm0;
                }
            case .avx;
            #through;
            case .avx2;
                #asm AVX, AVX2 {
                    movdqu.y  ymm0: vec, [b];
                    xorps.y ymm0, ymm0, ymm0;
                    movupd.y  [b], ymm0;
                }
            case;
                assert(false);
            }

            i += stride;
        }

        // print("%=>", i);
    }

    // print("\n");

    if i <= dst.count {
        // catch spillover
        loop_unroll(dst.count - i, #code {
            dst[i] = 0;
            i += 1;
        });
    }

    // print("[%] %\n", T, dst);
}

simd_and :: inline (src: []$T, dst: []T, simd_type := SIMD_Type.cpu) {
    assert(dst.count >= src.count);

    i := 0;

    if simd_type == .cpu {
        loop_unroll(src.count, #code {
            dst[i] &= src[i];
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

            if `simd_type == {
            case .sse;
                #asm SSE {
                    movdqu.x  xmm0: vec, [a];
                    movdqu.x  xmm1: vec, [b];
                    andps.x   xmm1, xmm0;
                    movupd.x  [b], xmm1;
                }
            case .avx;
            #through;
            case .avx2;
                #asm AVX, AVX2 {
                    movdqu.y  ymm0: vec, [a];
                    movdqu.y  ymm1: vec, [b];
                    andps.y   ymm1, ymm0, ymm1;
                    movupd.y  [b], ymm1;
                }
            case;
                assert(false);
            }

            i += stride;
        }

        // print("%=>", i);
    }

    // print("\n");

    if i <= src.count {
        // catch spillover
        loop_unroll(src.count - i, #code {
            dst[i] &= src[i];
            i += 1;
        });
    }

    // print("[%] %\n", T, dst);
}
