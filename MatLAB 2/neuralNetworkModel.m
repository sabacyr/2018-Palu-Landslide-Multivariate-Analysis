function [model, rSquared] = neuralNetworkModel(trainData, testData, length)
    % Extract the input variables and target variable from the training data
    twi_train = trainData.twi;
    slope_train = trainData.slope;
    irrigationDensity_train = trainData.irrigationDensity;
    distanceFromCanal_train = trainData.distanceFromCanal;
    length_train = trainData.length;

    % Extract the input variables and target variable from the testing data
    twi_test = testData.twi;
    slope_test = testData.slope;
    irrigationDensity_test = testData.irrigationDensity;
    distanceFromCanal_test = testData.distanceFromCanal;
    length_test = testData.length;

    % Combine the input variables into matrices for training and testing
    Xtrain = [twi_train, slope_train, irrigationDensity_train, distanceFromCanal_train];
    Xtest = [twi_test, slope_test, irrigationDensity_test, distanceFromCanal_test];

    % Normalize the input variables to improve training performance
    Xnorm_train = normalize(Xtrain);
    Xnorm_test = normalize(Xtest);

    % Normalize the target variable and store the normalization parameters
    [Ynorm_train, Ymean, Ystd] = normalize(length_train);

    % Normalize the target variable for testing data
    Ynorm_test = (length_test - Ymean) / Ystd;

    % Create a neural network with reduced complexity and regularization
    hiddenLayerSize = 10;
    lambda = 0.01;
    net = fitrnet(Xnorm_train, Ynorm_train, 'LayerSizes', hiddenLayerSize, 'Lambda', lambda);

    % Predict the target variable for the training and testing data
    YtrainPredicted = predict(net, Xnorm_train);
    YtestPredicted = predict(net, Xnorm_test);

    % Denormalize the predicted target variable
    YtrainPredicted = YtrainPredicted * Ystd + Ymean;
    YtestPredicted = YtestPredicted * Ystd + Ymean;

    % Calculate the R-squared value for training and testing data
    rSquaredTrain = 1 - sum((length_train - YtrainPredicted).^2) / sum((length_train - mean(length_train)).^2);
    rSquaredTest = 1 - sum((length_test - YtestPredicted).^2) / sum((length_test - mean(length_test)).^2);

    % Plot the predicted length over the observed length for training data
    figure;
    plot(length_train, YtrainPredicted, 'bo');
    hold on;
    plot(min(length_train), max(length_train), 'r--');
    hold off;
    xlabel('Observed Length');
    ylabel('Predicted Length');
    title('Predicted Length vs Observed Length (Training Data)');

    % Plot the predicted length over the observed length for testing data
    figure;
    plot(length_test, YtestPredicted, 'bo');
    hold on;
    plot(min(length_test), max(length_test), 'r--');
    hold off;
    xlabel('Observed Length');
    ylabel('Predicted Length');
    title('Predicted Length vs Observed Length (Testing Data)');

    % Return the trained model and R-squared values
    model = net;
    rSquared.train = rSquaredTrain;
    rSquared.test = rSquaredTest;
end
