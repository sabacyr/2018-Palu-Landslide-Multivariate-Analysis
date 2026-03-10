function J = jacobian(twi, slope, irrigation, distance, beta)

    n = length(twi);
    J = zeros(n, 4);
    
    J(:, 1) = twi;
    J(:, 2) = slope;
    J(:, 3) = irrigation;
    J(:, 4) = distance;
    
end