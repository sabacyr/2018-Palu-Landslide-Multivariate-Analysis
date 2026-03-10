clc; clear all; close all;

%% Extract Data from Table

data_r1 = dlmread('R1_Merge.txt', ',', 1, 0);
data_r3 = dlmread('R3_Merge.txt', ',', 1, 0);

length_r1 = (data_r1(1:1220, 2))./1000;
slope_r1 = (data_r1(1:1220,8));
twi_r1 = (data_r1(1:1220, 4));
irrigationDensity_r1 = (data_r1(1:1220, 14));
distancefromcanal_r1 = (data_r1(1:1220, 17))./1000;

length_r3 = (data_r3(1:769, 2))./1000;
slope_r3 = (data_r3(1:769,8));
twi_r3 = (data_r3(1:769, 4));
irrigationDensity_r3 = (data_r3(1:769, 14));
distancefromcanal_r3 = (data_r3(1:769, 17))./1000;


%% Scatter3 Plot Region 1

figure(1)
scatter3(irrigationDensity_r1, distancefromcanal_r1, length_r1, 50, twi_r1, 'filled'); 
% Change the size of the markers to 50 and use distancefromcanal_r1 as the color data
xlabel('ID [km/km^2]');
ylabel('TWI [-]');
zlabel('Displacement [km] ');
axis ([0 10 0 10 0 0.05]);
c = colorbar; % Add colorbar to show the mapping of colors to distances from the canal
colormap("jet");
c.Label.String = 'Distance From Canal [km]';
title('Region 1 Scatter Plot');
set(gca,'FontSize',12);
view(45, 30);

disp('TWI: 3.9819 - 9.4140, ID: 0 - 10.7069, Displacement: 0 - 1.2326');

%% Scatter3 Plot Region 3

figure(2)
scatter3(irrigationDensity_r3, twi_r3, length_r3, 50, distancefromcanal_r3, 'filled');
% Change the size of the markers to 50 and use distancefromcanal_r3 as the color data
xlabel('ID [km/km^2]');
ylabel('TWI');
zlabel('Displacement [km] ');
axis ([0 10 0 10 0 0.05]);
c = colorbar ; % Add colorbar to show the mapping of colors to distances from the canal
colormap("jet");
c.Label.String = 'Distance From Canal [km]';
title('Region 3 Scatter Plot');
set(gca,'FontSize',12);
view(45, 30);

disp('TWI: 4.4108 - 9.2450, ID: 0 - 7.9448, Displacement: 0 - 0.1335');

%% Multiple Linear Regression
% Model the relationship between multiple independent variables 
% (also known as explanatory variables or features) and a dependent variable

X_r1 = [twi_r1, slope_r1, irrigationDensity_r1, distancefromcanal_r1];
X_r3 = [twi_r3, slope_r3, irrigationDensity_r3, distancefromcanal_r3];

Y_r1 = length_r1;
Y_r3 = length_r3;

mdl_r1 = fitlm(X_r1, Y_r1);
mdl_r3 = fitlm(X_r3, Y_r3);

disp('Region 1 Coefficients:');
disp(mdl_r1.Coefficients);
disp('Length = 0.025061 - 0.0011768 * TWI + 0.0012255 * Slope + 0.00046755 * Irrigation Density - 0.0084318 * Distance from Canal');

disp('Region 3 Coefficients:');
disp(mdl_r3.Coefficients);
disp('Length = 0.0023408 + 0.0003266 * TWI + 0.00021876 * Slope - 0.00025082 * Irrigation Density - 0.00090899 * Distance from Canal');

disp('Region 1 R-squared:');
disp(mdl_r1.Rsquared.Ordinary);
disp('Region 3 R-squared:');
disp(mdl_r3.Rsquared.Ordinary);
%% Support Vector Regression (SVR)

% The SVR model uses support vectors and a non-linear kernel function to capture complex relationships between variables. 
% The coefficients do not have direct interpretations as in linear regression. 
% Instead of displaying coefficients, SVR focuses on support vectors and the parameters of the model. 
% The support vectors are the data points that have the most influence on the model's prediction.

% Create the SVR model
svr_r1 = fitrsvm(X_r1, Y_r1);
svr_r3 = fitrsvm(X_r3, Y_r3);

% Display the coefficient estimates for each explanatory variable
disp('Region 1 Coefficients (SVR):');
disp(svr_r1.Beta);
disp('Region 3 Coefficients (SVR):');
disp(svr_r3.Beta);

% Calculate and display the R-squared values
Y_pred_r1 = predict(svr_r1, X_r1);
r_squared_r1 = 1 - sum((Y_r1 - Y_pred_r1).^2) / sum((Y_r1 - mean(Y_r1)).^2);
disp('Region 1 R-squared (SVR):');
disp(r_squared_r1);

Y_pred_r3 = predict(svr_r3, X_r3);
r_squared_r3 = 1 - sum((Y_r3 - Y_pred_r3).^2) / sum((Y_r3 - mean(Y_r3)).^2);
disp('Region 3 R-squared (SVR):');
disp(r_squared_r3);


%% Polynomial Regression Degree 2

% A variation of linear regression where the relationship between the independent variable(s) 
% and the dependent variable is modeled as an nth-degree polynomial function. 
% This allows for a more flexible modeling of non-linear relationships between the variables.
% Y = β0 + β1 * X1 + β2 * X2 + β3 * X3 + β4 * X4 
% + β5 * X1^2 + β6 * X2^2 + β7 * X3^2 + β8 * X4^2 
% + β9 * X1X2 + β10 * X1X3 + β11 * X1X4 + β12 * X2X3 + β13 * X2X4 + β14 * X3X4 
% + ε

degree = 2;

X_poly_r1 = zeros(size(X_r1, 1), size(X_r1, 2) * degree);
X_poly_r3 = zeros(size(X_r3, 1), size(X_r3, 2) * degree);

for i = 1:size(X_r1, 2)
    for j = 1:degree
        X_poly_r1(:, (i-1)*degree + j) = X_r1(:, i).^j;
        X_poly_r3(:, (i-1)*degree + j) = X_r3(:, i).^j;
    end
end

poly_r1 = fitlm(X_poly_r1, Y_r1);
poly_r3 = fitlm(X_poly_r3, Y_r3);

% Display the coefficient estimates for each explanatory variable
disp('Region 1 Coefficients (Polynomial Regression):');
disp(poly_r1.Coefficients);
disp('Region 3 Coefficients (Polynomial Regression):');
disp(poly_r3.Coefficients);

% Calculate and display the R-squared values
Y_pred_r1 = predict(poly_r1, X_poly_r1);
r_squared_r1 = 1 - sum((Y_r1 - Y_pred_r1).^2) / sum((Y_r1 - mean(Y_r1)).^2);
disp('Region 1 R-squared (Polynomial Regression):');
disp(r_squared_r1);

Y_pred_r3 = predict(poly_r3, X_poly_r3);
r_squared_r3 = 1 - sum((Y_r3 - Y_pred_r3).^2) / sum((Y_r3 - mean(Y_r3)).^2);
disp('Region 3 R-squared (Polynomial Regression):');
disp(r_squared_r3);

%% Gaussian Process Regression (BEST RESULT FOR REGION 3)

% Non-parametric probabilistic regression technique that uses Gaussian processes to model 
% the relationship between variables. 
% It is a powerful method for modeling complex and non-linear relationships between variables.
% In GPR, the goal is to estimate a function that maps input variables (X) to output variables (Y). 
% Instead of assuming a specific functional form for the relationship, GPR models the relationship 
% as a Gaussian process. A Gaussian process is defined by a mean function and a covariance function, 
% which capture the prior beliefs about the smoothness and variability of the function.

gpr_r1 = fitrgp(X_r1, Y_r1);

Y_pred_r1 = predict(gpr_r1, X_r1);

r_squared_r1 = 1 - sum((Y_r1 - Y_pred_r1).^2) / sum((Y_r1 - mean(Y_r1)).^2);
disp('Region 1 R-squared (GPR):');
disp(r_squared_r1);

gpr_r3 = fitrgp(X_r3, Y_r3);

Y_pred_r3 = predict(gpr_r3, X_r3);

r_squared_r3 = 1 - sum((Y_r3 - Y_pred_r3).^2) / sum((Y_r3 - mean(Y_r3)).^2);
disp('Region 3 R-squared (GPR):');
disp(r_squared_r3);

% Display the mean and covariance function of the GPR model
disp('Mean Function GPR (Region 1):');
disp(gpr_r1.KernelInformation.KernelParameters(end));

disp('Covariance Function GPR (Region 1):');
disp(gpr_r1.KernelInformation.KernelParameters(1:end-1));

disp('Mean Function GPR (Region 3):');
disp(gpr_r3.KernelInformation.KernelParameters(end));

disp('Covariance Function GPR (Region 3):');
disp(gpr_r3.KernelInformation.KernelParameters(1:end-1));

%disp(['On average, the predicted displacement in Region 1 is expected to be around 34.4 m.' ...
    %'The covariance function value of 1.9855 indicates a relatively more uncertain prediction in region 1.']);

%disp(['On average, the predicted displacement in Region 3 is expected to be around 7.7 m.' ...
   % 'The covariance function value of 0.3390 indicates a relatively certain prediction in this region 3.']);


%Plot actual vs predicted values
figure(3);
scatter(Y_r1, Y_pred_r1, 'b', 's');
xlabel('Actual Displacement [km]');
ylabel('Predicted Displacement [km]');
title('Actual vs Predicted Values (Region 1)');
axis ([0 0.2 0 0.2]);
hold on;
%figure(4);
scatter(Y_r3, Y_pred_r3, 'r', 'o');
xlabel('Actual Displacement [km]');
ylabel('Predicted Displacement [km]');
title('Actual vs Predicted Values');
legend('Region 1', 'Region 3');

% Scatter plot for individual input variable in Region 1
%figure(5);
%scatter(X_r1(:, 1), Y_r1, 'filled');
%xlabel('TWI [-]');
%ylabel('Displacement [km]');
%title('Scatter Plot: TWI vs Displacement (Region 1)');

% Scatter plot for individual input variable in Region 3
%figure(6);
%scatter(X_r3(:, 1), Y_r3, 'filled');
%xlabel('TWI [-]');
%ylabel('Displacement [km]');
%title('Scatter Plot: TWI vs Displacement (Region 3)');


