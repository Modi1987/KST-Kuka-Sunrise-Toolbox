function normalizedT = normalizeColumns(T)
    r = zeros(4, 3);
    for j = 1:3
        r(1:3, j) = T(1:3, j) / norm(T(1:3, j));
    end
    normalizedT = [r, T(:, 4)];
end