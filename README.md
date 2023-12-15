# Simpd

## Simple SIMD in Jai

As of compiler version 0.1.078 and the current state of the codebase, here's the ranking on average time to complete multiple runs of 2048 random numbers and each op. See `tests/benchmark_convert.jai` to run yourself.

Ran on AMD Ryzen 7 7730U, single thread.

| OP | CPU | AVX2 | AVX | SSE | Best |
| --- | --- | --- | --- | --- | --- |
| Convert | 7404ns | 2054ns | 2054ns | 2776ns | AVX2 + AVX |
| Divide | 32250ns | 244839ns | 198692ns | 19256ns | SSE |
| Add | 11602ns | 359394ns | 358683ns | 6161ns | SSE |
| Subtract | 11642ns | 356789ns | 357971ns | 6502ns | SSE |
| Multiply | 12243ns | 597991ns | 714280ns | 9728ns | SSE |

I know that AVX + LLVM is an area that is currently being worked on by compiler team, so I would expect these numbers to shift over time. In the mean time, unless you're converting, the SSE backing should give you a speed boost.

**SIMD may generally improve performance across the board compared to loop unrolling, but different backings may be better or worse than each other depending on the task and data. Going with newest instructions (AVX2) does not mean it will perform better across the board compared to SSE (earliest this library supports). There are instances where SSE still outperforms AVX2. Do your homework if performance is critical to you. The goal of this library is to provide a reasonable speed increase for common operations overall, not to achieve optimal performance.**

---

Upon loading, `Simpd` will choose AVX2, AVX, or SSE (in that order) depending on what your hardware supports.

To overload this, set `context.simd_type` to one of the following:

```
SIMD_Type :: enum {
    sse;
    avx;
    avx2;
    neon; // unsupported currently
    cpu;  // use loop unrolling for everything
}

...

context.simd_type = .sse; // for example
```


---

All two parameter functions use the last parameter as the destination to store the result.

```
we put result here
~~~~~~~~~~~~~~~~~~~~~~~~v
simd_add :: (src: []$T, dst: []T)
```

One parameter functions are performed **in place**.

#### Hardware Support Table

> **If an instruction does not have an AVX, AVX2, or SSE backing, `Simpd` will instead use loop unrolling.** If a user wanted to detect a program trying to use a `Simpd` function on a data type that didn't have a hardware accellerated backing, the `@simd_unsupported_op` note can be caught by a metaprogram. See `tests/metaprogram_test.jai` for details.

The API of these functions may be made to reject any unsupported types instead of just reporting it as a note to the metaprogram. This aspect of the design is under review and open to discussion.

##### Arithmetic

| Instruction | float32 | float64 | i8/u8 | i16/u16 | i32/u32 | i64/u64 |
| --- | --- | --- | --- | --- | --- | --- |
| `simd_add :: (src: []$T, dst: []T)` | AVX+AVX2+SSE| AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE |
| `simd_subtract :: (src: []$T, dst: []T)` | AVX+AVX2+SSE| AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE |
| `simd_multiply :: (src: []$T, dst: []T)` | AVX+AVX2+SSE| AVX+AVX2+SSE |  | AVX+AVX2+SSE | AVX+AVX2+SSE |  |
| `simd_divide :: (src: []$T, dst: []T)` | AVX+AVX2+SSE| AVX+AVX2+SSE |  | |  |  |
<!-- | `simd_reciprocal` | AVX+AVX2+SSE| |  | |  |  |
| `simd_reciprocal_root` | AVX+AVX2+SSE| |  | |  |  |
| `simd_root` | AVX+AVX2+SSE| |  | |  |  |
| `simd_average` | | | AVX+AVX2+SSE | AVX+AVX2+SSE |  |  | -->
<!--
##### Bit Manipulation

| Instruction | float32 | float64 | i8/u8 | i16/u16 | i32/u32 | i64/u64 |
| --- | --- | --- | --- | --- | --- | --- |
| `simd_shift_left` | AVX+AVX2+SSE | AVX+AVX2+SSE | | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE |
| `simd_shift_right` | AVX+AVX2+SSE | AVX+AVX2+SSE | | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE |
| `simd_rotate_left` | AVX+AVX2+SSE | AVX+AVX2+SSE | | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE |
| `simd_rotate_right`| AVX+AVX2+SSE | AVX+AVX2+SSE | | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE | -->
<!--
##### Comparisons and Validity

| Instruction | float32 | float64 | i8/u8 | i16/u16 | i32/u32 | i64/u64 | Note |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `simd_equal` | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE |  Sets destination to 1 if equal, 0 otherwise |
| `simd_not_equal` | AVX+AVX2+SSE | AVX+AVX2+SSE | | |  |  | Sets destination to 1 if dst != src, 0 otherwise |
| `simd_greater` | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE |  Sets destination to 1 if dst > src, 0 otherwise |
| `simd_greater_or_equal` | AVX+AVX2+SSE | AVX+AVX2+SSE | | |  |  | Sets destination to 1 if dst >= src, 0 otherwise |
| `simd_less` | AVX+AVX2+SSE | AVX+AVX2+SSE | | |  |  | Sets destination to 1 if dst < src, 0 otherwise |
| `simd_less_or_equal` | AVX+AVX2+SSE | AVX+AVX2+SSE | | |  |  | Sets destination to 1 if dst <= src, 0 otherwise |
| `simd_nan` | AVX+AVX2+SSE | AVX+AVX2+SSE | | |  |  | Sets destination to 1 if dst or src is NaN, 0 otherwise |
| `simd_valid` | AVX+AVX2+SSE | AVX+AVX2+SSE | | |  |  | Sets destination to 1 if dst and src is not NaN, 0 otherwise |
| `simd_max` | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE | |  Sets destination to 1 if dst > src, 0 otherwise |
| `simd_min` | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE | AVX+AVX2+SSE | |  Sets destination to 1 if dst > src, 0 otherwise | -->

##### Conversions

```simd_convert_to :: (src: []$T1, target: $T2) -> dst: []$T2```

`✔️` for fully supported by all backings and empty for `loop unroll`

|src/dst| float64 | float32 | s64 | s32 | s16 | s8 | u64 | u32 | u16 | u8 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| float64   | No-op |✔️| |✔️|| | ||| |
| float32   |✔️| No-op | |✔️| | | || | | |
| s64       | | | No-op || | | | | | | |
| s32       |✔️|✔️|✔️| No-op | | | | | | |
| s16       | | |✔️|✔️| No-op | | || | | |
| s8        | | |✔️|✔️|✔️| No-op | || | | |
| u64       | | | | | | | No-op | | | | |
| u32       ||| | | | |✔️| No-op || |
| u16       | | | || | |✔️|✔️| No-op ||
| u8        | | | || | |✔️|✔️|✔️| No-op |

##### Logical

| Instruction | Any |
| --- | --- |
| `simd_clear :: (dst: []$T)` | AVX2+AVX+SSE |
| `simd_and :: (src: []$T, dst: []T)` | AVX2+AVX+SSE |
<!-- | `simd_or` | AVX2+AVX+SSE |
| `simd_xor` | AVX2+AVX+SSE |
| `simd_nand` | AVX2+AVX+SSE |
| `simd_copy` | AVX2+AVX+SSE | -->