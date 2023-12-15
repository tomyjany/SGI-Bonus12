function g = sigmoid_cycles(z)
%SIGMOID Pocita sigmoid funkci pro z, z je skalar nebo matice

% Je treba vratit promennou g

% ========================== VÁŠ KÓD ZDE ======================
for i=1:size(z,1)
    for j=1:size(z,2)
        g(i,j)=1/(1+exp(-z(i,j)));

    end
end
% =============================================================

end
