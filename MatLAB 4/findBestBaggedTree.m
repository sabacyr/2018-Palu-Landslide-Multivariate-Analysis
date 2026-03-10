function bestBaggedTree = findBestBaggedTree(X_train, y_train, numTrees, min_samples_leaf)
    % Set the number of random seeds
    numSeeds = 10;
    maxCorr = 0;
    bestBaggedTree = [];

    for seed = 1:numSeeds
        % Set the random seed
        rng(seed);
        
        % Create a bagging ensemble with the decision tree as the base learner
        baggedTree = TreeBagger(numTrees, X_train, y_train, 'Method', 'regression', 'MinLeafSize', min_samples_leaf);

        % Calculate the correlation coefficient between predicted and actual values
        y_pred = predict(baggedTree, X_train);
        corr_coeff = corr(y_pred, y_train);
        
        % Update the best model if the correlation coefficient is higher
        if corr_coeff > maxCorr
            maxCorr = corr_coeff;
            bestBaggedTree = baggedTree;
        end
    end
end
