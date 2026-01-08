%%
%4 panel plot two on top S04p and 2 on bottom I06s, left side is Souther
%Zone data averaged and right side is Antarctic Zone data averaged, just
% abundance not relative

%4 of these, one with crustacea, one with gelatinous, one with rhizaria,
%and detritus supercategories

clear all;
%load data
%zoo_summary_new_s04p = readtable('G:\MS_Southern_Ocean\data\zoo_s04p_val_pred_photo_no_fiber_3Apr2024_summary_mean_new_depth_bins.csv');
%zoo_summary_new_s04p = readtable('G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_3Apr2024_summary_mean_new_depth_bins.csv');
%zoo_summary_new_s04p = readtable('G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_5Sept2024_summary_mean_new_depth_bins.csv');
zoo_summary_new_s04p = readtable('G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_20Feb2025_summary_mean_new_depth_bins.csv');
%remove extra stations in Southern Zone that aren't connected to main section
%zoo_summary_new_s04p = zoo_summary_new_s04p(1:515,:);
zoo_summary_new_s04p = zoo_summary_new_s04p(1:507,:);

%zoo_summary_new_i06s = readtable('G:\MS_Southern_Ocean\data\zoo_i06s_val_pred_photo_no_fiber_3Apr2024_summary_mean_new_depth_bins.csv');
%zoo_summary_new_i06s = readtable('G:\MS_Southern_Ocean\data\zoo_i06s_val_photo_no_fiber_3Apr2024_summary_mean_new_depth_bins.csv');
zoo_summary_new_i06s = readtable('G:\MS_Southern_Ocean\data\zoo_i06s_val_photo_no_fiber_5Sept2024_summary_mean_new_depth_bins.csv');

%load AOU data
load('G:\MS_Southern_Ocean\data\Oxygen_sensor\avg_AOU_I06s_S04p_AZ_SZ.mat')

depth_bins_new = [0 200 500 1000 3000 6000];

%% One plot with all 5 types, but only from the southern Zone , total abundance and relative abundance
%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
fig1 = figure; fig1.Units = 'inches'; fig1.Position = [0.4417 0.6167 6.5+0.25 6.75]; %[0.4417 0.6167 6.5+0.2 7.9]

% %add AOU plot on top
% ax2 = axes;
% set(ax2, 'Units', 'inches', 'Position',[0.6747 6.5520 1.0488 1.1700],'Box','on', 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_S04p_SZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_S04p_SZ(index,4);
    fake_std(in) = avg_AOU_S04p_SZ(index,5);
end

% Detritus
detritus = {'Dense_agg_M_3'; 'Fiber_M_3'; 'Feces_M_3'; 'mc_aggregate_fluffy_M_3'; 
    'mc_aggregate_fluffy_elongated_M_3'; 'mc_aggregate_fluffy_grainy_to_aggregate_dense_M_3'; 
    'mc_aggregate_fluffy_grey_to_aggregate_badfocus_M_3'}; %'Fluffy agg'; 
detritus_label = {'Dense aggregate';  'Fiber'; 'Feces'; 'Fluffy agg circular'; 'Fluffy agg elongated'; 
    'Fluffy agg grainy/dense'; 'Fluffy agg gray/badfocus'; 'Fluffy agg other'}; 

%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Fluffy_agg_M_3(w(w2)));
    for index2 = 1:length(detritus)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(detritus(index2))));
    end
end
data(1:5,8) = super - sum(data(:,4:7),2);

%add panel for relative abundance
data_relative = data./sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[0.6747 4.9920 1.0488 1.1700],'Box','on', 'Color', 'none');

X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data_relative, 'stacked'); %added ax1 here
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];

set(ax1, 'YDir','reverse', 'XDir', 'reverse')
ax1.XTickLabel = {'0', '50%', '100%'};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
%xlabel('Abundance (# m^-^3)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %      
%label on top
t = text(1, -2.1, 'Boundary Zone: Pacific Sector', 'FontWeight','Bold','FontSize',10.5,'fontname','helvetica'); %0.0806, -17.3988
t3 = text(1, -1.1, '"Fluffy Aggregate Flux Event"', 'FontWeight','Bold','FontSize',10.5,'fontname','helvetica'); %0.0806, -17.3988
t2 = text(1.6, -0.4, 'Detritus', 'FontWeight','Bold','FontSize',10.5,'fontname','helvetica'); %0.0806, -17.3988
hold off

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[1.7235 4.9920 1.0488 1.1700],'Box','on'); 
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 630]; 
ax1.XTick = [0 200 400 600];
ax1.XTickLabel = {'0', '200', '400', '600'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(520, 4.9, 'a', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
%xlabel('Abundance (%)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %     
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Fluffy_agg_M_3(w(w2)));
    for index2 = 1:length(detritus)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(detritus(index2))));
    end
end
data(1:5,8) = super - sum(data(:,4:7),2);
data_relative = data./sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[2.7723+0.2 4.9920 1.0488 1.1700],'Box','on'); %2.7723 4.9920 1.0488 1.1700

X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data_relative, 'stacked');
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];
set(ax1, 'YDir','reverse', 'XDir','reverse')
ax1.XTickLabel = {'0', '50%', '100%'};
% ax1.XLim = [0 75]; %ax1.XLim = [0 630]; %ax1.XLim = [0 611]; %ax1.XLim = [0 730];
% ax1.XTick = [0 25 50 75]; %ax1.XTick = [0 200 400 600];
% ax1.XTickLabel = {'', '25', '50', ''};%ax1.XTickLabel = {'', '200', '400', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
%xlabel('Abundance (# m^-^3)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %        
%label on top
t = text(1, -2.1, 'Boundary Zone: African Sector', 'FontWeight','Bold','FontSize',10.5,'fontname','helvetica'); %0.0806, -17.3988
t3 = text(1, -1.1, '"Zooplankton-Mediated Flux Event"', 'FontWeight','Bold','FontSize',10.5,'fontname','helvetica'); %0.0806, -17.3988
hold off

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[3.8211+0.2 4.9920 1.0488 1.1700],'Box','on'); %[2.7723 4.9920 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 630]; %ax1.XLim = [0 611]; %ax1.XLim = [0 730];
ax1.XTick = [0 200 400 600];
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(520, 4.9, 'b', 'FontWeight','Bold','FontSize',15,'fontname','helvetica'); %520, 4.9
ax1.YTickLabel = {};
%xlabel('Abundance (%)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %                                                             
hold off

%add legend
leg1 = legend(detritus_label);
%title(leg1,'Detritus Categories')
set(leg1,'Units', 'inches', 'Position',[5+0.2 4.9920 1.2813 1.1700]); %[4.8699 4.9920 1.2813 1.1700]); % 2.92 4.8150 4.8699


% rhizaria
 
Rhizaria_harosa = {'Acantharea_M_3'; 'Aulacantha_M_3'; 'Aulosphaeridae_M_3'; 'Cannosphaeridae_M_3';  ...
    'colonial_Cannosphaeridae_M_3'; 'Collodaria_M_3'; 'Medusettidae_M_3'; 'mc_aulosphaeridae_to_cannosphaeridae_M_3'; 
     'solitaryblack_M_3'; 'mc_solitary_black_to_puff_M_3'}; %'Rhizaria_M_3'; 'unknown_Phaeodaria_M_3'; 
Rhizaria_harosa_label = {'Acantharea'; 'Aulacantha';  'Aulosphaeridae'; 'Cannosphaeridae'; 
    'Cannosphaeridae colonial'; 'Collodaria'; 'Medusettidae'; 'Aulo./Canno. unknown'; 
    'Solitary black'; 'Solitary black/puff'; 'Rhizaria other'}; %'Phaeodaria unknown'; 
%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Rhizaria_harosa_M_3(w(w2)));
    for index2 = 1:length(Rhizaria_harosa)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Rhizaria_harosa(index2))));
    end
end
data(1:5,11) = super - sum(data,2);
data_relative = data./sum(data,2);

%ax1 = axes('Position',[0.11 0.2 0.171 0.75],'Box','on');
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[0.6747 3.432 1.0488 1.1700],'Box','on', 'Color', 'none');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data_relative, 'stacked'); %added ax1 here
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
%hb(12).FaceColor = [96/255 96/255 96/255];
set(ax1, 'YDir','reverse', 'XDir','reverse')
ax1.XTickLabel = {'0', '50%', '100%'};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
%xlabel('Abundance (# m^-^3)','FontWeight','Bold','FontSize',7,'fontname','helvetica');
%t2 = text(5.2, 4.9, 'e', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
t2 = text(1.6, -0.4, 'Rhizarian', 'FontWeight','Bold','FontSize',10.5,'fontname','helvetica'); %0.0806, -17.3988
hold off

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[1.7235 3.432 1.0488 1.1700],'Box','on'); %[2.7723 4.9920 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 6]; %ax1.XLim = [0 13];
xticks([0 2 4 6])
ax1.XTickLabel = {'0', '2', '4', '6'}; %ax1.XTickLabel = {'0', '5', '10'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(5, 4.9, 'c', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
%xlabel('Abundance (%)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %                                                             
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Rhizaria_harosa_M_3(w(w2)));
    for index2 = 1:length(Rhizaria_harosa)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Rhizaria_harosa(index2))));
    end
end
data(1:5,11) = super - sum(data,2);
data_relative = data./sum(data,2);

%ax1 = axes('Position',[0.452 0.2 0.171 0.75],'Box','on');
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[2.7723+0.2 3.432 1.0488 1.1700],'Box','on', 'Color', 'none'); %[1.7235 3.432 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data_relative, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
%hb(12).FaceColor = [96/255 96/255 96/255];
set(ax1, 'YDir','reverse', 'XDir','reverse')
ax1.YTickLabel = {};
ax1.XTickLabel = {'0', '50%', '100%'};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
%xlabel('Abundance (# m^-^3)','FontWeight','Bold','FontSize',7,'fontname','helvetica');
hold off

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[2.7723+(2.7723-1.7235)+0.2 3.432 1.0488 1.1700],'Box','on'); %[2.7723 4.9920 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 6]; %ax1.XLim = [0 13];
xticks([0 2 4 6])
ax1.XTickLabel = {'', '2', '4', '6'}; 
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(5, 4.9, 'd', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
%xlabel('Abundance (%)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %                                                             
hold off

%add legend
leg1 = legend(Rhizaria_harosa_label);
%title(leg1,'Rhizarian Categories')
%set(leg1,'Position',[0.807 0.163 0.171 0.75]);  %set(leg1,'Position',[0.807 0.130 0.171 0.75]); %0.6775
%set(leg1,'Units','inches', 'Position',[4.8699 3.432 1.0488 1.1700])
set(leg1,'Units','inches', 'Position',[4.8699+0.2  3.432 1.6229 1.1700]) %4.8699+0.2  (3.0666+3.432)/2 1.6229 1.5354


% Gelatinous 
Gelatinous = {'Ctenophora_Metazoa_M_3'; 'Hydrozoa_M_3'; 
    'Narcomedusae_M_3'; 'Salpida_M_3'; 'Siphonophorae_M_3'; ...
    'tentacle_Cnidaria_M_3'}; %'house_M_3'; 'Cnidaria_Metazoa_M_3'; 'Solmundella_bitentaculata_M_3';
Gelatinous_label = {'Ctenophora'; ...
    'Hydrozoa'; 'Narcomedusae'; 'Salpida'; 'Siphonophorae'; ...
    'Tentacle'; 'Cnidaria other'}; %'Larvacean house'; 'Solmundella bitentaculata'
%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Gelatinous_M_3(w(w2)));
    for index2 = 1:length(Gelatinous)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Gelatinous(index2))));
    end
end
data(1:5,7) = super - sum(data,2);
data_relative = data./sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[0.6747 1.872 1.0488 1.1700],'Box','on', 'Color', 'none');

X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data_relative, 'stacked'); 
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse', 'XDir','reverse')
ax1.XTickLabel = {'0', '50%', '100%'};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
%xlabel('Abundance (# m^-^3)','FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(1.6, -0.4, 'Gelatinous', 'FontWeight','Bold','FontSize',10.5,'fontname','helvetica'); %0.0806, -17.3988
hold off;

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[1.7235 1.872 1.0488 1.1700],'Box','on'); %[2.7723 4.9920 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 1.35]; 
xticks([0 0.5 1]); 
ax1.XTickLabel = {'0', '0.5', '1'}; 
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(1.1, 4.9, 'e', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
%xlabel('Abundance (%)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %                                                             
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Gelatinous_M_3(w(w2)));
    for index2 = 1:length(Gelatinous)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Gelatinous(index2))));
    end
end
data(1:5,7) = super - sum(data,2);
data_relative = data./sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[2.7723+0.2 1.872 1.0488 1.1700],'Box','on', 'Color', 'none'); %[1.7235 1.872 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data_relative, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse', 'XDir','reverse')
ax1.XTickLabel = {'0', '50', '100'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
%xlabel('Abundance (# m^-^3)','FontWeight','Bold','FontSize',7,'fontname','helvetica');
hold off

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[2.7723+(2.7723-1.7235)+0.2 1.872 1.0488 1.1700],'Box','on'); %[2.7723 4.9920 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 1.35]; 
xticks([0 0.5 1]);
ax1.XTickLabel = {'0', '0.5', '1'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(1.1, 4.9, 'f', 'FontWeight','Bold','FontSize',15,'fontname','helvetica'); %1.2
%xlabel('Abundance (%)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %                                                             
hold off

%add legend
leg1 = legend(Gelatinous_label);
%title(leg1,'Gelatinous Categories')
set(leg1,'Units', 'inches', 'Position',[4.8699+0.2 1.872 1.2813 1.1700]); % 4.8150 4.8699

%crustacea category names
crustacea = {'like_Amphipoda_M_3'; 'Copepoda_Maxillopoda_M_3'; 'like_Copepoda_M_3'; 'Hyperia_M_3'; ...
    'Ostracoda_M_3'; 'shrimp_like_M_3'}; %7 categories, deleted 'part_Copepoda_M_3', ; 'Crustacea_M_3'
crustacea_label = {'Amphipoda like'; 'Copepoda'; 'Copepoda like'; 'Hyperia';  ...
     'Ostracoda'; 'Shrimp like'; 'Crustacea other'};

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Arthro_crustacea_M_3(w(w2)));
    for index2 = 1:length(crustacea)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(crustacea(index2))));
    end
end
data(1:5,7) = super - sum(data,2);
data_relative = data./sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[0.6747 0.34 1.0488 1.1700],'Box','on', 'Color', 'none');

X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data_relative, 'stacked'); %added ax1 here
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse', 'XDir','reverse')
ax1.XTickLabel = {'0', '50%', '100%'};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
xlabel('Abundance (%)', 'FontWeight','Bold','FontSize',9,'fontname','helvetica')
t2 = text(1.6, -0.4, 'Crustacean', 'FontWeight','Bold','FontSize',10.5,'fontname','helvetica'); %0.0806, -17.3988
hold off

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[1.7235 0.34 1.0488 1.1700],'Box','on'); %[2.7723 4.9920 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 3]; %ax1.XLim = [0 2]; %ax1.XLim = [0 4];
xticks([0 1 2 3]) %xticks([0 0.5 1 1.5 2])
ax1.XTickLabel = {'0', '1', '2', '3'}; %ax1.XTickLabel = {'0', '0.5', '1', '1.5', ''}; %ax1.XTickLabel = {'0', '2', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(2.5, 4.9, 'g', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
xlabel('Abundance (# m^-^3)', 'FontWeight','Bold','FontSize',9,'fontname','helvetica'); %                                                             
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Arthro_crustacea_M_3(w(w2)));
    for index2 = 1:length(crustacea)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(crustacea(index2))));
    end
end
data(1:5,7) = super - sum(data,2);
data_relative = data./sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[2.7723+0.2 0.34 1.0488 1.1700],'Box','on', 'Color', 'none');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data_relative, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse', 'XDir','reverse')
ax1.XTickLabel = {'0', '50%', '100%'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
xlabel('Abundance (%)', 'FontWeight','Bold','FontSize',9,'fontname','helvetica'); %     

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[2.7723+(2.7723-1.7235)+0.2 0.34 1.0488 1.1700],'Box','on'); %[2.7723 4.9920 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 3]; %ax1.XLim = [0 2]; %ax1.XLim = [0 4];
xticks([0 1 2 3]) %xticks([0 0.5 1 1.5 2])
ax1.XTickLabel = {'0', '1', '2', '3'}; %ax1.XTickLabel = {'0', '0.5', '1', '1.5', ''}; %ax1.XTickLabel = {'0', '2', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(2.5, 4.9, 'h', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
xlabel('Abundance (# m^-^3)', 'FontWeight','Bold','FontSize',9,'fontname','helvetica')
hold off

%add legend
leg1 = legend(crustacea_label);
%title(leg1,'Crustacean Categories')
set(leg1,'Units', 'inches', 'Position',[4.8699+0.2 0.34 1.2813 1.1700]); % 4.8150 4.8699

print('-dpng','-r350', 'G:/MS_Southern_Ocean/Figures/stacked_bar_plot_val_all_bz_percent_05Jan2026');

%% One plot with all 5 types, but only from the southern Zone , total abundance and relative abundance
%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
fig1 = figure; fig1.Units = 'inches'; fig1.Position = [0.4417 0.6167 6.5 7.9]; %[0.4417 0.6167 4.45 7.9]

%add AOU plot on top
ax2 = axes;
set(ax2, 'Units', 'inches', 'Position',[0.6747 6.5520 1.0488 1.1700],'Box','on', 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_S04p_SZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_S04p_SZ(index,4);
    fake_std(in) = avg_AOU_S04p_SZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:377) + fake_std(1:377); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:377) - fake_std(1:377);
x2_2 = [fake_depth_2(1:377), fliplr(fake_depth_2(1:377))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse') %, 'XAxisLocation','top'
set(ax2,'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %size changed from 9
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); 
xticks([0 0.1 0.2 0.3 0.4])
ax2.XTickLabel = {'0', '0.1', '0.2', '0.3', ''};
set(ax2,'YTick',[40.1 120.3 200.5 280.7 360.9]);
ax2.YTickLabel = {'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'}; 
ylabel('Depth (m)')
xlabel('Fluorescence (RFU)','FontWeight','Bold','FontSize',7,'fontname','helvetica'); 
%label on top
t = text(0.0806, -17.3988, '            Pacific Sector', 'FontWeight','Bold','FontSize',9,'fontname','helvetica'); %-31.7301
t2 = text(0.33, 345, 'a', 'FontWeight','Bold','FontSize',15,'fontname','helvetica'); %size changed from 20
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 

%add AOU plot on top 
ax2 = axes;
set(ax2, 'Units', 'inches', 'Position',[2.7723 6.5520 1.0488 1.1700],'Box','on', 'Color', 'none'); %1.7235

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_I06s_SZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_I06s_SZ(index,4);
    fake_std(in) = avg_AOU_I06s_SZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(7:391) + fake_std(7:391); %cut out nans at the end of the variable
curve2_2 = fake_AOU(7:391) - fake_std(7:391);
x2_2 = [fake_depth_2(7:391), fliplr(fake_depth_2(7:391))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse') %, 'XAxisLocation','top'
set(ax2,'FontWeight','Bold','FontSize',7,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); 
xticks([0 0.1 0.2 0.3 0.4]);
ax2.XTickLabel = {'0', '0.1', '0.2', '0.3', ''};
set(ax2,'YTick',[40.1 120.3 200.5 280.7 360.9]);
ax2.YTickLabel = {'', '', '', '', ''}; 
xlabel('Fluorescence (RFU)','FontWeight','Bold','FontSize',7,'fontname','helvetica'); 

%label on top
t = text(0.0806, -17.3988, '           African Sector', 'FontWeight','Bold','FontSize',9,'fontname','helvetica'); %-31.7301
t2 = text(0.33, 345, 'b', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%add legend
fluor_label = {'1 SD';  'Average'}; 
leg1 = legend(fluor_label);
title(leg1,'Fluorescence')
set(leg1,'Units','inches', 'Position',[4.8699 6.5520 1.0488 1.1700]) %2.7723 
hold off


% Detritus
detritus = {'Dense_agg_M_3'; 'Fiber_M_3'; 'Feces_M_3'; 'mc_aggregate_fluffy_M_3'; 
    'mc_aggregate_fluffy_elongated_M_3'; 'mc_aggregate_fluffy_grainy_to_aggregate_dense_M_3'; 
    'mc_aggregate_fluffy_grey_to_aggregate_badfocus_M_3'}; %'Fluffy agg'; 
detritus_label = {'Dense aggregate';  'Fiber'; 'Feces'; 'Fluffy agg circular'; 'Fluffy agg elongated'; 
    'Fluffy agg grainy/dense'; 'Fluffy agg gray/badfocus'; 'Fluffy agg other'}; 

%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Fluffy_agg_M_3(w(w2)));
    for index2 = 1:length(detritus)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(detritus(index2))));
    end
end
data(1:5,8) = super - sum(data(:,4:7),2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[0.6747 4.9920 1.0488 1.1700],'Box','on', 'Color', 'none');

X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); %added ax1 here
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];

set(ax1, 'YDir','reverse')
ax1.XLim = [0 630]; %ax1.XLim = [0 611]; %ax1.XLim = [0 730];
ax1.XTick = [0 200 400 600];
ax1.XTickLabel = {'0', '200', '400', ''};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
xlabel('Abundance (# m^-^3)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %                                                             
t2 = text(520, 4.9, 'c', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%add panel for relative abundance
data_relative = data./sum(data,2);
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[1.7235 4.9920 1.0488 1.1700],'Box','on'); %[2.7723 4.9920 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data_relative, 'stacked');
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];
set(ax1, 'YDir','reverse')
%ax1.XLim = [0 630]; %ax1.XLim = [0 611]; %ax1.XLim = [0 730];
%ax1.XTick = [0 200 400 600];
ax1.XTickLabel = {'0', '50', '100'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
%t2 = text(520, 4.9, 'd', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
xlabel('Abundance (%)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %                                                             
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Fluffy_agg_M_3(w(w2)));
    for index2 = 1:length(detritus)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(detritus(index2))));
    end
end
data(1:5,8) = super - sum(data(:,4:7),2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[2.7723 4.9920 1.0488 1.1700],'Box','on'); %[1.7235 4.9920 1.0488 1.1700]

X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 75]; %ax1.XLim = [0 630]; %ax1.XLim = [0 611]; %ax1.XLim = [0 730];
ax1.XTick = [0 25 50 75]; %ax1.XTick = [0 200 400 600];
ax1.XTickLabel = {'', '25', '50', ''};%ax1.XTickLabel = {'', '200', '400', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(60, 3.9, 'd', 'FontWeight','Bold','FontSize',15,'fontname','helvetica'); %520, 4.9
xlabel('Abundance (# m^-^3)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %                                                             
hold off

%add panel for relative abundance
data_relative = data./sum(data,2);
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[3.8211 4.9920 1.0488 1.1700],'Box','on'); %[2.7723 4.9920 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data_relative, 'stacked');
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];
set(ax1, 'YDir','reverse')
%ax1.XLim = [0 630]; %ax1.XLim = [0 611]; %ax1.XLim = [0 730];
%ax1.XTick = [0 200 400 600];
ax1.XTickLabel = {'0', '50', '100'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
%t2 = text(520, 4.9, 'd', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
xlabel('Abundance (%)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %                                                             
hold off

%add legend
leg1 = legend(detritus_label);
title(leg1,'Detritus Categories')
set(leg1,'Units', 'inches', 'Position',[5 4.9920 1.2813 1.1700]); %[4.8699 4.9920 1.2813 1.1700]); % 2.92 4.8150 4.8699

% rhizaria
 
Rhizaria_harosa = {'Acantharea_M_3'; 'Aulacantha_M_3'; 'Aulosphaeridae_M_3'; 'Cannosphaeridae_M_3';  ...
    'colonial_Cannosphaeridae_M_3'; 'Collodaria_M_3'; 'Medusettidae_M_3'; 'mc_aulosphaeridae_to_cannosphaeridae_M_3'; 
     'solitaryblack_M_3'; 'mc_solitary_black_to_puff_M_3'}; %'Rhizaria_M_3'; 'unknown_Phaeodaria_M_3'; 
Rhizaria_harosa_label = {'Acantharea'; 'Aulacantha';  'Aulosphaeridae'; 'Cannosphaeridae'; 
    'Cannosphaeridae colonial'; 'Collodaria'; 'Medusettidae'; 'Aulo./Canno. unknown'; 
    'Solitary black'; 'Solitary black/puff'; 'Rhizaria other'}; %'Phaeodaria unknown'; 
%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Rhizaria_harosa_M_3(w(w2)));
    for index2 = 1:length(Rhizaria_harosa)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Rhizaria_harosa(index2))));
    end
end
data(1:5,11) = super - sum(data,2);

%ax1 = axes('Position',[0.11 0.2 0.171 0.75],'Box','on');
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[0.6747 3.432 1.0488 1.1700],'Box','on', 'Color', 'none');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); %added ax1 here
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
%hb(12).FaceColor = [96/255 96/255 96/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 6]; %ax1.XLim = [0 13];
xticks([0 2 4 6])
ax1.XTickLabel = {'0', '2', '4', ''}; %ax1.XTickLabel = {'0', '5', '10'};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
xlabel('Abundance (# m^-^3)','FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(5.2, 4.9, 'e', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%add panel for relative abundance
data_relative = data./sum(data,2);
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[1.7235 3.432 1.0488 1.1700],'Box','on'); %[2.7723 4.9920 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data_relative, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
set(ax1, 'YDir','reverse')
%ax1.XLim = [0 630]; %ax1.XLim = [0 611]; %ax1.XLim = [0 730];
%ax1.XTick = [0 200 400 600];
ax1.XTickLabel = {'0', '50', '100'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
%t2 = text(520, 4.9, 'd', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
xlabel('Abundance (%)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %                                                             
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Rhizaria_harosa_M_3(w(w2)));
    for index2 = 1:length(Rhizaria_harosa)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Rhizaria_harosa(index2))));
    end
end
data(1:5,11) = super - sum(data,2);

%ax1 = axes('Position',[0.452 0.2 0.171 0.75],'Box','on');
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[2.7723 3.432 1.0488 1.1700],'Box','on', 'Color', 'none'); %[1.7235 3.432 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
%hb(12).FaceColor = [96/255 96/255 96/255];
set(ax1, 'YDir','reverse')
ax1.YTickLabel = {};
ax1.XLim = [0 6]; %ax1.XLim = [0 13];
xticks([0 2 4 6])
ax1.XTickLabel = {'', '2', '4', ''}; %ax1.XTickLabel = {'0', '5', '10'};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
xlabel('Abundance (# m^-^3)','FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(5.2, 4.9, 'f', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%add panel for relative abundance
data_relative = data./sum(data,2);
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[2.7723+(2.7723-1.7235) 3.432 1.0488 1.1700],'Box','on'); %[2.7723 4.9920 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data_relative, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
set(ax1, 'YDir','reverse')
%ax1.XLim = [0 630]; %ax1.XLim = [0 611]; %ax1.XLim = [0 730];
%ax1.XTick = [0 200 400 600];
ax1.XTickLabel = {'0', '50', '100'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
%t2 = text(520, 4.9, 'd', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
xlabel('Abundance (%)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %                                                             
hold off

%add legend
leg1 = legend(Rhizaria_harosa_label);
title(leg1,'Rhizarian Categories')
%set(leg1,'Position',[0.807 0.163 0.171 0.75]);  %set(leg1,'Position',[0.807 0.130 0.171 0.75]); %0.6775
%set(leg1,'Units','inches', 'Position',[4.8699 3.432 1.0488 1.1700])
set(leg1,'Units','inches', 'Position',[4.8699  3.0666 1.6229 1.5354]) %2.7723

% Gelatinous 
Gelatinous = {'Ctenophora_Metazoa_M_3'; 'Hydrozoa_M_3'; 
    'Narcomedusae_M_3'; 'Salpida_M_3'; 'Siphonophorae_M_3'; ...
    'tentacle_Cnidaria_M_3'}; %'house_M_3'; 'Cnidaria_Metazoa_M_3'; 'Solmundella_bitentaculata_M_3';
Gelatinous_label = {'Ctenophora'; ...
    'Hydrozoa'; 'Narcomedusae'; 'Salpida'; 'Siphonophorae'; ...
    'Tentacle'; 'Cnidaria other'}; %'Larvacean house'; 'Solmundella bitentaculata'
%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Gelatinous_M_3(w(w2)));
    for index2 = 1:length(Gelatinous)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Gelatinous(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[0.6747 1.872 1.0488 1.1700],'Box','on', 'Color', 'none');

X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); 
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 1.5]; %0.3]; 
xticks([0 0.5 1 1.5]); %[0 0.1 0.2 0.3]) 
ax1.XTickLabel = {'0', '0.5', '1', ''}; %{'0', '0.1', '0.2', ''};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
xlabel('Abundance (# m^-^3)','FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(1.2, 4.9, 'g', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off;

%add panel for relative abundance
data_relative = data./sum(data,2);
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[1.7235 1.872 1.0488 1.1700],'Box','on'); %[2.7723 4.9920 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data_relative, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse')
%ax1.XLim = [0 630]; %ax1.XLim = [0 611]; %ax1.XLim = [0 730];
%ax1.XTick = [0 200 400 600];
ax1.XTickLabel = {'0', '50', '100'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
%t2 = text(520, 4.9, 'd', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
xlabel('Abundance (%)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %                                                             
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Gelatinous_M_3(w(w2)));
    for index2 = 1:length(Gelatinous)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Gelatinous(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[2.7723 1.872 1.0488 1.1700],'Box','on', 'Color', 'none'); %[1.7235 1.872 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 0.18]; %ax1.XLim = [0 1.5]; %0.3]; 
xticks([0 0.05 0.1 0.15]);%xticks([0 0.5 1 1.5]); %[0 0.1 0.2 0.3]) 
ax1.XTickLabel = {'0', '0.05', '0.1', '0.15'};%ax1.XTickLabel = {'0', '0.5', '1', ''}; %{'0', '0.1', '0.2', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
xlabel('Abundance (# m^-^3)','FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(0.15, 4.9, 'h', 'FontWeight','Bold','FontSize',15,'fontname','helvetica'); %1.2
hold off

%add panel for relative abundance
data_relative = data./sum(data,2);
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[2.7723+(2.7723-1.7235) 1.872 1.0488 1.1700],'Box','on'); %[2.7723 4.9920 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data_relative, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse')
%ax1.XLim = [0 630]; %ax1.XLim = [0 611]; %ax1.XLim = [0 730];
%ax1.XTick = [0 200 400 600];
ax1.XTickLabel = {'0', '50', '100'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
%t2 = text(520, 4.9, 'd', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
xlabel('Abundance (%)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %                                                             
hold off

%add legend
leg1 = legend(Gelatinous_label);
title(leg1,'Gelatinous Categories')
set(leg1,'Units', 'inches', 'Position',[4.8699 1.872 1.2813 1.1700]); % 4.8150 4.8699

%crustacea category names
crustacea = {'like_Amphipoda_M_3'; 'Copepoda_Maxillopoda_M_3'; 'like_Copepoda_M_3'; 'Hyperia_M_3'; ...
    'Ostracoda_M_3'; 'shrimp_like_M_3'}; %7 categories, deleted 'part_Copepoda_M_3', ; 'Crustacea_M_3'
crustacea_label = {'Amphipoda like'; 'Copepoda'; 'Copepoda like'; 'Hyperia';  ...
     'Ostracoda'; 'Shrimp like'; 'Crustacea other'};


%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Arthro_crustacea_M_3(w(w2)));
    for index2 = 1:length(crustacea)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(crustacea(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[0.6747 0.34 1.0488 1.1700],'Box','on', 'Color', 'none');

X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); %added ax1 here
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 3.25]; %ax1.XLim = [0 2]; %ax1.XLim = [0 4];
xticks([0 1 2 3]) %xticks([0 0.5 1 1.5 2])
ax1.XTickLabel = {'0', '1', '2', '3'}; %ax1.XTickLabel = {'0', '0.5', '1', '1.5', ''}; %ax1.XTickLabel = {'0', '2', ''};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
xlabel('Abundance (# m^-^3)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica')
t2 = text(2.7, 4.9, 'i', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%add panel for relative abundance
data_relative = data./sum(data,2);
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[1.7235 0.34 1.0488 1.1700],'Box','on'); %[2.7723 4.9920 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data_relative, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse')
%ax1.XLim = [0 630]; %ax1.XLim = [0 611]; %ax1.XLim = [0 730];
%ax1.XTick = [0 200 400 600];
ax1.XTickLabel = {'0', '50', '100'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
%t2 = text(520, 4.9, 'd', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
xlabel('Abundance (%)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %                                                             
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Arthro_crustacea_M_3(w(w2)));
    for index2 = 1:length(crustacea)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(crustacea(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[2.7723 0.34 1.0488 1.1700],'Box','on', 'Color', 'none');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 3.25]; %ax1.XLim = [0 2]; %ax1.XLim = [0 4];
xticks([0 1 2 3]) %xticks([0 0.5 1 1.5 2])
ax1.XTickLabel = {'0', '1', '2', '3'}; %ax1.XTickLabel = {'0', '0.5', '1', '1.5', ''}; %ax1.XTickLabel = {'0', '2', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
xlabel('Abundance (# m^-^3)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica')
t2 = text(2.7, 4.9, 'j', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');

%add panel for relative abundance
data_relative = data./sum(data,2);
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[2.7723+(2.7723-1.7235) 0.34 1.0488 1.1700],'Box','on'); %[2.7723 4.9920 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data_relative, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse')
%ax1.XLim = [0 630]; %ax1.XLim = [0 611]; %ax1.XLim = [0 730];
%ax1.XTick = [0 200 400 600];
ax1.XTickLabel = {'0', '50', '100'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
%t2 = text(520, 4.9, 'd', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
xlabel('Abundance (%)', 'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %                                                             
hold off

%add legend
leg1 = legend(crustacea_label);
title(leg1,'Crustacean Categories')
set(leg1,'Units', 'inches', 'Position',[4.8699 0.34 1.2813 1.1700]); % 4.8150 4.8699

print('-dpng','-r350', 'G:/MS_Southern_Ocean/Figures/stacked_bar_plot_val_all_sz_percent_22Sept2025');

%% One plot with all 5 types, but only from the southern Zone 
%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
fig1 = figure; fig1.Units = 'inches'; fig1.Position = [0.4417 0.6167 4.45 7.9]; %[0.4417 0.6167 6.5 7.9]

%add AOU plot on top
ax2 = axes;
set(ax2, 'Units', 'inches', 'Position',[0.6747 6.5520 1.0488 1.1700],'Box','on', 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_S04p_SZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_S04p_SZ(index,4);
    fake_std(in) = avg_AOU_S04p_SZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:377) + fake_std(1:377); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:377) - fake_std(1:377);
x2_2 = [fake_depth_2(1:377), fliplr(fake_depth_2(1:377))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse') %, 'XAxisLocation','top'
set(ax2,'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %size changed from 9
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); 
xticks([0 0.1 0.2 0.3 0.4])
ax2.XTickLabel = {'0', '0.1', '0.2', '0.3', ''};
set(ax2,'YTick',[40.1 120.3 200.5 280.7 360.9]);
ax2.YTickLabel = {'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'}; 
ylabel('Depth (m)')
xlabel('                                                            Fluorescence (RFU)', ...
    'FontWeight','Bold','FontSize',9,'fontname','helvetica'); 
%label on top
t = text(0.0806, -31.7301, 'Pacific Sector', 'FontWeight','Bold','FontSize',9,'fontname','helvetica');
t2 = text(0.33, 345, 'a', 'FontWeight','Bold','FontSize',15,'fontname','helvetica'); %size changed from 20
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 

%add AOU plot on top 
ax2 = axes;
set(ax2, 'Units', 'inches', 'Position',[1.7235 6.5520 1.0488 1.1700],'Box','on', 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_I06s_SZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_I06s_SZ(index,4);
    fake_std(in) = avg_AOU_I06s_SZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(7:391) + fake_std(7:391); %cut out nans at the end of the variable
curve2_2 = fake_AOU(7:391) - fake_std(7:391);
x2_2 = [fake_depth_2(7:391), fliplr(fake_depth_2(7:391))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse') %, 'XAxisLocation','top'
set(ax2,'FontWeight','Bold','FontSize',7,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); 
xticks([0 0.1 0.2 0.3 0.4]);
ax2.XTickLabel = {'0', '0.1', '0.2', '0.3', ''};
set(ax2,'YTick',[40.1 120.3 200.5 280.7 360.9]);
ax2.YTickLabel = {'', '', '', '', ''}; 

%label on top
t = text(0.0806, -31.7301, 'African Sector', 'FontWeight','Bold','FontSize',9,'fontname','helvetica');
t2 = text(0.33, 345, 'b', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%add legend
fluor_label = {'1 SD';  'Average'}; 
leg1 = legend(fluor_label);
title(leg1,'Fluorescence')
set(leg1,'Units','inches', 'Position',[2.7723 6.5520 1.0488 1.1700]) %4.8699
hold off


% Detritus
detritus = {'Dense_agg_M_3'; 'Fiber_M_3'; 'Feces_M_3'; 'mc_aggregate_fluffy_M_3'; 
    'mc_aggregate_fluffy_elongated_M_3'; 'mc_aggregate_fluffy_grainy_to_aggregate_dense_M_3'; 
    'mc_aggregate_fluffy_grey_to_aggregate_badfocus_M_3'}; %'Fluffy agg'; 
detritus_label = {'Dense aggregate';  'Fiber'; 'Feces'; 'Fluffy agg circular'; 'Fluffy agg elongated'; 
    'Fluffy agg grainy/dense'; 'Fluffy agg gray/badfocus'; 'Fluffy agg other'}; 

%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Fluffy_agg_M_3(w(w2)));
    for index2 = 1:length(detritus)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(detritus(index2))));
    end
end
data(1:5,8) = super - sum(data(:,4:7),2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[0.6747 4.9920 1.0488 1.1700],'Box','on', 'Color', 'none');

X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); %added ax1 here
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];

set(ax1, 'YDir','reverse')
ax1.XLim = [0 630]; %ax1.XLim = [0 611]; %ax1.XLim = [0 730];
ax1.XTick = [0 200 400 600];
ax1.XTickLabel = {'0', '200', '400', ''};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
xlabel('                                                             Abundance (# m^-^3)', ...
    'FontWeight','Bold','FontSize',9,'fontname','helvetica');
t2 = text(520, 4.9, 'c', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Fluffy_agg_M_3(w(w2)));
    for index2 = 1:length(detritus)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(detritus(index2))));
    end
end
data(1:5,8) = super - sum(data(:,4:7),2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[1.7235 4.9920 1.0488 1.1700],'Box','on'); %[2.7723 4.9920 1.0488 1.1700]

X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 630]; %ax1.XLim = [0 611]; %ax1.XLim = [0 730];
ax1.XTick = [0 200 400 600];
ax1.XTickLabel = {'0', '200', '400', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(520, 4.9, 'd', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%add legend
leg1 = legend(detritus_label);
title(leg1,'Detritus Categories')
set(leg1,'Units', 'inches', 'Position',[2.92 4.9920 1.2813 1.1700]); % 4.8150 4.8699

% rhizaria
 
Rhizaria_harosa = {'Acantharea_M_3'; 'Aulacantha_M_3'; 'Aulosphaeridae_M_3'; 'Cannosphaeridae_M_3';  ...
    'colonial_Cannosphaeridae_M_3'; 'Collodaria_M_3'; 'Medusettidae_M_3'; 'mc_aulosphaeridae_to_cannosphaeridae_M_3'; 
     'solitaryblack_M_3'; 'mc_solitary_black_to_puff_M_3'}; %'Rhizaria_M_3'; 'unknown_Phaeodaria_M_3'; 
Rhizaria_harosa_label = {'Acantharea'; 'Aulacantha';  'Aulosphaeridae'; 'Cannosphaeridae'; 
    'Cannosphaeridae colonial'; 'Collodaria'; 'Medusettidae'; 'Aulo./Canno. unknown'; 
    'Solitary black'; 'Solitary black/puff'; 'Rhizaria other'}; %'Phaeodaria unknown'; 
%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Rhizaria_harosa_M_3(w(w2)));
    for index2 = 1:length(Rhizaria_harosa)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Rhizaria_harosa(index2))));
    end
end
data(1:5,11) = super - sum(data,2);

%ax1 = axes('Position',[0.11 0.2 0.171 0.75],'Box','on');
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[0.6747 3.432 1.0488 1.1700],'Box','on', 'Color', 'none');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); %added ax1 here
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
%hb(12).FaceColor = [96/255 96/255 96/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 6]; %ax1.XLim = [0 13];
xticks([0 2 4 6])
ax1.XTickLabel = {'0', '2', '4', ''}; %ax1.XTickLabel = {'0', '5', '10'};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
xlabel('                                                           Abundance (# m^-^3)', ...
    'FontWeight','Bold','FontSize',9,'fontname','helvetica');
t2 = text(5.3, 4.9, 'e', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Rhizaria_harosa_M_3(w(w2)));
    for index2 = 1:length(Rhizaria_harosa)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Rhizaria_harosa(index2))));
    end
end
data(1:5,11) = super - sum(data,2);

%ax1 = axes('Position',[0.452 0.2 0.171 0.75],'Box','on');
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[1.7235 3.432 1.0488 1.1700],'Box','on', 'Color', 'none'); %[2.7723 3.432 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
%hb(12).FaceColor = [96/255 96/255 96/255];
set(ax1, 'YDir','reverse')
ax1.YTickLabel = {};
ax1.XLim = [0 6]; %ax1.XLim = [0 13];
xticks([0 2 4 6])
ax1.XTickLabel = {'0', '2', '4', ''}; %ax1.XTickLabel = {'0', '5', '10'};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(5.2, 4.9, 'f', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%add legend
leg1 = legend(Rhizaria_harosa_label);
title(leg1,'Rhizarian Categories')
%set(leg1,'Position',[0.807 0.163 0.171 0.75]);  %set(leg1,'Position',[0.807 0.130 0.171 0.75]); %0.6775
%set(leg1,'Units','inches', 'Position',[4.8699 3.432 1.0488 1.1700])
set(leg1,'Units','inches', 'Position',[2.7723  3.0666 1.6229 1.5354])


% Gelatinous 
Gelatinous = {'Ctenophora_Metazoa_M_3'; 'Hydrozoa_M_3'; 
    'Narcomedusae_M_3'; 'Salpida_M_3'; 'Siphonophorae_M_3'; ...
    'tentacle_Cnidaria_M_3'}; %'house_M_3'; 'Cnidaria_Metazoa_M_3'; 'Solmundella_bitentaculata_M_3';
Gelatinous_label = {'Ctenophora'; ...
    'Hydrozoa'; 'Narcomedusae'; 'Salpida'; 'Siphonophorae'; ...
    'Tentacle'; 'Cnidaria other'}; %'Larvacean house'; 'Solmundella bitentaculata'
%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Gelatinous_M_3(w(w2)));
    for index2 = 1:length(Gelatinous)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Gelatinous(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[0.6747 1.872 1.0488 1.1700],'Box','on', 'Color', 'none');

X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); 
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 1.5]; %0.3]; 
xticks([0 0.5 1 1.5]); %[0 0.1 0.2 0.3]) 
ax1.XTickLabel = {'0', '0.5', '1', ''}; %{'0', '0.1', '0.2', ''};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
xlabel('                                                              Abundance (# m^-^3)', ...
    'FontWeight','Bold','FontSize',9,'fontname','helvetica');
t2 = text(1.2, 4.9, 'g', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off;

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Gelatinous_M_3(w(w2)));
    for index2 = 1:length(Gelatinous)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Gelatinous(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[1.7235 1.872 1.0488 1.1700],'Box','on', 'Color', 'none'); %[2.7723 1.872 1.0488 1.1700]
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 1.5]; %0.3]; 
xticks([0 0.5 1 1.5]); %[0 0.1 0.2 0.3]) 
ax1.XTickLabel = {'0', '0.5', '1', ''}; %{'0', '0.1', '0.2', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(1.2, 4.9, 'h', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%add legend
leg1 = legend(Gelatinous_label);
title(leg1,'Gelatinous Categories')
set(leg1,'Units', 'inches', 'Position',[2.7723 1.872 1.2813 1.1700]); % 4.8150 4.8699


%crustacea category names
crustacea = {'like_Amphipoda_M_3'; 'Copepoda_Maxillopoda_M_3'; 'like_Copepoda_M_3'; 'Hyperia_M_3'; ...
    'Ostracoda_M_3'; 'shrimp_like_M_3'}; %7 categories, deleted 'part_Copepoda_M_3', ; 'Crustacea_M_3'
crustacea_label = {'Amphipoda like'; 'Copepoda'; 'Copepoda like'; 'Hyperia';  ...
     'Ostracoda'; 'Shrimp like'; 'Crustacea other'};
 
%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Arthro_crustacea_M_3(w(w2)));
    for index2 = 1:length(crustacea)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(crustacea(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[0.6747 0.34 1.0488 1.1700],'Box','on', 'Color', 'none');

X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); %added ax1 here
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 3.25]; %ax1.XLim = [0 2]; %ax1.XLim = [0 4];
xticks([0 1 2 3]) %xticks([0 0.5 1 1.5 2])
ax1.XTickLabel = {'0', '1', '2', '3'}; %ax1.XTickLabel = {'0', '0.5', '1', '1.5', ''}; %ax1.XTickLabel = {'0', '2', ''};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
xlabel('                                                              Abundance (# m^-^3)', ...
    'FontWeight','Bold','FontSize',9,'fontname','helvetica')
t2 = text(2.7, 4.9, 'i', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Arthro_crustacea_M_3(w(w2)));
    for index2 = 1:length(crustacea)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(crustacea(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[1.7235 0.34 1.0488 1.1700],'Box','on', 'Color', 'none');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 3.25]; %ax1.XLim = [0 2]; %ax1.XLim = [0 4];
xticks([0 1 2 3]) %xticks([0 0.5 1 1.5 2])
ax1.XTickLabel = {'0', '1', '2', '3'}; %ax1.XTickLabel = {'0', '0.5', '1', '1.5', ''}; %ax1.XTickLabel = {'0', '2', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(2.7, 4.9, 'j', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');

%add legend
leg1 = legend(crustacea_label);
title(leg1,'Crustacean Categories')
set(leg1,'Units', 'inches', 'Position',[2.7723 0.34 1.2813 1.1700]); % 4.8150 4.8699


print('-dpng','-r350', 'G:/MS_Southern_Ocean/Figures/stacked_bar_plot_val_all_sz_19May2025');

%% One plot with all 5 types

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
fig1 = figure; fig1.Units = 'inches'; fig1.Position = [0.4417 0.6167 6.5 7.9]; %changed from 6.13 7.8

%add AOU plot on top
ax2 = axes;
set(ax2, 'Units', 'inches', 'Position',[0.6747 6.5520 1.0488 1.1700],'Box','on', 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_S04p_SZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_S04p_SZ(index,4);
    fake_std(in) = avg_AOU_S04p_SZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:377) + fake_std(1:377); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:377) - fake_std(1:377);
x2_2 = [fake_depth_2(1:377), fliplr(fake_depth_2(1:377))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse') %, 'XAxisLocation','top'
set(ax2,'FontWeight','Bold','FontSize',7,'fontname','helvetica'); %size changed from 9
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); 
xticks([0 0.1 0.2 0.3 0.4])
ax2.XTickLabel = {'0', '0.1', '0.2', '0.3', ''};
set(ax2,'YTick',[40.1 120.3 200.5 280.7 360.9]);
ax2.YTickLabel = {'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'}; 
ylabel('Depth (m)')
xlabel('                                                                                                       Fluorescence (RFU)', ...
    'FontWeight','Bold','FontSize',9,'fontname','helvetica'); 
%label on top
t = text(0.0806, -31.7301, 'Pacific: SZ', 'FontWeight','Bold','FontSize',9,'fontname','helvetica');
t2 = text(0.33, 345, 'a', 'FontWeight','Bold','FontSize',15,'fontname','helvetica'); %size changed from 20
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Antarctic Zone'})); 

%add AOU plot on top 
ax2 = axes;
set(ax2, 'Units', 'inches', 'Position',[1.7235 6.5520 1.0488 1.1700],'Box','on', 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_S04p_AZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_S04p_AZ(index,4);
    fake_std(in) = avg_AOU_S04p_AZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:375) + fake_std(1:375); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:375) - fake_std(1:375);
x2_2 = [fake_depth_2(1:375), fliplr(fake_depth_2(1:375))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse') %, 'XAxisLocation','top'
set(ax2,'FontWeight','Bold','FontSize',7,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]);
xticks([0 0.1 0.2 0.3 0.4]);
ax2.XTickLabel = {'0', '0.1', '0.2', '0.3', ''};
set(ax2,'YTick',[40.1 120.3 200.5 280.7 360.9]);
ax2.YTickLabel = {'', '', '', '', ''}; 
%label on top
t = text(0.0806, -31.7301, 'Pacific: AZ', 'FontWeight','Bold','FontSize',9,'fontname','helvetica');
t2 = text(0.33, 345, 'b', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 

%add AOU plot on top 
ax2 = axes;
set(ax2, 'Units', 'inches', 'Position',[2.7723 6.5520 1.0488 1.1700],'Box','on', 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_I06s_SZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_I06s_SZ(index,4);
    fake_std(in) = avg_AOU_I06s_SZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(7:391) + fake_std(7:391); %cut out nans at the end of the variable
curve2_2 = fake_AOU(7:391) - fake_std(7:391);
x2_2 = [fake_depth_2(7:391), fliplr(fake_depth_2(7:391))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse') %, 'XAxisLocation','top'
set(ax2,'FontWeight','Bold','FontSize',7,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); 
xticks([0 0.1 0.2 0.3 0.4]);
ax2.XTickLabel = {'0', '0.1', '0.2', '0.3', ''};
set(ax2,'YTick',[40.1 120.3 200.5 280.7 360.9]);
ax2.YTickLabel = {'', '', '', '', ''}; 

%label on top
t = text(0.0806, -31.7301, 'African: SZ', 'FontWeight','Bold','FontSize',9,'fontname','helvetica');
t2 = text(0.33, 345, 'c', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Antarctic Zone'})); 

%add AOU plot on top 
ax2 = axes;
set(ax2, 'Units', 'inches', 'Position',[3.8211 6.5520 1.0488 1.1700],'Box','on', 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_I06s_AZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_I06s_AZ(index,4);
    fake_std(in) = avg_AOU_I06s_AZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:391) + fake_std(1:391); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:391) - fake_std(1:391);
x2_2 = [fake_depth_2(1:391), fliplr(fake_depth_2(1:391))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse') %, 'XAxisLocation','top'
set(ax2,'FontWeight','Bold','FontSize',7,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); 
xticks([0 0.1 0.2 0.3 0.4]);
set(ax2,'YTick',[40.1 120.3 200.5 280.7 360.9]);
ax2.YTickLabel = {'', '', '', '', ''}; 

%label on top
t = text(0.0806, -31.7301, 'African: AZ', 'FontWeight','Bold','FontSize',9,'fontname','helvetica');
t2 = text(0.33, 345, 'd', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%add legend
fluor_label = {'1 SD';  'Average'}; 
leg1 = legend(fluor_label);
title(leg1,'Fluorescence')
set(leg1,'Units','inches', 'Position',[4.8699 6.5520 1.0488 1.1700])
hold off

% Detritus
detritus = {'Dense_agg_M_3'; 'Fiber_M_3'; 'Feces_M_3'; 'mc_aggregate_fluffy_M_3'; 
    'mc_aggregate_fluffy_elongated_M_3'; 'mc_aggregate_fluffy_grainy_to_aggregate_dense_M_3'; 
    'mc_aggregate_fluffy_grey_to_aggregate_badfocus_M_3'}; %'Fluffy agg'; 
detritus_label = {'Dense aggregate';  'Fiber'; 'Feces'; 'Fluffy agg circular'; 'Fluffy agg elongated'; 
    'Fluffy agg grainy/dense'; 'Fluffy agg gray/badfocus'; 'Fluffy agg other'}; 

%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Fluffy_agg_M_3(w(w2)));
    for index2 = 1:length(detritus)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(detritus(index2))));
    end
end
data(1:5,8) = super - sum(data(:,4:7),2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[0.6747 4.9920 1.0488 1.1700],'Box','on', 'Color', 'none');

X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); %added ax1 here
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];

set(ax1, 'YDir','reverse')
ax1.XLim = [0 630]; %ax1.XLim = [0 611]; %ax1.XLim = [0 730];
ax1.XTick = [0 200 400 600];
ax1.XTickLabel = {'0', '200', '400', ''};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
xlabel('                                                                                                       Abundance (# m^-^3)', ...
    'FontWeight','Bold','FontSize',9,'fontname','helvetica');
t2 = text(520, 4.9, 'e', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Antarctic Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Fluffy_agg_M_3(w(w2)));
    for index2 = 1:length(detritus)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(detritus(index2))));
    end
end
data(1:5,8) = super - sum(data(:,4:7),2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[1.7235 4.9920 1.0488 1.1700],'Box','on', 'Color', 'none');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];
set(ax1, 'YDir','reverse')
ax1.YTickLabel = {};
ax1.XLim = [0 630]; %ax1.XLim = [0 611]; %ax1.XLim = [0 730];
ax1.XTick = [0 200 400 600];
ax1.XTickLabel = {'0', '200', '400', ''};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(520, 4.9, 'f', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Fluffy_agg_M_3(w(w2)));
    for index2 = 1:length(detritus)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(detritus(index2))));
    end
end
data(1:5,8) = super - sum(data(:,4:7),2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[2.7723 4.9920 1.0488 1.1700],'Box','on');

X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 630]; %ax1.XLim = [0 611]; %ax1.XLim = [0 730];
ax1.XTick = [0 200 400 600];
ax1.XTickLabel = {'0', '200', '400', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(520, 4.9, 'g', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Antarctic Zone'})); 
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Fluffy_agg_M_3(w(w2)));
    for index2 = 1:length(detritus)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(detritus(index2))));
    end
end
data(1:5,8) = super - sum(data(:,4:7),2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[3.8211 4.9920 1.0488 1.1700],'Box','on');

X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 630]; %ax1.XLim = [0 611]; %ax1.XLim = [0 730];
ax1.XTick = [0 200 400 600];
ax1.XTickLabel = {'0', '200', '400', '600'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(500, 4.9, 'h', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%add legend
leg1 = legend(detritus_label);
title(leg1,'Detritus Categories')
set(leg1,'Units', 'inches', 'Position',[5 4.9920 1.2813 1.1700]); % 4.8150 4.8699


% rhizaria
 
Rhizaria_harosa = {'Acantharea_M_3'; 'Aulacantha_M_3'; 'Aulosphaeridae_M_3'; 'Cannosphaeridae_M_3';  ...
    'colonial_Cannosphaeridae_M_3'; 'Collodaria_M_3'; 'Medusettidae_M_3'; 'mc_aulosphaeridae_to_cannosphaeridae_M_3'; 
     'solitaryblack_M_3'; 'mc_solitary_black_to_puff_M_3'}; %'Rhizaria_M_3'; 'unknown_Phaeodaria_M_3'; 
Rhizaria_harosa_label = {'Acantharea'; 'Aulacantha';  'Aulosphaeridae'; 'Cannosphaeridae'; 
    'Cannosphaeridae colonial'; 'Collodaria'; 'Medusettidae'; 'Aulo./Canno. unknown'; 
    'Solitary black'; 'Solitary black/puff'; 'Rhizaria other'}; %'Phaeodaria unknown'; 
%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Rhizaria_harosa_M_3(w(w2)));
    for index2 = 1:length(Rhizaria_harosa)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Rhizaria_harosa(index2))));
    end
end
data(1:5,11) = super - sum(data,2);

%ax1 = axes('Position',[0.11 0.2 0.171 0.75],'Box','on');
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[0.6747 3.432 1.0488 1.1700],'Box','on', 'Color', 'none');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); %added ax1 here
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
%hb(12).FaceColor = [96/255 96/255 96/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 6]; %ax1.XLim = [0 13];
xticks([0 2 4 6])
ax1.XTickLabel = {'0', '2', '4', ''}; %ax1.XTickLabel = {'0', '5', '10'};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
xlabel('                                                                                                       Abundance (# m^-^3)', ...
    'FontWeight','Bold','FontSize',9,'fontname','helvetica');
t2 = text(5.3, 4.9, 'i', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Antarctic Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Rhizaria_harosa_M_3(w(w2)));
    for index2 = 1:length(Rhizaria_harosa)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Rhizaria_harosa(index2))));
    end
end
data(1:5,11) = super - sum(data,2);

%ax1 = axes('Position',[0.281 0.2 0.171 0.75],'Box','on');
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[1.7235 3.432 1.0488 1.1700],'Box','on', 'Color', 'none');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
%hb(12).FaceColor = [96/255 96/255 96/255];
set(ax1, 'YDir','reverse')
ax1.YTickLabel = {};
ax1.XLim = [0 6]; %ax1.XLim = [0 13];
xticks([0 2 4 6])
ax1.XTickLabel = {'0', '2', '4', ''}; %ax1.XTickLabel = {'0', '5', '10'};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(5.3, 4.9, 'j', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Rhizaria_harosa_M_3(w(w2)));
    for index2 = 1:length(Rhizaria_harosa)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Rhizaria_harosa(index2))));
    end
end
data(1:5,11) = super - sum(data,2);

%ax1 = axes('Position',[0.452 0.2 0.171 0.75],'Box','on');
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[2.7723 3.432 1.0488 1.1700],'Box','on', 'Color', 'none');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
%hb(12).FaceColor = [96/255 96/255 96/255];
set(ax1, 'YDir','reverse')
ax1.YTickLabel = {};
ax1.XLim = [0 6]; %ax1.XLim = [0 13];
xticks([0 2 4 6])
ax1.XTickLabel = {'0', '2', '4', ''}; %ax1.XTickLabel = {'0', '5', '10'};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(5.2, 4.9, 'k', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Antarctic Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Rhizaria_harosa_M_3(w(w2)));
    for index2 = 1:length(Rhizaria_harosa)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Rhizaria_harosa(index2))));
    end
end
data(1:5,11) = super - sum(data,2);

%ax1 = axes('Position',[0.623 0.2 0.171 0.75],'Box','on');
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[3.8211 3.432 1.0488 1.1700],'Box','on', 'Color', 'none');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
%hb(12).FaceColor = [96/255 96/255 96/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 6]; %ax1.XLim = [0 13];
xticks([0 2 4 6])
ax1.XTickLabel = {'0', '2', '4', ''}; %ax1.XTickLabel = {'0', '5', '10'};
text(5.7, 5.89, '6', 'FontWeight','Bold','FontSize',7,'fontname','helvetica')
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(5.3, 4.9, 'l', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%add legend
leg1 = legend(Rhizaria_harosa_label);
title(leg1,'Rhizarian Categories')
%set(leg1,'Position',[0.807 0.163 0.171 0.75]);  %set(leg1,'Position',[0.807 0.130 0.171 0.75]); %0.6775
%set(leg1,'Units','inches', 'Position',[4.8699 3.432 1.0488 1.1700])
set(leg1,'Units','inches', 'Position',[4.8699 3.0666 1.6229 1.5354])


% Gelatinous 
Gelatinous = {'Ctenophora_Metazoa_M_3'; 'Hydrozoa_M_3'; 
    'Narcomedusae_M_3'; 'Salpida_M_3'; 'Siphonophorae_M_3'; ...
    'tentacle_Cnidaria_M_3'}; %'house_M_3'; 'Cnidaria_Metazoa_M_3'; 'Solmundella_bitentaculata_M_3';
Gelatinous_label = {'Ctenophora'; ...
    'Hydrozoa'; 'Narcomedusae'; 'Salpida'; 'Siphonophorae'; ...
    'Tentacle'; 'Cnidaria other'}; %'Larvacean house'; 'Solmundella bitentaculata'
%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Gelatinous_M_3(w(w2)));
    for index2 = 1:length(Gelatinous)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Gelatinous(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[0.6747 1.872 1.0488 1.1700],'Box','on', 'Color', 'none');

X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); 
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 1.5]; %0.3]; 
xticks([0 0.5 1 1.5]); %[0 0.1 0.2 0.3]) 
ax1.XTickLabel = {'0', '0.5', '1', ''}; %{'0', '0.1', '0.2', ''};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
xlabel('                                                                                                       Abundance (# m^-^3)', ...
    'FontWeight','Bold','FontSize',9,'fontname','helvetica');
t2 = text(1.2, 4.9, 'm', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off;

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Antarctic Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Gelatinous_M_3(w(w2)));
    for index2 = 1:length(Gelatinous)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Gelatinous(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

%ax1 = axes('Position',[0.281 0.2 0.171 0.75],'Box','on');
ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[1.7235 1.872 1.0488 1.1700],'Box','on', 'Color', 'none');

X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
%hb(7).FaceColor = [255/255 255/255 51/255];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 1.5]; %0.3]; 
xticks([0 0.5 1 1.5]); %[0 0.1 0.2 0.3]) 
ax1.XTickLabel = {'0', '0.5', '1', ''}; %{'0', '0.1', '0.2', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(1.2, 4.9, 'n', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Gelatinous_M_3(w(w2)));
    for index2 = 1:length(Gelatinous)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Gelatinous(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[2.7723 1.872 1.0488 1.1700],'Box','on', 'Color', 'none');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
%hb(7).FaceColor = [255/255 255/255 51/255];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 1.5]; %0.3]; 
xticks([0 0.5 1 1.5]); %[0 0.1 0.2 0.3]) 
ax1.XTickLabel = {'0', '0.5', '1', ''}; %{'0', '0.1', '0.2', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(1.2, 4.9, 'o', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Antarctic Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Gelatinous_M_3(w(w2)));
    for index2 = 1:length(Gelatinous)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Gelatinous(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[3.8211 1.872 1.0488 1.1700],'Box','on', 'Color', 'none');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
%hb(7).FaceColor = [255/255 255/255 51/255];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 1.5]; %0.3]; 
xticks([0 0.5 1 1.5]); %[0 0.1 0.2 0.3]) 
ax1.XTickLabel = {'0', '0.5', '1', '1.5'}; %{'0', '0.1', '0.2', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(1.2, 4.9, 'p', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');

%add legend
leg1 = legend(Gelatinous_label);
title(leg1,'Gelatinous Categories')
set(leg1,'Units', 'inches', 'Position',[4.86 1.872 1.2813 1.1700]); % 4.8150 4.8699

%crustacea category names
crustacea = {'like_Amphipoda_M_3'; 'Copepoda_Maxillopoda_M_3'; 'like_Copepoda_M_3'; 'Hyperia_M_3'; ...
    'Ostracoda_M_3'; 'shrimp_like_M_3'}; %7 categories, deleted 'part_Copepoda_M_3', ; 'Crustacea_M_3'
crustacea_label = {'Amphipoda like'; 'Copepoda'; 'Copepoda like'; 'Hyperia';  ...
     'Ostracoda'; 'Shrimp like'; 'Crustacea other'};
 
%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Arthro_crustacea_M_3(w(w2)));
    for index2 = 1:length(crustacea)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(crustacea(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[0.6747 0.34 1.0488 1.1700],'Box','on', 'Color', 'none');

X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); %added ax1 here
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 3.25]; %ax1.XLim = [0 2]; %ax1.XLim = [0 4];
xticks([0 1 2 3]) %xticks([0 0.5 1 1.5 2])
ax1.XTickLabel = {'0', '1', '2', '3'}; %ax1.XTickLabel = {'0', '0.5', '1', '1.5', ''}; %ax1.XTickLabel = {'0', '2', ''};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
xlabel('                                                                                                       Abundance (# m^-^3)', ...
    'FontWeight','Bold','FontSize',9,'fontname','helvetica')
t2 = text(2.7, 4.9, 'q', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Antarctic Zone'})); 
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Arthro_crustacea_M_3(w(w2)));
    for index2 = 1:length(crustacea)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(crustacea(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[1.7235 0.34 1.0488 1.1700],'Box','on', 'Color', 'none');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.YTickLabel = {};
ax1.XLim = [0 3.25]; %ax1.XLim = [0 2]; %ax1.XLim = [0 4];
xticks([0 1 2 3]) %xticks([0 0.5 1 1.5 2])
ax1.XTickLabel = {'0', '1', '2', '3'}; %ax1.XTickLabel = {'0', '0.5', '1', '1.5', ''}; %ax1.XTickLabel = {'0', '2', ''};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(2.7, 4.9, 'r', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Arthro_crustacea_M_3(w(w2)));
    for index2 = 1:length(crustacea)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(crustacea(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[2.7723 0.34 1.0488 1.1700],'Box','on', 'Color', 'none');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 3.25]; %ax1.XLim = [0 2]; %ax1.XLim = [0 4];
xticks([0 1 2 3]) %xticks([0 0.5 1 1.5 2])
ax1.XTickLabel = {'0', '1', '2', '3'}; %ax1.XTickLabel = {'0', '0.5', '1', '1.5', ''}; %ax1.XTickLabel = {'0', '2', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(2.7, 4.9, 's', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Antarctic Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Arthro_crustacea_M_3(w(w2)));
    for index2 = 1:length(crustacea)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(crustacea(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes;
set(ax1, 'Units', 'inches', 'Position',[3.8211 0.34 1.0488 1.1700],'Box','on', 'Color', 'none');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 3.25]; %ax1.XLim = [0 2]; %ax1.XLim = [0 4];
xticks([0 1 2 3])%xticks([0 0.5 1 1.5 2])
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',7,'fontname','helvetica');
t2 = text(2.7, 4.9, 't', 'FontWeight','Bold','FontSize',15,'fontname','helvetica');

%add legend
leg1 = legend(crustacea_label);
title(leg1,'Crustacean Categories')
set(leg1,'Units', 'inches', 'Position',[4.86 0.34 1.2813 1.1700]); % 4.8150 4.8699


print('-dpng','-r350', 'G:/MS_Southern_Ocean/Figures/stacked_bar_plot_val_all_sz_az_20Feb2025');

%%
%crustacea category names
crustacea = {'like_Amphipoda_M_3'; 'Copepoda_Maxillopoda_M_3'; 'like_Copepoda_M_3'; 'Hyperia_M_3'; ...
    'Ostracoda_M_3'; 'shrimp_like_M_3'}; %7 categories, deleted 'part_Copepoda_M_3', ; 'Crustacea_M_3'
crustacea_label = {'Amphipoda like'; 'Copepoda'; 'Copepoda like'; 'Hyperia';  ...
     'Ostracoda'; 'Shrimp like'; 'Crustacea other'};
 
%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Arthro_crustacea_M_3(w(w2)));
    for index2 = 1:length(crustacea)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(crustacea(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

fig1 = figure; fig1.Position = [133 230 1318 319] ; %[396 289 793 475]; %396.2000 232.2000 736.8000 532
ax1 = axes('Position',[0.11 0.2 0.171 0.75],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); %added ax1 here
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 3.25]; %ax1.XLim = [0 2]; %ax1.XLim = [0 4];
xticks([0 1 2 3]) %xticks([0 0.5 1 1.5 2])
ax1.XTickLabel = {'0', '1', '2', '3'}; %ax1.XTickLabel = {'0', '0.5', '1', '1.5', ''}; %ax1.XTickLabel = {'0', '2', ''};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');
xlabel('                                                                                                                                  Abundance (# m^-^3)', ...
    'FontWeight','Bold','FontSize',14,'fontname','helvetica')
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Antarctic Zone'})); 
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Arthro_crustacea_M_3(w(w2)));
    for index2 = 1:length(crustacea)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(crustacea(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes('Position',[0.281 0.2 0.171 0.75],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.YTickLabel = {};
ax1.XLim = [0 3.25]; %ax1.XLim = [0 2]; %ax1.XLim = [0 4];
xticks([0 1 2 3]) %xticks([0 0.5 1 1.5 2])
ax1.XTickLabel = {'0', '1', '2', '3'}; %ax1.XTickLabel = {'0', '0.5', '1', '1.5', ''}; %ax1.XTickLabel = {'0', '2', ''};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Arthro_crustacea_M_3(w(w2)));
    for index2 = 1:length(crustacea)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(crustacea(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes('Position',[0.452 0.2 0.171 0.75],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 3.25]; %ax1.XLim = [0 2]; %ax1.XLim = [0 4];
xticks([0 1 2 3]) %xticks([0 0.5 1 1.5 2])
ax1.XTickLabel = {'0', '1', '2', '3'}; %ax1.XTickLabel = {'0', '0.5', '1', '1.5', ''}; %ax1.XTickLabel = {'0', '2', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Antarctic Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Arthro_crustacea_M_3(w(w2)));
    for index2 = 1:length(crustacea)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(crustacea(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes('Position',[0.623 0.2 0.171 0.75],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 3.25]; %ax1.XLim = [0 2]; %ax1.XLim = [0 4];
xticks([0 1 2 3])%xticks([0 0.5 1 1.5 2])
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add legend
leg1 = legend(crustacea_label);
title(leg1,'Crustacea Categories')
set(leg1,'Position',[0.794 0.2 0.171 0.75]); %0.6775, 0.797

print('-dpng','-r250', 'G:/MS_Southern_Ocean/Figures/stacked_bar_plot_val_crustacea_concentration_sz_az');
%print('-dpng','-r250', 'G:/MS_Southern_Ocean/Figures/stacked_bar_plot_val_pred_crustacea_concentration_sz_az');

%% Gelatinous 
%4 panel plot two on top S04p and 2 on bottom I06s, left side is Souther
%Zone data averaged and right side is Antarctic Zone data averaged, just
% abundance not relative

%4 of these, one with crustacea, one with gelatinous, one with rhizaria,
%and detritus supercategories

% clear all;
% %load data
% zoo_summary_new_s04p = readtable('G:\MS_Southern_Ocean\data\zoo_s04p_val_pred_phaeo_fluf_fiber_photo_summary_mean_new_depth_bins.csv');
% %remove extra stations in Southern Zone that aren't connected to main section
% zoo_summary_new_s04p = zoo_summary_new_s04p(1:515,:);
% zoo_summary_new_i06s = readtable('G:\MS_Southern_Ocean\data\zoo_i06s_val_pred_phaeo_fiber_photo_summary_mean_new_depth_bins.csv');
% 
% %load AOU data
% load('G:\MS_Southern_Ocean\data\Oxygen_sensor\avg_AOU_I06s_S04p_AZ_SZ.mat')
% 
% depth_bins_new = [0 200 500 1000 3000 6000];

%gelatinous category names
%Gelatinous = {'Ctenophora_Metazoa_M_3'; 'Hydrozoa_M_3'; 
%    'Narcomedusae_M_3'; 'Salpida_M_3'; 'Siphonophorae_M_3'; ...
%    'Solmundella_bitentaculata_M_3'; 'tentacle_Cnidaria_M_3'}; %'house_M_3'; 'Cnidaria_Metazoa_M_3'; 
Gelatinous = {'Ctenophora_Metazoa_M_3'; 'Hydrozoa_M_3'; 
    'Narcomedusae_M_3'; 'Salpida_M_3'; 'Siphonophorae_M_3'; ...
    'tentacle_Cnidaria_M_3'}; %'house_M_3'; 'Cnidaria_Metazoa_M_3'; 'Solmundella_bitentaculata_M_3';
%Gelatinous_label = {'Ctenophora'; ...
%    'Hydrozoa'; 'Narcomedusae'; 'Salpida'; 'Siphonophorae'; ...
%    'Solmundella bitentaculata'; 'Tentacle'; 'Cnidaria other'}; %'Larvacean house'; 
Gelatinous_label = {'Ctenophora'; ...
    'Hydrozoa'; 'Narcomedusae'; 'Salpida'; 'Siphonophorae'; ...
    'Tentacle'; 'Cnidaria other'}; %'Larvacean house'; 'Solmundella bitentaculata';

  
%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Gelatinous_M_3(w(w2)));
    for index2 = 1:length(Gelatinous)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Gelatinous(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

fig1 = figure; fig1.Position = [133 230 1318 319] ; %[396 289 793 475]; %396.2000 232.2000 736.8000 532
ax1 = axes('Position',[0.11 0.2 0.171 0.75],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); %added ax1 here
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
%hb(7).FaceColor = [255/255 255/255 51/255];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 0.3]; %ax1.XLim = [0 0.25]; %ax1.XLim = [0 4];
xticks([0 0.1 0.2 0.3]) %xticks([0 0.1 0.2])
ax1.XTickLabel = {'0', '0.1', '0.2', ''}; %ax1.XTickLabel = {'0', '0.1', '0.2'}; %ax1.XTickLabel = {'0', '2', ''};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');
xlabel('                                                                                                                                  Abundance (# m^-^3)', ...
    'FontWeight','Bold','FontSize',14,'fontname','helvetica');
hold off;

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Antarctic Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Gelatinous_M_3(w(w2)));
    for index2 = 1:length(Gelatinous)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Gelatinous(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes('Position',[0.281 0.2 0.171 0.75],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
%hb(7).FaceColor = [255/255 255/255 51/255];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 0.3]; %ax1.XLim = [0 0.25]; %ax1.XLim = [0 4];
xticks([0 0.1 0.2 0.3]) %xticks([0 0.1 0.2])
ax1.XTickLabel = {'0', '0.1', '0.2', ''}; %ax1.XTickLabel = {'0', '0.1', '0.2'}; %ax1.XTickLabel = {'0', '2', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Gelatinous_M_3(w(w2)));
    for index2 = 1:length(Gelatinous)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Gelatinous(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes('Position',[0.452 0.2 0.171 0.75],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
%hb(7).FaceColor = [255/255 255/255 51/255];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 0.3]; %ax1.XLim = [0 0.25]; %ax1.XLim = [0 4];
xticks([0 0.1 0.2 0.3]) %xticks([0 0.1 0.2])
ax1.XTickLabel = {'0', '0.1', '0.2', ''}; %ax1.XTickLabel = {'0', '0.1', '0.2'}; %ax1.XTickLabel = {'0', '2', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Antarctic Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Gelatinous_M_3(w(w2)));
    for index2 = 1:length(Gelatinous)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Gelatinous(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes('Position',[0.623 0.2 0.171 0.75],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
%hb(7).FaceColor = [255/255 255/255 51/255];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 0.3]; %ax1.XLim = [0 0.25]; %ax1.XLim = [0 4];
xticks([0 0.1 0.2 0.3]) %xticks([0 0.1 0.2])
ax1.XTickLabel = {'0', '0.1', '0.2', '0.3'}; %ax1.XTickLabel = {'0', '0.1', '0.2'}; %ax1.XTickLabel = {'0', '2', '4'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add legend
leg1 = legend(Gelatinous_label);
title(leg1,'Gelatinous Categories')
set(leg1,'Position',[0.794 0.2 0.171 0.75]); %set(leg1,'Position',[0.807 0.2 0.171 0.75]); %0.6775

print('-dpng','-r250', 'G:/MS_Southern_Ocean/Figures/stacked_bar_plot_val_gelatinous_concentration_sz_az');
%print('-dpng','-r250', 'G:/MS_Southern_Ocean/Figures/stacked_bar_plot_val_pred_gelatinous_concentration_sz_az_val');


%% rhizaria
%4 panel plot two on top S04p and 2 on bottom I06s, left side is Souther
%Zone data averaged and right side is Antarctic Zone data averaged, just
% abundance not relative

%4 of these, one with crustacea, one with gelatinous, one with rhizaria,
%and detritus supercategories

% clear all;
% %load data
% zoo_summary_new_s04p = readtable('G:\MS_Southern_Ocean\data\zoo_s04p_val_pred_phaeo_fluf_fiber_photo_summary_mean_new_depth_bins.csv');
% %remove extra stations in Southern Zone that aren't connected to main section
% zoo_summary_new_s04p = zoo_summary_new_s04p(1:515,:);
% zoo_summary_new_i06s = readtable('G:\MS_Southern_Ocean\data\zoo_i06s_val_pred_phaeo_fiber_photo_summary_mean_new_depth_bins.csv');
% 
% %load AOU data
% load('G:\MS_Southern_Ocean\data\Oxygen_sensor\avg_AOU_I06s_S04p_AZ_SZ.mat')
% 
% depth_bins_new = [0 200 500 1000 3000 6000];

%rhizaria category names
% Rhizaria_harosa = {'Acantharea_M_3'; 'Aulacantha_M_3'; 'Aulosphaeridae_M_3'; 'Cannosphaeridae_M_3';  ...
%     'colonial_Cannosphaeridae_M_3'; 'Collodaria_M_3'; 'Medusettidae_M_3'; 'mc_aulosphaeridae_to_cannosphaeridae_M_3'; 
%      'unknown_Phaeodaria_M_3'; 'solitaryblack_M_3'; 'mc_solitary_black_to_puff_M_3'}; %'Rhizaria_M_3'; 
% Rhizaria_harosa_label = {'Acantharea'; 'Aulacantha';  'Aulosphaeridae'; 'Cannosphaeridae'; 
%     'Cannosphaeridae colonial'; 'Collodaria'; 'Medusettidae'; 'Aulo./Canno. unknown'; 'Phaeodaria unknown'; 
%     'Solitary black'; 'Solitary black/puff'; 'Rhizaria other'}; 
 
Rhizaria_harosa = {'Acantharea_M_3'; 'Aulacantha_M_3'; 'Aulosphaeridae_M_3'; 'Cannosphaeridae_M_3';  ...
    'colonial_Cannosphaeridae_M_3'; 'Collodaria_M_3'; 'Medusettidae_M_3'; 'mc_aulosphaeridae_to_cannosphaeridae_M_3'; 
     'solitaryblack_M_3'; 'mc_solitary_black_to_puff_M_3'}; %'Rhizaria_M_3'; 'unknown_Phaeodaria_M_3'; 
Rhizaria_harosa_label = {'Acantharea'; 'Aulacantha';  'Aulosphaeridae'; 'Cannosphaeridae'; 
    'Cannosphaeridae colonial'; 'Collodaria'; 'Medusettidae'; 'Aulo./Canno. unknown'; 
    'Solitary black'; 'Solitary black/puff'; 'Rhizaria other'}; %'Phaeodaria unknown'; 
%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Rhizaria_harosa_M_3(w(w2)));
    for index2 = 1:length(Rhizaria_harosa)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Rhizaria_harosa(index2))));
    end
end
data(1:5,11) = super - sum(data,2);

fig1 = figure; fig1.Position = [133 230 1318 319] ; %[396 289 793 475]; %396.2000 232.2000 736.8000 532
ax1 = axes('Position',[0.11 0.2 0.171 0.75],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); %added ax1 here
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
%hb(12).FaceColor = [96/255 96/255 96/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 6]; %ax1.XLim = [0 13];
xticks([0 2 4 6])
ax1.XTickLabel = {'0', '2', '4', ''}; %ax1.XTickLabel = {'0', '5', '10'};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');
xlabel('                                                                                                                                  Abundance (# m^-^3)', ...
    'FontWeight','Bold','FontSize',14,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Antarctic Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Rhizaria_harosa_M_3(w(w2)));
    for index2 = 1:length(Rhizaria_harosa)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Rhizaria_harosa(index2))));
    end
end
data(1:5,11) = super - sum(data,2);

ax1 = axes('Position',[0.281 0.2 0.171 0.75],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
%hb(12).FaceColor = [96/255 96/255 96/255];
set(ax1, 'YDir','reverse')
ax1.YTickLabel = {};
ax1.XLim = [0 6]; %ax1.XLim = [0 13];
xticks([0 2 4 6])
ax1.XTickLabel = {'0', '2', '4', ''}; %ax1.XTickLabel = {'0', '5', '10'};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Rhizaria_harosa_M_3(w(w2)));
    for index2 = 1:length(Rhizaria_harosa)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Rhizaria_harosa(index2))));
    end
end
data(1:5,11) = super - sum(data,2);

ax1 = axes('Position',[0.452 0.2 0.171 0.75],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
%hb(12).FaceColor = [96/255 96/255 96/255];
set(ax1, 'YDir','reverse')
ax1.YTickLabel = {};
ax1.XLim = [0 6]; %ax1.XLim = [0 13];
xticks([0 2 4 6])
ax1.XTickLabel = {'0', '2', '4', ''}; %ax1.XTickLabel = {'0', '5', '10'};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Antarctic Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Rhizaria_harosa_M_3(w(w2)));
    for index2 = 1:length(Rhizaria_harosa)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Rhizaria_harosa(index2))));
    end
end
data(1:5,11) = super - sum(data,2);

ax1 = axes('Position',[0.623 0.2 0.171 0.75],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
%hb(12).FaceColor = [96/255 96/255 96/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 6]; %ax1.XLim = [0 13];
xticks([0 2 4 6])
ax1.XTickLabel = {'0', '2', '4', ''}; %ax1.XTickLabel = {'0', '5', '10'};
text(5.7, 5.89, '6', 'FontWeight','Bold','FontSize',14,'fontname','helvetica')
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add legend
leg1 = legend(Rhizaria_harosa_label);
title(leg1,'Rhizaria Categories')
set(leg1,'Position',[0.807 0.163 0.171 0.75]);  %set(leg1,'Position',[0.807 0.130 0.171 0.75]); %0.6775

%print('-dpng','-r250', 'G:/MS_Southern_Ocean/Figures/stacked_bar_plot_val_pred_rhizaria_concentration_sz_az');
print('-dpng','-r250', 'G:/MS_Southern_Ocean/Figures/stacked_bar_plot_val_rhizaria_concentration_sz_az');


%% Detritus
%4 panel plot two on top S04p and 2 on bottom I06s, left side is Souther
%Zone data averaged and right side is Antarctic Zone data averaged, just
% abundance not relative

%4 of these, one with crustacea, one with gelatinous, one with rhizaria,
%and detritus supercategories

% clear all;
% %load data
% zoo_summary_new_s04p = readtable('G:\MS_Southern_Ocean\data\zoo_s04p_val_pred_phaeo_fluf_fiber_photo_summary_mean_new_depth_bins.csv');
% %remove extra stations in Southern Zone that aren't connected to main section
% zoo_summary_new_s04p = zoo_summary_new_s04p(1:515,:);
% zoo_summary_new_i06s = readtable('G:\MS_Southern_Ocean\data\zoo_i06s_val_pred_phaeo_fiber_photo_summary_mean_new_depth_bins.csv');
% 
% %load AOU data
% load('G:\MS_Southern_Ocean\data\Oxygen_sensor\avg_AOU_I06s_S04p_AZ_SZ.mat')
% 
% depth_bins_new = [0 200 500 1000 3000 6000];

%rhizaria category names
detritus = {'Dense_agg_M_3'; 'Fiber_M_3'; 'Feces_M_3'; 'mc_aggregate_fluffy_M_3'; 
    'mc_aggregate_fluffy_elongated_M_3'; 'mc_aggregate_fluffy_grainy_to_aggregate_dense_M_3'; 
    'mc_aggregate_fluffy_grey_to_aggregate_badfocus_M_3'}; %'Fluffy agg'; 
detritus_label = {'Dense aggregate';  'Fiber'; 'Feces'; 'Fluffy agg circular'; 'Fluffy agg elongated'; 
    'Fluffy agg grainy/dense'; 'Fluffy agg gray/badfocus'; 'Fluffy agg other'}; 

%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Fluffy_agg_M_3(w(w2)));
    for index2 = 1:length(detritus)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(detritus(index2))));
    end
end
data(1:5,8) = super - sum(data(:,4:7),2);

fig1 = figure; fig1.Position = [133 230 1318 319] ; %[396 289 793 475]; %396.2000 232.2000 736.8000 532
ax1 = axes('Position',[0.11 0.2 0.171 0.75],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); %added ax1 here
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];

set(ax1, 'YDir','reverse')
ax1.XLim = [0 611]; %ax1.XLim = [0 730];
ax1.XTickLabel = {'0', '200', '400', ''};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');
xlabel('                                                                                                                                  Abundance (# m^-^3)', ...
    'FontWeight','Bold','FontSize',14,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Antarctic Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Fluffy_agg_M_3(w(w2)));
    for index2 = 1:length(detritus)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(detritus(index2))));
    end
end
data(1:5,8) = super - sum(data(:,4:7),2);

ax1 = axes('Position',[0.281 0.2 0.171 0.75],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];
set(ax1, 'YDir','reverse')
ax1.YTickLabel = {};
ax1.XLim = [0 611]; %ax1.XLim = [0 730];
ax1.XTickLabel = {'0', '200', '400', ''};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Fluffy_agg_M_3(w(w2)));
    for index2 = 1:length(detritus)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(detritus(index2))));
    end
end
data(1:5,8) = super - sum(data(:,4:7),2);

ax1 = axes('Position',[0.452 0.2 0.171 0.75],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 611]; %ax1.XLim = [0 730];
ax1.XTickLabel = {'0', '200', '400', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Antarctic Zone'})); 
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Fluffy_agg_M_3(w(w2)));
    for index2 = 1:length(detritus)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(detritus(index2))));
    end
end
data(1:5,8) = super - sum(data(:,4:7),2);

ax1 = axes('Position',[0.623 0.2 0.171 0.75],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 611]; %ax1.XLim = [0 730];
ax1.XTickLabel = {'0', '200', '400', '600'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add legend
leg1 = legend(detritus_label);
title(leg1,'Detritus Categories')
set(leg1,'Position',[0.804 0.2 0.171 0.75]); %0.6775

%print('-dpng','-r250', 'G:/MS_Southern_Ocean/Figures/stacked_bar_plot_val_pred_detritus_concentration_sz_az');
print('-dpng','-r250', 'G:/MS_Southern_Ocean/Figures/stacked_bar_plot_val_detritus_concentration_sz_az');

%% fluorescence line plot

%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
fig1 = figure; fig1.Position = [133 230 1318 319] ; %[396 289 793 475]; %396.2000 232.2000 736.8000 532

%add AOU plot on top
ax2 = axes('Position',[0.11 0.2 0.171 0.75],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_S04p_SZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_S04p_SZ(index,4);
    fake_std(in) = avg_AOU_S04p_SZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:377) + fake_std(1:377); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:377) - fake_std(1:377);
x2_2 = [fake_depth_2(1:377), fliplr(fake_depth_2(1:377))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse') %, 'XAxisLocation','top'
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); 
xticks([0 0.1 0.2 0.3 0.4])
ax2.XTickLabel = {'0', '0.1', '0.2', '0.3', ''};
set(ax2,'YTick',[40.1 120.3 200.5 280.7 360.9]);
ax2.YTickLabel = {'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'}; 
ylabel('Depth (m)')
xlabel('                                                                                                                                  Fluorescence (RFU)', ...
    'FontWeight','Bold','FontSize',14,'fontname','helvetica');
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Antarctic Zone'})); 

%add AOU plot on top
ax2 = axes('Position',[0.281 0.2 0.171 0.75],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_S04p_AZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_S04p_AZ(index,4);
    fake_std(in) = avg_AOU_S04p_AZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:375) + fake_std(1:375); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:375) - fake_std(1:375);
x2_2 = [fake_depth_2(1:375), fliplr(fake_depth_2(1:375))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse') %, 'XAxisLocation','top'
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]);
xticks([0 0.1 0.2 0.3 0.4]);
ax2.XTickLabel = {'0', '0.1', '0.2', '0.3', ''};
set(ax2,'YTick',[40.1 120.3 200.5 280.7 360.9]);
ax2.YTickLabel = {'', '', '', '', ''}; 
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 

%add AOU plot on top
ax2 = axes('Position',[0.452 0.2 0.171 0.75],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_I06s_SZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_I06s_SZ(index,4);
    fake_std(in) = avg_AOU_I06s_SZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(7:391) + fake_std(7:391); %cut out nans at the end of the variable
curve2_2 = fake_AOU(7:391) - fake_std(7:391);
x2_2 = [fake_depth_2(7:391), fliplr(fake_depth_2(7:391))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse') %, 'XAxisLocation','top'
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); 
xticks([0 0.1 0.2 0.3 0.4]);
ax2.XTickLabel = {'0', '0.1', '0.2', '0.3', ''};
set(ax2,'YTick',[40.1 120.3 200.5 280.7 360.9]);
ax2.YTickLabel = {'', '', '', '', ''}; 
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Antarctic Zone'})); 

%add AOU plot on top
ax2 = axes('Position',[0.623 0.2 0.171 0.75],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_I06s_AZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_I06s_AZ(index,4);
    fake_std(in) = avg_AOU_I06s_AZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:391) + fake_std(1:391); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:391) - fake_std(1:391);
x2_2 = [fake_depth_2(1:391), fliplr(fake_depth_2(1:391))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse') %, 'XAxisLocation','top'
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); 
xticks([0 0.1 0.2 0.3 0.4]);
set(ax2,'YTick',[40.1 120.3 200.5 280.7 360.9]);
ax2.YTickLabel = {'', '', '', '', ''}; 
hold off

%add legend
fluor_label = {'1 SD';  'Average'}; 
leg1 = legend(fluor_label);
title(leg1,'Fluorescence')
set(leg1,'Position',[0.794 0.2 0.171 0.75]); %0.6775

print('-dpng','-r250', 'G:/MS_Southern_Ocean/Figures/stacked_bar_plot_val_pred_fluorescence_concentration_sz_az_Fluorescense');

%% % %plotting stacked bar plots to look at living particle types over depth

%for I06S

%save structure as csv for PCA
clear all;
%load('G:\MS_Southern_Ocean\data\zoo_i06s_val_pred_photo_no_fiber_3Apr2024.mat')
%load('G:\MS_Southern_Ocean\data\zoo_i06s_val_photo_no_fiber_3Apr2024.mat')
load('G:\MS_Southern_Ocean\data\zoo_i06s_val_photo_no_fiber_5Sept2024.mat')

load('G:/Cruises/2019_I06S/uvp5_sn207_2019_i06s_tcn322_ecotaxa_export_par2.mat'); %use this one
zoo.water_mass = par.water_mass;
%writetable(struct2table(zoo), 'G:\MS_Southern_Ocean\data\zoo_i06s_val_pred_photo_no_fiber_3Apr2024.csv')
%writetable(struct2table(zoo), 'G:\MS_Southern_Ocean\data\zoo_i06s_val_photo_no_fiber_3Apr2024.csv')
writetable(struct2table(zoo), 'G:\MS_Southern_Ocean\data\zoo_i06s_val_photo_no_fiber_5Sept2024.csv')


% %get categories
% zoo_txt = readtable('G:/MS_Southern_Ocean/data/i06s_ecotaxa_export.txt');
% %zoo_txt = readtable('G:/MS_Southern_Ocean/data/s04p_ecotaxa_export.txt');
% %Replace category names that are too long with shorter ones
% zoo_txt.object_annotation_category(:) = strrep(zoo_txt.object_annotation_category(:), ... 
%     {'mc+aggregate-dense-two-black-elements-to-aggregate-fluffy-dark'},{'mc+aggregate-dense-2-black-to-aggregate-fluffy-dark'}); 
% zoo_txt.object_annotation_category(:) = strrep(zoo_txt.object_annotation_category(:), ... 
%     {'mc+aggregate-fluffy-elongated-to-aggregate-dense-elongated'},{'mc+aggregate-fluffy-elongated-to-aggregate-dense-elong'}); 
% categories = unique(zoo_txt.object_annotation_category);
% %change all special variables 
% categories(:) = strrep(categories(:),'+','_'); categories(:) = strrep(categories(:),'<','_');
% categories(:) = strrep(categories(:),'-','_'); categories(:) = strrep(categories(:),' ','_');
% categories = [categories; {'Fluffy_agg'}; {'Dense_agg'}; {'Fiber'}; {'Feces'}; {'Bad_focus'}; {'Not_relevant'}; {'Photosynthetic'}; ...
%     {'Rhizaria_harosa'}; {'Arthro_crustacea'}; {'Gelatinous'}; {'Metazoa'}; {'Living'}; {'Detritus'}];

%I06s val categories %edit this later
categories = {'like_Trichodesmium'; 'puff'; 'tuff'; 'Rhizaria'; 'Phaeodaria'; 'Castanellidae'; 'Circoporidae'; ...
'Tuscaroridae'; 'Aulacantha'; 'Aulographis'; 'mc_aulacantha_to_foraminifera'; 'Coelodendrum'; 'Coelographis'; ...
'leg_Coelodendridae'; 'Medusettidae'; 'Aulosphaeridae'; 'Aulatractus'; 'colonial_Aulosphaeridae'; ...
'mc_aulosphaeridae_to_cannosphaeridae'; 'Cannosphaeridae'; 'colonial_Cannosphaeridae'; ...
'Acantharea'; 'Foraminifera'; 'Collodaria'; 'colonial_Collodaria'; 'mc_solitary_black_to_puff'; 'solitaryblack'; ...
'Annelida';  'Polychaeta'; 'Poeobius'; 'Crustacea'; 'Hyperia'; 'like_Amphipoda'; 'shrimp_like'; 'Copepoda_Maxillopoda'; ...
'like_Copepoda'; 'Ostracoda'; 'Chaetognatha'; 'Teleostei'; 'fish_egg'; ...
'house';  'Salpida'; 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 'Narcomedusae';  ...
'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 'Mollusca'; 'Cephalopoda'; 'Phaeocystis'; 'badfocus_to_small_aggregates'; ...
'badfocus_to_turbid'; 'mc_badfocus_aggregate_elongated'; 'mc_badfocus_aggregate_fluffy'; ...
'mc_badfocus_aggregate_fluffy_to_badfocus_rhizaria'; 'bubble'; 'not_relevant_duplicate'; ...
'mc_aggregate_dense_amorphous_to_detritus_dense_round'; 'mc_aggregate_dense_dark_round_to_rhizaria'; ...
'mc_aggregate_dense_elongated_to_aggregate_fluffy'; 'mc_aggregate_dense_elongated_two_elements_to_bubbles'; ...
'mc_aggregate_dense_to_aggregate_fluffy_dark'; 'mc_aggregate_dense_to_crustacea'; 'mc_aggregate_dense_to_feces'; ...
'mc_aggregate_dense_2_black_to_aggregate_fluffy_dark'; 'mc_aggregate_fluffy'; 'mc_aggregate_dark_round_to_puff'; ...
'mc_aggregate_fluffy_dark_to_aggregate_dense'; 'mc_aggregate_fluffy_elongated'; ...
'mc_aggregate_fluffy_elongated_to_aggregate_dense_elong'; 'mc_aggregate_fluffy_grainy'; 'mc_aggregate_fluffy_grainy_elongated'; ...
'mc_aggregate_fluffy_grainy_to_aggregate_dense'; 'mc_aggregate_fluffy_grey'; 'mc_aggregate_fluffy_grey_elongated'; ...
'mc_aggregate_fluffy_grey_to_aggregate_badfocus'; 'mc_aggregate_fluffy_grey_to_rhizaria'; 'mc_fiber_fluffy_to_feces'; ...
'mc_fiber_thin_to_fiber_fluffy'; 'mc_fiber_thin_straight'; 'mc_fiber_thin_straight_with_black_element'; 'feces_little_fluffy'; ...
'mc_feces_bent_circular_fluffy'; 'mc_feces_bent_thin'; 'mc_feces_bent_to_crustacea'; 'mc_feces_dark_roundish'; ...
'mc_feces_dark_small_irregular_shape'; 'mc_feces_short_straight'; 'mc_feces_small_round_grey'; 'mc_feces_straight_to_feces_bent'; ...
'mc_feces_straight_fluffy'; 'mc_feces_straight_fluffy_to_trichodesmium_tuff'; 'mc_feces_straight_thin'; 'mc_feces_to_copepoda'; ...
'mc_feces_to_fiber'; 'mc_feces_straight_thin_to_fiber'; 't001'; 't003'; 't006';'t020'; 'Fluffy_agg'; ...
'Dense_agg'; 'Fiber'; 'Feces'; 'Bad_focus'; 'Not_relevant'; 'Photosynthetic'; 'Rhizaria_harosa'; 'Arthro_crustacea';...
'Gelatinous'; 'Metazoa'; 'Living'; 'Detritus'}; %'egg_Teleostei';  'Appendicularia';'Doliolida'; 'unknown_Phaeodaria'; 
% 'part_Copepoda'; 'Solmundella_bitentaculata'; 't005'; 

label_end = [{'_num'}; {'_M_3'}; {'_mm3L_1'}; {'_mm'}; {'_grey'}]; 

% add frontal zone info
zoo.frontal_zone = {}; %create cell array within structure
w = find(zoo.latitude > -40.6662); %North of STF
zoo.frontal_zone(w,1) = {'Subtropical Zone'}; 
w = find(zoo.latitude > -49 & zoo.latitude <= -40.6662); %North of SAF
zoo.frontal_zone(w,1) = {'Subantarctic Zone'}; 
w = find(zoo.latitude > -53.5 & zoo.latitude <= -49); %North of PF
zoo.frontal_zone(w,1) = {'Polar Frontal Zone'}; 
w = find(zoo.latitude > -55.9998 & zoo.latitude <= -53.5); %North of SACCF
zoo.frontal_zone(w,1) = {'Antarctic Zone'}; 
w = find(zoo.latitude > -60.7523 & zoo.latitude <= -55.9998); %North of SBDY
zoo.frontal_zone(w,1) = {'Southern Zone'}; 
w = find(zoo.latitude <= -60.7523); %South of SBDY
zoo.frontal_zone(w,1) = {'Subpolar Region'};

%% create structure array

stations = unique(zoo.site); 
%for S04P, remove station 84
stations(74)=[]; %updated for 20Feb2025 from 77

for index = 1: length(stations)
    depth_bins_all = [0 200 500 1000 3000 6000];
    w = find(zoo.site == stations(index));
    depth_bins_stn = depth_bins_all(depth_bins_all <= max(zoo.Depth(w)));
    bigger = depth_bins_all(depth_bins_all > max(zoo.Depth(w)));
    depth_bins_stn2 = [depth_bins_stn bigger(1)];
    depth_bins_stn = [depth_bins_stn max(zoo.Depth(w))];
    for index2 = 1:length(depth_bins_stn)-1
        if index2 < length(depth_bins_stn)-1
            w2 = find(zoo.Depth(w)>=depth_bins_stn(index2) & zoo.Depth(w)< depth_bins_stn(index2+1));
        else 
            w2 = find(zoo.Depth(w)>=depth_bins_stn(index2) & zoo.Depth(w)<= depth_bins_stn(index2+1));
        end
        if index == 1 && index2 == 1 %no concactionation
            zoo_summary.cruise = zoo.cruise(w(w2(1)));
            zoo_summary.site = zoo.site(w(w2(1)));
            zoo_summary.profile = zoo.profile(w(w2(1)));
            zoo_summary.dataowner = zoo.dataowner(w(w2(1)));
            zoo_summary.rawfilename = zoo.rawfilename(w(w2(1)));
            zoo_summary.instrument = zoo.instrument(w(w2(1)));
            zoo_summary.sn = zoo.sn(w(w2(1)));
            zoo_summary.ctdrosettefilename = zoo.ctdrosettefilename(w(w2(1)));
            zoo_summary.datetime = zoo.datetime(w(w2(1)));
            zoo_summary.latitude = zoo.latitude(w(w2(1)));
            zoo_summary.longitude = zoo.longitude(w(w2(1)));
            zoo_summary.Depth = zoo.Depth(w(w2(1)));
            zoo_summary.Depth_range(1) = {[depth_bins_stn(index2) depth_bins_stn(index2+1)]};
            zoo_summary.Depth_range2(1) = {[depth_bins_stn2(index2) depth_bins_stn2(index2+1)]};
            zoo_summary.SampledVolume_L_ = sum(zoo.SampledVolume_L_(w(w2)));
            zoo_summary.water_mass = zoo.water_mass(w(w2(1)));
            zoo_summary.frontal_zone = zoo.frontal_zone(w(w2(1)));
            formatSpec = 'zoo_summary.%s%s = sum([zoo.%s%s(w(w2))], "omitnan");'; 
            formatSpec_mean = 'zoo_summary.%s%s = mean([zoo.%s%s(w(w2))], "omitnan");'; 
            formatSpec_mean_w_0 = 'zoo_summary.%s%s = mean([zoo.%s%s(w(w2))]);'; 
            formatSpec_nan_zero = 'zoo.%s%s(isnan(zoo.%s%s))=0;';
            for index3 = 1:length(label_end) %loop through label_end
                for index4 = 1:length(categories) %loop through catgories
                    if index3 == 1 %%%%%%%%editing here moving index 3 = 2 and 3 to mean value
                        eval(sprintf(formatSpec, char(categories(index4)), char(label_end(index3)), char(categories(index4)), char(label_end(index3)))); 
                    end
                    if index3 == 2 || index3 == 3  %%%%edited this added index3 = 2 and 3
                        eval(sprintf(formatSpec_nan_zero, char(categories(index4)), char(label_end(index3)), char(categories(index4)), char(label_end(index3))));
                        eval(sprintf(formatSpec_mean_w_0, char(categories(index4)), char(label_end(index3)), char(categories(index4)), char(label_end(index3)))); 
                    end
                    if index3 == 4 || index3 == 5 %%%%edited this added index3 = 2 and 3
                        eval(sprintf(formatSpec_mean, char(categories(index4)), char(label_end(index3)), char(categories(index4)), char(label_end(index3)))); 
                    end
                end
            end
        else %concactionation
            zoo_summary.cruise = [zoo_summary.cruise; zoo.cruise(w(w2(1)))];
            zoo_summary.site = [zoo_summary.site; zoo.site(w(w2(1)))];
            zoo_summary.profile = [zoo_summary.profile; zoo.profile(w(w2(1)))];
            zoo_summary.dataowner = [zoo_summary.dataowner; zoo.dataowner(w(w2(1)))];
            zoo_summary.rawfilename = [zoo_summary.rawfilename; zoo.rawfilename(w(w2(1)))];
            zoo_summary.instrument = [zoo_summary.instrument; zoo.instrument(w(w2(1)))];
            zoo_summary.sn = [zoo_summary.sn ; zoo.sn(w(w2(1)))];
            zoo_summary.ctdrosettefilename = [zoo_summary.ctdrosettefilename; zoo.ctdrosettefilename(w(w2(1)))];
            zoo_summary.datetime = [zoo_summary.datetime; zoo.datetime(w(w2(1)))];
            zoo_summary.latitude = [zoo_summary.latitude; zoo.latitude(w(w2(1)))];
            zoo_summary.longitude = [zoo_summary.longitude; zoo.longitude(w(w2(1)))];
            zoo_summary.Depth = [zoo_summary.Depth; zoo.Depth(w(w2(1)))];
            zoo_summary.Depth_range = [zoo_summary.Depth_range; {[depth_bins_stn(index2) depth_bins_stn(index2+1)]}];
            zoo_summary.Depth_range2 = [zoo_summary.Depth_range2; {[depth_bins_stn2(index2) depth_bins_stn2(index2+1)]}];
            zoo_summary.SampledVolume_L_ = [zoo_summary.SampledVolume_L_; sum(zoo.SampledVolume_L_(w(w2)))];
            zoo_summary.water_mass = [zoo_summary.water_mass; zoo.water_mass(w(w2(1)))];
            zoo_summary.frontal_zone = [zoo_summary.frontal_zone; zoo.frontal_zone(w(w2(1)))];
            formatSpec = 'zoo_summary.%s%s = [zoo_summary.%s%s; sum([zoo.%s%s(w(w2))], "omitnan")];'; 
            formatSpec_mean = 'zoo_summary.%s%s = [zoo_summary.%s%s; mean([zoo.%s%s(w(w2))], "omitnan")];'; 
            formatSpec_mean_w_0 = 'zoo_summary.%s%s = [zoo_summary.%s%s; mean([zoo.%s%s(w(w2))])];'; 
            formatSpec_nan_zero = 'zoo.%s%s(isnan(zoo.%s%s))=0;';
            for index3 = 1:length(label_end) %loop through label_end
                for index4 = 1:length(categories) %loop through catgories
                    if index3 == 1 %loop through label_end
                        eval(sprintf(formatSpec, char(categories(index4)), char(label_end(index3)), char(categories(index4)), ...
                            char(label_end(index3)), char(categories(index4)), char(label_end(index3)))); 
                    end
                    if index3 == 2 || index3 == 3  %%%%edited this added index3 = 2 and 3
                        eval(sprintf(formatSpec_nan_zero, char(categories(index4)), char(label_end(index3)), char(categories(index4)), ...
                            char(label_end(index3)))); 
                        eval(sprintf(formatSpec_mean_w_0, char(categories(index4)), char(label_end(index3)), char(categories(index4)), ...
                            char(label_end(index3)), char(categories(index4)), char(label_end(index3)))); 
                    end
                    if index3 == 4 || index3 == 5 %%%%edited this added index3 = 2 and 3
                        eval(sprintf(formatSpec_mean, char(categories(index4)), char(label_end(index3)), char(categories(index4)), ...
                            char(label_end(index3)), char(categories(index4)), char(label_end(index3)))); 
                    end
                end
            end
        end
    end
end

%writetable(struct2table(zoo_summary), 'G:\MS_Southern_Ocean\data\zoo_i06s_val_pred_photo_no_fiber_3Apr2024_summary_mean_new_depth_bins.csv')
%writetable(struct2table(zoo_summary), 'G:\MS_Southern_Ocean\data\zoo_i06s_val_photo_no_fiber_3Apr2024_summary_mean_new_depth_bins.csv')
%writetable(struct2table(zoo_summary), 'G:\MS_Southern_Ocean\data\zoo_i06s_val_photo_no_fiber_5Sept2024_summary_mean_new_depth_bins.csv')
%writetable(struct2table(zoo_summary), 'G:\MS_Southern_Ocean\data\zoo_s04p_val_pred_photo_no_fiber_3Apr2024_summary_mean_new_depth_bins.csv')
%writetable(struct2table(zoo_summary), 'G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_3Apr2024_summary_mean_new_depth_bins.csv')
%writetable(struct2table(zoo_summary), 'G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_5Sept2024_summary_mean_new_depth_bins.csv')
writetable(struct2table(zoo_summary), 'G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_20Feb2025_summary_mean_new_depth_bins.csv')

%%
clear all;

%load('G:\MS_Southern_Ocean\data\zoo_s04p_val_pred_photo_no_fiber_3Apr2024.mat')
%load('G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_3Apr2024.mat')
%load('G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_5Sept2024.mat')
%load('G:\Cruises\2018_S04P\uvp5_sn207_2018_s04p_ecotaxa_export_par2')
load('G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_20Feb2025.mat')
load('G:\Cruises\2018_S04P\uvp5_sn207_2018_s04p_ecotaxa_export_par2_filtered_AOU_fluor_sitecorrect.mat')

zoo.water_mass = par.water_mass;
%writetable(struct2table(zoo), 'G:\MS_Southern_Ocean\data\zoo_s04p_val_pred_photo_no_fiber_3Apr2024.csv')
%writetable(struct2table(zoo), 'G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_3Apr2024.csv')
%writetable(struct2table(zoo), 'G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_5Sept2024.csv')
writetable(struct2table(zoo), 'G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_20Feb2025.csv')

% %S04P: add lines and text labeling fronts and zones
% line([wrapTo360(-131.252) wrapTo360(-131.252)], [0 max(zoo.Depth(w))],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5 %SBDY
% line([wrapTo360(-104.0791) wrapTo360(-104.0791)], [0 max(zoo.Depth(w))],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5 % SACCF
% line([wrapTo360(-78.4832) wrapTo360(-78.4832)], [0
% max(zoo.Depth(w))],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5 %SACCF
zoo.frontal_zone = {}; %create cell array within structure
w = find(wrapTo360(zoo.longitude) <= wrapTo360(-131.252)); %West of SBDY
zoo.frontal_zone(w,1) = {'Subpolar Region'}; 
w = find(wrapTo360(zoo.longitude) >  wrapTo360(-131.252) & wrapTo360(zoo.longitude) <=  wrapTo360(-104.0791)); %West of SACCF
zoo.frontal_zone(w,1) = {'Southern Zone'}; 
w = find(wrapTo360(zoo.longitude) >  wrapTo360(-104.0791) & wrapTo360(zoo.longitude) <=  wrapTo360(-78.4832)); %West of SACCF
zoo.frontal_zone(w,1) = {'Antarctic Zone'}; 
w = find(wrapTo360(zoo.longitude) >  wrapTo360(-78.4832)); %East of SACCF
zoo.frontal_zone(w,1) = {'Southern Zone'};


% %get categories
% zoo_txt = readtable('G:/MS_Southern_Ocean/data/s04p_ecotaxa_export.txt');
% %Replace category names that are too long with shorter ones
% zoo_txt.object_annotation_category(:) = strrep(zoo_txt.object_annotation_category(:), ... 
%     {'mc+aggregate-dense-two-black-elements-to-aggregate-fluffy-dark'},{'mc+aggregate-dense-2-black-to-aggregate-fluffy-dark'}); 
% zoo_txt.object_annotation_category(:) = strrep(zoo_txt.object_annotation_category(:), ... 
%     {'mc+aggregate-fluffy-elongated-to-aggregate-dense-elongated'},{'mc+aggregate-fluffy-elongated-to-aggregate-dense-elong'}); 
% categories = unique(zoo_txt.object_annotation_category);
% %change all special variables 
% categories(:) = strrep(categories(:),'+','_'); categories(:) = strrep(categories(:),'<','_');
% categories(:) = strrep(categories(:),'-','_'); categories(:) = strrep(categories(:),' ','_');
% categories = [categories; {'Fluffy_agg'}; {'Dense_agg'}; {'Fiber'}; {'Feces'}; {'Bad_focus'}; {'Not_relevant'}; {'Photosynthetic'}; ...
%     {'Rhizaria_harosa'}; {'Arthro_crustacea'}; {'Gelatinous'}; {'Metazoa'}; {'Living'}; {'Detritus'}];
 
label_end = [{'_num'}; {'_M_3'}; {'_mm3L_1'}; {'_mm'}; {'_grey'}]; 

%S04p val categories
categories = {'like_Trichodesmium'; 'puff'; 'tuff'; 'Rhizaria'; 'Phaeodaria'; 'Castanellidae'; 'Circoporidae'; ...
'Tuscaroridae'; 'Aulacantha'; 'Aulographis'; 'mc_aulacantha_to_foraminifera'; 'Coelodendrum'; 'Coelographis'; ...
'leg_Coelodendridae'; 'Medusettidae'; 'Aulosphaeridae'; 'Aulatractus'; 'colonial_Aulosphaeridae'; ...
'mc_aulosphaeridae_to_cannosphaeridae'; 'Cannosphaeridae'; 'colonial_Cannosphaeridae'; 'unknown_Phaeodaria'; ...
'Acantharea'; 'Foraminifera'; 'Collodaria'; 'colonial_Collodaria'; 'mc_solitary_black_to_puff'; 'solitaryblack'; ...
'Annelida'; 'Poeobius'; 'Crustacea'; 'Hyperia'; 'like_Amphipoda'; 'shrimp_like'; 'Copepoda_Maxillopoda'; ...
'like_Copepoda'; 'Ostracoda'; 'Chaetognatha'; 'fish_egg'; ...
'house'; 'Salpida'; 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 'Narcomedusae'; 'Solmundella_bitentaculata'; ...
'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 'Mollusca'; 'Cephalopoda'; 'Phaeocystis'; 'badfocus_to_small_aggregates'; ...
'badfocus_to_turbid'; 'mc_badfocus_aggregate_elongated'; 'mc_badfocus_aggregate_fluffy'; ...
'mc_badfocus_aggregate_fluffy_to_badfocus_rhizaria'; 'bubble'; 'not_relevant_duplicate'; ...
'mc_aggregate_dense_amorphous_to_detritus_dense_round'; 'mc_aggregate_dense_dark_round_to_rhizaria'; ...
'mc_aggregate_dense_elongated_to_aggregate_fluffy'; 'mc_aggregate_dense_elongated_two_elements_to_bubbles'; ...
'mc_aggregate_dense_to_aggregate_fluffy_dark'; 'mc_aggregate_dense_to_crustacea'; 'mc_aggregate_dense_to_feces'; ...
'mc_aggregate_dense_2_black_to_aggregate_fluffy_dark'; 'mc_aggregate_fluffy'; 'mc_aggregate_dark_round_to_puff'; ...
'mc_aggregate_fluffy_dark_to_aggregate_dense'; 'mc_aggregate_fluffy_elongated'; ...
'mc_aggregate_fluffy_elongated_to_aggregate_dense_elong'; 'mc_aggregate_fluffy_grainy'; 'mc_aggregate_fluffy_grainy_elongated'; ...
'mc_aggregate_fluffy_grainy_to_aggregate_dense'; 'mc_aggregate_fluffy_grey'; 'mc_aggregate_fluffy_grey_elongated'; ...
'mc_aggregate_fluffy_grey_to_aggregate_badfocus'; 'mc_aggregate_fluffy_grey_to_rhizaria'; 'mc_fiber_fluffy_to_feces'; ...
'mc_fiber_thin_to_fiber_fluffy'; 'mc_fiber_thin_straight'; 'mc_fiber_thin_straight_with_black_element'; 'feces_little_fluffy'; ...
'mc_feces_bent_circular_fluffy'; 'mc_feces_bent_thin'; 'mc_feces_bent_to_crustacea'; 'mc_feces_dark_roundish'; ...
'mc_feces_dark_small_irregular_shape'; 'mc_feces_short_straight'; 'mc_feces_small_round_grey'; 'mc_feces_straight_to_feces_bent'; ...
'mc_feces_straight_fluffy'; 'mc_feces_straight_fluffy_to_trichodesmium_tuff'; 'mc_feces_straight_thin'; 'mc_feces_to_copepoda'; ...
'mc_feces_to_fiber'; 'mc_feces_straight_thin_to_fiber'; 't001'; 't003'; 't005';  'Fluffy_agg'; ...
'Dense_agg'; 'Fiber'; 'Feces'; 'Bad_focus'; 'Not_relevant'; 'Photosynthetic'; 'Rhizaria_harosa'; 'Arthro_crustacea';...
'Gelatinous'; 'Metazoa'; 'Living'; 'Detritus'}; %'t020'; 'Polychaeta'; 'Teleostei';'t006'; 'Doliolida';

%%
%one figure with 4 panels accross and each row is a diffferent super
%category 

%%
%4 panel plot two on top S04p and 2 on bottom I06s, left side is Souther
%Zone data averaged and right side is Antarctic Zone data averaged, just
% abundance not relative

%4 of these, one with crustacea, one with gelatinous, one with rhizaria,
%and detritus supercategories

clear all;
%load data
zoo_summary_new_s04p = readtable('G:\MS_Southern_Ocean\data\zoo_s04p_val_pred_photo_no_fiber_3Apr2024_summary_mean_new_depth_bins.csv');
%remove extra stations in Southern Zone that aren't connected to main section
zoo_summary_new_s04p = zoo_summary_new_s04p(1:515,:);
zoo_summary_new_i06s = readtable('G:\MS_Southern_Ocean\data\zoo_i06s_val_pred_photo_no_fiber_3Apr2024_summary_mean_new_depth_bins.csv');

%load AOU data
load('G:\MS_Southern_Ocean\data\Oxygen_sensor\avg_AOU_I06s_S04p_AZ_SZ.mat')

depth_bins_new = [0 200 500 1000 3000 6000];

%crustacea category names
crustacea = {'like_Amphipoda_M_3'; 'Copepoda_Maxillopoda_M_3'; 'like_Copepoda_M_3'; 'Hyperia_M_3'; ...
    'Ostracoda_M_3'; 'shrimp_like_M_3'}; %7 categories, deleted 'part_Copepoda_M_3', ; 'Crustacea_M_3'
crustacea_label = {'Amphipoda like'; 'Copepoda'; 'Copepoda like'; 'Hyperia';  ...
     'Ostracoda'; 'Shrimp like'; 'Crustacea other'};
 
%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Arthro_crustacea_M_3(w(w2)));
    for index2 = 1:length(crustacea)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(crustacea(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

fig1 = figure; fig1.Position = [133 230 1318 319] ; %[396 289 793 475]; %396.2000 232.2000 736.8000 532
ax1 = axes('Position',[0.11 0.2 0.171 0.6],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); %added ax1 here
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 4];
ax1.XTickLabel = {'0', '2', ''};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add AOU plot on top
ax2 = axes('Position',[0.11 0.2 0.171 0.6],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_S04p_SZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_S04p_SZ(index,4);
    fake_std(in) = avg_AOU_S04p_SZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:377) + fake_std(1:377); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:377) - fake_std(1:377);
x2_2 = [fake_depth_2(1:377), fliplr(fake_depth_2(1:377))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse', 'XAxisLocation','top')
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); ax2.XTickLabel = {'0', '0.2', ''};
yticklabels([]); set(ax2,'YTick',[]);
text(0.63,-100, 'Fluorescence (mg m^-^3)', 'FontWeight','Bold','FontSize',14,'fontname','helvetica') %the units on the CTD file are 0-5VDC
text(0.67, 500, 'Abundance (# m^-^3)', 'FontWeight','Bold','FontSize',14,'fontname','helvetica')
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Antarctic Zone'})); 
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Arthro_crustacea_M_3(w(w2)));
    for index2 = 1:length(crustacea)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(crustacea(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes('Position',[0.281 0.2 0.171 0.6],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 4];
ax1.YTickLabel = {};
ax1.XTickLabel = {'0', '2', ''};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add AOU plot on top
ax2 = axes('Position',[0.281 0.2 0.171 0.6],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_S04p_AZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_S04p_AZ(index,4);
    fake_std(in) = avg_AOU_S04p_AZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:375) + fake_std(1:375); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:375) - fake_std(1:375);
x2_2 = [fake_depth_2(1:375), fliplr(fake_depth_2(1:375))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse', 'XAxisLocation','top')
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); ax2.XTickLabel = {'0', '0.2', ''};
yticklabels([]); set(ax2,'YTick',[]);
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Arthro_crustacea_M_3(w(w2)));
    for index2 = 1:length(crustacea)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(crustacea(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes('Position',[0.452 0.2 0.171 0.6],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 4];
%xlabel('Abundance (# m^-^3)')
ax1.XTickLabel = {'0', '2', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add AOU plot on top
ax2 = axes('Position',[0.452 0.2 0.171 0.6],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_I06s_SZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_I06s_SZ(index,4);
    fake_std(in) = avg_AOU_I06s_SZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(7:391) + fake_std(7:391); %cut out nans at the end of the variable
curve2_2 = fake_AOU(7:391) - fake_std(7:391);
x2_2 = [fake_depth_2(7:391), fliplr(fake_depth_2(7:391))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse', 'XAxisLocation','top')
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); ax2.XTickLabel = {'0', '0.2', ''};
yticklabels([]); set(ax2,'YTick',[]);
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Antarctic Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Arthro_crustacea_M_3(w(w2)));
    for index2 = 1:length(crustacea)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(crustacea(index2))));
    end
end
data(1:5,7) = super - sum(data,2);

ax1 = axes('Position',[0.623 0.2 0.171 0.6],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 4];
%xlabel('Abundance (# m^-^3)')
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add legend
leg1 = legend(crustacea_label);
title(leg1,'Crustacea Categories')
set(leg1,'Position',[0.797 0.2 0.171 0.6]); %0.6775

%add AOU plot on top
ax2 = axes('Position',[0.623 0.2 0.171 0.6],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_I06s_AZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_I06s_AZ(index,4);
    fake_std(in) = avg_AOU_I06s_AZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:391) + fake_std(1:391); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:391) - fake_std(1:391);
x2_2 = [fake_depth_2(1:391), fliplr(fake_depth_2(1:391))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse', 'XAxisLocation','top')
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); 
yticklabels([]); set(ax2,'YTick',[]);
hold off

print('-dpng','-r250', 'G:/MS_Southern_Ocean/Figures/stacked_bar_plot_val_pred_crustacea_concentration_sz_az_Fluorescense');

%% Gelatinous 
%4 panel plot two on top S04p and 2 on bottom I06s, left side is Souther
%Zone data averaged and right side is Antarctic Zone data averaged, just
% abundance not relative

%4 of these, one with crustacea, one with gelatinous, one with rhizaria,
%and detritus supercategories

% clear all;
% %load data
% zoo_summary_new_s04p = readtable('G:\MS_Southern_Ocean\data\zoo_s04p_val_pred_phaeo_fluf_fiber_photo_summary_mean_new_depth_bins.csv');
% %remove extra stations in Southern Zone that aren't connected to main section
% zoo_summary_new_s04p = zoo_summary_new_s04p(1:515,:);
% zoo_summary_new_i06s = readtable('G:\MS_Southern_Ocean\data\zoo_i06s_val_pred_phaeo_fiber_photo_summary_mean_new_depth_bins.csv');
% 
% %load AOU data
% load('G:\MS_Southern_Ocean\data\Oxygen_sensor\avg_AOU_I06s_S04p_AZ_SZ.mat')
% 
% depth_bins_new = [0 200 500 1000 3000 6000];

%gelatinous category names
Gelatinous = {'Ctenophora_Metazoa_M_3'; 'Hydrozoa_M_3'; 
    'Narcomedusae_M_3'; 'Salpida_M_3'; 'Siphonophorae_M_3'; ...
    'Solmundella_bitentaculata_M_3'; 'tentacle_Cnidaria_M_3'}; %'house_M_3'; 'Cnidaria_Metazoa_M_3'; 
Gelatinous_label = {'Ctenophora'; ...
    'Hydrozoa'; 'Narcomedusae'; 'Salpida'; 'Siphonophorae'; ...
    'Solmundella bitentaculata'; 'Tentacle'; 'Cnidaria other'}; %'Larvacean house'; 
  
%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Gelatinous_M_3(w(w2)));
    for index2 = 1:length(Gelatinous)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Gelatinous(index2))));
    end
end
data(1:5,8) = super - sum(data,2);

fig1 = figure; fig1.Position = [133 230 1318 319] ; %[396 289 793 475]; %396.2000 232.2000 736.8000 532
ax1 = axes('Position',[0.11 0.2 0.171 0.6],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); %added ax1 here
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 4];
ax1.XTickLabel = {'0', '2', ''};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add AOU plot on top
ax2 = axes('Position',[0.11 0.2 0.171 0.6],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_S04p_SZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_S04p_SZ(index,4);
    fake_std(in) = avg_AOU_S04p_SZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:377) + fake_std(1:377); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:377) - fake_std(1:377);
x2_2 = [fake_depth_2(1:377), fliplr(fake_depth_2(1:377))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse', 'XAxisLocation','top')
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); ax2.XTickLabel = {'0', '0.2', ''};
yticklabels([]); set(ax2,'YTick',[]);
text(0.63,-100, 'Fluorescense (mg m^-^3)', 'FontWeight','Bold','FontSize',14,'fontname','helvetica')
text(0.67, 500, 'Abundance (# m^-^3)', 'FontWeight','Bold','FontSize',14,'fontname','helvetica')
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Antarctic Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Gelatinous_M_3(w(w2)));
    for index2 = 1:length(Gelatinous)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Gelatinous(index2))));
    end
end
data(1:5,8) = super - sum(data,2);

ax1 = axes('Position',[0.281 0.2 0.171 0.6],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 4];
ax1.YTickLabel = {};
%xlabel('Abundance (# m^-^3)')
ax1.XTickLabel = {'0', '2', ''};
%title('Antarctic Zone')
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add AOU plot on top
ax2 = axes('Position',[0.281 0.2 0.171 0.6],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_S04p_AZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_S04p_AZ(index,4);
    fake_std(in) = avg_AOU_S04p_AZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:375) + fake_std(1:375); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:375) - fake_std(1:375);
x2_2 = [fake_depth_2(1:375), fliplr(fake_depth_2(1:375))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse', 'XAxisLocation','top')
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); ax2.XTickLabel = {'0', '0.2', ''};
yticklabels([]); set(ax2,'YTick',[]);
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Gelatinous_M_3(w(w2)));
    for index2 = 1:length(Gelatinous)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Gelatinous(index2))));
    end
end
data(1:5,8) = super - sum(data,2);

ax1 = axes('Position',[0.452 0.2 0.171 0.6],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 4];
%xlabel('Abundance (# m^-^3)')
ax1.XTickLabel = {'0', '2', ''};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add AOU plot on top
ax2 = axes('Position',[0.452 0.2 0.171 0.6],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_I06s_SZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_I06s_SZ(index,4);
    fake_std(in) = avg_AOU_I06s_SZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(7:391) + fake_std(7:391); %cut out nans at the end of the variable
curve2_2 = fake_AOU(7:391) - fake_std(7:391);
x2_2 = [fake_depth_2(7:391), fliplr(fake_depth_2(7:391))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse', 'XAxisLocation','top')
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); ax2.XTickLabel = {'0', '0.2', ''};
yticklabels([]); set(ax2,'YTick',[]);
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Antarctic Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Gelatinous_M_3(w(w2)));
    for index2 = 1:length(Gelatinous)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Gelatinous(index2))));
    end
end
data(1:5,8) = super - sum(data,2);

ax1 = axes('Position',[0.623 0.2 0.171 0.6],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 4];
%xlabel('Abundance (# m^-^3)')
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add legend
leg1 = legend(Gelatinous_label);
title(leg1,'Gelatinous Categories')
set(leg1,'Position',[0.807 0.2 0.171 0.6]); %0.6775

%add AOU plot on top
ax2 = axes('Position',[0.623 0.2 0.171 0.6],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_I06s_AZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_I06s_AZ(index,4);
    fake_std(in) = avg_AOU_I06s_AZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:391) + fake_std(1:391); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:391) - fake_std(1:391);
x2_2 = [fake_depth_2(1:391), fliplr(fake_depth_2(1:391))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse', 'XAxisLocation','top')
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); 
yticklabels([]); set(ax2,'YTick',[]);
hold off

print('-dpng','-r250', 'G:/MS_Southern_Ocean/Figures/stacked_bar_plot_val_pred_gelatinous_concentration_sz_az_Fluorescense');

%% rhizaria
%4 panel plot two on top S04p and 2 on bottom I06s, left side is Souther
%Zone data averaged and right side is Antarctic Zone data averaged, just
% abundance not relative

%4 of these, one with crustacea, one with gelatinous, one with rhizaria,
%and detritus supercategories

% clear all;
% %load data
% zoo_summary_new_s04p = readtable('G:\MS_Southern_Ocean\data\zoo_s04p_val_pred_phaeo_fluf_fiber_photo_summary_mean_new_depth_bins.csv');
% %remove extra stations in Southern Zone that aren't connected to main section
% zoo_summary_new_s04p = zoo_summary_new_s04p(1:515,:);
% zoo_summary_new_i06s = readtable('G:\MS_Southern_Ocean\data\zoo_i06s_val_pred_phaeo_fiber_photo_summary_mean_new_depth_bins.csv');
% 
% %load AOU data
% load('G:\MS_Southern_Ocean\data\Oxygen_sensor\avg_AOU_I06s_S04p_AZ_SZ.mat')
% 
% depth_bins_new = [0 200 500 1000 3000 6000];

%rhizaria category names
Rhizaria_harosa = {'Acantharea_M_3'; 'Aulacantha_M_3'; 'Aulosphaeridae_M_3'; 'Cannosphaeridae_M_3';  ...
    'colonial_Cannosphaeridae_M_3'; 'Collodaria_M_3'; 'Medusettidae_M_3'; 'mc_aulosphaeridae_to_cannosphaeridae_M_3'; 
     'unknown_Phaeodaria_M_3'; 'solitaryblack_M_3'; 'mc_solitary_black_to_puff_M_3'}; %'Rhizaria_M_3'; 
Rhizaria_harosa_label = {'Acantharea'; 'Aulacantha';  'Aulosphaeridae'; 'Cannosphaeridae'; 
    'Cannosphaeridae colonial'; 'Collodaria'; 'Medusettidae'; 'Aulo./Canno. unknown'; 'Phaeodaria unknown'; 
    'Solitary black'; 'Solitary black/puff'; 'Rhizaria other'}; 
  
%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Rhizaria_harosa_M_3(w(w2)));
    for index2 = 1:length(Rhizaria_harosa)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Rhizaria_harosa(index2))));
    end
end
data(1:5,12) = super - sum(data,2);

fig1 = figure; fig1.Position = [133 230 1318 319] ; %[396 289 793 475]; %396.2000 232.2000 736.8000 532
ax1 = axes('Position',[0.11 0.2 0.171 0.6],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); %added ax1 here
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
hb(12).FaceColor = [96/255 96/255 96/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 13];
ax1.XTickLabel = {'0', '5', '10'};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add AOU plot on top
ax2 = axes('Position',[0.11 0.2 0.171 0.6],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_S04p_SZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_S04p_SZ(index,4);
    fake_std(in) = avg_AOU_S04p_SZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:377) + fake_std(1:377); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:377) - fake_std(1:377);
x2_2 = [fake_depth_2(1:377), fliplr(fake_depth_2(1:377))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse', 'XAxisLocation','top')
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); ax2.XTickLabel = {'0', '0.2', ''};
yticklabels([]); set(ax2,'YTick',[]);
text(0.63,-100, 'Fluorescense (mg m^-^3)', 'FontWeight','Bold','FontSize',14,'fontname','helvetica')
text(0.67, 500, 'Abundance (# m^-^3)', 'FontWeight','Bold','FontSize',14,'fontname','helvetica')
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Antarctic Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Rhizaria_harosa_M_3(w(w2)));
    for index2 = 1:length(Rhizaria_harosa)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Rhizaria_harosa(index2))));
    end
end
data(1:5,12) = super - sum(data,2);

ax1 = axes('Position',[0.281 0.2 0.171 0.6],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
hb(12).FaceColor = [96/255 96/255 96/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 13];
ax1.YTickLabel = {};
ax1.XTickLabel = {'0', '5', '10'};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add AOU plot on top
ax2 = axes('Position',[0.281 0.2 0.171 0.6],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_S04p_AZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_S04p_AZ(index,4);
    fake_std(in) = avg_AOU_S04p_AZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:375) + fake_std(1:375); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:375) - fake_std(1:375);
x2_2 = [fake_depth_2(1:375), fliplr(fake_depth_2(1:375))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse', 'XAxisLocation','top')
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); ax2.XTickLabel = {'0', '0.2', ''};
yticklabels([]); set(ax2,'YTick',[]);
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Rhizaria_harosa_M_3(w(w2)));
    for index2 = 1:length(Rhizaria_harosa)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Rhizaria_harosa(index2))));
    end
end
data(1:5,12) = super - sum(data,2);

ax1 = axes('Position',[0.452 0.2 0.171 0.6],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
hb(12).FaceColor = [96/255 96/255 96/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 13];
ax1.XTickLabel = {'0', '5', '10'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add AOU plot on top
ax2 = axes('Position',[0.452 0.2 0.171 0.6],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_I06s_SZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_I06s_SZ(index,4);
    fake_std(in) = avg_AOU_I06s_SZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(7:391) + fake_std(7:391); %cut out nans at the end of the variable
curve2_2 = fake_AOU(7:391) - fake_std(7:391);
x2_2 = [fake_depth_2(7:391), fliplr(fake_depth_2(7:391))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse', 'XAxisLocation','top')
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); ax2.XTickLabel = {'0', '0.2', ''};
yticklabels([]); set(ax2,'YTick',[]);
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Antarctic Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Rhizaria_harosa_M_3(w(w2)));
    for index2 = 1:length(Rhizaria_harosa)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(Rhizaria_harosa(index2))));
    end
end
data(1:5,12) = super - sum(data,2);

ax1 = axes('Position',[0.623 0.2 0.171 0.6],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [153/255 204/255 255/255];
hb(2).FaceColor = [51/255 153/255 255/255];
hb(3).FaceColor = [0 102/255 204/255];
hb(4).FaceColor = [255/255 153/255 153/255];
hb(5).FaceColor = [255/255 51/255 51/255];
hb(6).FaceColor = [204/255 0 0];
hb(7).FaceColor = [255/255 255/255 51/255];
hb(8).FaceColor = [204/255 204/255 0];
hb(9).FaceColor = [102/255 102/255 0];
hb(10).FaceColor = [224/255 224/255 224/255];
hb(11).FaceColor = [160/255 160/255 160/255];
hb(12).FaceColor = [96/255 96/255 96/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 13];
ax1.XTickLabel = {'0', '5', '10'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add legend
leg1 = legend(Rhizaria_harosa_label);
title(leg1,'Rhizaria Categories')
set(leg1,'Position',[0.815 0.2 0.171 0.6]); %0.6775

%add AOU plot on top
ax2 = axes('Position',[0.623 0.2 0.171 0.6],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_I06s_AZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_I06s_AZ(index,4);
    fake_std(in) = avg_AOU_I06s_AZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:391) + fake_std(1:391); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:391) - fake_std(1:391);
x2_2 = [fake_depth_2(1:391), fliplr(fake_depth_2(1:391))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse', 'XAxisLocation','top')
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); 
yticklabels([]); set(ax2,'YTick',[]);
hold off

print('-dpng','-r250', 'G:/MS_Southern_Ocean/Figures/stacked_bar_plot_val_pred_rhizaria_concentration_sz_az_Fluorescense');

%% Detritus
%4 panel plot two on top S04p and 2 on bottom I06s, left side is Souther
%Zone data averaged and right side is Antarctic Zone data averaged, just
% abundance not relative

%4 of these, one with crustacea, one with gelatinous, one with rhizaria,
%and detritus supercategories

% clear all;
% %load data
% zoo_summary_new_s04p = readtable('G:\MS_Southern_Ocean\data\zoo_s04p_val_pred_phaeo_fluf_fiber_photo_summary_mean_new_depth_bins.csv');
% %remove extra stations in Southern Zone that aren't connected to main section
% zoo_summary_new_s04p = zoo_summary_new_s04p(1:515,:);
% zoo_summary_new_i06s = readtable('G:\MS_Southern_Ocean\data\zoo_i06s_val_pred_phaeo_fiber_photo_summary_mean_new_depth_bins.csv');
% 
% %load AOU data
% load('G:\MS_Southern_Ocean\data\Oxygen_sensor\avg_AOU_I06s_S04p_AZ_SZ.mat')
% 
% depth_bins_new = [0 200 500 1000 3000 6000];

%rhizaria category names
detritus = {'Dense_agg_M_3'; 'Fiber_M_3'; 'Feces_M_3'; 'mc_aggregate_fluffy_M_3'; 
    'mc_aggregate_fluffy_elongated_M_3'; 'mc_aggregate_fluffy_grainy_to_aggregate_dense_M_3'; 
    'mc_aggregate_fluffy_grey_to_aggregate_badfocus_M_3'}; %'Fluffy agg'; 
detritus_label = {'Dense aggregate';  'Fiber'; 'Feces'; 'Fluffy aggregate'; 'Fluffy agg elongated'; 
    'Fluffy agg grainy/dense'; 'Fluffy agg gray/badfocus'; 'Fluffy agg other'}; 

%plot

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Southern Zone'})); %'Antarctic Zone'
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Fluffy_agg_M_3(w(w2)));
    for index2 = 1:length(detritus)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(detritus(index2))));
    end
end
data(1:5,8) = super - sum(data(:,4:7),2);

fig1 = figure; fig1.Position = [133 230 1318 319] ; %[396 289 793 475]; %396.2000 232.2000 736.8000 532
ax1 = axes('Position',[0.11 0.2 0.171 0.6],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(ax1, X, data, 'stacked'); %added ax1 here
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];

set(ax1, 'YDir','reverse')
ax1.XLim = [0 730];
%ax1.XTickLabel = {'0', '5', '10'};
ylabel('Depth (m)')
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add AOU plot on top
ax2 = axes('Position',[0.11 0.2 0.171 0.6],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_S04p_SZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_S04p_SZ(index,4);
    fake_std(in) = avg_AOU_S04p_SZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:377) + fake_std(1:377); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:377) - fake_std(1:377);
x2_2 = [fake_depth_2(1:377), fliplr(fake_depth_2(1:377))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse', 'XAxisLocation','top')
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); ax2.XTickLabel = {'0', '0.2', ''};
yticklabels([]); set(ax2,'YTick',[]);
text(0.63,-100, 'Fluorescense (mg m^-^3)', 'FontWeight','Bold','FontSize',14,'fontname','helvetica')
text(0.67, 500, 'Abundance (# m^-^3)', 'FontWeight','Bold','FontSize',14,'fontname','helvetica')
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_s04p.frontal_zone, {'Antarctic Zone'})); 
data = [];super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_s04p.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_s04p.Fluffy_agg_M_3(w(w2)));
    for index2 = 1:length(detritus)
        formatSpec = 'mean(zoo_summary_new_s04p.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(detritus(index2))));
    end
end
data(1:5,8) = super - sum(data(:,4:7),2);

ax1 = axes('Position',[0.281 0.2 0.171 0.6],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 730];
ax1.YTickLabel = {};
%ax1.XTickLabel = {'0', '5', '10'};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add AOU plot on top
ax2 = axes('Position',[0.281 0.2 0.171 0.6],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_S04p_AZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_S04p_AZ(index,4);
    fake_std(in) = avg_AOU_S04p_AZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:375) + fake_std(1:375); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:375) - fake_std(1:375);
x2_2 = [fake_depth_2(1:375), fliplr(fake_depth_2(1:375))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse', 'XAxisLocation','top')
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); ax2.XTickLabel = {'0', '0.2', ''};
yticklabels([]); set(ax2,'YTick',[]);
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Southern Zone'})); 
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Fluffy_agg_M_3(w(w2)));
    for index2 = 1:length(detritus)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(detritus(index2))));
    end
end
data(1:5,8) = super - sum(data(:,4:7),2);

ax1 = axes('Position',[0.452 0.2 0.171 0.6],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 730];
%ax1.XTickLabel = {'0', '5', '10'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add AOU plot on top
ax2 = axes('Position',[0.452 0.2 0.171 0.6],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_I06s_SZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_I06s_SZ(index,4);
    fake_std(in) = avg_AOU_I06s_SZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(7:391) + fake_std(7:391); %cut out nans at the end of the variable
curve2_2 = fake_AOU(7:391) - fake_std(7:391);
x2_2 = [fake_depth_2(7:391), fliplr(fake_depth_2(7:391))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse', 'XAxisLocation','top')
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); ax2.XTickLabel = {'0', '0.2', ''};
yticklabels([]); set(ax2,'YTick',[]);
hold off

%just certian frontal zones
w = find(ismember(zoo_summary_new_i06s.frontal_zone, {'Antarctic Zone'})); 
data = []; super = [];
for index = 1:(length(depth_bins_new)-1)
    w2 = find(zoo_summary_new_i06s.Depth_range2_1(w) == depth_bins_new(index));
    super(index,1) = mean(zoo_summary_new_i06s.Fluffy_agg_M_3(w(w2)));
    for index2 = 1:length(detritus)
        formatSpec = 'mean(zoo_summary_new_i06s.%s(w(w2)));';
        data(index, index2) = eval(sprintf(formatSpec, char(detritus(index2))));
    end
end
data(1:5,8) = super - sum(data(:,4:7),2);

ax1 = axes('Position',[0.623 0.2 0.171 0.6],'Box','on');
X = categorical({'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
X = reordercats(X,{'0-200', '200-500', '500-1000', '1000-3000', '3000-6000'});
hb = barh(X, data, 'stacked');
hb(1).FaceColor = [56/255 87/255 35/255];
hb(2).FaceColor = [46/255 117/255 182/255];
hb(3).FaceColor = [191/255 144/255 0];
hb(4).FaceColor = [229/255 255/255 204/255];
hb(5).FaceColor = [204/255 255/255 153/255];
hb(6).FaceColor = [128/255 255/255 0/255];
hb(7).FaceColor = [102/255 204/255 0/255];
hb(8).FaceColor = [76/255 153/255 0/255];
set(ax1, 'YDir','reverse')
ax1.XLim = [0 730];
%ax1.XTickLabel = {'0', '5', '10'};
ax1.YTickLabel = {};
set(ax1,'FontWeight','Bold','FontSize',14,'fontname','helvetica');

%add legend
leg1 = legend(detritus_label);
title(leg1,'Detritus Categories')
set(leg1,'Position',[0.804 0.2 0.171 0.6]); %0.6775

%add AOU plot on top
ax2 = axes('Position',[0.623 0.2 0.171 0.6],'Box','on');
set(ax2, 'Color', 'none');

%make fake data so I can have an irregularly spaced y axis
fake_depth = [0:200/100:198 200:(500-200)/100:497 500:(1000-500)/100:995 ...
    1000:(6000-1000)/100:6000];
fake_AOU = [];
fake_std = [];
for in = 1:length(fake_depth)
    [c index] = min(abs(avg_AOU_I06s_AZ(:,1)-fake_depth(in)));
    fake_AOU(in) = avg_AOU_I06s_AZ(index,4);
    fake_std(in) = avg_AOU_I06s_AZ(index,5);
end

fake_depth_2 = (1:1:length(fake_depth));
curve1_2 = fake_AOU(1:391) + fake_std(1:391); %cut out nans at the end of the variable
curve2_2 = fake_AOU(1:391) - fake_std(1:391);
x2_2 = [fake_depth_2(1:391), fliplr(fake_depth_2(1:391))];
inBetween_2 = [curve1_2, fliplr(curve2_2)];
p = patch(ax2, inBetween_2,x2_2, 'g', 'FaceAlpha', 0.3);
hold on;
plot(ax2, fake_AOU,fake_depth_2, 'k', 'LineWidth', 2);
set(ax2, 'YDir','reverse', 'XAxisLocation','top')
set(ax2,'FontWeight','Bold','FontSize',14,'fontname','helvetica'); 
ylim([fake_depth_2(1) fake_depth_2(end)])
xlim([0 0.4]); 
yticklabels([]); set(ax2,'YTick',[]);
hold off

print('-dpng','-r250', 'G:/MS_Southern_Ocean/Figures/stacked_bar_plot_val_pred_detritus_concentration_sz_az_Fluorescense');
