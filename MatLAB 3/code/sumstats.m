% Displays the summary of the statistics of the dataset in Command Window
function stats = sumstats(dataset)
    
    [mean, std, var, min, max] = grpstats(dataset, [], ["mean", "std", "var", "min", "max"]); 
    stats = [mean, std, var, min, max];
    headers = ["Mean", "Standard Deviation", "Variance", "Minimum", "Maximum"];
    
    num_elements = size(stats, 2);
    if num_elements > 5
        f_column = stats(:, 1:2:end);
        s_column = stats(:, 2:2:end);
        f_column = [headers; f_column];
        s_column = [headers; s_column];
        f_column = array2table(f_column);
        s_column = array2table(s_column);
        %disp(f_column);
        %disp(s_column);        
    else
        f_column = stats;
        f_column = [headers; f_column];
        f_column = array2table(f_column);
        %disp(f_column);
    end

end
