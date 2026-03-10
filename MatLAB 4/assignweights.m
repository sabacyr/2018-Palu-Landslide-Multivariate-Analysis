% Define the number of nearest neighbors to consider
k = 5; % Number of nearest neighbors

dataset = table2array(readtable('R1_E20_max.xlsx'));
columnNames = readtable('R1_E20_max.xlsx').Properties.VariableNames;

% Initialize weight vector
weights = zeros(size(dataset, 1), 1);

% Iterate through each data point
for i = 1:size(dataset, 1)
    % Get the coordinates and displacement length of the current data point
    x = dataset(i, 3); % Assuming x coordinate is in column 3
    y = dataset(i, 4); % Assuming y coordinate is in column 4
    displacement_length = dataset(i, 6); % Assuming displacement length is in column 2
    
    % Calculate the Euclidean distances between the current data point and all other data points
    distances = sqrt((dataset(:, 3) - x).^2 + (dataset(:, 4) - y).^2);
    
    % Sort the distances and select the k nearest neighbors
    [~, sorted_indices] = sort(distances);
    nearest_indices = sorted_indices(2:k+1); % Exclude the current data point itself
    
    % Calculate the average displacement length of the selected nearest neighbors
    avg_displacement_length = mean(dataset(nearest_indices, 6));
    
    % Assign a weight value to the current data point based on the average displacement length
    weights(i) = avg_displacement_length;
end
