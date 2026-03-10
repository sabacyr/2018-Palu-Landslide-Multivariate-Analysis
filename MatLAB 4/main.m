clc; clear all; close all;

dataset = table2array(readtable('R1_E10 - Copy.xlsx'));
columnNames = readtable('R1_E10 - Copy.xlsx').Properties.VariableNames;

summary(array2table(dataset, 'VariableNames', columnNames));
X_all = dataset(:, [5, 8]);     % Explanatory features (TWI, S, ID, DFC)
y_all = dataset(:, 2);       % Dependent feature (LENGTH)

% Split the data into training (70%) and testing (30%) sets
rng(73073);
indices = randperm(size(dataset, 1));
X_train = X_all(indices(1:624), :);     
X_test = X_all(indices(625:end), :);
y_train = y_all(indices(1:624), :);
y_test = y_all(indices(625:end), :);

% Min and Max of dataset
twimin = 4.8028; twimax = 8.6264;
smin = 0.60832; smax = 11.882;
idmin = 0.0; idmax = 9.6258;
dfcmin = 1.2909; dfcmax = 3328.6;
lmin = 1.4151; lmax = 9.9934;

% Correlation Matrix
corr_matrix = corrcoef(dataset(:, [2, 5:8]), 'rows', 'complete');
rounded_corr_matrix = round(corr_matrix, 2);
disp('Correlation matrix of Region 1:'); disp(rounded_corr_matrix);
disp('1.0 in diagonal is the correlation of each variable with themselves');
plot_corr(dataset(:, [2, 5:8]));
figure; gplotmatrix(dataset(:, [2, 5:8]), [], [], "k", ".", [], 'on', 'none', columnNames(:, [2, 5:8]), columnNames(:, [2, 5:8]));

% Check univariate statistics of TWI, DFC, and L
figure;
subplot(1,3,1);
histogram(X_train(:,1), linspace(twimin, twimax), "FaceColor","k");
title('TWI Training Data [-]');
subplot(1,3,2);
histogram(X_train(:,2), linspace(dfcmin, dfcmax), "FaceColor","k");
title('DFC Training Data [m]');
subplot(1,3,3);
histogram(y_train, linspace(lmin, lmax), "FaceColor","k");
title('L Training Data [m]');

% Scatter plot of TWI, DFC, colored by length
figure;
scatter(X_train(:, 1), X_train(:, 2)/1000, [], y_train, 'filled');
xlabel('TWI');
ylabel('DFC');
cbar = colorbar('vertical');
cbar.Label.String = 'Displacement Length [m]';
cbar.Label.FontSize = 12;
cbar.Label.Position(1) = cbar.Label.Position(1) + 1;
cbar.Label.Rotation = 270;
cbar.Label.VerticalAlignment = 'middle';


%%
max_num_splits = 10;
min_samples_leaf = 2;

initial_tree = fitrtree(X_train, y_train, 'MaxNumSplits', max_num_splits, 'MinLeafSize', min_samples_leaf);
visualize_model(initial_tree, X_test(:, 1), min(X_test(:, 1)), max(X_test(:, 1)), X_test(:, 2), min(X_test(:, 2)), max(X_test(:, 2)), y_test, min(y_test), max(y_test));
check_model(initial_tree, X_test(:, 1), X_test(:, 2), y_test);
y_pred = predict(initial_tree, X_test);