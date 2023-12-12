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

#add_context simd_type: SIMD_Type = .cpu;

#if 1 {
    #run () {
        cpu_info := get_cpu_info();

        if check_feature(cpu_info.feature_leaves, .AVX2) {
            context.simd_type = .avx2;
        } else if check_feature(cpu_info.feature_leaves, .AVX) {
            context.simd_type = .avx;
        } else if check_feature(cpu_info.feature_leaves, .SSE) {
            context.simd_type = .sse;
        }
    }();
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