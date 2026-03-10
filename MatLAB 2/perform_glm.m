% A generalized linear model (GLM) is a special case of nonlinear models 
% that uses linear methods. It involves fitting a linear combination of 
% the inputs to a nonlinear function (the link function) of the outputs.
% The logistic regression model is an example of a GLM.

function [glm_model, glm_coef, glm_rs] = perform_glm(twi, slope, irrigationDensity, distancefromcanal, length)

    tbl = table(twi, slope, irrigationDensity, distancefromcanal, length, 'VariableNames', {'TWI', 'Slope', 'Irrigation Density', 'Distance from the Canal', 'Displacement Length'});
    glm_model = fitglm(tbl, "quadratic");
    glm_coef = round(glm_model.Coefficients(:, 1), 3);
    glm_rs = glm_model.Rsquared.Ordinary;

end

% To call this function:
% [glm_model_rX, glm_coef_rX, glm_rs_rX] = perform_glm(variables)