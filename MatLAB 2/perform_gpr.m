% Gaussian Process Regression models are nonparametric machine learning models that are used for 
% predicting the value of a continuous response variable. The response 
% variable is modeled as a Gaussian process, using covariances with the 
% input variables. These models are widely used in the field of spatial 
% analysis for interpolation in the presence of uncertainty. GPR is also
% referred to as Kriging.

function [gpr_model, gpr_rs] = perform_gpr(twi, slope, irrigationDensity, displacementLength)
    
% Partition the data into training and testing sets
    cvp = cvpartition(size(displacementLength, 1), 'HoldOut', 0.3);
    trainIdx = training(cvp);
    testIdx = test(cvp);
    
    X_train = [twi(trainIdx), slope(trainIdx), irrigationDensity(trainIdx)];
    y_train = displacementLength(trainIdx);
    X_test = [twi(testIdx), slope(testIdx), irrigationDensity(testIdx)];
    y_test = displacementLength(testIdx);
    
    % Fit the Gaussian Process Regression model using training data
    gpr_model = fitrgp(X_train, y_train, 'KernelFunction', 'squaredexponential');
    
    % Predict displacement lengths for testing data
    y_predict = predict(gpr_model, X_test);
    
    % Compute the R-squared value using testing data
    SS_res = sum((y_test - y_predict).^2);
    SS_tot = sum((y_test - mean(y_test)).^2);
    gpr_rs = 1 - SS_res / SS_tot;
    
    % Plot predicted displacement lengths over observed displacement lengths
    figure;
    scatter(y_test, y_predict, 'filled');
    hold on;
    plot([min(y_test), max(y_test)], [min(y_test), max(y_test)], 'r--');
    xlabel('Observed Displacement Length');
    ylabel('Predicted Displacement Length');
    title('Gaussian Process Regression: Observed vs. Predicted Displacement Length');
    legend('Predictions', 'Ideal');

     % Specify the range of values for each explanatory attribute
    range_twi = linspace(min(X_test(:, 1)), max(X_test(:, 1)), 100); % Range for TWI
    range_slope = linspace(min(X_test(:, 2)), max(X_test(:, 2)), 100); % Range for Slope
    range_irrigationDensity = linspace(min(X_test(:, 3)), max(X_test(:, 3)), 100); % Range for Irrigation Density

    % Compute the predicted displacement lengths for the range of attribute values
    Y_pred_twi = predict(gpr_model, [range_twi(:), repmat(mean(X_test(:, 2:end), 1), numel(range_twi), 1)]);
    Y_pred_slope = predict(gpr_model, [repmat(mean(X_test(:, 1), 1), numel(range_slope), 1), range_slope(:), repmat(mean(X_test(:, 3:end), 1), numel(range_slope), 1)]);
    Y_pred_irrigationDensity = predict(gpr_model, [repmat(mean(X_test(:, 1:2), 1), numel(range_irrigationDensity), 1), range_irrigationDensity(:), repmat(mean(X_test(:, 4:end), 1), numel(range_irrigationDensity), 1)]);
    
    % Plot the partial dependence
    figure;
    subplot(2, 2, 1);
    plot(range_twi, Y_pred_twi, 'LineWidth', 1.5);
    xlabel('TWI');
    ylabel('Predicted Displacement Length');
    title('Partial Dependence of TWI');
    
    subplot(2, 2, 2);
    plot(range_slope, Y_pred_slope, 'LineWidth', 1.5);
    xlabel('Slope');
    ylabel('Predicted Displacement Length');
    title('Partial Dependence of Slope');
    
    subplot(2, 2, 3);
    plot(range_irrigationDensity, Y_pred_irrigationDensity, 'LineWidth', 1.5);
    xlabel('Irrigation Density');
    ylabel('Predicted Displacement Length');
    title('Partial Dependence of Irrigation Density');
    
    sgtitle('Partial Dependence Plots');



end
