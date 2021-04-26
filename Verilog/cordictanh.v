module cordictanh(CLK, EN, z, out);
    parameter FLOAT_SIZE = 24;
    parameter INT_SIZE = 8;

    input wire CLK;
    input wire EN;
    input wire signed [INT_SIZE-1:-FLOAT_SIZE] z;
    output wire signed [INT_SIZE-1:-FLOAT_SIZE] out;

    parameter MAX_ITERATION_DIV = 31;
    reg signed [INT_SIZE-1:-FLOAT_SIZE] x_;
    reg signed [INT_SIZE-1:-FLOAT_SIZE] y_;
    reg signed [INT_SIZE-1:-FLOAT_SIZE] z_;
    reg signed [4:0] i;
    wire signed [INT_SIZE-1:-FLOAT_SIZE] Z_UPDATE;
    atanh_LOOKUP LOOKUP(
        .index(i),
        .value(Z_UPDATE));
    reg div_en;
    reg IS_FIRST4;
    reg IS_FIRST13;
    reg IS_Z_ZERO;

    always @(posedge CLK)
    begin
        if (EN) //  Like Reset
        begin
            x_ <= 32'h01_000000;
            y_ <= 32'h00_000000;
            z_ <= z;
            i <= -3;
            div_en <= 1'b0;
            IS_FIRST4 <= 1'b1;
            IS_FIRST13 <= 1'b1;
            IS_Z_ZERO <= 1'b0;
        end
        else
        begin
            if (|z_)    //  z not zero
            begin
                z_ <= z_[INT_SIZE-1] ? z_ + Z_UPDATE : z_ - Z_UPDATE;
            
                if (i < 1)
                begin
                    x_ <= z_[INT_SIZE-1] ? x_ - y_ + (y_ >>> -(i-2)) : x_ + y_ - (y_ >>> -(i-2));
                    y_ <= z_[INT_SIZE-1] ? y_ - x_ + (x_ >>> -(i-2)) : y_ + x_ - (x_ >>> -(i-2));
                    i <= i + 1;
                end
                else if (i == 4)
                begin
                    x_ <= z_[INT_SIZE-1] ? x_ - (y_ >>> i) : x_ + (y_ >>> i);
                    y_ <= z_[INT_SIZE-1] ? y_ - (x_ >>> i) : y_ + (x_ >>> i);
                    if (IS_FIRST4)  IS_FIRST4 <= 1'b0;
                    else            i <= i + 1; 
                end
                else if (i == 13)
                begin
                    x_ <= z_[INT_SIZE-1] ? x_ - (y_ >>> i) : x_ + (y_ >>> i);
                    y_ <= z_[INT_SIZE-1] ? y_ - (x_ >>> i) : y_ + (x_ >>> i);
                    if (IS_FIRST13)  IS_FIRST13 <= 1'b0;
                    else            i <= i + 1;     
                end
                else if (i < 14)
                begin
                    x_ <= z_[INT_SIZE-1] ? x_ - (y_ >>> i) : x_ + (y_ >>> i);
                    y_ <= z_[INT_SIZE-1] ? y_ - (x_ >>> i) : y_ + (x_ >>> i);
                    i <= i + 1;
                end
                else if (i == 14)
                begin
                    div_en <= 1'b1;
                    i <= i + 1;
                end
                else
                begin
                    div_en <= 1'b0;
                    i <= i;
                end
            end
            else
            begin
                if (IS_Z_ZERO)
                    div_en <= 1'b0;
                else
                begin
                    IS_Z_ZERO <= 1'b1;
                    div_en <= 1'b1;
                end
                     
            end
        end
    end

    cordicdiv divider(
        .CLK(CLK),
        .EN(div_en),
        .y(y_),
        .x(x_),
        .out(out)
    );
endmodule
