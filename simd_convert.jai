#scope_file

unsupported_convert_loop_unroll :: () #expand {
    loop_unroll(`src.count, #code {
        `result[`i] = cast(`target) `src[`i];
        `i += 1;
    });
} @simd_unsupported_op

#scope_export

simd_convert_to :: inline (src: []$T1, $target: Type, result: []target, simd_type := SIMD_Type.cpu) -> bool #modify { return (T1 == float32 || T1 == s32 || T1 == s16 || T1 == u32 || T1 == u16 || T1 == float64 || T1 == u8 || T1 == s8 || T1 == u64 || T1 == s64); } {
    valid_simd := false;

    #if T1 == target {
        return false;
    }

    i := 0;

    if simd_type == .cpu {
        loop_unroll(src.count, #code {
            result[i] = cast(target) src[i];
            i += 1;
        });
    } else {
        stride: int;
        __data_width := size_of(T1);

        if simd_type == .sse {
            stride = 128 / (__data_width * 8);
        } else {
            stride = 256 / (__data_width * 8);
        }

        // start := to_nanoseconds(current_time_monotonic());

        while i + stride <= src.count {
            a := src.data + i;
            b := result.data + i;

            #if target == float32 {
                // any other kind of conversion actually performs worse than native
                #if !(T1 == s32 || T1 == float64) {
                    // nonstandard conversion
                    unsupported_convert_loop_unroll();
                } else {
                    i += __convert_to_float32(a, b);
                    valid_simd = true;
                }
            } else #if target == float64 {
                // any other kind of conversion actually performs worse than native
                #if !(T1 == s32 || T1 == float32) {
                    // nonstandard conversion
                    unsupported_convert_loop_unroll();
                } else {
                    i += __convert_to_float64(a, b);
                    valid_simd = true;
                }
            } else #if target == s16 || target == u16 {
                if (T1 == s8 && target == s16) || (T1 == u8 && target == u16) {
                    i += __convert_to_16(a, b);
                    valid_simd = true;
                } else {
                    // nonstandard conversion
                    unsupported_convert_loop_unroll();
                }
            } else #if target == s32 || target == u32 {
                #if !(
                    (T1 == float32 && target == s32) || (T1 == float64 && target == s32) ||
                    (T1 == s8 && target == s32) || (T1 == s16 && target == s32) ||
                    (T1 == u8 && target == u32) || (T1 == u16 && target == u32)) {
                    // nonstandard conversion
                    unsupported_convert_loop_unroll();
                } else {
                    i += __convert_to_32(a, b);
                    valid_simd = true;
                }
            } else #if target == s64 || target == u64 {
                #if T1 == float32 || T1 == float64 ||
                    (T1 == s64 && target == u64) || (T1 == u64 && target == s64) ||
                    (T1 == s32 && target == u64) || (T1 == u32 && target == s64) ||
                    (T1 == s16 && target == u64) || (T1 == u16 && target == s64) ||
                    (T1 == s8 && target == u64) || (T1 == u8 && target == s64) {
                    // nonstandard conversion
                    unsupported_convert_loop_unroll();
                } else {
                    i += __convert_to_64(a, b);
                    valid_simd = true;
                }
            } else {
                // haven't implemented this conversion target yet
                unsupported_convert_loop_unroll();
            }
        }

        // end := to_nanoseconds(current_time_monotonic()) - start;

        if valid_simd {
            // print("% => % success!\n", T1, target);
        //     comp_start := to_nanoseconds(current_time_monotonic());
        //     t := NewArray(src.count, target, allocator=temp, alignment=16);
        //     c := 0;
        //     loop_unroll(src.count, #code {
        //         t[c] = cast(target) src[c];
        //         c += 1;
        //     });

        //     comp_end := to_nanoseconds(current_time_monotonic()) - comp_start;

        //     // memory leak w/e

        //     print("\t% => % with SIMD took %ns (versus %ns for CPU) %\% delta\n", T1, target, end, comp_end, 100 - ((cast(float32) end / cast(float32) comp_end) * 100));
        }
    }

    if i < src.count {
        // print("unrolling remaining %\n", src.count - i);

        // catch spillover
        loop_unroll(src.count - i, #code {
            result[i] = cast(target) src[i];
            i += 1;
        });
    }

    // print("[%] %\n", T1, src);
    // print("[%] %\n", target, result);

    #if 0 {
        sanity := NewArray(src.count, target, allocator=temp, alignment=16);

        for src {
            sanity[it_index] = cast(target) it;
        }

        for sanity {
            diff: float32;

            #if target == s8 || target == s16 || target == s32 || target == s64 || target == float32 || target == float64 {
                diff_a := ifx sanity[it_index] < 0 then sanity[it_index] * -1 else sanity[it_index];
                diff_b := ifx result[it_index] < 0 then result[it_index] * -1 else result[it_index];
                diff = xx (diff_a - diff_b);
            } else {
                diff = xx (sanity[it_index] - result[it_index]);
            }

            if diff > 1 || diff < -1 { // within a little epsilon is fine idgaf
                print("[% => %] % != % @ %\n", T1, target, sanity[it_index], result[it_index], it_index);
                for sanity {
                    print("[%]\t%\t\t%\n", it_index, it, result[it_index]);
                }
                assert(false);
            }
        }
    }

    return true;
}