#scope_export

#import "Machine_X64";
#import "Compiler";
#import "Basic";


SIMD_Type :: enum {
    sse;
    avx;
    avx2;
    neon;
    cpu;
}

most_recent_simd :: () {
    cpu_info := get_cpu_info();

    if check_feature(cpu_info.feature_leaves, .AVX2) {
        return .avx2;
    } else if check_feature(cpu_info.feature_leaves, .AVX) {
        return .avx;
    } else if check_feature(cpu_info.feature_leaves, .SSE) {
        return .sse;
    }
}

#load "simd_common.jai";
#load "simd_add.jai";
#load "simd_subtract.jai";
#load "simd_multiply.jai";
#load "simd_divide.jai";
#load "simd_logical.jai";
#load "simd_convert_16.jai";
#load "simd_convert_32.jai";
#load "simd_convert_64.jai";
#load "simd_convert_float32.jai";
#load "simd_convert_float64.jai";
#load "simd_convert.jai";