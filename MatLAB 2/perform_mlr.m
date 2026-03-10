 % Multiple linear regression function with explanatory attributes in
 % quadratic expression. This function will round the coefficient values to
 % 0.001 precision and will store coeficients and r squared value.

function [mlr_model, mlr_coef, mlr_rs] = perform_mlr(twi, slope, irrigationDensity, distancefromcanal, length)
   
    tbl = table(twi, slope, irrigationDensity, distancefromcanal, length, 'VariableNames', {'TWI', 'Slope', 'Irrigation Density', 'Distance from the Canal', 'Displacement Length'});
    mlr_model = fitlm(tbl, 'quadratic');
    mlr_coef = round(mlr_model.Coefficients(:, 1), 3);
    mlr_rs = mlr_model.Rsquared.Ordinary;
end


% To call the function:
% [mlr_model, mlr_coef, mlr_rs] = perform_mlr(variables);