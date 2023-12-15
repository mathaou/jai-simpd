#scope_file

Vector4ps :: struct {
  x: float;
  y: float;
  z: float;
  w: float;
  q: float;
  r: float;
  s: float;
  t: float;
}

Vector4s32 :: struct {
  x: s32;
  y: s32;
  z: s32;
  w: s32;
  q: s32;
  r: s32;
  s: s32;
  t: s32;
}

#scope_module

__32_to_float32 :: (a: *s32, b: *float32) -> int #expand {
    if `simd_type == {
    case .sse;
        #asm SSE {
            cvtdq2ps.x    xmm0: vec, [a];
            movupd.x      [b], xmm0;
        }

        return 4;
    case .avx;
    #through;
    case .avx2;
        // src: Vector4s32 = .{a[0], a[1], a[2], a[3],
        //     a[4], a[5], a[6], a[7]} #align 16;
        // dst: Vector4ps #align 16;

        /*
        CPU took 5721ns to convert s32 to float32
        SSE took 2805ns to convert s32 to float32
        AVX took 11301ns to convert s32 to float32
        AVX2 took 11432ns to convert s32 to float32
        */

        #asm AVX, AVX2 {
            cvtdq2ps.x    xmm0: vec, [a]; //     and this
            movapd.x      [b], xmm0; // this takes basically no time
        }

        return 8;
    }

    return 0;
}

__float64_to_float32 :: (a: *float64, b: *float32) -> int #expand {
    if `simd_type == {
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
    simd_type := `simd_type;
    #if T1 == s32 {
        return __32_to_float32(a, b);
    } else #if T1 == float64 {
        return __float64_to_float32(a, b);
    } else {
        assert(false);
    }

    return 0;
}