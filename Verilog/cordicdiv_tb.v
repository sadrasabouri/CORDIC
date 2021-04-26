`timescale 10ns / 100ps
module cordicdiv_tb;
    localparam FLOAT_SIZE = 24;
    localparam INT_SIZE = 8;

	// Inputs
	reg CLK;
	reg EN;
	reg signed [INT_SIZE-1:-FLOAT_SIZE] x;
    reg signed [INT_SIZE-1:-FLOAT_SIZE] y;

	// Outputs
	wire signed [INT_SIZE-1:-FLOAT_SIZE] result;

	// Instantiate the Unit Under Test (UUT)
	cordicdiv uut (
		.CLK(CLK), 
		.EN(EN), 
		.x(x), 
		.y(y), 
		.out(result)
    );
	
    localparam CLK_PERIOD_2 = 0.05;
	localparam SF = 2.0**-FLOAT_SIZE;

    always 
	begin
		 CLK = ~CLK;
		 #CLK_PERIOD_2;
	end

	always
	begin
        #2;
		$display($time, "0ns: ",
			"EN=", EN,
			", x: %h(%f)", x, $itor(x*SF),
			", y: %h(%f)", y, $itor(y*SF),
			" --- >",
			" result:%h(%f)", result, $itor(result*SF));
    end
	
    initial begin
		// Initialize Inputs
		$display("[START]");
		CLK = 0;
		EN = 0;
        x = 0;
        y = 0;
        #5

        x = 32'h01_000000;  //  1.0
        y = 32'h01_000000;  //  1.0
        EN = 1;
        #1
        EN = 0;
        #5
        if (result == 32'h01_000000)
            $display("[PASS] :)");
        else
            $display("[Failed] :_)");
        
        x = 32'h01_000000;  //  1.0
        y = 32'h01_800000;  //  1.5
        EN = 1;
        #1
        EN = 0;
        #5
        if (result == 32'h01_800000)
            $display("[PASS] :)");
        else
            $display("[Failed] :_)");
        
        x = 32'h01_052318;  //  cosh(0.2)
        y = 32'h00_338ac2;  //  sinh(0.2)
        EN = 1;
        #1
        EN = 0;
        #5
        if (result == 32'h00_328731)
            $display("[PASS] :)");
        else
            $display("[Failed] :_)");
        
        x = 32'h01_052318;  //  cosh(-0.2)
        y = 32'hff_cc753e;  //  sinh(-0.2)
        EN = 1;
        #1
        EN = 0;
        #5
        if (result == 32'hff_cd78cf)
            $display("[PASS] :)");
        else
            $display("[Failed] :_)");
    end
endmodule

