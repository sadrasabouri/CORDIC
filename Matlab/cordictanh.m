function result = cordictanh(z)
%   Calculation Cordic Tanh Using Fixed-Point Simulation
%
%   param z: inputted number
%   type z: (floating / fixed) point
%   return result: fixed point cordic tanh of z
IS_SIGNED = 1;
WORD_L = 32;
FLOAT_L = 24;


%   Calculating sinh and cosh
%   x_n = A_n(x_0 * cosh(z_0) + y_0 * sinh(z_0))
%   y_n = A_n(y_0 * cosh(z_0) + x_0 * sinh(z_0))
y = fi(0, IS_SIGNED, WORD_L, FLOAT_L);
x = fi(1, IS_SIGNED, WORD_L, FLOAT_L);
z = fi(z, IS_SIGNED, WORD_L, FLOAT_L);
%   x_n = A_n(x_0 * cosh(z_0))
%   y_n = A_n(x_0 * sinh(z_0))
%   [tanh = y_n / x_n]

%   for i <= 0:
M = 3;
I = -M:0;
atanh_LOOKUP = fi(atanh(1 - 2.^(I-2)), IS_SIGNED, WORD_L, FLOAT_L);
hex(atanh_LOOKUP)
for i = I
%     disp(['X:', hex(x), ' Y:', hex(y), ' Z:', hex(z), ' i=', int2str(i)]);
    if abs(z) == fi(0, 1, WORD_L, FLOAT_L)
        break
    end
    
    d_i = fi(sign(z), IS_SIGNED, WORD_L, FLOAT_L);
    x_old = x;
    y_old = y;
    x = fi(x_old + d_i * y_old - d_i * bitshift(y_old, i - 2), ...
            IS_SIGNED, WORD_L, FLOAT_L);
    y = fi(y_old + d_i * x_old - d_i * bitshift(x_old, i - 2), ...
            IS_SIGNED, WORD_L, FLOAT_L);
    z = fi(z - d_i * atanh_LOOKUP(M + i + 1), ...
            IS_SIGNED, WORD_L, FLOAT_L);
end


%   for i > 0:
N = 13;
I = 1:N;
atanh_LOOKUP = fi(atanh(2.^(-I)), IS_SIGNED, WORD_L, FLOAT_L);
hex(atanh_LOOKUP)
for i = I
    if abs(z) == fi(0, 1, WORD_L, FLOAT_L)
        
        break
    end
%     disp(['X:', hex(x), ' Y:', hex(y), ' Z:', hex(z), ' i=', int2str(i)]);
    
    d_i = fi(sign(z), IS_SIGNED, WORD_L, FLOAT_L);
    x_old = fi(x, IS_SIGNED, WORD_L, FLOAT_L);
    y_old = fi(y, IS_SIGNED, WORD_L, FLOAT_L);
    x = fi(x_old + d_i * bitshift(y_old, -i), IS_SIGNED, WORD_L, FLOAT_L);
    y = fi(y_old + d_i * bitshift(x_old, -i), IS_SIGNED, WORD_L, FLOAT_L);
    z = fi(z - d_i * atanh_LOOKUP(i), IS_SIGNED, WORD_L, FLOAT_L);
    if i == 13 || i == 4  %   Repeat Condition (3k + 1)
%         disp(['X:', hex(x), ' Y:', hex(y), ' Z:', hex(z), ' i=', int2str(i)]);
        x_old = fi(x, IS_SIGNED, WORD_L, FLOAT_L);
        y_old = fi(y, IS_SIGNED, WORD_L, FLOAT_L);
        d_i = fi(sign(z), IS_SIGNED, WORD_L, FLOAT_L);
        x = fi(x_old + d_i * bitshift(y_old, -i), IS_SIGNED, WORD_L, FLOAT_L);
        y = fi(y_old + d_i * bitshift(x_old, -i), IS_SIGNED, WORD_L, FLOAT_L);
        z = fi(z - d_i * atanh_LOOKUP(i), IS_SIGNED, WORD_L, FLOAT_L);
    end
end
% disp(['X:', hex(x), ' Y:', hex(y), ' Z:', hex(z), ' i=', int2str(i)]);
% display('CORDID_DIV:');
result = cordicdivide(y, x);
end
