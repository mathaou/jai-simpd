#scope_export

// god bless how_to
loop_unroll :: (n: int, code: Code) #expand {
    UNROLL_SIZE :: 4;

    big_loops   := n / UNROLL_SIZE;
    small_loops := n % UNROLL_SIZE;

    for 1..big_loops {
        // We just paste the code in 4 times, so that we have no overhead between the iterations.
        #insert code;
        #insert code;
        #insert code;
        #insert code;
    }

    for 1..small_loops {
        #insert code;
    }
}