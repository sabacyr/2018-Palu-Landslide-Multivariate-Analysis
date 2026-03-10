%Function to filter and delete all data points that their
%displacement length is more than 10 m. Report them as original data_rX, outliers_rX and create
%a new dataset without considering these points called filtered_data_rX.

function [filtered_data, outliers, data] = FilterData(filename)
    
    data = dlmread(filename, ',', 1, 0);
    numRows = size(data, 1);
    filtered_data = [];
    outliers = [];

    for i = 1:numRows
        if data(i, 2) <= 10 && data(i, 2) >= 1
            filtered_data = [filtered_data; data(i, :)];
        else
            outliers = [outliers; data(i, :)];
        end
    end
end


% To call the function:
% [filtered_data_rX, outliers_rX, data_rX] = FilterData('XXXX.txt')