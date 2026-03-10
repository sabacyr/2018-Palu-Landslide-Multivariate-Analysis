%This function extracts all available attributes from the input data. (15
%Variables)

function attributes = Attributes(filtered_data)
    D = filtered_data(:, 2);
    T = filtered_data(:, 3);
    T_5 = filtered_data(:, 4);
    T_10 = filtered_data(:, 5);
    T_15 = filtered_data(:, 6);
    S = filtered_data(:, 7);
    S_5 = filtered_data(:, 8);
    S_10 = filtered_data(:, 9);
    S_15 = filtered_data(:, 10);
    ID_100 = filtered_data(:, 11);
    ID_200 = filtered_data(:, 12);
    ID_300 = filtered_data(:, 13);
    ID_400 = filtered_data(:, 14);
    DFC = filtered_data(:, 17);

    attributes = struct('D', D, 'T', T, 'T_5', T_5, 'T_10', T_10, 'T_15', T_15, ...
        'S', S, 'S_5', S_5, 'S_10', S_10, 'S_15', S_15, ...
        'ID_100', ID_100, 'ID_200', ID_200, 'ID_300', ID_300, 'ID_400', ID_400, 'DFC', DFC);
end

% To call this function:
% attributes_rX = Attributes(filtered_data_rX);

% To call the fields in a structure:
% getfield(Structure Name, Field Name)
