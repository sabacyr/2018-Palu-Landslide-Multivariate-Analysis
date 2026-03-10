%% Decision Tree
% Supervised learning with numeric value. Y = f(x1, ..., xm) + e. Concept
% is further expanded via random forests, bagging and boosting to enhance
% model's performance. 

clc; clear all; close all;
%% Extracting data

%Region1 = readtable("R1_E10.xlsx"); Region3 = readtable("R3_E10.xlsx");     % Read data file

dataset1 = table2array(readtable("R1_E10_20 - Copy.xlsx")); columnNames1 = readtable("R1_E10_20 - Copy.xlsx").Properties.VariableNames;      % Turn table to array for compatibility with functions and better visualization
%dataset3 = table2array(readtable("R3_E10.xlsx")); columnNames3 = readtable("R3_E10.xlsx").Properties.VariableNames;

corr_matrix = corrcoef(dataset1(:, [2, 5:8]), 'rows', 'complete');
rounded_corr_matrix = round(corr_matrix, 2);
disp('Correlation matrix of Region 1:'); disp(rounded_corr_matrix);
disp('1.0 in diagonal is the correlation of each variable with themselves');

figure; plot_corr(dataset1(:, [2, 5:8]));
figure; gplotmatrix(dataset1(:, [2, 5:8]), [], [], "k", ".", [], 'on', 'none', columnNames1(:, [2, 5:8]), columnNames1(:, [2, 5:8]));


X_all = dataset1(:, 5:8);     % Explanatory features (TWI, S, ID, DFC)
y_all = dataset1(:, 2);       % Dependent feature (LENGTH)

rng(73073);     % Set the random seed for reproducibility. Could be any number. Change to see the effect.
indices = randperm(size(dataset1, 1));
X_train = X_all(indices(1:112), :);     % Split the data into training (0.75%) and testing (0.25) sets
X_test = X_all(indices(113:end), :);
y_train = y_all(indices(1:112), :);
y_test = y_all(indices(113:end), :);


%% Univariate statistics 
% Checking for univariate statistics of TWI, DFC and L to justify using
% machine learning algorithms to find a better model than linear models.

% Histograms
figure;
subplot(2,5,1);
histogram(X_train(:,1), linspace(min(X_train(:,1)), max(X_train(:,1))), "FaceColor","k");
title('TWI Training Data [-]');

subplot(2,5,2);
histogram(X_train(:,2), linspace(min(X_train(:,2)), max(X_train(:,2))), "FaceColor","k");
title('S Training Data [deg]');

subplot(2,5,3);
histogram(X_train(:,3), linspace(min(X_train(:,3)), max(X_train(:,3))), "FaceColor","k");
title('ID Training Data [km/km2]');

subplot(2,5,4);
histogram(X_train(:,4), linspace(min(X_train(:,4)), max(X_train(:,4))), "FaceColor","k");
title('DFC Training Data [m]');

subplot(2,5,5);
histogram(y_train, linspace(min(y_train), max(y_train)), "FaceColor","k");
title('L Training Data [m]');

subplot(2,5,6);
histogram(X_test(:,1), linspace(min(X_test(:,1)), max(X_test(:,1))), "FaceColor","k");
title('TWI Testing Data [-]');

subplot(2,5,7);
histogram(X_test(:,2), linspace(min(X_test(:,2)), max(X_test(:,2))), "FaceColor","k");
title('S Testing Data [deg]');

subplot(2,5,8);
histogram(X_test(:,3), linspace(min(X_test(:,3)), max(X_test(:,3))), "FaceColor","k");
title('ID Testing Data [km/km2]');

subplot(2,5,9);
histogram(X_test(:,4), linspace(min(X_test(:,4)), max(X_test(:,4))), "FaceColor","k");
title('DFC Testing Data [m]');

subplot(2,5,10);
histogram(y_test, linspace(min(y_test), max(y_test)), "FaceColor","k");
title('L Testing Data [m]');

sgtitle('Univariate Statistics Histograms for Region 1');

%% Creating the preliminary tree algorithm
% These parameters constrain tree complexity:
% MaxNumSplits -  number of splits that limit the depth or number of levels in the tree. 
% MinLeafSize - minimum number of data in a new region, to ensure each region has enough data to make a reasonable estimate

max_num_splits = 15;
min_leaf_size = 10; % higher stops model from overfitting

ptree = fitrtree(X_train, y_train, 'MaxNumSplits', max_num_splits,'MinLeafSize', min_leaf_size);

% Horizontal lines on the plot of estimated vs. observed are expected as 
% the regression tree estimates with the average of the data in each region
% of the feature space (terminal node).

figure;
check_model4(ptree, X_test(:, 1), X_test(:, 2), X_test(:, 3), X_test(:, 4), y_test); 
sgtitle('Preliminary Decision Tree Model Visualization');

view(ptree, 'Mode', 'graph');

%% Tuning the hyperparameters: Number of Nodes Iteration for low Square Root Error

trees = {};
error = [];
var_exp = [];
nodes = [];

inodes = 2;
while inodes < 375
    my_tree = fitrtree(X_train, y_train, 'MinLeafSize', 1, 'MaxNumSplits', inodes);
    trees = {trees, my_tree};

    predict_train = predict(my_tree, [X_test(:, 1), X_test(:, 2), X_test(:, 3), X_test(:, 4)]);
    error = [error; mean((y_test - predict_train).^2)];
    var_exp = [var_exp; 1 - var(y_test - predict_train) ./ var(y_test)];

    all_nodes = my_tree.NumNodes;
    decision_nodes = sum(~isnan(my_tree.CutPoint));
    terminal_nodes = all_nodes - decision_nodes;
    nodes = [nodes; terminal_nodes];
    
    inodes = inodes + 1;
end

figure;
scatter(nodes, error, 'red', 'filled');
tuned_nodes = nodes(find(error == min(error), 1));
hold on;
plot([tuned_nodes, tuned_nodes], [0, 10], 'r--');
text(tuned_nodes-0.75, 2.6, ['Tuned Max Nodes = ', num2str(tuned_nodes)], 'Rotation', 90);
hold off;
title('Decision Tree Cross Validation Testing Error vs. Complexity');
xlabel('Number of Terminal Nodes');
ylabel('Mean Square Error');
xlim([0, 30]);
ylim([2, 8]);


%% Tuning the hyperparameters: KFold

% modified from StackOverFlow by Dimosthenis

score = [];
node = [];

for inodes = 2:300
    KF_my_tree = fitrtree(dataset1(:, 5:8), dataset1(:, 2), 'MaxNumSplits', inodes);
    cv = cvpartition(size(dataset1, 1), 'KFold', 5);
    KF_mse_values = zeros(cv.NumTestSets, 1);
    
    for i = 1:cv.NumTestSets
        KF_X_train = dataset1(training(cv, i), 5:8);
        KF_y_train = dataset1(training(cv, i), 2);
        KF_X_test = dataset1(test(cv, i), 5:8);
        KF_y_test = dataset1(test(cv, i), 2);
        
        KF_my_tree = fitrtree(KF_X_train, KF_y_train, 'MaxNumSplits', inodes);
        KF_y_pred = predict(KF_my_tree, KF_X_test);
        KF_mse_values(i) = mean((KF_y_test - KF_y_pred).^2);
    end
    
    score = [score; mean(KF_mse_values)];
    node = [node; inodes];
end

tuned_node = node(find(score == min(score), 1));
figure;
scatter(node, score, 'red', 'filled');
hold on;
plot([tuned_node, tuned_node], [0, max(score)], 'r--');
text(tuned_node + 4, 2.5, ['Tuned Max Nodes = ', num2str(tuned_node)], 'Rotation', 90);
hold off;
title('Decision Tree k-Fold Cross Validation Error (MSE) vs. Complexity');
xlabel('Number of Terminal Nodes');
ylabel('Mean Square Error');
xlim([0, 300]);
%ylim([2, max(score)+0.2]);

%% Final decision tree algorithm

finaltree = fitrtree(X_train, y_train, 'MaxNumSplits', tuned_nodes,'MinLeafSize', min_leaf_size);

figure;
check_model4(finaltree, X_test(:, 1), X_test(:, 2), X_test(:, 3), X_test(:, 4), y_test); 
sgtitle('Final Decision Tree Model Visualization');
view(finaltree, 'Mode', 'graph');

%% Gini Importance of each feature
% Calculate feature importance using permutation method
nPredictors = size(X_train, 2);
importances = zeros(1, nPredictors);
oobLoss = loss(finaltree, X_train, y_train);
for i = 1:nPredictors
    X_permuted = X_train;
    X_permuted(:, i) = X_permuted(randperm(size(X_permuted, 1)), i);  % Randomly permute the predictor
    permutedLoss = loss(finaltree, X_permuted, y_train);
    importances(i) = oobLoss - permutedLoss;
end

% Normalize the importances to sum up to 1
importances = importances / sum(importances);

% Print feature importances
for i = 1:nPredictors
    fprintf('Feature %d importance: %f\n', i, importances(i));
end

%% Predicting features for Region 3 based on the model from Region 1

R1_X = dataset1(:, 5:8);     % Explanatory features (TWI, S, ID, DFC)
R1_y = dataset1(:, 2);       % Dependent feature (LENGTH)
R1_y_pred = predict(finaltree, R1_X);

R3_X = dataset3(:, 5:8);     % Explanatory features (TWI, S, ID, DFC)
R3_y = dataset3(:, 2);       % Dependent feature (LENGTH)
R3_y_pred = predict(finaltree, R3_X);

figure;
check_model4(finaltree, R1_X(:, 1), R1_X(:, 2), R1_X(:, 3), R1_X(:, 4), R1_y);

figure;
check_model4(finaltree, R3_X(:, 1), R3_X(:, 2), R3_X(:, 3), R3_X(:, 4), R3_y);

