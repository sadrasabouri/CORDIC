`timescale 10ns / 100ps
module cordictanh_tb;
    localparam FLOAT_SIZE = 24;
    localparam INT_SIZE = 8;

	// Inputs
	reg CLK;
	reg EN;
	reg signed [INT_SIZE-1:-FLOAT_SIZE] z;

	// Outputs
	wire signed [INT_SIZE-1:-FLOAT_SIZE] result;

	// Instantiate the Unit Under Test (UUT)
	cordictanh uut (
		.CLK(CLK), 
		.EN(EN), 
		.z(z),
		.out(result)
    );
	
    localparam CLK_PERIOD_2 = 0.05;
	localparam SF = 2.0**-FLOAT_SIZE;

    always 
	begin
		 CLK = ~CLK;
		 #CLK_PERIOD_2;
	end

    initial begin
		// Initialize Inputs
		CLK = 0;
		EN = 0;
        z = 0;
    end

    parameter N_TESTS = 201;
    integer idx;
    integer failed_n, passed_n;
    integer output_file;
    reg signed [INT_SIZE-1:-FLOAT_SIZE] actual_values [0:N_TESTS-1];
    reg signed [INT_SIZE-1:-FLOAT_SIZE] inputs [0:N_TESTS-1];
    initial
    begin
        idx = 0;
        failed_n = 0;
        passed_n = 0;
        $readmemb("../Matlab/input_b.txt", inputs);
        $readmemb("../Matlab/output_b.txt", actual_values);
        output_file = $fopen("cordictanh_tb.txt", "w");
		$fwrite(output_file, "[START]\n");
        repeat (N_TESTS)
        begin
            z = inputs[idx];
            EN = 1;
            #1;
            EN = 0;
            #10;
            if (result == actual_values[idx])
            begin
                $fwrite(output_file, "[PASSED] :)       ",
                            "TEST:{%03d", idx, "/%03d", N_TESTS-1, "}\n");
                passed_n = passed_n + 1;
            end
            else
            begin
                $fwrite(output_file,"[FAILED] :(       ",
                        "TEST:{%03d", idx, "/%03d", N_TESTS-1, "}", "\n>>> ", $time,
                        " INPUT=%h(%f)", z, $itor(z*SF),
                        " CALCULATED=%h(%f)", result, $itor(result*SF),
                        " ACTUAL=%h(%f)\n", actual_values[idx], $itor(actual_values[idx]*SF));
                failed_n = failed_n + 1;                
            end
            idx = idx + 1;
        end
        $fwrite(output_file,"[PASSED IN %03d", passed_n,
                            "/%03d", N_TESTS, "]\n");
        $fwrite(output_file,"[FAILED IN %03d", failed_n,
                            "/%03d", N_TESTS, "]\n");
        $fwrite(output_file, "[DONE]\n");
        $fclose(output_file);
    end
endmodule
