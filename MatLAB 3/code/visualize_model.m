% Plots the data points and the decision tree prediction

function visualize_model(model, xfeature, x_min, x_max, yfeature, y_min, y_max, response, z_min, z_max)
    
    cmap = colormap("parula");
    xplot_step = (x_max - x_min) / 20.0;                                   % resolution of the model visualization
    yplot_step = (y_max - y_min) / 20.0;
    [xx, yy] = meshgrid(x_min:xplot_step:x_max, y_min:yplot_step:y_max);    % set up the mesh
    mesh_data = [xx(:), yy(:)];
    Z = reshape(model.predict(mesh_data), size(xx));                        % predict with trained model over the mesh
    scatter(xfeature, yfeature, [], response, 'filled');
    hold on;
    surf(xx, yy, Z, 'FaceAlpha', 0.8);
    hold off;
    xlabel('Topographic Wetness Index [-]');
    ylabel('Variable (S, DFC, ID)');
    xlim([x_min, x_max]);
    ylim([y_min, y_max]);
    zlim([z_min, z_max]);
    cbar = colorbar('vertical');
    cbar.Label.String = 'Displacement Length [m]';
    cbar.Label.Position(1) = cbar.Label.Position(1) + 0.15;
    cbar.Label.Rotation = 270;
    cbar.Label.VerticalAlignment = 'middle';

end