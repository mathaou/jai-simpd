#!/bin/bash

rm -rf bin
mkdir -p bin

# jai add_test.jai -output_path bin -exe add -release
# jai subtract_test.jai -output_path bin -exe sub -release
# jai divide_test.jai -output_path bin -exe div -release
# jai multiply_test.jai -output_path bin -exe mult -release
# jai logical_test.jai -output_path bin -exe logic -release
# jai convert_test.jai -output_path bin -exe convert -release
jai benchmark_convert.jai -output_path bin -exe benchmark -release
