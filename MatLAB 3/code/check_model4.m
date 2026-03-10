% Plots the estimated vs. the actual 

function check_model4(model, exp1, exp2, exp3, exp4, response)
    predict_train = model.predict([exp1, exp2, exp3, exp4]);
    scatter(response, predict_train, 'filled', 'red');
    %title(title);
    xlabel('Observed Displacement Length [m]');
    ylabel('Estimated Displacement Length [m]');
    xlim([0 max(response)+5]);
    ylim([0 max(predict_train)+5]);
    line([0, max(response)+5], [0, max(response)+5], 'Color', 'k', 'LineWidth', 2);
    MSE = mean((response - predict_train).^2);
    cor = sqrt(corr(response, predict_train));
    fprintf('Mean Squared Error = %.2f, Correlation Coefficient = %.2f\n', MSE, cor);
end