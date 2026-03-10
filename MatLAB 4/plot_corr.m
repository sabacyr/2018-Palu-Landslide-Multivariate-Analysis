% Plots a graphical correlation matrix 

function plot_corr(data)
    if istable(data)
        corr_matrix = corrcoef(data{:,:}, 'Rows', 'pairwise');
        variable_names = data.Properties.VariableNames;
    elseif ismatrix(data)
        corr_matrix = corrcoef(data, 'Rows', 'pairwise');
        variable_names = 1:size(data, 2);
    else
        error('Input data should be either a table or a matrix.');
    end
    
    figure;
    colormap('parula');
    imagesc(corr_matrix, [-1 1]);
    matrix_size = size(corr_matrix, 2);
    xticks(1:matrix_size);
    yticks(1:matrix_size);
    
    if iscellstr(variable_names)
        xticklabels(variable_names);
        yticklabels(variable_names);
    end

    c = colorbar;
    colorbar_ticks = linspace(-1, 1, 11);  % specify tick positions
    c.Ticks = colorbar_ticks;
    title('Correlation Matrix');
end
