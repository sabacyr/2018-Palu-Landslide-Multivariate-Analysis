
%% REGION 1 
% Multiple linear regression model with explanotory attributes in quadratic
% expression.

tbl_r1 = table(twi_r1, slope_r1, irrigationDensity_r1, distancefromcanal_r1, length_r1, 'VariableNames', {'TWI', 'Slope', 'Irrigation Density', 'Distance from the Canal', 'Displacement Length'});
mlr_r1 = fitlm(tbl_r1,'quadratic'); %disp(mlr_r1);
coef_r1 = mlr_r1.Coefficients(1:i,1);
for i = 1:size(coef_r1, 1)
    for j = 1:size(coef_r3, 2)
        coef_r3(i, j) = round(coef_r3(i, j), 3);
    end
end
disp(coef_r1); disp('REGION 1: R squared'); disp(mlr_r1.Rsquared.Ordinary); %disp(mlr_r1.Formula);
figure(1) 
plot(mlr_r1); set(gca, 'FontSize', 12, 'FontName', 'Times New Roman'); title('Region 1'); 

%% REGION 3
% Multiple linear regression model with explanotory attributes in quadratic
% expression.

tbl_r3 = table(twi_r3, slope_r3, irrigationDensity_r3, distancefromcanal_r3, length_r3, 'VariableNames', {'TWI', 'Slope', 'Irrigation Density', 'Distance from the Canal', 'Displacement Length'});
mlr_r3 = fitlm(tbl_r3,'quadratic'); %disp(mlr_r3);
coef_r3 = mlr_r3.Coefficients(1:i,1);
for i = 1:size(coef_r3, 1)
    for j = 1:size(coef_r3, 2)
        coef_r3(i, j) = round(coef_r3(i, j), 3);
    end
end
disp(coef_r3); disp('REGION 3: R squared'); disp(mlr_r3.Rsquared.Ordinary); %disp(mlr_r3.Formula);
figure (2)
plot(mlr_r3); set(gca, 'FontSize', 12, 'FontName', 'Times New Roman'); title('Region 3');
