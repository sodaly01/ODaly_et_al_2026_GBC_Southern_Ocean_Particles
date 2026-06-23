%plotting I06s CTD parameters fluorescence in upper 300 m
%from CTD files- 2 m depth bins

clear all; close all;
addpath('G:\MATLAB\seawater_ver3_3.1')
addpath('G:\MATLAB\m_map'); 

%load data, downloaded 8/27/2025
%ncdisp('G:/Cruises/2019_I06S/325020190403_ctd.nc'); %view discription of data
ctd.station = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc', 'station');
%this station data is in a weird format
ctd.stn = [1:55]; %this is the same but in a better format
ctd.cast = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc', 'cast');
ctd.lat = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','latitude'); 
ctd.lon = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','longitude'); 
ctd.depth = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','pressure'); 
ctd.fluorescence = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','ctd_fluor_raw'); 
ctd.fluorescence_flag = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','ctd_fluor_raw_qc');
ctd.transmission = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','ctd_beamcp'); 
ctd.transmission_flag = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','ctd_beamcp_qc'); 
ctd.temperature = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','ctd_temperature'); 
ctd.temperature_flag = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','ctd_temperature_qc'); 
ctd.salinity = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','ctd_salinity'); 
ctd.salinity_flag = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','ctd_salinity_qc'); 
ctd.salinity = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','ctd_salinity'); 
ctd.salinity_flag = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','ctd_salinity_qc'); 
ctd.oxygen = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','ctd_oxygen'); 
ctd.oxygen_flag = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','ctd_oxygen_qc'); 
ctd.beta700_raw = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','ctd_beta700_raw'); 
ctd.ctd_beta700_raw_qc = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','ctd_beta700_raw_qc'); 
ctd.time = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','time'); 

% %checking date from station 34 and 35
% datetime(1950,01,01, 'Format','d-MMM-y hh:mm') + days(ctd.time(34)) % character vector
% datetime(1950,01,01, 'Format','d-MMM-y hh:mm') + days(ctd.time(35)) % character vector
% ctd.time(34)
% ctd.time(35)

%Load CTD bottle datafile for this cruise
bot = readtable("G:/Cruises/2019_I06S/325020190403_bottle_05Aug2025/325020190403_hy1_removed_flagged_data.xlsx");
bot = bot(2:end-1, :);

%load MLD data
load('G:/Cruises/2019_I06S/stn_lat_mld_pt.mat');
stn_lat_mld_pt= sortrows(stn_lat_mld_pt, 2);

% calculate AOU
addpath('G:/MATLAB/GSW-Matlab-master/Toolbox')
addpath('G:\MATLAB\GSW-Matlab-master\Toolbox\library')

%calculate potential temperature
pt0 = gsw_pt0_from_t(ctd.salinity,ctd.temperature,ctd.depth);

%calculate oxygen solubility
O2sol = gsw_O2sol_SP_pt(ctd.salinity,pt0); %  O2sol = solubility of oxygen in micro-moles per kg  

%calculate AOU
ctd.AOU = O2sol - ctd.oxygen;

%make a flag variable for AOU
ctd.AOU_flag = ones(size(ctd.AOU))*4;

%unique(ctd.temperature_flag) %3 questionable 
w_temp = (ctd.temperature_flag == 2); %good temp
%unique(ctd.oxygen_flag) %3 questionable % 4 is bad
w_oxy = (ctd.oxygen_flag == 2); %good oxy
%unique(ctd.salinity_flag) %3 questionable %4 is bad
w_sal = (ctd.salinity_flag == 2); %good sal
w_AOU = w_temp & w_oxy & w_sal;

ctd.AOU_flag(w_AOU) = 2;

% Set categories for environmental parameters
% categories = {'temperature'; 'salinity'; 'oxygen'; 'AOU';...
%      'fluorescence'}; 
categories = {'temperature'; 'salinity'; 'AOU'; 'transmission';...
     'fluorescence'}; 
categories_bot = {'NITRAT'}; %categories_bot = {'SILCAT','NITRAT', 'PHSPHT'};
% color_bar_label = {'Temperature (^oC)'; 'Salinity'; 'Oxygen (\mumol kg^-^1)';...
%     'AOU (\mumol kg^-^1)'; 'Fluorescence (RFU)'; 'Silicate (\mumol kg^-^1)';...
%     'Nitrate (\mumol kg^-^1)'; 'Phosphate (\mumol kg^-^1)'};
color_bar_label = {'Temperature (^oC)'; 'Salinity'; ...
    'AOU (\mumol kg^-^1)'; 'Beam c_p (m^-^1)'; 'Fluorescence (RFU)'; ...
    'Nitrate (\mumol kg^-^1)'};
sublet = {'a', 'b', 'c', 'd', 'e','f'}; %, 'g', 'h'}; 


%% Plot data 6000 from CTD file- 6 panel

fig2 = figure;
set(fig2, 'Units', 'inches', 'Position', [0.4417 0.6167 7.67 6.05]); %[0.4417 0.6167 7.67 7.8]
stations = unique(ctd.stn)'; 

%pull out lat and long from each station location
for in = 1:length(stations)
   w=find(ctd.stn == stations(in));
   lat_lon(in,1) = ctd.lat(w);
   lat_lon(in,2) = wrapTo360(ctd.lon(w));
   %find bottom depth in each sample
   %bottom_depth(in,1) = ctd.depth(end,w(1));
end
lat_lon = sortrows(lat_lon, 1); %sort so lat is from min to max, added on 5/13/2025

%Interpolate between stations to 5KM resolution
%lat = interp(ctd.lat,15);
%long = interp(ctd.lon,15);
lat = interp1([1:length(lat_lon(:,1))]',lat_lon(:,1), linspace(1,55, 630)); 
long = interp1([1:length(lat_lon(:,2))]',lat_lon(:,2), linspace(1,55, 630));

%download bathy file from etopo2
%[ELEV,LONG,LAT]=m_etopo2([min(ctd.lon) max(ctd.lon) min(ctd.lat) max(ctd.lat)]);
[ELEV,LONG,LAT]=m_etopo2([min(lat_lon(:,2)) max(lat_lon(:,2)) min(lat_lon(:,1)) max(lat_lon(:,1))]);

%find row/column that best matches exact station locations interpolated
elevation = [];
for in = 1:length(lat)
    temp = abs(LONG(1,:)-long(in));
    temp2 = find(temp == min(temp));
    lon_col(in) = LONG(1,temp2);
    temp = abs(LAT(:,1) - lat(in));
    temp3 = find(temp == min(temp));
    lat_row(in) = LAT(temp3,1);
    elevation(in) = ELEV(temp3,temp2);
end

for index1 = 1:4%loop through all categories of particles
    category = char(categories(index1));
    w = ismember(ctd.stn, stations);
    
    formatSpec = 'value = ctd.%s;';
    eval(sprintf(formatSpec, category))   

    %remove nans
    w_test = ~isnan(value);
    w3_test = w.*w_test;
    w = w3_test;
    w3_test = w & w_test;
    w = w3_test;
    
    %remove flags
    %unique(ctd.fluorescence_flag)
    %flag 1, 2, and 6 are good
    formatSpec = 'w4 = (ctd.%s_flag == 1 | ctd.%s_flag == 2 | ctd.%s_flag == 6);';
    eval(sprintf(formatSpec, category, category, category))
    w4_test = w & w4;
    w = w4_test;
    
    % %makes flagged 6 data NaN %6 flag means: interpolated_over_a_pressure_interval_larger_than_2_dbar
    % w4 = find(ctd.fluorescence_flag == 6);
    % ctd.fluorescence(w4) = NaN;

    if index1 == 1
        cmap_bins = [min(value(w)) 0 1 2 3 5 7.5 10 15 20 max(value(w))];
    end
    if index1 == 2
        cmap_bins = [min(value(w)) 34 34.25 34.5 34.6 34.65 34.7 34.75 35 35.25 35.5 max(value(w))];
    end
    if index1 == 3 
        cmap_bins = [min(value(w)) -5 0 25 50 75 100 130 140 145 200 max(value(w))];
    end
    if index1 == 4
        cmap_bins = [min(value(w)) 0.0001 0.001 0.005 0.01 0.02 0.05 0.1 max(value(w))];
    end
    N_colorbins = length(cmap_bins);
    y = 0:N_colorbins-1; 
    dtr = interp1(cmap_bins, y, value(w));

   %plot UVP data over latitude with colorbar created
    depth = ctd.depth(w);
    zbin = min(depth):2:max(depth); % zbin = 0:5:max(depth(w)); 
    zbin = zbin';
    lat_axes = min(ctd.lat) :0.1: max(ctd.lat);
    [X1,Y1] = meshgrid(lat_axes,zbin);
    lat_stack = [];
    for in = 1:length(ctd.lat)
        lat_stack  = [lat_stack, repelem(ctd.lat(in), length(ctd.depth))'];
    end
    
    var_data=griddata(lat_stack(w),depth,dtr,X1,Y1);
    
    w2=find(var_data == min(min(var_data))); %EDITED 3/18/25
    var_data(w2) = min(dtr);%EDITED 3/18/25
    w2=find(var_data == max(max(var_data)));%EDITED 3/18/25
    var_data(w2) = max(dtr);%EDITED 3/18/25
    clear w2;%EDITED 3/18/25
    ax2 = axes;

    if index1 == 1
        set(ax2, 'Units', 'inches', 'Position', [0.45 4.19 3.36 1.75]) %[0.45 5.94 3.36 1.75]
    elseif index1 == 2
        set(ax2, 'Units', 'inches', 'Position', [4.03 4.19 3.36 1.75]) %[4.03 5.94 3.36 1.75]
    elseif index1 == 3
        set(ax2, 'Units', 'inches', 'Position', [0.45 2.44 3.36 1.75]) %[0.45 4.19 3.36 1.75] 
    elseif index1 == 4
        set(ax2, 'Units', 'inches', 'Position', [4.03 2.44 3.36 1.75]) %[4.03 4.19 3.36 1.75]
    end

    [C,h] = contourf(X1, Y1, var_data); 
    c = parula(N_colorbins - 1);
    colormap(ax2, c); %8/14 I had to specify the axis here because it was editing all of the colormaps at once
    set(h, 'LineColor', 'none');
    hold on

    if index1 == 1 || index1 == 2
        plot(ax2,unique(lat_stack(w)),zeros([1 length(unique(lat_stack(w)))]),'r|','MarkerSize',5)
    end
    temp4 = unique(lat_stack(w));
    ax2.YDir = 'reverse';
    %Bathymetry
    hold on
    p = patch([lat lat(end) lat(1)], [elevation.*-1 6000 6000],'k');
    set(p, 'facecolor',[0.5 0.5 0.5], 'edgecolor', [0.5 0.5 0.5]);

    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
    end
    if index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        yticklabels([]);
    end
    if index1 == 5 || index1 == 6
        xlabel('Latitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
        xticks([-65 -60 -55 -50 -45 -40 -35]);
        xticklabels({'65^oS','60^oS','55^oS','50^oS','45^oS','40^oS','35^oS'});
        xtickangle(30);
    end
    if index1 == 1 || index1 == 2 || index1 == 3 || index1 == 4 
        xticklabels([]);
        xlabel([]);
    end
    cblh = colorbar;
    if index1 == 1 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'-2', '0', '1', '2', '3', '5', '7.5', '10', '15', '20', ''});
    end
    if index1 == 2 
        cblh.YTick = y;
        set(cblh,'yticklabel',{'33.75', '34', '34.25', '34.5', '34.6', '34.65', '34.7', '34.75', '35', '35.25', '35.5' ''});
    end 
    if index1 == 3 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'','-5', '0', '25', '50', '75', '100', '130', '140', '145', '200', ''});
    end
    if index1 == 4
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'0', '10^-^4', '10^-^3', '5*10^-^3', '10^-^2','2*10^-^2', '5*10^-^2', '10^-^1', ''});
    end
    cblh.Label.String = char(color_bar_label(index1)); 
    set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 8)
    hold on
    %plot MLD
    plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);
    %plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'MarkerEdgeColor', 'r', 'LineWidth', 1.5);

    ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
    value = ctd.pden;
    cmap_bins = [23.5 24 24.5 25 25.5 26 26.5 26.75 27 27.15 27.5 27.6 27.7 27.75 27.8 27.83 27.85 27.9]; %[23.5 24 24.5 25 25.5 26 26.5 27 27.5 27.6 27.7 27.8 27.85 27.9];
    %cmap_bins = [24.5 24.75 25 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9 26 26.1 26.2 26.3 26.4 26.5 26.6 26.7 26.8 26.9 27 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
    y = 1:length(cmap_bins); 
    dtr = interp1(cmap_bins, y, value(w)); %this is for irregularly spaced intervals
    var_data=griddata(lat_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr
    if index1 == 1
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 4.19 2.75 1.75]); %5.94
    elseif index1 == 2
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 4.19 2.75 1.75]); %5.94
    elseif index1 == 3
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 2.44 2.75 1.75]); %4.19
    elseif index1 == 4
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 2.44 2.75 1.75]); %4.19
    end
    %labels on sigma 2
    [C,h] = contour(ax4, X1, Y1, var_data,cmap_bins, 'showtext','on');
    h.LevelList=round(h.LevelList,2);  %rounds levels to 3rd decimal place
    clabel(C,h);
    %no labels on sigma 2
    %[C,h] = contour(X1, Y1, var_data,cmap_bins);
    
    set(h, 'LineColor', 'w'); clabel(C,h, 'Color','w', 'LabelSpacing', 100, 'FontSize', 7);
    ax4.YDir = 'reverse';
    ax4.XTick = []; ax4.YTick = [];
    set(ax4, 'Color','none');
    %ylim([0 300]);
    
    rectangle('Position',[-49.983 0 11.4837  6000], 'FaceColor', 'w', 'EdgeColor', 'none')

    %add lines and text labeling fronts and zones
    line([-60.7523 -60.7523], [0 6000],'color',[0 0 0],'linewi',1); %SBDY
    line([-55.9998 -55.9998], [0 6000],'color',[0 0 0],'linewi',1); %SACCF
    line([-53.5 -53.5], [0 6000],'color',[0 0 0],'linewi',1)%, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
    %line([-49.5 -49.5], [0 6000],'color',[0 0 0],'linewi',1, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
    line([-49 -49], [0 6000],'color',[0 0 0],'linewi',1); %SAF
    line([-40.6662 -40.6662], [0 6000],'color',[0 0 0],'linewi',1); %STF
    %label fronts on bottom
    temp4 = unique(lat_stack(w));
    
    % text(ax2, -60.7523-1.25, 6100, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 14);
    % text(ax2, -55.9998-1.6, 6100, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
    % text(ax2, -53.5-0.5, 6100, "PF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
    % text(ax2, -49-1, 306, "SAF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
    % text(ax2, -40.6662-1, 6100, "STF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
    
    % hold on
    % p1 = patch([lat_lon(11:32,1)' max(lat_lon(11:32,1)) min(lat_lon(11:32,1))], [(bottom_depth(11:32))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');
    % p1 = patch([lat_lon(1:10,1)' max(lat_lon(1:10,1)) min(lat_lon(1:10,1))], [(bottom_depth(1:10))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');
    % p1 = patch([lat_lon(33:end,1)'  min(lat_lon(33:end,1)) max(lat_lon(33:end,1))], [(bottom_depth(33:end))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');%p = patch([long' long(end) long(1)], [elevation.*-1 4810 4810],'k');%p = patch([long' long(end) long(1)], [elevation.*-1 4810 4810],'k');
    
    %split upper 1000m to be half of the panel
    xlim1 = ax2.XLim;
    % change limits and shrink positions
    ax2.YLim = [1000 6000]; ax2.Position(4) = ax2.Position(4)/2;
    % center the ylabel
    ax2.YAxis.Label.Units = 'normalized';
    ax2.YAxis.Label.Position(2) = 1;
    % copy axes with data
    ax2_top = copyobj(ax2,gcf);
    % change limits and shrink positions
    ax2_top.YLim = [0 1000]; ax2_top.Position(2) = ax2_top.Position(2) + ax2_top.Position(4);
    ax2_top.YLabel     = [];
    ax2_top.XTickLabel = [];
    ax2_top.XLabel     = [];
    % make sure xlimis consistent
    ax2.XLim       = xlim1;
    ax2_top.XLim       = xlim1;
    % resize colorbar height
    ax2.Colorbar.Position(4) = ax2.Colorbar.Position(4)*2;

    %split upper 1000m to be half of the panel ax4
    xlim1 = ax4.XLim;
    % change limits and shrink positions
    ax4.YLim = [1000 6000]; ax4.Position(4) = ax4.Position(4)/2;
    % center the ylabel
    ax4.YAxis.Label.Units = 'normalized';
    ax4.YAxis.Label.Position(2) = 1;
    % copy axes with data
    ax4_top = copyobj(ax4,gcf);
    % change limits and shrink positions
    ax4_top.YLim = [0 1000]; ax4_top.Position(2) = ax4_top.Position(2) + ax4_top.Position(4);
    ax4_top.YLabel     = [];
    ax4_top.XTickLabel = [];
    ax4_top.XLabel     = [];
    % make sure xlimis consistent
    ax4.XLim       = xlim1;
    ax4_top.XLim       = xlim1;
    
    if index1 == 1 || index1 == 2  
        %add zone labels to the top %edited 
        text(ax2, -68, -4400, "Subpolar Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, -59,  -4400, "BZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, -55.5, -4400, "AZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, -52.5, -4400, "PFZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, -46, -4400, "SAZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, -37.5, -4400, "STZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
    end
    %add subplot letter
    subplot_letter = sublet(index1);
    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        text(ax4_top, -72, 140, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    elseif index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        text(ax4_top, -71, 140, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    end
end

%fluorescence plot
for index1 = 5
    category = char(categories(index1));
    if index1 == 5 
        w3 = ismember(ctd.stn, stations);
        w2 = ctd.depth <= 303; %only 300 m and less
        w = w3 & w2;
    end
    formatSpec = 'value = ctd.%s;';
    eval(sprintf(formatSpec, category))

    %remove nans
    w_test = ~isnan(value);
    w3_test = w.*w_test;
    w = w3_test;
    w3_test = w & w_test;
    w = w3_test;
    
    %remove flags
    %unique(ctd.fluorescence_flag)
    %flag 1, 2, and 6 are good
    formatSpec = 'w4 = (ctd.%s_flag == 1 | ctd.%s_flag == 2 | ctd.%s_flag == 6);';
    eval(sprintf(formatSpec, category, category, category))
    w4_test = w & w4;
    w = w4_test;

    if index1 == 5
        cmap_bins = [min(value(w)) 0.05 0.06 0.07 0.08 0.09 0.10 0.15 0.20 0.30 0.40 max(value(w))];
    end
    N_colorbins = length(cmap_bins);
    y = 0:N_colorbins-1; 
    dtr = interp1(cmap_bins, y, value(w));

    %plot UVP data over latitude with colorbar created
    depth = ctd.depth(w);
    zbin = min(depth):2:max(depth); % zbin = 0:5:max(depth(w)); 
    zbin = zbin';
    lat_axes = min(ctd.lat) :0.1: max(ctd.lat);
    [X1,Y1] = meshgrid(lat_axes,zbin);
    lat_stack = [];
    for in = 1:length(ctd.lat)
        lat_stack  = [lat_stack, repelem(ctd.lat(in), length(ctd.depth))'];
    end
    
    var_data=griddata(lat_stack(w),depth,dtr,X1,Y1);
    w2=find(var_data == min(min(var_data))); %EDITED 3/18/25
    var_data(w2) = min(dtr);%EDITED 3/18/25
    w2=find(var_data == max(max(var_data)));%EDITED 3/18/25
    var_data(w2) = max(dtr);%EDITED 3/18/25
    clear w2;%EDITED 3/18/25

    ax2 = axes;
    if index1 == 5
        set(ax2, 'Units', 'inches', 'Position', [0.45 0.5 3.36 1.94]) %0.45 2.44 3.36 1.75 
    end

    [C,h] = contourf(X1, Y1, var_data); 
    c = parula(N_colorbins - 1);
    colormap(ax2, c); %8/14 I had to specify the axis here because it was editing all of the colormaps at once
    set(h, 'LineColor', 'none');
    hold on
    temp4 = unique(lat_stack(w));
    ax2.YDir = 'reverse';
    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
    end
    if index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        yticklabels([]);
    end
    if index1 == 5 || index1 == 6
        xlabel('Longitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
        xticks([-65 -60 -55 -50 -45 -40 -35]);
        xticklabels({'65^oS','60^oS','55^oS','50^oS','45^oS','40^oS','35^oS'});
        xtickangle(30);
    end
    if index1 == 1 || index1 == 2 || index1 == 3 || index1 == 4 
        xticklabels([]);
        xlabel([]);
    end
    cblh = colorbar;
    
    if index1 == 5
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'0','0.05', '0.06', '0.07', '0.08', '0.09', '0.10', '0.15', '0.20',  '0.30', '0.40', ''});
    end
    cblh.Label.String = char(color_bar_label(index1)); 
    set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 8)
    hold on
    %plot MLD
    plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);
    ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
    value = ctd.pden;
    
    %set colorbar
    %cmap_bins = [24.5 24.75 25 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9 26 26.1 26.2 26.3 26.4 26.5 26.6 26.7 26.8 26.9 27 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
    cmap_bins = [24.5 25 25.25 25.5 26 26.5 26.75 27 27.15 27.5 27.6 27.7 27.75 27.8 27.85 27.9]; %25.75 26.25 27.2 27.25
    y = 1:length(cmap_bins); 
    
    % val_in_bin = round(length(value(w))/N_colorbins);
    % sort(value(w));
    % cmap_bins = [min(value(w))];
    % ordered = sort(value(w));
    % for in = 1:N_colorbins-1
    %     cmap_bins = [cmap_bins ordered(val_in_bin*in)];
    % end
    % cmap_bins(end+1) = max(value(w));
    % y = 1:N_colorbins+1;
    dtr = interp1(cmap_bins, y, value(w)); %this is for irregularly spaced intervals
    var_data=griddata(lat_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr

    if index1 == 1
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 5.94 2.75 1.75]); 
    elseif index1 == 2
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 5.94 2.75 1.75]);
    elseif index1 == 3
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 4.19 2.75 1.75]); 
    elseif index1 == 4
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 4.19 2.75 1.75]);
    elseif index1 == 5
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 0.5 2.75 1.94]);  %[0.45 2.44 2.75 1.75]
    elseif index1 == 6
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 2.44 2.75 1.76]);
    elseif index1 == 7
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 0.5 2.75 1.94]);
    elseif index1 == 8
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 0.5 2.75 1.94]);
    end

    %labels on sigma 2
    [C,h] = contour(ax4, X1, Y1, var_data,cmap_bins, 'showtext','on','LabelSpacing', 300);
    h.LevelList=round(h.LevelList,2);  %rounds levels to 3rd decimal place
    clabel(C,h)
    %no labels on sigma 2
    %[C,h] = contour(X1, Y1, var_data,cmap_bins);
    
    ax2.YLim = [0 300]; %ax2.XLim = [134.8611  235.1631];
    set(h, 'LineColor', 'w'); clabel(C,h, 'Color','w', 'LabelSpacing', 200, 'FontSize', 7);
    ax4.YDir = 'reverse';
    ax4.XTick = []; ax4.YTick = [];
    %ax4.XTickLabel = {'','','','','','','','','','',''};
    set(ax4, 'Color','none');%ax4.XLim = [134.8611  235.1631];
    
    rectangle('Position',[-49.983 0 11.4837  302.5], 'FaceColor', 'w', 'EdgeColor', 'none')

    %add lines and text labeling fronts and zones
    line([-60.7523 -60.7523], [0 302.5],'color',[0 0 0],'linewi',1); %SBDY
    line([-55.9998 -55.9998], [0 302.5],'color',[0 0 0],'linewi',1); %SACCF
    line([-53.5 -53.5], [0 302.5],'color',[0 0 0],'linewi',1)%, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
    %line([-49.5 -49.5], [0 6000],'color',[0 0 0],'linewi',1, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
    line([-49 -49], [0 302.5],'color',[0 0 0],'linewi',1); %SAF
    line([-40.6662 -40.6662], [0 302.5],'color',[0 0 0],'linewi',1); %STF
    %label fronts on bottom
    temp4 = unique(lat_stack(w));
    
    if index1 == 5 || index1 == 6
        text(ax2, -60.7523-1.25, 306, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, -55.9998-1.6, 306, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, -53.5-0.5, 306, "PF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, -49-1, 306, "SAF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, -40.6662-1, 306, "STF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
    end

    %add subplot letter
    subplot_letter = sublet(index1);
    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        text(ax2, -72, 20, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    elseif index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        text(ax2, -71, 20, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    end
    % %fix colorbar position to match 6000 m
    % cblh.Position = [0.8986-0.001 0.3126 0.0290 0.2244];
end

%adding bottle nutrients
for index1 = 6
   for in = 1:length(stations)
       w=find(bot.STNNBR == stations(in));
       lat_lon(in,1) = bot.LATITUDE(w(1));
       lat_lon(in,2) = bot.LONGITUDE(w(1));
       %find bottom depth in each sample
       bottom_depth(in,1) = bot.CTDPRS(w(end));
   end
    %Interpolate between stations to 5KM resolution
    lat = interp(lat_lon(:,1),15);
    long = interp(lat_lon(:,2),15);
    %download bathy file from etopo2
    [ELEV,LONG,LAT]=m_etopo2([min(lat_lon(:,2)) max(lat_lon(:,2)) min(lat_lon(:,1)) max(lat_lon(:,1))]);
    elevation = [];
    for in = 1:length(lat)
        temp = abs(LONG(1,:)-long(in));
        temp2 = find(temp == min(temp));
        lon_col(in) = LONG(1,temp2);
        temp = abs(LAT(:,1) - lat(in));
        temp3 = find(temp == min(temp));
        lat_row(in) = LAT(temp3,1);
        elevation(in) = ELEV(temp3,temp2);
    end
    
    w3 = ismember(bot.STNNBR, stations);
    w2 = bot.CTDPRS <= 310; 
    w = w3 & w2;
    
    category = char(categories_bot(index1-5));

    formatSpec = 'value = bot.%s;';
    eval(sprintf(formatSpec, category))

    %remove nans
    w_test = ~isnan(value);
    w3_test = w.*w_test;
    w = w3_test;
    w3_test = w & w_test;
    w = w3_test;
    
    %remove flags
    %unique(ctd.fluorescence_flag)
    %flag 1, 2, and 6 are good
    formatSpec = 'w4 = (bot.%s_FLAG_W == 1 | bot.%s_FLAG_W == 2 | bot.%s_FLAG_W == 6);';
    eval(sprintf(formatSpec, category, category, category))
    w4_test = w & w4;
    w = w4_test;
    if index1 == 6
        cmap_bins = [min(value(w)) 0.5 1 5 10 20 22.5 25 27.5 30 32.5 max(value(w))];
    end
   
    N_colorbins = length(cmap_bins);
    y = 0:N_colorbins-1; 
    dtr = interp1(cmap_bins, y, value(w));

    %plot UVP data over longitude with colorbar created
    depth = bot.CTDPRS;
    zbin = min(depth(w)):5:max(depth(w)); % zbin = 0:5:max(depth(w)); 
    zbin = zbin';
    lat_axes = min(bot.LATITUDE(w)) :0.1: max(bot.LATITUDE(w));
    [X1,Y1] = meshgrid(lat_axes,zbin);
    var_data=griddata(bot.LATITUDE(w),depth(w),dtr,X1,Y1);
    
    w2=find(var_data == min(min(var_data))); %EDITED 3/18/25
    var_data(w2) = min(dtr);%EDITED 3/18/25
    w2=find(var_data == max(max(var_data)));%EDITED 3/18/25
    var_data(w2) = max(dtr);%EDITED 3/18/25
    clear w2;%EDITED 3/18/25

    ax2 = axes;
    if index1 == 6
        set(ax2, 'Units', 'inches', 'Position', [4.03 0.5 3.36 1.94]) %[4.03 2.44 3.36 1.75]
    elseif index1 == 7
        set(ax2, 'Units', 'inches', 'Position', [0.45 0.5 3.36 1.94]) 
    elseif index1 == 8
        set(ax2, 'Units', 'inches', 'Position', [4.03 0.5 3.36 1.94])
    end

    [C,h] = contourf(X1, Y1, var_data); 
    c = parula(N_colorbins - 1);
    colormap(ax2, c); %8/14 I had to specify the axis here because it was editing all of the colormaps at once
    set(h, 'LineColor', 'none');
    hold on
    scatter(bot.LATITUDE(w), depth(w), 1,'MarkerFaceColor','k','MarkerEdgeColor','none') %mark sample locations

    temp4 = unique(lat_stack(w));
    ax2.YDir = 'reverse';

    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
    end
    if index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        yticklabels([]);
    end
    if index1 == 5 || index1 == 6
        xlabel('Latitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
        xticks([-65 -60 -55 -50 -45 -40 -35]);
        xticklabels({'65^oS','60^oS','55^oS','50^oS','45^oS','40^oS','35^oS'});
        xtickangle(30);
    end
    if index1 == 1 || index1 == 2 || index1 == 3 || index1 == 4 
        xticklabels([]);
        xlabel([]);
    end
    cblh = colorbar;
    if index1 == 6 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'0','0.5', '1', '5', '10', '20', '22.5', '25', '27.5',  '30', '32.5', ''});
    end
    if index1 == 7 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'0','0.5', '1', '5', '10', '20', '22.5', '25', '27.5',  '30', '32.5', ''}); 
    end
    if index1 == 8 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'0', '0.1', '0.3', '0.5', '1.5', '1.6', '1.7', '1.8', '1.9', '2', '2.2', ''});
    end
    
    cblh.Label.String = char(color_bar_label(index1)); 
    set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 8)
    hold on
    %plot MLD
    plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);

    ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
    value = ctd.pden;
    
    %set colorbar
    %cmap_bins = [24.5 24.75 25 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9 26 26.1 26.2 26.3 26.4 26.5 26.6 26.7 26.8 26.9 27 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
    %cmap_bins = [24.5 25 25.25 25.5 25.75 26 26.25 26.5 26.75 27 27.2 27.25 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
    cmap_bins = [24.5 25 25.25 25.5 26 26.5 26.75 27 27.15 27.5 27.6 27.7 27.75 27.8 27.85 27.9]; %25.75 26.25 27.2 27.25

    y = 1:length(cmap_bins); 
    
    %dtr = interp1(cmap_bins, y, value(w)); %this is for irregularly spaced intervals

    %error here
    %var_data=griddata(lat_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr


    %taken from fluorescence plot

    % I think I need to fully switch to CTD data to plot the contours
    % because I want them to be the same. Not sure where the issue is
    % coming from

    w3 = ismember(ctd.stn, stations);
    w2 = ctd.depth <= 303; %only 300 m and less
    w = w3 & w2;

    %remove nans
    w_test = ~isnan(value);
    w3_test = w.*w_test;
    w = w3_test;
    w3_test = w & w_test;
    w = w3_test;
    
    dtr = interp1(cmap_bins, y, value(w)); %this is for irregularly spaced intervals



    %plot UVP data over latitude with colorbar created
    depth = ctd.depth(w);
    zbin = min(depth):2:max(depth); % zbin = 0:5:max(depth(w)); 
    zbin = zbin';
    lat_axes = min(ctd.lat) :0.1: max(ctd.lat);
    [X1,Y1] = meshgrid(lat_axes,zbin);
    lat_stack = [];
    for in = 1:length(ctd.lat)
        lat_stack  = [lat_stack, repelem(ctd.lat(in), length(ctd.depth))'];
    end

    var_data=griddata(lat_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr
    
    if index1 == 6
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 0.5 2.75 1.94]); %[4.03 2.44 2.75 1.76]
    elseif index1 == 7
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 0.5 2.75 1.94]);
    elseif index1 == 8
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 0.5 2.75 1.94]);
    end

    %labels on sigma 2
    [C,h] = contour(ax4, X1, Y1, var_data,cmap_bins, 'showtext','on','LabelSpacing', 300);
    h.LevelList=round(h.LevelList,2);  %rounds levels to 3rd decimal place
    clabel(C,h)
    %no labels on sigma 2
    %[C,h] = contour(X1, Y1, var_data,cmap_bins);
    
    ax2.YLim = [0 300]; %ax2.XLim = [134.8611  235.1631];
    set(h, 'LineColor', 'w'); clabel(C,h, 'Color','w', 'LabelSpacing', 200, 'FontSize', 7);
    ax4.YDir = 'reverse';
    ax4.XTick = []; ax4.YTick = [];
    %ax4.XTickLabel = {'','','','','','','','','','',''};
    set(ax4, 'Color','none');%ax4.XLim = [134.8611  235.1631];
    
    rectangle('Position',[-49.983 0 11.4837  302.5], 'FaceColor', 'w', 'EdgeColor', 'none')

    %add lines and text labeling fronts and zones
    line([-60.7523 -60.7523], [0 302.5],'color',[0 0 0],'linewi',1); %SBDY
    line([-55.9998 -55.9998], [0 302.5],'color',[0 0 0],'linewi',1); %SACCF
    line([-53.5 -53.5], [0 302.5],'color',[0 0 0],'linewi',1)%, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
    %line([-49.5 -49.5], [0 6000],'color',[0 0 0],'linewi',1, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
    line([-49 -49], [0 302.5],'color',[0 0 0],'linewi',1); %SAF
    line([-40.6662 -40.6662], [0 302.5],'color',[0 0 0],'linewi',1); %STF
    % %label fronts on bottom
    % temp4 = unique(lat_stack(w));
    
    if index1 == 5 || index1 == 6
        text(ax2, -60.7523-1.25, 306, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, -55.9998-1.6, 306, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, -53.5-0.5, 306, "PF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, -49-1, 306, "SAF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, -40.6662-1, 306, "STF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
    end

    %add subplot letter
    subplot_letter = sublet(index1);
    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        text(ax2, -72, 20, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    elseif index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        text(ax2, -71, 20, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    end
end
%save figure
print("G:/Cruises/2019_I06S/I06s_multi_panel_CTD_Environment_6panel", "-dpng","-r300");

%% Plot data 6000 from CTD file

fig2 = figure;
set(fig2, 'Units', 'inches', 'Position', [0.4417 0.6167 7.67 7.8]); 
stations = unique(ctd.stn)'; 

%pull out lat and long from each station location
for in = 1:length(stations)
   w=find(ctd.stn == stations(in));
   lat_lon(in,1) = ctd.lat(w);
   lat_lon(in,2) = wrapTo360(ctd.lon(w));
   %find bottom depth in each sample
   %bottom_depth(in,1) = ctd.depth(end,w(1));
end
lat_lon = sortrows(lat_lon, 1); %sort so lat is from min to max, added on 5/13/2025

%Interpolate between stations to 5KM resolution
%lat = interp(ctd.lat,15);
%long = interp(ctd.lon,15);
lat = interp1([1:length(lat_lon(:,1))]',lat_lon(:,1), linspace(1,55, 630)); 
long = interp1([1:length(lat_lon(:,2))]',lat_lon(:,2), linspace(1,55, 630));

%download bathy file from etopo2
%[ELEV,LONG,LAT]=m_etopo2([min(ctd.lon) max(ctd.lon) min(ctd.lat) max(ctd.lat)]);
[ELEV,LONG,LAT]=m_etopo2([min(lat_lon(:,2)) max(lat_lon(:,2)) min(lat_lon(:,1)) max(lat_lon(:,1))]);

%find row/column that best matches exact station locations interpolated
elevation = [];
for in = 1:length(lat)
    temp = abs(LONG(1,:)-long(in));
    temp2 = find(temp == min(temp));
    lon_col(in) = LONG(1,temp2);
    temp = abs(LAT(:,1) - lat(in));
    temp3 = find(temp == min(temp));
    lat_row(in) = LAT(temp3,1);
    elevation(in) = ELEV(temp3,temp2);
end

for index1 = 1:4%loop through all categories of particles
    category = char(categories(index1));
    w = ismember(ctd.stn, stations);
    
    formatSpec = 'value = ctd.%s;';
    eval(sprintf(formatSpec, category))   

    %remove nans
    w_test = ~isnan(value);
    w3_test = w.*w_test;
    w = w3_test;
    w3_test = w & w_test;
    w = w3_test;
    
    %remove flags
    %unique(ctd.fluorescence_flag)
    %flag 1, 2, and 6 are good
    formatSpec = 'w4 = (ctd.%s_flag == 1 | ctd.%s_flag == 2 | ctd.%s_flag == 6);';
    eval(sprintf(formatSpec, category, category, category))
    w4_test = w & w4;
    w = w4_test;
    
    % %makes flagged 6 data NaN %6 flag means: interpolated_over_a_pressure_interval_larger_than_2_dbar
    % w4 = find(ctd.fluorescence_flag == 6);
    % ctd.fluorescence(w4) = NaN;

    if index1 == 1
        cmap_bins = [min(value(w)) 0 1 2 3 5 7.5 10 15 20 max(value(w))];
    end
    if index1 == 2
        cmap_bins = [min(value(w)) 34 34.25 34.5 34.6 34.65 34.7 34.75 35 35.25 35.5 max(value(w))];
    end
    if index1 == 3 
        cmap_bins = [min(value(w)) 150 175 200 210 220 230 240 250 300 350 max(value(w))];
    end
    if index1 == 4
        cmap_bins = [min(value(w)) -5 0 25 50 75 100 130 140 145 200 max(value(w))];
    end
    N_colorbins = length(cmap_bins);
    y = 0:N_colorbins-1; 
    dtr = interp1(cmap_bins, y, value(w));

   %plot UVP data over latitude with colorbar created
    depth = ctd.depth(w);
    zbin = min(depth):2:max(depth); % zbin = 0:5:max(depth(w)); 
    zbin = zbin';
    lat_axes = min(ctd.lat) :0.1: max(ctd.lat);
    [X1,Y1] = meshgrid(lat_axes,zbin);
    lat_stack = [];
    for in = 1:length(ctd.lat)
        lat_stack  = [lat_stack, repelem(ctd.lat(in), length(ctd.depth))'];
    end
    
    var_data=griddata(lat_stack(w),depth,dtr,X1,Y1);
    
    w2=find(var_data == min(min(var_data))); %EDITED 3/18/25
    var_data(w2) = min(dtr);%EDITED 3/18/25
    w2=find(var_data == max(max(var_data)));%EDITED 3/18/25
    var_data(w2) = max(dtr);%EDITED 3/18/25
    clear w2;%EDITED 3/18/25
    ax2 = axes;

    if index1 == 1
        set(ax2, 'Units', 'inches', 'Position', [0.45 5.94 3.36 1.75]) 
    elseif index1 == 2
        set(ax2, 'Units', 'inches', 'Position', [4.03 5.94 3.36 1.75])
    elseif index1 == 3
        set(ax2, 'Units', 'inches', 'Position', [0.45 4.19 3.36 1.75])
    elseif index1 == 4
        set(ax2, 'Units', 'inches', 'Position', [4.03 4.19 3.36 1.75])
    end

    [C,h] = contourf(X1, Y1, var_data); 
    c = parula(N_colorbins - 1);
    colormap(ax2, c); %8/14 I had to specify the axis here because it was editing all of the colormaps at once
    set(h, 'LineColor', 'none');
    hold on

    if index1 == 1 || index1 == 2
        plot(ax2,unique(lat_stack(w)),zeros([1 length(unique(lat_stack(w)))]),'r|','MarkerSize',5)
    end
    temp4 = unique(lat_stack(w));
    ax2.YDir = 'reverse';
    %Bathymetry
    hold on
    p = patch([lat lat(end) lat(1)], [elevation.*-1 6000 6000],'k');
    set(p, 'facecolor',[0.5 0.5 0.5], 'edgecolor', [0.5 0.5 0.5]);

    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
    end
    if index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        yticklabels([]);
    end
    if index1 == 5 || index1 == 6
        xlabel('Latitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
        xticks([-65 -60 -55 -50 -45 -40 -35]);
        xticklabels({'65^oS','60^oS','55^oS','50^oS','45^oS','40^oS','35^oS'});
        xtickangle(30);
    end
    if index1 == 1 || index1 == 2 || index1 == 3 || index1 == 4 
        xticklabels([]);
        xlabel([]);
    end
    cblh = colorbar;
    if index1 == 1 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'-2', '0', '1', '2', '3', '5', '7.5', '10', '15', '20', ''});
    end
    if index1 == 2 
        cblh.YTick = y;
        set(cblh,'yticklabel',{'33.75', '34', '34.25', '34.5', '34.6', '34.65', '34.7', '34.75', '35', '35.25', '35.5' ''});
    end 
    if index1 == 3 
        cblh.YTick = y; 
        %set(cblh,'yticklabel',{'10', '15', '25', '50', '100', '150', '200', '210', '220', '230', '240', ''});
        set(cblh,'yticklabel',{'0', '150', '175', '200', '210', '220', '230', '240', '250', '300', '350', ''});
    end
    if index1 == 4
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'','-5', '0', '25', '50', '75', '100', '130', '140', '145', '200', ''});
    end
    cblh.Label.String = char(color_bar_label(index1)); 
    set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 8)
    hold on
    %plot MLD
    plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);
    %plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'MarkerEdgeColor', 'r', 'LineWidth', 1.5);

    ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
    value = ctd.pden;
    cmap_bins = [23.5 24 24.5 25 25.5 26 26.5 27 27.5 27.6 27.7 27.8 27.85 27.9];
    %cmap_bins = [24.5 24.75 25 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9 26 26.1 26.2 26.3 26.4 26.5 26.6 26.7 26.8 26.9 27 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
    y = 1:length(cmap_bins); 
    dtr = interp1(cmap_bins, y, value(w)); %this is for irregularly spaced intervals
    var_data=griddata(lat_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr
    if index1 == 1
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 5.94 2.75 1.75]); 
    elseif index1 == 2
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 5.94 2.75 1.75]);
    elseif index1 == 3
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 4.19 2.75 1.75]); 
    elseif index1 == 4
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 4.19 2.75 1.75]);
    end
    %labels on sigma 2
    [C,h] = contour(ax4, X1, Y1, var_data,cmap_bins, 'showtext','on');
    h.LevelList=round(h.LevelList,2);  %rounds levels to 3rd decimal place
    clabel(C,h);
    %no labels on sigma 2
    %[C,h] = contour(X1, Y1, var_data,cmap_bins);
    
    set(h, 'LineColor', 'w'); clabel(C,h, 'Color','w', 'LabelSpacing', 100, 'FontSize', 8);
    ax4.YDir = 'reverse';
    ax4.XTick = []; ax4.YTick = [];
    set(ax4, 'Color','none');
    %ylim([0 300]);
    
    rectangle('Position',[-49.983 0 11.4837  6000], 'FaceColor', 'w', 'EdgeColor', 'none')

    %add lines and text labeling fronts and zones
    line([-60.7523 -60.7523], [0 6000],'color',[0 0 0],'linewi',1); %SBDY
    line([-55.9998 -55.9998], [0 6000],'color',[0 0 0],'linewi',1); %SACCF
    line([-53.5 -53.5], [0 6000],'color',[0 0 0],'linewi',1)%, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
    %line([-49.5 -49.5], [0 6000],'color',[0 0 0],'linewi',1, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
    line([-49 -49], [0 6000],'color',[0 0 0],'linewi',1); %SAF
    line([-40.6662 -40.6662], [0 6000],'color',[0 0 0],'linewi',1); %STF
    %label fronts on bottom
    temp4 = unique(lat_stack(w));
    
    % text(ax2, -60.7523-1.25, 6100, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 14);
    % text(ax2, -55.9998-1.6, 6100, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
    % text(ax2, -53.5-0.5, 6100, "PF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
    % text(ax2, -49-1, 306, "SAF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
    % text(ax2, -40.6662-1, 6100, "STF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
    
    % hold on
    % p1 = patch([lat_lon(11:32,1)' max(lat_lon(11:32,1)) min(lat_lon(11:32,1))], [(bottom_depth(11:32))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');
    % p1 = patch([lat_lon(1:10,1)' max(lat_lon(1:10,1)) min(lat_lon(1:10,1))], [(bottom_depth(1:10))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');
    % p1 = patch([lat_lon(33:end,1)'  min(lat_lon(33:end,1)) max(lat_lon(33:end,1))], [(bottom_depth(33:end))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');%p = patch([long' long(end) long(1)], [elevation.*-1 4810 4810],'k');%p = patch([long' long(end) long(1)], [elevation.*-1 4810 4810],'k');
    
    %split upper 1000m to be half of the panel
    xlim1 = ax2.XLim;
    % change limits and shrink positions
    ax2.YLim = [1000 6000]; ax2.Position(4) = ax2.Position(4)/2;
    % center the ylabel
    ax2.YAxis.Label.Units = 'normalized';
    ax2.YAxis.Label.Position(2) = 1;
    % copy axes with data
    ax2_top = copyobj(ax2,gcf);
    % change limits and shrink positions
    ax2_top.YLim = [0 1000]; ax2_top.Position(2) = ax2_top.Position(2) + ax2_top.Position(4);
    ax2_top.YLabel     = [];
    ax2_top.XTickLabel = [];
    ax2_top.XLabel     = [];
    % make sure xlimis consistent
    ax2.XLim       = xlim1;
    ax2_top.XLim       = xlim1;
    % resize colorbar height
    ax2.Colorbar.Position(4) = ax2.Colorbar.Position(4)*2;

    %split upper 1000m to be half of the panel ax4
    xlim1 = ax4.XLim;
    % change limits and shrink positions
    ax4.YLim = [1000 6000]; ax4.Position(4) = ax4.Position(4)/2;
    % center the ylabel
    ax4.YAxis.Label.Units = 'normalized';
    ax4.YAxis.Label.Position(2) = 1;
    % copy axes with data
    ax4_top = copyobj(ax4,gcf);
    % change limits and shrink positions
    ax4_top.YLim = [0 1000]; ax4_top.Position(2) = ax4_top.Position(2) + ax4_top.Position(4);
    ax4_top.YLabel     = [];
    ax4_top.XTickLabel = [];
    ax4_top.XLabel     = [];
    % make sure xlimis consistent
    ax4.XLim       = xlim1;
    ax4_top.XLim       = xlim1;
    
    if index1 == 1 || index1 == 2  
        %add zone labels to the top %edited
        text(ax2, -68, -4400, "SP Region", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, -60.5,  -4400, "S Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, -56.7, -4400, "A Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, -53, -4400, "PF Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, -48.5, -4400, "SA Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, -40, -4400, "ST Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
    end
    %add subplot letter
    subplot_letter = sublet(index1);
    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        text(ax4_top, -72, 140, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    elseif index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        text(ax4_top, -71, 140, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    end
end

%fluorescence plot
for index1 = 5
    category = char(categories(index1));
    if index1 == 5 
        w3 = ismember(ctd.stn, stations);
        w2 = ctd.depth <= 303; %only 300 m and less
        w = w3 & w2;
    end
    formatSpec = 'value = ctd.%s;';
    eval(sprintf(formatSpec, category))

    %remove nans
    w_test = ~isnan(value);
    w3_test = w.*w_test;
    w = w3_test;
    w3_test = w & w_test;
    w = w3_test;
    
    %remove flags
    %unique(ctd.fluorescence_flag)
    %flag 1, 2, and 6 are good
    formatSpec = 'w4 = (ctd.%s_flag == 1 | ctd.%s_flag == 2 | ctd.%s_flag == 6);';
    eval(sprintf(formatSpec, category, category, category))
    w4_test = w & w4;
    w = w4_test;

    if index1 == 5
        cmap_bins = [min(value(w)) 0.05 0.06 0.07 0.08 0.09 0.10 0.15 0.20 0.30 0.40 max(value(w))];
    end
    N_colorbins = length(cmap_bins);
    y = 0:N_colorbins-1; 
    dtr = interp1(cmap_bins, y, value(w));

    %plot UVP data over latitude with colorbar created
    depth = ctd.depth(w);
    zbin = min(depth):2:max(depth); % zbin = 0:5:max(depth(w)); 
    zbin = zbin';
    lat_axes = min(ctd.lat) :0.1: max(ctd.lat);
    [X1,Y1] = meshgrid(lat_axes,zbin);
    lat_stack = [];
    for in = 1:length(ctd.lat)
        lat_stack  = [lat_stack, repelem(ctd.lat(in), length(ctd.depth))'];
    end
    
    var_data=griddata(lat_stack(w),depth,dtr,X1,Y1);
    w2=find(var_data == min(min(var_data))); %EDITED 3/18/25
    var_data(w2) = min(dtr);%EDITED 3/18/25
    w2=find(var_data == max(max(var_data)));%EDITED 3/18/25
    var_data(w2) = max(dtr);%EDITED 3/18/25
    clear w2;%EDITED 3/18/25

    ax2 = axes;
    if index1 == 5
        set(ax2, 'Units', 'inches', 'Position', [0.45 2.44 3.36 1.75]) 
    end

    [C,h] = contourf(X1, Y1, var_data); 
    c = parula(N_colorbins - 1);
    colormap(ax2, c); %8/14 I had to specify the axis here because it was editing all of the colormaps at once
    set(h, 'LineColor', 'none');
    hold on
    temp4 = unique(lat_stack(w));
    ax2.YDir = 'reverse';
    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
    end
    if index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        yticklabels([]);
    end
    if index1 == 7 || index1 == 8
        xlabel('Longitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
        xticks([-65 -60 -55 -50 -45 -40 -35]);
        xticklabels({'65^oS','60^oS','55^oS','50^oS','45^oS','40^oS','35^oS'});
        xtickangle(30);
    end
    if index1 == 1 || index1 == 2 || index1 == 3 || index1 == 4 || index1 == 5 || index1 == 6
        xticklabels([]);
        xlabel([]);
    end
    cblh = colorbar;
    
    if index1 == 5
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'0','0.05', '0.06', '0.07', '0.08', '0.09', '0.10', '0.15', '0.20',  '0.30', '0.40', ''});
    end
    cblh.Label.String = char(color_bar_label(index1)); 
    set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 8)
    hold on
    %plot MLD
    plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);
    ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
    value = ctd.pden;
    
    %set colorbar
    %cmap_bins = [24.5 24.75 25 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9 26 26.1 26.2 26.3 26.4 26.5 26.6 26.7 26.8 26.9 27 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
    cmap_bins = [24.5 25 25.25 25.5 25.75 26 26.25 26.5 26.75 27 27.2 27.25 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
    y = 1:length(cmap_bins); 
    
    % val_in_bin = round(length(value(w))/N_colorbins);
    % sort(value(w));
    % cmap_bins = [min(value(w))];
    % ordered = sort(value(w));
    % for in = 1:N_colorbins-1
    %     cmap_bins = [cmap_bins ordered(val_in_bin*in)];
    % end
    % cmap_bins(end+1) = max(value(w));
    % y = 1:N_colorbins+1;
    dtr = interp1(cmap_bins, y, value(w)); %this is for irregularly spaced intervals
    var_data=griddata(lat_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr

    if index1 == 1
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 5.94 2.75 1.75]); 
    elseif index1 == 2
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 5.94 2.75 1.75]);
    elseif index1 == 3
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 4.19 2.75 1.75]); 
    elseif index1 == 4
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 4.19 2.75 1.75]);
    elseif index1 == 5
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 2.44 2.75 1.75]);
    elseif index1 == 6
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 2.44 2.75 1.76]);
    elseif index1 == 7
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 0.5 2.75 1.94]);
    elseif index1 == 8
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 0.5 2.75 1.94]);
    end

    %labels on sigma 2
    [C,h] = contour(ax4, X1, Y1, var_data,cmap_bins, 'showtext','on','LabelSpacing', 300);
    h.LevelList=round(h.LevelList,2);  %rounds levels to 3rd decimal place
    clabel(C,h)
    %no labels on sigma 2
    %[C,h] = contour(X1, Y1, var_data,cmap_bins);
    
    ax2.YLim = [0 300]; %ax2.XLim = [134.8611  235.1631];
    set(h, 'LineColor', 'w'); clabel(C,h, 'Color','w', 'LabelSpacing', 200, 'FontSize', 8);
    ax4.YDir = 'reverse';
    ax4.XTick = []; ax4.YTick = [];
    %ax4.XTickLabel = {'','','','','','','','','','',''};
    set(ax4, 'Color','none');%ax4.XLim = [134.8611  235.1631];
    
    rectangle('Position',[-49.983 0 11.4837  300], 'FaceColor', 'w', 'EdgeColor', 'none')

    %add lines and text labeling fronts and zones
    line([-60.7523 -60.7523], [0 300],'color',[0 0 0],'linewi',1); %SBDY
    line([-55.9998 -55.9998], [0 300],'color',[0 0 0],'linewi',1); %SACCF
    line([-53.5 -53.5], [0 300],'color',[0 0 0],'linewi',1)%, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
    %line([-49.5 -49.5], [0 6000],'color',[0 0 0],'linewi',1, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
    line([-49 -49], [0 300],'color',[0 0 0],'linewi',1); %SAF
    line([-40.6662 -40.6662], [0 300],'color',[0 0 0],'linewi',1); %STF
    %label fronts on bottom
    temp4 = unique(lat_stack(w));
    
    % text(ax2, -60.7523-1.25, 306, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 6);
    % text(ax2, -55.9998-1.6, 306, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
    % text(ax2, -53.5-0.5, 306, "PF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
    % text(ax2, -49-1, 306, "SAF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
    % text(ax2, -40.6662-1, 306, "STF", 'FontName','helvetica','fontweight','bold','fontsize', 6);

    %add subplot letter
    subplot_letter = sublet(index1);
    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        text(ax2, -72, 20, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    elseif index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        text(ax2, -71, 20, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    end
    % %fix colorbar position to match 6000 m
    % cblh.Position = [0.8986-0.001 0.3126 0.0290 0.2244];
end

%adding bottle nutrients
for index1 = 6:8
   for in = 1:length(stations)
       w=find(bot.STNNBR == stations(in));
       lat_lon(in,1) = bot.LATITUDE(w(1));
       lat_lon(in,2) = bot.LONGITUDE(w(1));
       %find bottom depth in each sample
       bottom_depth(in,1) = bot.CTDPRS(w(end));
   end
    %Interpolate between stations to 5KM resolution
    lat = interp(lat_lon(:,1),15);
    long = interp(lat_lon(:,2),15);
    %download bathy file from etopo2
    [ELEV,LONG,LAT]=m_etopo2([min(lat_lon(:,2)) max(lat_lon(:,2)) min(lat_lon(:,1)) max(lat_lon(:,1))]);
    elevation = [];
    for in = 1:length(lat)
        temp = abs(LONG(1,:)-long(in));
        temp2 = find(temp == min(temp));
        lon_col(in) = LONG(1,temp2);
        temp = abs(LAT(:,1) - lat(in));
        temp3 = find(temp == min(temp));
        lat_row(in) = LAT(temp3,1);
        elevation(in) = ELEV(temp3,temp2);
    end
    
    w3 = ismember(bot.STNNBR, stations);
    w2 = bot.CTDPRS <= 310; 
    w = w3 & w2;
    
    category = char(categories_bot(index1-5));

    formatSpec = 'value = bot.%s;';
    eval(sprintf(formatSpec, category))

    %remove nans
    w_test = ~isnan(value);
    w3_test = w.*w_test;
    w = w3_test;
    w3_test = w & w_test;
    w = w3_test;
    
    %remove flags
    %unique(ctd.fluorescence_flag)
    %flag 1, 2, and 6 are good
    formatSpec = 'w4 = (bot.%s_FLAG_W == 1 | bot.%s_FLAG_W == 2 | bot.%s_FLAG_W == 6);';
    eval(sprintf(formatSpec, category, category, category))
    w4_test = w & w4;
    w = w4_test;
    if index1 == 6
        cmap_bins = [min(value(w)) 2 4 5 10 35 40 42.5 45 60 80 max(value(w))];
    end
    if index1 == 7
        cmap_bins = [min(value(w)) 0.5 1 5 10 20 22.5 25 27.5 30 32.5 max(value(w))];
    end
    if index1 == 8 
        cmap_bins = [min(value(w)) 0.1 0.3 0.5 1.5 1.6 1.7 1.8 1.9 2 2.2 max(value(w))];
    end

    N_colorbins = length(cmap_bins);
    y = 0:N_colorbins-1; 
    dtr = interp1(cmap_bins, y, value(w));

    %plot UVP data over longitude with colorbar created
    depth = bot.CTDPRS;
    zbin = min(depth(w)):5:max(depth(w)); % zbin = 0:5:max(depth(w)); 
    zbin = zbin';
    lat_axes = min(bot.LATITUDE(w)) :0.1: max(bot.LATITUDE(w));
    [X1,Y1] = meshgrid(lat_axes,zbin);
    var_data=griddata(bot.LATITUDE(w),depth(w),dtr,X1,Y1);
    
    w2=find(var_data == min(min(var_data))); %EDITED 3/18/25
    var_data(w2) = min(dtr);%EDITED 3/18/25
    w2=find(var_data == max(max(var_data)));%EDITED 3/18/25
    var_data(w2) = max(dtr);%EDITED 3/18/25
    clear w2;%EDITED 3/18/25

    ax2 = axes;
    if index1 == 6
        set(ax2, 'Units', 'inches', 'Position', [4.03 2.44 3.36 1.75])
    elseif index1 == 7
        set(ax2, 'Units', 'inches', 'Position', [0.45 0.5 3.36 1.94]) 
    elseif index1 == 8
        set(ax2, 'Units', 'inches', 'Position', [4.03 0.5 3.36 1.94])
    end

    [C,h] = contourf(X1, Y1, var_data); 
    c = parula(N_colorbins - 1);
    colormap(ax2, c); %8/14 I had to specify the axis here because it was editing all of the colormaps at once
    set(h, 'LineColor', 'none');
    hold on
    scatter(bot.LATITUDE(w), depth(w), 1,'MarkerFaceColor','k','MarkerEdgeColor','none') %mark sample locations

    temp4 = unique(lat_stack(w));
    ax2.YDir = 'reverse';

    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
    end
    if index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        yticklabels([]);
    end
    if index1 == 7 || index1 == 8
        xlabel('Latitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
        xticks([-65 -60 -55 -50 -45 -40 -35]);
        xticklabels({'65^oS','60^oS','55^oS','50^oS','45^oS','40^oS','35^oS'});
        xtickangle(30);
    end
    if index1 == 1 || index1 == 2 || index1 == 3 || index1 == 4 || index1 == 5 || index1 == 6
        xticklabels([]);
        xlabel([]);
    end
    cblh = colorbar;
    if index1 == 6 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'0', '2', '4', '5', '10', '35', '40', '42.5', '45', '60', '80', ''});
    end
    if index1 == 7 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'0','0.5', '1', '5', '10', '20', '22.5', '25', '27.5',  '30', '32.5', ''}); 
    end
    if index1 == 8 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'0', '0.1', '0.3', '0.5', '1.5', '1.6', '1.7', '1.8', '1.9', '2', '2.2', ''});
    end
    
    cblh.Label.String = char(color_bar_label(index1)); 
    set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 8)
    hold on
    %plot MLD
    plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);

    ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
    value = ctd.pden;
    
    %set colorbar
    %cmap_bins = [24.5 24.75 25 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9 26 26.1 26.2 26.3 26.4 26.5 26.6 26.7 26.8 26.9 27 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
    cmap_bins = [24.5 25 25.25 25.5 25.75 26 26.25 26.5 26.75 27 27.2 27.25 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
    y = 1:length(cmap_bins); 
    
    %dtr = interp1(cmap_bins, y, value(w)); %this is for irregularly spaced intervals

    %error here
    %var_data=griddata(lat_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr


    %taken from fluorescence plot

    % I think I need to fully switch to CTD data to plot the contours
    % because I want them to be the same. Not sure where the issue is
    % coming from

    w3 = ismember(ctd.stn, stations);
    w2 = ctd.depth <= 303; %only 300 m and less
    w = w3 & w2;

    %remove nans
    w_test = ~isnan(value);
    w3_test = w.*w_test;
    w = w3_test;
    w3_test = w & w_test;
    w = w3_test;
    
    dtr = interp1(cmap_bins, y, value(w)); %this is for irregularly spaced intervals



    %plot UVP data over latitude with colorbar created
    depth = ctd.depth(w);
    zbin = min(depth):2:max(depth); % zbin = 0:5:max(depth(w)); 
    zbin = zbin';
    lat_axes = min(ctd.lat) :0.1: max(ctd.lat);
    [X1,Y1] = meshgrid(lat_axes,zbin);
    lat_stack = [];
    for in = 1:length(ctd.lat)
        lat_stack  = [lat_stack, repelem(ctd.lat(in), length(ctd.depth))'];
    end

    var_data=griddata(lat_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr
    
    if index1 == 6
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 2.44 2.75 1.76]);
    elseif index1 == 7
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 0.5 2.75 1.94]);
    elseif index1 == 8
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 0.5 2.75 1.94]);
    end

    %labels on sigma 2
    [C,h] = contour(ax4, X1, Y1, var_data,cmap_bins, 'showtext','on','LabelSpacing', 300);
    h.LevelList=round(h.LevelList,2);  %rounds levels to 3rd decimal place
    clabel(C,h)
    %no labels on sigma 2
    %[C,h] = contour(X1, Y1, var_data,cmap_bins);
    
    ax2.YLim = [0 300]; %ax2.XLim = [134.8611  235.1631];
    set(h, 'LineColor', 'w'); clabel(C,h, 'Color','w', 'LabelSpacing', 200, 'FontSize', 8);
    ax4.YDir = 'reverse';
    ax4.XTick = []; ax4.YTick = [];
    %ax4.XTickLabel = {'','','','','','','','','','',''};
    set(ax4, 'Color','none');%ax4.XLim = [134.8611  235.1631];
    
    rectangle('Position',[-49.983 0 11.4837  300], 'FaceColor', 'w', 'EdgeColor', 'none')

    %add lines and text labeling fronts and zones
    line([-60.7523 -60.7523], [0 300],'color',[0 0 0],'linewi',1); %SBDY
    line([-55.9998 -55.9998], [0 300],'color',[0 0 0],'linewi',1); %SACCF
    line([-53.5 -53.5], [0 300],'color',[0 0 0],'linewi',1)%, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
    %line([-49.5 -49.5], [0 6000],'color',[0 0 0],'linewi',1, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
    line([-49 -49], [0 300],'color',[0 0 0],'linewi',1); %SAF
    line([-40.6662 -40.6662], [0 300],'color',[0 0 0],'linewi',1); %STF
    % %label fronts on bottom
    % temp4 = unique(lat_stack(w));
    
    if index1 == 7 || index1 == 8
        text(ax2, -60.7523-1.25, 306, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, -55.9998-1.6, 306, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, -53.5-0.5, 306, "PF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, -49-1, 306, "SAF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, -40.6662-1, 306, "STF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
    end

    %add subplot letter
    subplot_letter = sublet(index1);
    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        text(ax2, -72, 20, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    elseif index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        text(ax2, -71, 20, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    end
end
%save figure
print("G:/Cruises/2019_I06S/I06s_multi_panel_CTD_Environment_8panel", "-dpng","-r300");

%% calculate MLD with CTD data
ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000

%create variable to store all calculated mixed layer depths
mld = []; latitude_mld = [];

%loop through all casts
for index = 1:length(stations)
    w = find(ctd.stn == stations(index));
    w2 = ~isnan(ctd.depth(:,w));
    mld = [mld, calc_mld(ctd.depth(w2,w), ctd.pden(w2,w)+1000)];
    %mld_temp = calc_mld(ctd.depth(w), ctd.pden(w));
    latitude_mld = [latitude_mld, ctd.lat(w)];
    %den = par.pden(w);
    %dep = par.Depth(w);
    % %plot results
    % b = zeros(1,length(den(1:21)));
    % b = b + mld_temp;
    % fig = figure();
    % plot(den(1:21), dep(1:21), 'ok') 
    % hold on
    % plot(den(1:21), b, '-r')
    % ylim = [min(den(1:11)) max(dep(1:21))];
    % set(gca, 'YDir','reverse');%flip y axis
    % xlabel('Density (kg m^-^3)'); %x axis label
    % ylabel('Depth (m)');%y axis label
    % title(par.site(w(1)))
end

%now you can toggle through the plots and see if the function did a good job

stn_lat_mld_pt = [stations, latitude_mld', mld'];
save('G:/Cruises/2019_I06S/stn_lat_mld_pt.mat', "stn_lat_mld_pt")


%% plot data 300 from CTD file- fluorescence solo plot

 stations = unique(ctd.stn)'; 
% 
% %pull out lat and long from each station location
% for in = 1:length(stations)
%    w=find(ctd.stn == stations(in));
%    lat_lon(in,1) = bot.LATITUDE(w(1));
%    lat_lon(in,2) = bot.LONGITUDE(w(1));
%    %find bottom depth in each sample
%    bottom_depth(in,1) = bot.CTDPRS(w(end));
% end
%Interpolate between stations to 5KM resolution
lat = interp(ctd.lat,15);
long = interp(ctd.lon,15);
%download bathy file from etopo2
[ELEV,LONG,LAT]=m_etopo2([min(ctd.lon) max(ctd.lon) min(ctd.lat) max(ctd.lat)]);
%find row/column that best matches exact station locations interpolated
% for in = 1:length(lat_lon)
%     temp = abs(LONG(1,:)-lat_lon(in,2));
%     temp2 = find(temp == min(temp));
%     lon_col(in) = LONG(1,temp2);
%     temp = abs(LAT(:,1) - lat_lon(in,1));
%     temp3 = find(temp == min(temp));
%     lat_row(in) = LAT(temp3,1);
%     elevation(in) = ELEV(temp3,temp2);
% end
% 
elevation = [];
for in = 1:length(lat)
    temp = abs(LONG(1,:)-long(in));
    temp2 = find(temp == min(temp));
    lon_col(in) = LONG(1,temp2);
    temp = abs(LAT(:,1) - lat(in));
    temp3 = find(temp == min(temp));
    lat_row(in) = LAT(temp3,1);
    elevation(in) = ELEV(temp3,temp2);
end
% create colorbar (histogram of all values from UVP variable, then decide
% how many different color bins I want to use and set the values to there
% are an even number of values in each colorbin
%w3 = ismember(bot.STNNBR, stations); % only need to do this if we aren't plotting all of the casts
%w2 = bot.CTDPRS <= 310; 
%w = w3 & w2;

w = ctd.depth <= 303; 

value = ctd.fluorescence;
 
%remove nans
w_test = ~isnan(value);
w3_test = w.*w_test;
w = w3_test;
w3_test = w & w_test;
w = w3_test;

% %remove flags
% unique(ctd.fluorescence_flag)
% %flag 1, 2, and 6 are good
% w4 = (ctd.fluorescence_flag == 1 || ctd.fluorescence_flag == 2 || ctd.fluorescence_flag == 6);
% w4_test = w & w4;
% w = w4_test;

% %makes flagged 6 data NaN %6 flag means: interpolated_over_a_pressure_interval_larger_than_2_dbar
% w4 = find(ctd.fluorescence_flag == 6);
% ctd.fluorescence(w4) = NaN;


% %val_in_bin = round(length(value(w))/N_colorbins);
% sort(value(w));
% cmap_bins = [min(value(w))];
% ordered = sort(value(w));
% ordered = ordered(~isnan(ordered)); %added this line 3/21/24 to remove nans from cmap_bins
% val_in_bin = floor(length(ordered)/N_colorbins);
% for in = 1:N_colorbins-1
%     cmap_bins = [cmap_bins ordered(val_in_bin*in)];
% end
% cmap_bins(end+1) = max(value(w));%length(par.tot_par_abundance);
% y = 1:N_colorbins+1;
% dtr = interp1(cmap_bins, y, value(w), 'parula');

%new CB
cmap_bins = [min(value(w)) 0.05 0.06 0.07 0.08 0.09 0.10 0.15 0.20 0.30 0.40 max(value(w))]; 

N_colorbins = length(cmap_bins);
y = 0:N_colorbins-1; %changed to 0 and -1
dtr = interp1(cmap_bins, y, value(w));

%plot UVP data over latitude with colorbar created
depth = ctd.depth(w);
zbin = min(depth):2:max(depth); % zbin = 0:5:max(depth(w)); 
zbin = zbin';
lat_axes = min(ctd.lat) :0.1: max(ctd.lat);
[X1,Y1] = meshgrid(lat_axes,zbin);
lat_stack = [];
for in = 1:length(ctd.lat)
    lat_stack  = [lat_stack, repelem(ctd.lat(in), length(ctd.depth))'];
end

var_data=griddata(lat_stack(w),depth,dtr,X1,Y1);

w2=find(var_data == min(min(var_data))); %EDITED 3/18/25
var_data(w2) = min(dtr);%EDITED 3/18/25
w2=find(var_data == max(max(var_data)));%EDITED 3/18/25
var_data(w2) = max(dtr);%EDITED 3/18/25
clear w2;%EDITED 3/18/25

fig2 = figure; 
ax2 = gca;
[C,h] = contourf(X1, Y1, var_data); 
c = parula(N_colorbins - 1);
colormap(c)
set(h, 'LineColor', 'none');
hold on
%scatter(lat_stack(w), depth, 1,'MarkerFaceColor','k','MarkerEdgeColor','none') %mark sample locations

% %create a line at omega = 1
% w4 = bot.Omega_Calcite<1;
% stn = unique(bot.STNNBR(w4));
% stn = stn(2:end); %remove first station because it is a test
% lat_1 = []; depth_1 = [];
% for index = 1:length(stn)
%     w5 = find(bot.STNNBR == stn(index));
%     w6 = bot.Omega_Calcite(w5)<1;
%     w7 = find(w6 == 1);
%     w8 = min(w7);
%     lat_1(index) = wrapTo360(bot.LONGITUDE(w5(w8)));
%     depth_1(index) = str2double(bot.CTDPRS(w5(w8)));
% end
% plot(lat_1, depth_1, '-w', 'LineWidth', 2);

plot(ax2,unique(lat_stack(w)),zeros([1 length(unique(lat_stack(w)))]),'r|','MarkerSize',5)
temp4 = unique(lat_stack(w));
%text(ax2, temp4(1:8:end), ones(length(temp4(1:8:end)),1).*-150, string(stations(1:8:end)));
ax2.YDir = 'reverse';
ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 14);
xlabel('Latitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 14);
xticks([-65 -60 -55 -50 -45 -40 -35]);
xticklabels({'65^oS','60^oS','55^oS','50^oS','45^oS','40^oS','35^oS'});
xtickangle(30)

cblh = colorbar;
% set(cblh, 'ytick', 1:101)
% set(cblh,'ytick',1:10:101, 'yticklabel',round(cmap_bins(1:10:101),2)) 
set(cblh,'yticklabel',{'0','0.05', '0.06', '0.07', '0.08', '0.09', '0.10', '0.15', '0.20',  '0.30', '0.40', '>0.40'}); 

cblh.Label.String = 'Fluorescence (RFU)';
set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 14)
fig2.Position = [559.4000 191.4000 935.2000 521.6000];
ax2.Position = [0.1218 0.1680 0.7264 0.7570];
hold on
ylim([0 300]);

%add density isolines
%stations = unique(par.site)'; 
%pull out lat and long from each station location
for in = 1:length(stations)
   %w=find(ctd.station == stations(in));
   lat_lon(in,1) = ctd.lat(w(1));
   lat_lon(in,2) = wrapTo360(ctd.lon(w(1)));
   %find bottom depth in each sample
   %bottom_depth(in,1) = par.Depth(w(end));
end
lat_lon = sortrows(lat_lon, 1); %sort so lat is from min to max, added on 5/13/2025
%Interpolate between stations to 5KM resolution
lat = interp1([1:length(lat_lon(:,1))]',lat_lon(:,1), linspace(1,42, 630)); 
long = interp1([1:length(lat_lon(:,2))]',lat_lon(:,2), linspace(1,42, 630));
%lat = [min(lat_lon(:,1)):0.05: max(lat_lon(:,1))]'; %attempting to create a 5 km resolution
%long = [min(lat_lon(:,2)):0.05: max(lat_lon(:,2))]'; %attempting to create a 5 km resolution

%download bathy file from etopo2
%[ELEV,LONG,LAT]=m_etopo2([lat_lon(end,2) lat_lon(1,2) lat_lon(1,1) lat_lon(end,1)]);
[ELEV,LONG,LAT]=m_etopo2([min(lat_lon(:,2)) max(lat_lon(:,2)) min(lat_lon(:,1)) max(lat_lon(:,1))]);

%find row/column that best matches exact station locations interpolated
% for in = 1:length(lat_lon)
%     temp = abs(LONG(1,:)-lat_lon(in,2));
%     temp2 = find(temp == min(temp));
%     lon_col(in) = LONG(1,temp2);
%     temp = abs(LAT(:,1) - lat_lon(in,1));
%     temp3 = find(temp == min(temp));
%     lat_row(in) = LAT(temp3,1);
%     elevation(in) = ELEV(temp3,temp2);
% end
elevation = [];
for in = 1:length(lat)
    temp = abs(LONG(1,:)-long(in));
    temp2 = find(temp == min(temp));
    lon_col(in) = LONG(1,temp2);
    temp = abs(LAT(:,1) - lat(in));
    temp3 = find(temp == min(temp));
    lat_row(in) = LAT(temp3,1);
    elevation(in) = ELEV(temp3,temp2);
end

% create colorbar (histogram of all values from UVP variable, then decide
% how many different color bins I want to use and set the values to there
% are an even number of values in each colorbin
% w3 = ismember(par.site, stations);
% w2 = par.Depth <= 305; %only 200 m and less
% w = w3 & w2;

%plot UVP data over longitude with colorbar created
% zbin = min(par.Depth(w)):5:max(par.Depth(w)); %zbin = 0:5:max(par.Depth(w));  %EDITED 3/18/25
% zbin = zbin';
% lon_axes = min(par.latitude(w)) :0.1: max(par.latitude(w)); %lon_axes = min(par.latitude(w)) :0.5: max(par.latitude(w)); %EDITED 3/18/25
% [X1,Y1] = meshgrid(lon_axes,zbin);

ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
%N_colorbins = 15;
value = ctd.pden;
% val_in_bin = round(length(value(w))/N_colorbins);
% sort(value(w));
% cmap_bins = [min(value(w))];
% ordered = sort(value(w));
% for in = 1:N_colorbins-1
%     cmap_bins = [cmap_bins ordered(val_in_bin*in)];
% end
% cmap_bins(end+1) = max(value(w));
% y = 1:N_colorbins+1;

%set colorbar
%min(value)
%max(value)
cmap_bins = [24.5 24.75 25 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9 26 26.1 26.2 26.3 26.4 26.5 26.6 26.7 26.8 26.9 27 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
y = 1:length(cmap_bins); 
dtr = interp1(cmap_bins, y, value(w)); %this is for irregularly spaced intervals
var_data=griddata(lat_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr

ax4 = axes(fig2, 'Position', [0.1218 0.1680 0.7264 0.7570]);
%labels on sigma 2
[C,h] = contour(ax4, X1, Y1, var_data,cmap_bins, 'showtext','on','LabelSpacing', 300);
h.LevelList=round(h.LevelList,2)  %rounds levels to 3rd decimal place
clabel(C,h)
%no labels on sigma 2
%[C,h] = contour(X1, Y1, var_data,cmap_bins);

set(h, 'LineColor', 'k');
ax4.YDir = 'reverse';
ax4.XTick = []; ax4.YTick = [];
set(ax4, 'Color','none');
ylim([0 300]);

rectangle('Position',[-49.983 0 11.4837  300], 'FaceColor', 'w', 'EdgeColor', 'none')

%add lines and text labeling fronts and zones
line([-60.7523 -60.7523], [0 300],'color',[0 0 0],'linewi',3); %SBDY
line([-55.9998 -55.9998], [0 300],'color',[0 0 0],'linewi',3); %SACCF
line([-53.5 -53.5], [0 300],'color',[0 0 0],'linewi',3)%, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
%line([-49.5 -49.5], [0 6000],'color',[0 0 0],'linewi',1, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
line([-49 -49], [0 300],'color',[0 0 0],'linewi',3); %SAF
line([-40.6662 -40.6662], [0 300],'color',[0 0 0],'linewi',3); %STF
%label fronts on bottom
temp4 = unique(lat_stack(w));

text(ax2, -60.7523-1.25, 306, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, -55.9998-1.6, 306, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, -53.5-0.5, 306, "PF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, -49-1, 306, "SAF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, -40.6662-1, 306, "STF", 'FontName','helvetica','fontweight','bold','fontsize', 14);

% hold on
% p1 = patch([lat_lon(11:32,1)' max(lat_lon(11:32,1)) min(lat_lon(11:32,1))], [(bottom_depth(11:32))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');
% p1 = patch([lat_lon(1:10,1)' max(lat_lon(1:10,1)) min(lat_lon(1:10,1))], [(bottom_depth(1:10))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');
% p1 = patch([lat_lon(33:end,1)'  min(lat_lon(33:end,1)) max(lat_lon(33:end,1))], [(bottom_depth(33:end))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');%p = patch([long' long(end) long(1)], [elevation.*-1 4810 4810],'k');%p = patch([long' long(end) long(1)], [elevation.*-1 4810 4810],'k');

% %split upper 1000m to be half of the panel
% xlim1 = ax2.XLim;
% % change limits and shrink positions
% ax2.YLim = [1000 6000]; ax2.Position(4) = ax2.Position(4)/2;
% % center the ylabel
% ax2.YAxis.Label.Units = 'normalized';
% ax2.YAxis.Label.Position(2) = 1;
% % copy axes with data
% ax2_top = copyobj(ax2,gcf);
% % change limits and shrink positions
% ax2_top.YLim = [0 1000]; ax2_top.Position(2) = ax2_top.Position(2) + ax2_top.Position(4);
% ax2_top.YLabel     = [];
% ax2_top.XTickLabel = [];
% ax2_top.XLabel     = [];
% % make sure xlimis consistent
% ax2.XLim       = xlim1;
% ax2_top.XLim       = xlim1;
% % resize colorbar height
% ax2.Colorbar.Position(4) = ax2.Colorbar.Position(4)*2;
% 
% %split upper 1000m to be half of the panel ax4
% xlim1 = ax4.XLim;
% % change limits and shrink positions
% ax4.YLim = [1000 6000]; ax4.Position(4) = ax4.Position(4)/2;
% % center the ylabel
% ax4.YAxis.Label.Units = 'normalized';
% ax4.YAxis.Label.Position(2) = 1;
% % copy axes with data
% ax4_top = copyobj(ax4,gcf);
% % change limits and shrink positions
% ax4_top.YLim = [0 1000]; ax4_top.Position(2) = ax4_top.Position(2) + ax4_top.Position(4);
% ax4_top.YLabel     = [];
% ax4_top.XTickLabel = [];
% ax4_top.XLabel     = [];
% % make sure xlimis consistent
% ax4.XLim       = xlim1;
% ax4_top.XLim       = xlim1;

%add zone labels to the top %edited
text(ax2, -68, -10, "Subpolar Region", 'FontName','helvetica','fontweight','bold','fontsize', 12); %edited
text(ax2, -59.75, -10, "S Zone", 'FontName','helvetica','fontweight','bold','fontsize', 12); %edited
text(ax2, -56.2, -10, "A Zone", 'FontName','helvetica','fontweight','bold','fontsize', 12); %edited
text(ax2, -53, -10, "PF Zone", 'FontName','helvetica','fontweight','bold','fontsize', 12); %edited
text(ax2, -48.5, -10, "Subantarctic Zone", 'FontName','helvetica','fontweight','bold','fontsize', 12); %edited
text(ax2, -40, -10, "Subtropical Zone", 'FontName','helvetica','fontweight','bold','fontsize', 12); %edited


print('G:\Cruises\2019_I06S\I06s_ctd_fluorescence_300m_isopycnals_fronts','-dpng','-r300');


%% Plot Transmission individually

 stations = unique(ctd.stn)'; 

%pull out lat and long from each station location
for in = 1:length(stations)
   w=find(ctd.stn == stations(in));
   lat_lon(in,1) = ctd.lat(w);
   lat_lon(in,2) = wrapTo360(ctd.lon(w));
   %find bottom depth in each sample
   %bottom_depth(in,1) = ctd.depth(end,w(1));
end
lat_lon = sortrows(lat_lon, 1); %sort so lat is from min to max, added on 5/13/2025

%Interpolate between stations to 5KM resolution
%lat = interp(ctd.lat,15);
%long = interp(ctd.lon,15);
lat = interp1([1:length(lat_lon(:,1))]',lat_lon(:,1), linspace(1,55, 630)); 
long = interp1([1:length(lat_lon(:,2))]',lat_lon(:,2), linspace(1,55, 630));

% %Interpolate between stations to 5KM resolution
% lat = interp(ctd.lat,15);
% long = interp(ctd.lon,15);

%download bathy file from etopo2
[ELEV,LONG,LAT]=m_etopo2([min(ctd.lon) max(ctd.lon) min(ctd.lat) max(ctd.lat)]);
%find row/column that best matches exact station locations interpolated
% for in = 1:length(lat_lon)
%     temp = abs(LONG(1,:)-lat_lon(in,2));
%     temp2 = find(temp == min(temp));
%     lon_col(in) = LONG(1,temp2);
%     temp = abs(LAT(:,1) - lat_lon(in,1));
%     temp3 = find(temp == min(temp));
%     lat_row(in) = LAT(temp3,1);
%     elevation(in) = ELEV(temp3,temp2);
% end
% 
elevation = [];
for in = 1:length(lat)
    temp = abs(LONG(1,:)-long(in));
    temp2 = find(temp == min(temp));
    lon_col(in) = LONG(1,temp2);
    temp = abs(LAT(:,1) - lat(in));
    temp3 = find(temp == min(temp));
    lat_row(in) = LAT(temp3,1);
    elevation(in) = ELEV(temp3,temp2);
end

w = ismember(ctd.stn, stations);
value = ctd.transmission;

%remove nans
w_test = ~isnan(value);
w3_test = w.*w_test;
w = w3_test;
w3_test = w & w_test;
w = w3_test;

%remove flags
%unique(ctd.fluorescence_flag)
%flag 1, 2, and 6 are good
w4 = (ctd.transmission_flag == 1 | ctd.transmission_flag == 2 | ctd.transmission_flag == 6);
w4_test = w & w4;
w = w4_test;

% %makes flagged 6 data NaN %6 flag means: interpolated_over_a_pressure_interval_larger_than_2_dbar
% w4 = find(ctd.fluorescence_flag == 6);
% ctd.fluorescence(w4) = NaN;


cmap_bins = [min(value(w)) 0.0001 0.001 0.005 0.01 0.02 0.05 0.1 max(value(w))];

N_colorbins = length(cmap_bins);
y = 0:N_colorbins-1; 
dtr = interp1(cmap_bins, y, value(w));

%plot UVP data over latitude with colorbar created
depth = ctd.depth(w);
zbin = min(depth):2:max(depth); % zbin = 0:5:max(depth(w)); 
zbin = zbin';
lat_axes = min(ctd.lat) :0.1: max(ctd.lat);
[X1,Y1] = meshgrid(lat_axes,zbin);
lat_stack = [];
for in = 1:length(ctd.lat)
    lat_stack  = [lat_stack, repelem(ctd.lat(in), length(ctd.depth))'];
end

var_data=griddata(lat_stack(w),depth,dtr,X1,Y1);

w2=find(var_data == min(min(var_data))); %EDITED 3/18/25
var_data(w2) = min(dtr);%EDITED 3/18/25
w2=find(var_data == max(max(var_data)));%EDITED 3/18/25
var_data(w2) = max(dtr);%EDITED 3/18/25
clear w2;%EDITED 3/18/25

fig2 = figure; ax2 = gca;
[C,h] = contourf(X1, Y1, var_data); 
c = parula(N_colorbins - 1);
colormap(ax2, c); %8/14 I had to specify the axis here because it was editing all of the colormaps at once
set(h, 'LineColor', 'none');
hold on

plot(ax2,unique(lat_stack(w)),zeros([1 length(unique(lat_stack(w)))]),'r|','MarkerSize',5)

temp4 = unique(lat_stack(w));
ax2.YDir = 'reverse';
%Bathymetry
hold on
p = patch([lat lat(end) lat(1)], [elevation.*-1 6000 6000],'k');
set(p, 'facecolor',[0.5 0.5 0.5], 'edgecolor', [0.5 0.5 0.5]);
ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
xlabel('Latitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
xticks([-65 -60 -55 -50 -45 -40 -35]);
xticklabels({'65^oS','60^oS','55^oS','50^oS','45^oS','40^oS','35^oS'});
xtickangle(30);
cblh = colorbar;
cblh.YTick = y; 
set(cblh,'yticklabel',{'0', '10^-^4', '10^-^3', '5*10^-^3', '10^-^2','2*10^-^2', '5*10^-^2', '10^-^1', '>10^-^1'});

cblh.Label.String = ('Beam c_p (m^-^1)'); 
set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 14)
fig2.Position = [559.4000 191.4000 935.2000 521.6000];
ax2.Position = [0.1218 0.1680 0.7264 0.7570];
hold on
%plot MLD
plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);
%plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'MarkerEdgeColor', 'r', 'LineWidth', 1.5);

ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
value = ctd.pden;
cmap_bins = [23.5 24 24.5 25 25.5 26 26.5 26.75 27 27.15 27.5 27.6 27.7 27.75 27.8 27.83 27.85 27.9];
%cmap_bins = [24.5 24.75 25 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9 26 26.1 26.2 26.3 26.4 26.5 26.6 26.7 26.8 26.9 27 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
y = 1:length(cmap_bins); 
dtr = interp1(cmap_bins, y, value(w)); %this is for irregularly spaced intervals
var_data=griddata(lat_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr
ax4 = axes(fig2, 'Position', [0.1218 0.1680 0.7264 0.7570]);

%labels on sigma 2
[C,h] = contour(ax4, X1, Y1, var_data,cmap_bins, 'showtext','on');
h.LevelList=round(h.LevelList,2);  %rounds levels to 3rd decimal place
clabel(C,h);
%no labels on sigma 2
%[C,h] = contour(X1, Y1, var_data,cmap_bins);

set(h, 'LineColor', 'w'); clabel(C,h, 'Color','w', 'LabelSpacing', 100, 'FontSize', 8);
ax4.YDir = 'reverse';
ax4.XTick = []; ax4.YTick = [];
set(ax4, 'Color','none');
%ylim([0 300]);

rectangle('Position',[-49.983 0 11.4837  6000], 'FaceColor', 'w', 'EdgeColor', 'none')

%label fronts on bottom
temp4 = unique(lat_stack(w));

% text(ax2, -60.7523-1.25, 6100, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 14);
% text(ax2, -55.9998-1.6, 6100, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
% text(ax2, -53.5-0.5, 6100, "PF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
% text(ax2, -49-1, 306, "SAF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
% text(ax2, -40.6662-1, 6100, "STF", 'FontName','helvetica','fontweight','bold','fontsize', 14);

% hold on
% p1 = patch([lat_lon(11:32,1)' max(lat_lon(11:32,1)) min(lat_lon(11:32,1))], [(bottom_depth(11:32))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');
% p1 = patch([lat_lon(1:10,1)' max(lat_lon(1:10,1)) min(lat_lon(1:10,1))], [(bottom_depth(1:10))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');
% p1 = patch([lat_lon(33:end,1)'  min(lat_lon(33:end,1)) max(lat_lon(33:end,1))], [(bottom_depth(33:end))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');%p = patch([long' long(end) long(1)], [elevation.*-1 4810 4810],'k');%p = patch([long' long(end) long(1)], [elevation.*-1 4810 4810],'k');
%add lines and text labeling fronts and zones
line([-60.7523 -60.7523], [0 6000],'color',[0 0 0],'linewi',3); %SBDY
line([-55.9998 -55.9998], [0 6000],'color',[0 0 0],'linewi',3); %SACCF
line([-53.5 -53.5], [0 6000],'color',[0 0 0],'linewi',3)%, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
%line([-49.5 -49.5], [0 6000],'color',[0 0 0],'linewi',1, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
line([-49 -49], [0 6000],'color',[0 0 0],'linewi',3); %SAF
line([-40.6662 -40.6662], [0 6000],'color',[0 0 0],'linewi',3); %STF
%label fronts on bottom
temp4 = unique(lat_stack(w));

text(ax2, -60.7523-1.25, 6200, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, -55.9998-1.6, 6200, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, -53.5-0.5, 6200, "PF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, -49-1, 6200, "SAF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, -40.6662-1, 6200, "STF", 'FontName','helvetica','fontweight','bold','fontsize', 14);

%split upper 1000m to be half of the panel
xlim1 = ax2.XLim;
% change limits and shrink positions
ax2.YLim = [1000 6000]; ax2.Position(4) = ax2.Position(4)/2;
% center the ylabel
ax2.YAxis.Label.Units = 'normalized';
ax2.YAxis.Label.Position(2) = 1;
% copy axes with data
ax2_top = copyobj(ax2,gcf);
% change limits and shrink positions
ax2_top.YLim = [0 1000]; ax2_top.Position(2) = ax2_top.Position(2) + ax2_top.Position(4);
ax2_top.YLabel     = [];
ax2_top.XTickLabel = [];
ax2_top.XLabel     = [];
% make sure xlimis consistent
ax2.XLim       = xlim1;
ax2_top.XLim       = xlim1;
% resize colorbar height
ax2.Colorbar.Position(4) = ax2.Colorbar.Position(4)*2;

%split upper 1000m to be half of the panel ax4
xlim1 = ax4.XLim;
% change limits and shrink positions
ax4.YLim = [1000 6000]; ax4.Position(4) = ax4.Position(4)/2;
% center the ylabel
ax4.YAxis.Label.Units = 'normalized';
ax4.YAxis.Label.Position(2) = 1;
% copy axes with data
ax4_top = copyobj(ax4,gcf);
% change limits and shrink positions
ax4_top.YLim = [0 1000]; ax4_top.Position(2) = ax4_top.Position(2) + ax4_top.Position(4);
ax4_top.YLabel     = [];
ax4_top.XTickLabel = [];
ax4_top.XLabel     = [];
% make sure xlimis consistent
ax4.XLim       = xlim1;
ax4_top.XLim       = xlim1;

%add zone labels to the top %edited
text(ax2, -68, -4400, "SP Region", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, -60.5,  -4400, "S Zone", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, -56.7, -4400, "A Zone", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, -53, -4400, "PF Zone", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, -48.5, -4400, "SA Zone", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, -40, -4400, "ST Zone", 'FontName','helvetica','fontweight','bold','fontsize', 14); 


print('G:\Cruises\2019_I06S\I06s_ctd_transmission_isopycnals_fronts','-dpng','-r300');


%% Plot backscatter individually

 stations = unique(ctd.stn)'; 
 %remove station 2,15, 31 and 
 stations = stations(~ismember(stations, [2,15,31]));

%pull out lat and long from each station location
for in = 1:length(stations)
   w=find(ctd.stn == stations(in));
   lat_lon(in,1) = ctd.lat(w);
   lat_lon(in,2) = wrapTo360(ctd.lon(w));
   %find bottom depth in each sample
   %bottom_depth(in,1) = ctd.depth(end,w(1));
end
lat_lon = sortrows(lat_lon, 1); %sort so lat is from min to max, added on 5/13/2025

%Interpolate between stations to 5KM resolution
%lat = interp(ctd.lat,15);
%long = interp(ctd.lon,15);
lat = interp1([1:length(lat_lon(:,1))]',lat_lon(:,1), linspace(1,length(stations), 630)); 
long = interp1([1:length(lat_lon(:,2))]',lat_lon(:,2), linspace(1,length(stations), 630));

% %Interpolate between stations to 5KM resolution
% lat = interp(ctd.lat,15);
% long = interp(ctd.lon,15);

%download bathy file from etopo2
[ELEV,LONG,LAT]=m_etopo2([min(ctd.lon) max(ctd.lon) min(ctd.lat) max(ctd.lat)]);
%find row/column that best matches exact station locations interpolated
% for in = 1:length(lat_lon)
%     temp = abs(LONG(1,:)-lat_lon(in,2));
%     temp2 = find(temp == min(temp));
%     lon_col(in) = LONG(1,temp2);
%     temp = abs(LAT(:,1) - lat_lon(in,1));
%     temp3 = find(temp == min(temp));
%     lat_row(in) = LAT(temp3,1);
%     elevation(in) = ELEV(temp3,temp2);
% end
% 
elevation = [];
for in = 1:length(lat)
    temp = abs(LONG(1,:)-long(in));
    temp2 = find(temp == min(temp));
    lon_col(in) = LONG(1,temp2);
    temp = abs(LAT(:,1) - lat(in));
    temp3 = find(temp == min(temp));
    lat_row(in) = LAT(temp3,1);
    elevation(in) = ELEV(temp3,temp2);
end

w = ismember(ctd.stn, stations);
value = ctd.beta700_raw;

%remove nans
w_test = ~isnan(value);
w3_test = w.*w_test;
w = w3_test;
w3_test = w & w_test;
w = w3_test;

%remove flags
%unique(ctd.fluorescence_flag)
%flag 1, 2, and 6 are good
w4 = (ctd.ctd_beta700_raw_qc == 1 | ctd.ctd_beta700_raw_qc == 2 | ctd.ctd_beta700_raw_qc == 6);
w4_test = w & w4;
w = w4_test;

% %makes flagged 6 data NaN %6 flag means: interpolated_over_a_pressure_interval_larger_than_2_dbar
% w4 = find(ctd.fluorescence_flag == 6);
% ctd.fluorescence(w4) = NaN;


cmap_bins = [min(value(w)) 0.12 0.1225 0.125 0.1275 0.13 0.135 0.14 0.145 0.15 0.2 max(value(w))];

N_colorbins = length(cmap_bins);
y = 0:N_colorbins-1; 
dtr = interp1(cmap_bins, y, value(w));

%plot UVP data over latitude with colorbar created
depth = ctd.depth(w);
zbin = min(depth):2:max(depth); % zbin = 0:5:max(depth(w)); 
zbin = zbin';
lat_axes = min(ctd.lat) :0.1: max(ctd.lat);
[X1,Y1] = meshgrid(lat_axes,zbin);
lat_stack = [];
for in = 1:length(ctd.lat)
    lat_stack  = [lat_stack, repelem(ctd.lat(in), length(ctd.depth))'];
end

var_data=griddata(lat_stack(w),depth,dtr,X1,Y1);

w2=find(var_data == min(min(var_data))); %EDITED 3/18/25
var_data(w2) = min(dtr);%EDITED 3/18/25
w2=find(var_data == max(max(var_data)));%EDITED 3/18/25
var_data(w2) = max(dtr);%EDITED 3/18/25
clear w2;%EDITED 3/18/25

fig2 = figure; ax2 = gca;
[C,h] = contourf(X1, Y1, var_data); 
c = parula(N_colorbins - 1);
colormap(ax2, c); %8/14 I had to specify the axis here because it was editing all of the colormaps at once
set(h, 'LineColor', 'none');
hold on

plot(ax2,unique(lat_stack(w)),zeros([1 length(unique(lat_stack(w)))]),'r|','MarkerSize',5)

temp4 = unique(lat_stack(w));
ax2.YDir = 'reverse';
%Bathymetry
hold on
p = patch([lat lat(end) lat(1)], [elevation.*-1 6000 6000],'k');
set(p, 'facecolor',[0.5 0.5 0.5], 'edgecolor', [0.5 0.5 0.5]);
ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
xlabel('Latitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
xticks([-65 -60 -55 -50 -45 -40 -35]);
xticklabels({'65^oS','60^oS','55^oS','50^oS','45^oS','40^oS','35^oS'});
xtickangle(30);
cblh = colorbar;
cblh.YTick = y; 
set(cblh,'yticklabel',{'0', '0.12', '0.1225', '0.125', '0.1275', '0.13', '0.135', '0.14', '0.145', '0.15', '0.2', '>0.2'});

cblh.Label.String = ('bbp (700nm)'); 
set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 14)
fig2.Position = [559.4000 191.4000 935.2000 521.6000];
ax2.Position = [0.1218 0.1680 0.7264 0.7570];
hold on
%plot MLD
plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);
%plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'MarkerEdgeColor', 'r', 'LineWidth', 1.5);

ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
value = ctd.pden;
cmap_bins = [23.5 24 24.5 25 25.5 26 26.5 27 27.5 27.6 27.7 27.8 27.85 27.9];
%cmap_bins = [24.5 24.75 25 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9 26 26.1 26.2 26.3 26.4 26.5 26.6 26.7 26.8 26.9 27 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
y = 1:length(cmap_bins); 
dtr = interp1(cmap_bins, y, value(w)); %this is for irregularly spaced intervals
var_data=griddata(lat_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr
ax4 = axes(fig2, 'Position', [0.1218 0.1680 0.7264 0.7570]);

%labels on sigma 2
[C,h] = contour(ax4, X1, Y1, var_data,cmap_bins, 'showtext','on');
h.LevelList=round(h.LevelList,2);  %rounds levels to 3rd decimal place
clabel(C,h);
%no labels on sigma 2
%[C,h] = contour(X1, Y1, var_data,cmap_bins);

set(h, 'LineColor', 'w'); clabel(C,h, 'Color','w', 'LabelSpacing', 100, 'FontSize', 8);
ax4.YDir = 'reverse';
ax4.XTick = []; ax4.YTick = [];
set(ax4, 'Color','none');
%ylim([0 300]);

rectangle('Position',[-49.983 0 11.4837  6000], 'FaceColor', 'w', 'EdgeColor', 'none')

%label fronts on bottom
temp4 = unique(lat_stack(w));

% text(ax2, -60.7523-1.25, 6100, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 14);
% text(ax2, -55.9998-1.6, 6100, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
% text(ax2, -53.5-0.5, 6100, "PF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
% text(ax2, -49-1, 306, "SAF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
% text(ax2, -40.6662-1, 6100, "STF", 'FontName','helvetica','fontweight','bold','fontsize', 14);

% hold on
% p1 = patch([lat_lon(11:32,1)' max(lat_lon(11:32,1)) min(lat_lon(11:32,1))], [(bottom_depth(11:32))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');
% p1 = patch([lat_lon(1:10,1)' max(lat_lon(1:10,1)) min(lat_lon(1:10,1))], [(bottom_depth(1:10))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');
% p1 = patch([lat_lon(33:end,1)'  min(lat_lon(33:end,1)) max(lat_lon(33:end,1))], [(bottom_depth(33:end))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');%p = patch([long' long(end) long(1)], [elevation.*-1 4810 4810],'k');%p = patch([long' long(end) long(1)], [elevation.*-1 4810 4810],'k');
%add lines and text labeling fronts and zones
line([-60.7523 -60.7523], [0 6000],'color',[0 0 0],'linewi',3); %SBDY
line([-55.9998 -55.9998], [0 6000],'color',[0 0 0],'linewi',3); %SACCF
line([-53.5 -53.5], [0 6000],'color',[0 0 0],'linewi',3)%, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
%line([-49.5 -49.5], [0 6000],'color',[0 0 0],'linewi',1, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
line([-49 -49], [0 6000],'color',[0 0 0],'linewi',3); %SAF
line([-40.6662 -40.6662], [0 6000],'color',[0 0 0],'linewi',3); %STF
%label fronts on bottom
temp4 = unique(lat_stack(w));

text(ax2, -60.7523-1.25, 6200, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, -55.9998-1.6, 6200, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, -53.5-0.5, 6200, "PF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, -49-1, 6200, "SAF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, -40.6662-1, 6200, "STF", 'FontName','helvetica','fontweight','bold','fontsize', 14);

%split upper 1000m to be half of the panel
xlim1 = ax2.XLim;
% change limits and shrink positions
ax2.YLim = [1000 6000]; ax2.Position(4) = ax2.Position(4)/2;
% center the ylabel
ax2.YAxis.Label.Units = 'normalized';
ax2.YAxis.Label.Position(2) = 1;
% copy axes with data
ax2_top = copyobj(ax2,gcf);
% change limits and shrink positions
ax2_top.YLim = [0 1000]; ax2_top.Position(2) = ax2_top.Position(2) + ax2_top.Position(4);
ax2_top.YLabel     = [];
ax2_top.XTickLabel = [];
ax2_top.XLabel     = [];
% make sure xlimis consistent
ax2.XLim       = xlim1;
ax2_top.XLim       = xlim1;
% resize colorbar height
ax2.Colorbar.Position(4) = ax2.Colorbar.Position(4)*2;

%split upper 1000m to be half of the panel ax4
xlim1 = ax4.XLim;
% change limits and shrink positions
ax4.YLim = [1000 6000]; ax4.Position(4) = ax4.Position(4)/2;
% center the ylabel
ax4.YAxis.Label.Units = 'normalized';
ax4.YAxis.Label.Position(2) = 1;
% copy axes with data
ax4_top = copyobj(ax4,gcf);
% change limits and shrink positions
ax4_top.YLim = [0 1000]; ax4_top.Position(2) = ax4_top.Position(2) + ax4_top.Position(4);
ax4_top.YLabel     = [];
ax4_top.XTickLabel = [];
ax4_top.XLabel     = [];
% make sure xlimis consistent
ax4.XLim       = xlim1;
ax4_top.XLim       = xlim1;

%add zone labels to the top %edited
text(ax2, -68, -4400, "Subpolar Zone", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, -59,  -4400, "SZ", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, -55.5, -4400, "AZ", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, -52.5, -4400, "PFZ", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, -46, -4400, "SAZ", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, -37.5, -4400, "STZ", 'FontName','helvetica','fontweight','bold','fontsize', 14); 


print('G:\Cruises\2019_I06S\I06s_ctd_beta700_isopycnals_fronts','-dpng','-r300');

%% Plot n^2- buoyancy individually (Brunt-Vaisala frequency squared)

% High N: A high Brunt-Väisälä frequency means the water column is highly stratified and stable, resisting vertical mixing. 
% Low N: A low frequency indicates a less stable, less stratified water column, where vertical mixing is easier. 

addpath('G:\MATLAB\GSW-Matlab-master\Toolbox')
lon_stack = [];
    for in = 1:length(ctd.lon)
        lon_stack  = [lon_stack, repelem(ctd.lon(in), length(ctd.depth))'];
    end

%convert practical salinity to absolute salinity 
%[SA, in_ocean] = gsw_SA_from_SP(SP,p,long,lat)
[SA, in_ocean] = gsw_SA_from_SP(ctd.salinity,ctd.depth,lon_stack,lat_stack);
[N2, p_mid] = gsw_Nsquared(SA,ctd.temperature,ctd.depth,lat_stack);

stations = unique(ctd.stn)'; 

%pull out lat and long from each station location
for in = 1:length(stations)
   w=find(ctd.stn == stations(in));
   lat_lon(in,1) = ctd.lat(w);
   lat_lon(in,2) = wrapTo360(ctd.lon(w));
   %find bottom depth in each sample
   %bottom_depth(in,1) = ctd.depth(end,w(1));
end
lat_lon = sortrows(lat_lon, 1); %sort so lat is from min to max, added on 5/13/2025

%Interpolate between stations to 5KM resolution
%lat = interp(ctd.lat,15);
%long = interp(ctd.lon,15);
lat = interp1([1:length(lat_lon(:,1))]',lat_lon(:,1), linspace(1,length(stations), 630)); 
long = interp1([1:length(lat_lon(:,2))]',lat_lon(:,2), linspace(1,length(stations), 630));

% %Interpolate between stations to 5KM resolution
% lat = interp(ctd.lat,15);
% long = interp(ctd.lon,15);

%download bathy file from etopo2
[ELEV,LONG,LAT]=m_etopo2([min(ctd.lon) max(ctd.lon) min(ctd.lat) max(ctd.lat)]);
%find row/column that best matches exact station locations interpolated
% for in = 1:length(lat_lon)
%     temp = abs(LONG(1,:)-lat_lon(in,2));
%     temp2 = find(temp == min(temp));
%     lon_col(in) = LONG(1,temp2);
%     temp = abs(LAT(:,1) - lat_lon(in,1));
%     temp3 = find(temp == min(temp));
%     lat_row(in) = LAT(temp3,1);
%     elevation(in) = ELEV(temp3,temp2);
% end
% 
elevation = [];
for in = 1:length(lat)
    temp = abs(LONG(1,:)-long(in));
    temp2 = find(temp == min(temp));
    lon_col(in) = LONG(1,temp2);
    temp = abs(LAT(:,1) - lat(in));
    temp3 = find(temp == min(temp));
    lat_row(in) = LAT(temp3,1);
    elevation(in) = ELEV(temp3,temp2);
end

w = ismember(ctd.stn, stations);
value = N2;

%remove nans
w_test = ~isnan(value);
w3_test = w.*w_test;
w = w3_test;
w3_test = w & w_test;
w = w3_test;

% %remove flags
% %unique(ctd.fluorescence_flag)
% %flag 1, 2, and 6 are good
% w4 = (ctd.ctd_beta700_raw_qc == 1 | ctd.ctd_beta700_raw_qc == 2 | ctd.ctd_beta700_raw_qc == 6);
% w4_test = w & w4;
% w = w4_test;

% %makes flagged 6 data NaN %6 flag means: interpolated_over_a_pressure_interval_larger_than_2_dbar
% w4 = find(ctd.fluorescence_flag == 6);
% ctd.fluorescence(w4) = NaN;


cmap_bins = [min(value(w)) 0 10^-10 10^-9 10^-8 10^-7 10^-6 10^-5 10^-4 max(value(w))];

N_colorbins = length(cmap_bins);
y = 0:N_colorbins-1; 
dtr = interp1(cmap_bins, y, value(w));

%plot UVP data over latitude with colorbar created
depth = p_mid(w);
zbin = min(depth):2:max(depth); % zbin = 0:5:max(depth(w)); 
zbin = zbin';
lat_axes = min(ctd.lat) :0.1: max(ctd.lat);
[X1,Y1] = meshgrid(lat_axes,zbin);
lat_stack = [];
for in = 1:length(ctd.lat)
    lat_stack  = [lat_stack, repelem(ctd.lat(in), length(ctd.depth))'];
end

var_data=griddata(lat_stack(w),depth,dtr,X1,Y1);

w2=find(var_data == min(min(var_data))); %EDITED 3/18/25
var_data(w2) = min(dtr);%EDITED 3/18/25
w2=find(var_data == max(max(var_data)));%EDITED 3/18/25
var_data(w2) = max(dtr);%EDITED 3/18/25
clear w2;%EDITED 3/18/25

fig2 = figure; ax2 = gca;
[C,h] = contourf(X1, Y1, var_data); 
c = parula(N_colorbins - 1);
colormap(ax2, c); %8/14 I had to specify the axis here because it was editing all of the colormaps at once
set(h, 'LineColor', 'none');
hold on

plot(ax2,unique(lat_stack(w)),zeros([1 length(unique(lat_stack(w)))]),'r|','MarkerSize',5)

temp4 = unique(lat_stack(w));
ax2.YDir = 'reverse';
%Bathymetry
hold on
p = patch([lat lat(end) lat(1)], [elevation.*-1 6000 6000],'k');
set(p, 'facecolor',[0.5 0.5 0.5], 'edgecolor', [0.5 0.5 0.5]);
ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
xlabel('Latitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
xticks([-65 -60 -55 -50 -45 -40 -35]);
xticklabels({'65^oS','60^oS','55^oS','50^oS','45^oS','40^oS','35^oS'});
xtickangle(30);
cblh = colorbar;
cblh.YTick = y; 
set(cblh,'yticklabel',{'', '0', '10^-^1^0', '10^-^9', '10^-^8', '10^-^7', '10^-^6', '10^-^5', '10^-^4', '>10^-^4'});

cblh.Label.String = ('N^2 (sec^-^1)'); 
set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 14)
fig2.Position = [559.4000 191.4000 935.2000 521.6000];
ax2.Position = [0.1218 0.1680 0.7264 0.7570];
hold on
%plot MLD
plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);
%plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'MarkerEdgeColor', 'r', 'LineWidth', 1.5);

ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
value = ctd.pden;
cmap_bins = [23.5 24 24.5 25 25.5 26 26.5 27 27.5 27.6 27.7 27.8 27.85 27.9];
%cmap_bins = [24.5 24.75 25 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9 26 26.1 26.2 26.3 26.4 26.5 26.6 26.7 26.8 26.9 27 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
y = 1:length(cmap_bins); 
dtr = interp1(cmap_bins, y, value(w)); %this is for irregularly spaced intervals
var_data=griddata(lat_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr
ax4 = axes(fig2, 'Position', [0.1218 0.1680 0.7264 0.7570]);

%labels on sigma 2
[C,h] = contour(ax4, X1, Y1, var_data,cmap_bins, 'showtext','on');
h.LevelList=round(h.LevelList,2);  %rounds levels to 3rd decimal place
clabel(C,h);
%no labels on sigma 2
%[C,h] = contour(X1, Y1, var_data,cmap_bins);

set(h, 'LineColor', 'w'); clabel(C,h, 'Color','w', 'LabelSpacing', 100, 'FontSize', 8);
ax4.YDir = 'reverse';
ax4.XTick = []; ax4.YTick = [];
set(ax4, 'Color','none');
%ylim([0 300]);

rectangle('Position',[-49.983 0 11.4837  6000], 'FaceColor', 'w', 'EdgeColor', 'none')

%label fronts on bottom
temp4 = unique(lat_stack(w));

% text(ax2, -60.7523-1.25, 6100, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 14);
% text(ax2, -55.9998-1.6, 6100, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
% text(ax2, -53.5-0.5, 6100, "PF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
% text(ax2, -49-1, 306, "SAF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
% text(ax2, -40.6662-1, 6100, "STF", 'FontName','helvetica','fontweight','bold','fontsize', 14);

% hold on
% p1 = patch([lat_lon(11:32,1)' max(lat_lon(11:32,1)) min(lat_lon(11:32,1))], [(bottom_depth(11:32))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');
% p1 = patch([lat_lon(1:10,1)' max(lat_lon(1:10,1)) min(lat_lon(1:10,1))], [(bottom_depth(1:10))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');
% p1 = patch([lat_lon(33:end,1)'  min(lat_lon(33:end,1)) max(lat_lon(33:end,1))], [(bottom_depth(33:end))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');%p = patch([long' long(end) long(1)], [elevation.*-1 4810 4810],'k');%p = patch([long' long(end) long(1)], [elevation.*-1 4810 4810],'k');
%add lines and text labeling fronts and zones
line([-60.7523 -60.7523], [0 6000],'color',[0 0 0],'linewi',3); %SBDY
line([-55.9998 -55.9998], [0 6000],'color',[0 0 0],'linewi',3); %SACCF
line([-53.5 -53.5], [0 6000],'color',[0 0 0],'linewi',3)%, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
%line([-49.5 -49.5], [0 6000],'color',[0 0 0],'linewi',1, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
line([-49 -49], [0 6000],'color',[0 0 0],'linewi',3); %SAF
line([-40.6662 -40.6662], [0 6000],'color',[0 0 0],'linewi',3); %STF
%label fronts on bottom
temp4 = unique(lat_stack(w));

text(ax2, -60.7523-1.25, 6200, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, -55.9998-1.6, 6200, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, -53.5-0.5, 6200, "PF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, -49-1, 6200, "SAF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, -40.6662-1, 6200, "STF", 'FontName','helvetica','fontweight','bold','fontsize', 14);

%split upper 1000m to be half of the panel
xlim1 = ax2.XLim;
% change limits and shrink positions
ax2.YLim = [1000 6000]; ax2.Position(4) = ax2.Position(4)/2;
% center the ylabel
ax2.YAxis.Label.Units = 'normalized';
ax2.YAxis.Label.Position(2) = 1;
% copy axes with data
ax2_top = copyobj(ax2,gcf);
% change limits and shrink positions
ax2_top.YLim = [0 1000]; ax2_top.Position(2) = ax2_top.Position(2) + ax2_top.Position(4);
ax2_top.YLabel     = [];
ax2_top.XTickLabel = [];
ax2_top.XLabel     = [];
% make sure xlimis consistent
ax2.XLim       = xlim1;
ax2_top.XLim       = xlim1;
% resize colorbar height
ax2.Colorbar.Position(4) = ax2.Colorbar.Position(4)*2;

%split upper 1000m to be half of the panel ax4
xlim1 = ax4.XLim;
% change limits and shrink positions
ax4.YLim = [1000 6000]; ax4.Position(4) = ax4.Position(4)/2;
% center the ylabel
ax4.YAxis.Label.Units = 'normalized';
ax4.YAxis.Label.Position(2) = 1;
% copy axes with data
ax4_top = copyobj(ax4,gcf);
% change limits and shrink positions
ax4_top.YLim = [0 1000]; ax4_top.Position(2) = ax4_top.Position(2) + ax4_top.Position(4);
ax4_top.YLabel     = [];
ax4_top.XTickLabel = [];
ax4_top.XLabel     = [];
% make sure xlimis consistent
ax4.XLim       = xlim1;
ax4_top.XLim       = xlim1;

%add zone labels to the top %edited
text(ax2, -68, -4400, "Subpolar Zone", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, -59,  -4400, "SZ", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, -55.5, -4400, "AZ", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, -52.5, -4400, "PFZ", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, -46, -4400, "SAZ", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, -37.5, -4400, "STZ", 'FontName','helvetica','fontweight','bold','fontsize', 14); 


print('G:\Cruises\2019_I06S\I06s_ctd_n_squared_isopycnals_fronts','-dpng','-r300');