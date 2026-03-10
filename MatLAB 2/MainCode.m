clc; clear all; close all;

%% Filter Data
[filtered_data_r1, outliers_r1, data_r1] = FilterData('R1_Merge.txt');
[filtered_data_r3, outliers_r3, data_r3] = FilterData('R3_Merge.txt');

% Extract attributes from filtered datasets
attributes_r1 = Attributes(filtered_data_r1);
attributes_r3 = Attributes(filtered_data_r3);
%% Multiple Linear Regression
[mlr_model_r1, mlr_coef_r1, mlr_rs_r1] = perform_mlr(getfield(attributes_r1,"T_15"), getfield(attributes_r1,"S_15"), ...
    getfield(attributes_r1, "ID_400"), getfield(attributes_r1, "DFC"), getfield(attributes_r1, "D"));

[mlr_model_r3, mlr_coef_r3, mlr_rs_r3] = perform_mlr(getfield(attributes_r3,"T_15"), getfield(attributes_r3,"S_15"), ...
    getfield(attributes_r3, "ID_400"), getfield(attributes_r3, "DFC"), getfield(attributes_r3, "D"));

%% Generalized Linear Model (GLM)
[glm_model_r1, glm_coef_r1, glm_rs_r1] = perform_glm(getfield(attributes_r1,"T_15"), getfield(attributes_r1,"S_15"), ...
    getfield(attributes_r1, "ID_400"), getfield(attributes_r1, "DFC"), getfield(attributes_r1, "D"));

[glm_model_r3, glm_coef_r3, glm_rs_r3] = perform_glm(getfield(attributes_r3,"T_15"), getfield(attributes_r3,"S_15"), ...
    getfield(attributes_r3, "ID_400"), getfield(attributes_r3, "DFC"), getfield(attributes_r3, "D"));

%% Generalized Additive Model (GAM)
[gam_model_r1, gam_rs_r1] = perform_gam(getfield(attributes_r1,"T_15"), getfield(attributes_r1,"S_15"), ...
    getfield(attributes_r1, "ID_400"), getfield(attributes_r1, "DFC"), getfield(attributes_r1, "D"));

[gam_model_r3, gam_rs_r3] = perform_gam(getfield(attributes_r3,"T_15"), getfield(attributes_r3,"S_15"), ...
    getfield(attributes_r3, "ID_400"), getfield(attributes_r3, "DFC"), getfield(attributes_r3, "D"));

%% Gaussian Process Regression (GPR)
[gpr_model_r1, gpr_rs_r1] = perform_gpr(getfield(attributes_r1,"T_15"), getfield(attributes_r1,"S_15"), ...
    getfield(attributes_r1, "ID_400"), getfield(attributes_r1, "D"));

[gpr_model_r3, gpr_rs_r3] = perform_gpr(getfield(attributes_r3,"T_15"), getfield(attributes_r3,"S_15"), ...
    getfield(attributes_r3, "ID_400"), getfield(attributes_r3, "D"));

%% Neural Network
testData = struct('twi', getfield(attributes_r3,"T_15"), 'slope', getfield(attributes_r3,"S_15"), 'irrigationDensity', getfield(attributes_r3,"ID_400"), 'distanceFromCanal', getfield(attributes_r3, "DFC"), 'length', getfield(attributes_r3,"D"));
trainData = struct('twi', getfield(attributes_r1,"T_15"), 'slope', getfield(attributes_r1,"S_15"), 'irrigationDensity', getfield(attributes_r1,"ID_400"), 'distanceFromCanal', getfield(attributes_r1, "DFC"), 'length', getfield(attributes_r1,"D"));

[model, rSquared] = neuralNetworkModel(trainData, testData, getfield(attributes_r1,"D"));

