function result = cordicdivide(y, x)
%   Calculation Cordic Division (y/x) Using Fixed-Point Simulation
%
%   param y: inputted number
%   type y: (floating / fixed) point
%   param x: inputted number
%   type x: (floating / fixed) point
%   return result: fixed point cordic tanh of x
IS_SIGNED = 1;
WORD_L = 32;
FLOAT_L = 24;
MAX_ITER = FLOAT_L + 1;
I = 0:MAX_ITER;
pow2_LOOKUP = fi(2.^(-I), IS_SIGNED, WORD_L, FLOAT_L);
x = fi(x, IS_SIGNED, WORD_L, FLOAT_L);
y = fi(y, IS_SIGNED, WORD_L, FLOAT_L);

%   Calculating z = y/x
z = fi(0, IS_SIGNED, WORD_L, FLOAT_L);

for i = 1:MAX_ITER
%     disp(['X:', hex(x), ' Y:', hex(y), ' Z:', hex(z), ' i=', int2str(i)]);
    d_i = -sign(y);
    y = fi(y + d_i * bitshift(x, -(i-1)), IS_SIGNED, WORD_L, FLOAT_L);
    z = fi(z - d_i * pow2_LOOKUP(i), IS_SIGNED, WORD_L, FLOAT_L);
%     disp(bin(pow2_LOOKUP(i)));
end

result = z;
end
