module atanh_LOOKUP(index, value);
    localparam FLOAT_SIZE = 24;
    localparam INT_SIZE = 8;

    input wire signed [4:0] index;
    output reg signed [INT_SIZE-1:-FLOAT_SIZE] value;

    always @(index)
    begin
        case (index)
            -3: value = 32'h02_12523d;  //  atanh(1-2^(-5))
            -2: value = 32'h01_b78ce5;  //  atanh(1-2^(-4))
            -1: value = 32'h01_5aa164;  //  atanh(1-2^(-3))
            0:  value = 32'h00_f91395;  //  atanh(1-2^(-2))
            1:  value = 32'h00_8c9f54;  //  atanh(2^(-1))
            2:  value = 32'h00_4162bc;  //  atanh(2^(-2))
            3:  value = 32'h00_202b12;  //  atanh(2^(-3))
            4:  value = 32'h00_100559;  //  atanh(2^(-4))
            5:  value = 32'h00_0800ab;  //  atanh(2^(-5))
            6:  value = 32'h00_040015;  //  atanh(2^(-6))
            7:  value = 32'h00_020003;  //  atanh(2^(-7))
            8:  value = 32'h00_010000;  //  atanh(2^(-8))
            9:  value = 32'h00_008000;  //  atanh(2^(-9))
            10: value = 32'h00_004000;  //  atanh(2^(-10))
            11: value = 32'h00_002000;  //  atanh(2^(-11))
            12: value = 32'h00_001000;  //  atanh(2^(-12))
            13: value = 32'h00_000800;  //  atanh(2^(-13))
            default: 
                value = 32'h00_000000;
        endcase
    end
endmodule
