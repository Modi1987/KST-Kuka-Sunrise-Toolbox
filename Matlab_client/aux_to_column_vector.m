function y=aux_to_column_vector(x)
    if(size(x,2)==1)
        y=x;
    else
        y=x';
    end
end
