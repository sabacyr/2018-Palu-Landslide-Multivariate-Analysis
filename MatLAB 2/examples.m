% Sample data
data = [12, 5, 8, 7, 10];

% Rank transformation using tiedrank
ranked_data = tiedrank(data);

% Display the original data and the ranked data
disp('Original Data:');
disp(data);
disp('Ranked Data:');
disp(ranked_data);

% Read the CSV file
data = readtable('R3_Merge.txt');

% Write the data to an Excel file
writetable(data, 'R3_Merge.xlsx');

%%

corrplot(data1);
%%
x = [data1.TWI_15, data1.Slope_15, data1.Irrigation_Density_400, data1.NEAR_FID];
y = [data1.Length];
[mlr_model] = mlr(x, y);