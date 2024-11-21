function qout=aux_check_cell_convert2mat(qin)

    if iscell(qin)
        try
            qout = cell2mat(qin);
            disp('Warning: Joint angles passed as cell array, converting to matrix form');
        catch
            error('Error: Cell array contents cannot be converted to a matrix');
        end
    else
        qout = qin;
    end

end