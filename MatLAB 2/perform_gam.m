% Generalized Additive Model models explain a response variable using a 
% sum of univariate and bivariate shape functions of predictors. They use
% a boosted tree as a shape function for each predictor and, optionally, 
% each pair of predictors; therefore, the function can capture a nonlinear 
% relation between a predictor and the response variable. Because 
% contributions of individual shape functions to the prediction (response 
% value) are well separated, the model is easy to interpret.

function [gam_model, gam_rs] = perform_gam(twi, slope, irrigationDensity, distancefromcanal, length)
    
    cvp = cvpartition(size(length, 1), 'HoldOut', 0.3);
    trainIdx = training(cvp);
    testIdx = test(cvp);
    
    trainTbl = table(twi(trainIdx), slope(trainIdx), irrigationDensity(trainIdx), distancefromcanal(trainIdx), length(trainIdx), 'VariableNames', {'TWI', 'Slope', 'IrrigationDensity', 'DistanceFromCanal', 'DisplacementLength'});
    testTbl = table(twi(testIdx), slope(testIdx), irrigationDensity(testIdx), distancefromcanal(testIdx), length(testIdx), 'VariableNames', {'TWI', 'Slope', 'IrrigationDensity', 'DistanceFromCanal', 'DisplacementLength'});
    
    gam_model = fitrgam(trainTbl, 'DisplacementLength ~ TWI + Slope + IrrigationDensity + DistanceFromCanal');
    %gam_coef = gam_model.Coefficients;

    predictedLength = predict(gam_model, testTbl);
    gam_rs = 1 - sum((length(testIdx) - predictedLength).^2) / sum((length(testIdx) - mean(length(testIdx))).^2);
    
    % Plot predicted vs observed displacement lengths
    figure (1)
    scatter(length(testIdx), predictedLength);
    xlabel('Observed Displacement Length');
    ylabel('Predicted Displacement Length');
    title('Predicted vs Observed Displacement Length');

    % Plot partial dependence of each predictor
    figure (2);
    subplot(2, 2, 1);
    plotPartialDependence(gam_model, 'TWI');
    xlabel('TWI');
    ylabel('Partial Dependence');
    title('Partial Dependence of Displacement Length on TWI');
    
    subplot(2, 2, 2);
    plotPartialDependence(gam_model, 'Slope');
    xlabel('Slope');
    ylabel('Partial Dependence');
    title('Partial Dependence of Displacement Length on Slope');
    
    subplot(2, 2, 3);
    plotPartialDependence(gam_model, 'IrrigationDensity');
    xlabel('Irrigation Density');
    ylabel('Partial Dependence');
    title('Partial Dependence of Displacement Length on Irrigation Density');
    
    subplot(2, 2, 4);
    plotPartialDependence(gam_model, 'DistanceFromCanal');
    xlabel('Distance from Canal');
    ylabel('Partial Dependence');
    title('Partial Dependence of Displacement Length on Distance from Canal');
end

