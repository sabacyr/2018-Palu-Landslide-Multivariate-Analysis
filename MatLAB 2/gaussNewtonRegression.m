function [beta, converged] = gaussNewtonRegression(twi, slope, irrigation, distance, displacement, maxIterations, tolerance)
    % Inputs:
    % - twi: vector of twi values
    % - slope: vector of slope values
    % - irrigation: vector of irrigation density values
    % - distance: vector of distance from canal values
    % - displacement: vector of displacement values (dependent variable)
    % - maxIterations: maximum number of iterations allowed
    % - tolerance: convergence criterion based on the change in parameters
    
    % Initial parameter estimates
    beta = [1; 1; 1; 1; 1]; % Adjust the initial values as appropriate
    
    % Perform Gauss-Newton iterations
    for iteration = 1:maxIterations
        % Step 2: Calculate predicted values
        predicted = f(twi, slope, irrigation, distance, beta);
        
        % Step 3: Calculate residuals
        residuals = displacement - predicted;
        
        % Step 4: Calculate Jacobian matrix
        J = jacobian(twi, slope, irrigation, distance, beta);
        
        % Step 5: Update parameter estimates
        deltaBeta = pinv(J' * J) * J' * residuals;
        beta = beta + deltaBeta;
        
        % Step 6: Check convergence
        if norm(deltaBeta) < tolerance
            converged = true;
            return;
        end
    end
    
    % If maxIterations reached without convergence
    converged = false;
end
