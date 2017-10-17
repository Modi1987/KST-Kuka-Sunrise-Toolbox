function [ y ] = columnVec( x )
% Used to convert a vector into a column vector
if size(x,2)==1
    y=x;
else
    y=x';
end


end

