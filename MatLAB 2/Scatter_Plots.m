%% Scatter3 Plot Region 1
figure
scatter3(attributes_r1.ID_400, attributes_r1.T_15, attributes_r1.D, 50, attributes_r1.DFC, 'filled');
xlabel('ID [km/km^2]');
ylabel('TWI [-]');
zlabel('Displacement [m] ');
axis([0 10 0 10 0 10]);
c = colorbar;
colormap('jet');
c.Label.String = 'Distance From Canal [m]';
title('Region 1 Scatter Plot');
set(gca, 'FontSize', 12);
view(45, 30);


%% Scatter3 Plot Region 3
figure
scatter3(attributes_r3.ID_400, attributes_r3.T_15, attributes_r3.D, 50, attributes_r3.DFC, 'filled');
xlabel('ID [km/km^2]');
ylabel('TWI');
zlabel('Displacement [m] ');
axis([0 10 0 10 0 10]);
c = colorbar;
colormap('jet');
c.Label.String = 'Distance From Canal [m]';
title('Region 3 Scatter Plot');
set(gca, 'FontSize', 12);
view(45, 30);


