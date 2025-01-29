function y = aux_ensure_a_column_vector(x)
    y = aux_check_cell_convert2mat(x);
    y = aux_to_column_vector(y);
end
