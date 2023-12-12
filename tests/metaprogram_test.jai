#import "Compiler";
#import "Basic";
#import "String";

#run {
  w := compiler_create_workspace();

  options := get_build_options(w);
  options.output_executable_name = "meta";
  set_build_options(options, w);

  compiler_begin_intercept(w);
  add_build_file("multiply_test.jai", w);  

  while true {
    message := compiler_wait_for_message();
    if !message break;
    if message.kind == {
    case .TYPECHECKED;
      typechecked := cast(*Message_Typechecked) message;
      for decl: typechecked.declarations {
        for note: decl.expression.notes {
          if equal(note.text, "simd_unsupported_op") {
            print("unsupported SIMD OP encountered.\nYou likely tried to do something like multiply 64-bit ints (which is not supported by an AVX or SSE).\nUnrolling loop instead in macro % at line % in file %\n", 
                decl.expression.name, decl.expression.location.l0, decl.expression.location.enclosing_load.fully_pathed_filename);
            assert(false);
          }
        }

      }
    case .COMPLETE;
      break;
    }
  }
  
  compiler_end_intercept(w);
  set_build_options_dc(.{do_output=false});
}
  gen_code := false;
