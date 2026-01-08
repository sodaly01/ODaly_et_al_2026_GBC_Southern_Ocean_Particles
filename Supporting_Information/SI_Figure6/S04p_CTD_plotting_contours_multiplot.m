%S04p ctd plotting contours multiplot

clear all; close all;
addpath('G:\MATLAB\seawater_ver3_3.1')
addpath('G:\MATLAB\m_map'); 

%load CTD data
%load data, downloaded 9/17/2025
filepath = 'G:/Cruises/2018_S04P/320620180309_CTD_bottle_17Sept2025/320620180309_ctd.nc';
%ncdisp(filepath); %view discription of data
ctd.station = ncread(filepath, 'station'); %this station data is in a weird format
ctd.stn = [1:8 10:103 105:108 110:120]; %this is the same but in a better format %remove 901 test cast, no 9, 104, or 109
ctd.cast = ncread(filepath, 'cast');
ctd.lat = ncread(filepath,'latitude'); 
ctd.lon = ncread(filepath,'longitude'); 
ctd.depth = ncread(filepath,'pressure'); 
ctd.fluorescence = ncread(filepath,'ctd_fluor_raw'); 
ctd.fluorescence_flag = ncread(filepath,'ctd_fluor_raw_qc');
ctd.transmission = ncread(filepath,'ctd_beamcp'); 
%ctd.transmission_flag = ncread(filepath,'ctd_beamcp_qc'); %there is no flag file here, I think they removed any bad data
ctd.temperature = ncread(filepath,'ctd_temperature'); 
ctd.temperature_flag = ncread(filepath,'ctd_temperature_qc'); 
ctd.salinity = ncread(filepath,'ctd_salinity'); 
ctd.salinity_flag = ncread(filepath,'ctd_salinity_qc'); 
ctd.oxygen = ncread(filepath,'ctd_oxygen'); 
ctd.oxygen_flag = ncread(filepath,'ctd_oxygen_qc'); 
ctd.beta700_raw = ncread(filepath,'ctd_beta700_raw'); 
ctd.ctd_beta700_raw_qc = ncread(filepath,'ctd_beta700_raw_qc'); 
ctd.time = ncread(filepath,'time'); 

%remove the test cast number 901
ctd.cast = ctd.cast(2:end);
ctd.lat = ctd.lat(2:end); 
ctd.lon = ctd.lon(2:end); 
ctd.depth = ctd.depth(:,2:end);
ctd.fluorescence = ctd.fluorescence(:,2:end);
ctd.fluorescence_flag = ctd.fluorescence_flag(:,2:end);
ctd.transmission = ctd.transmission(:,2:end); 
%ctd.transmission_flag = ctd.transmission_flag(:,2:end); %there is no flag file here, I think they removed any bad data
ctd.temperature = ctd.temperature(:,2:end); 
ctd.temperature_flag = ctd.temperature_flag(:,2:end); 
ctd.salinity = ctd.salinity(:,2:end); 
ctd.salinity_flag = ctd.salinity_flag(:,2:end); 
ctd.oxygen = ctd.oxygen(:,2:end); 
ctd.oxygen_flag = ctd.oxygen_flag(:,2:end); 
ctd.beta700_raw = ctd.beta700_raw(:,2:end); 
ctd.ctd_beta700_raw_qc = ctd.ctd_beta700_raw_qc(:,2:end); 
ctd.time = ctd.time(2:end); 

%Load CTD bottle datafile for this cruise
bot = readtable("G:/Cruises/2018_S04P/320620180309_CTD_bottle_17Sept2025/320620180309_hy1");
bot = bot(2:end-1, :);
bot = bot(37:end, :); %remove test cast

%Calc MLD
ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000

%create variable to store all calculated mixed layer depths
mld = []; longitude_mld = [];
%stations = unique(ctd.stn)'; 
stations = load('G:\Cruises\2018_S04P\S04P_transect_main5_CTD.txt');
stations = stations';

%loop through all casts
for index = 1:length(stations)
    w = find(ctd.stn == stations(index));
    w2 = ~isnan(ctd.depth(:,w));
    mld = [mld, calc_mld(ctd.depth(w2,w), ctd.pden(w2,w)+1000)];
    %mld_temp = calc_mld(ctd.depth(w2,w), ctd.pden(w2,w)+1000);
    longitude_mld = [longitude_mld, ctd.lon(w)];
    % den = ctd.pden(w2,w);
    % dep = ctd.depth(w2,w);
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
    % title(ctd.stn(w))
end

%now you can toggle through the plots and see if the function did a good job

stn_lon_mld_pt = [stations, longitude_mld', mld'];
save('G:/Cruises/2018_S04P/stn_lon_mld_pt.mat', "stn_lon_mld_pt")

% station 89 has a shallow MLD but it seems that maybe it's correct? I'm
% not sure

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
% categories = {'temperature'; 'salinity'; 'oxygen'; 'AOU'; ...
%      'fluorescence'}; 
% categories_bot = {'SILCAT','NITRAT', 'PHSPHT'};
% color_bar_label = {'Temperature (^oC)'; 'Salinity'; 'Oxygen (\mumol kg^-^1)';...
%     'AOU (\mumol kg^-^1)'; 'Fluorescence (RFU)'; 'Silicate (\mumol kg^-^1)';...
%     'Nitrate (\mumol kg^-^1)'; 'Phosphate (\mumol kg^-^1)'};
% sublet = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'}; 

categories = {'temperature'; 'salinity'; 'AOU'; 'transmission';...
     'fluorescence'}; 
categories_bot = {'NITRAT'}; 
color_bar_label = {'Temperature (^oC)'; 'Salinity'; ...
    'AOU (\mumol kg^-^1)'; 'Beam c_p (m^-^1)'; 'Fluorescence (RFU)'; ...
    'Nitrate (\mumol kg^-^1)'};
sublet = {'a', 'b', 'c', 'd', 'e','f'}; 

%% Plot data 6000 from CTD file multiplot

fig2 = figure;
set(fig2, 'Units', 'inches', 'Position', [0.4417 0.6167 7.67 6.05]); %[0.4417 0.6167 7.67 7.8]
%stations = unique(ctd.stn)'; 
%I need to remove stations that aren't on the main line
stations = load('G:\Cruises\2018_S04P\S04P_transect_main5_CTD.txt');
stations = stations';

%pull out lat and long from each station location
for in = 1:length(stations)
   w=find(ctd.stn == stations(in));
   lat_lon(in,1) = ctd.lat(w);
   lat_lon(in,2) = wrapTo360(ctd.lon(w));
   %find bottom depth in each sample
   %bottom_depth(in,1) = ctd.depth(end,w(1));
end
lat_lon = sortrows(lat_lon, 2); %sort so lat is from min to max, added on 5/13/2025

%Interpolate between stations to 5KM resolution
%lat = interp(ctd.lat,15);
%long = interp(ctd.lon,15);
lat = interp1([1:length(lat_lon(:,1))]',lat_lon(:,1), linspace(1,length(lat_lon), 630)); 
long = interp1([1:length(lat_lon(:,2))]',lat_lon(:,2), linspace(1,length(lat_lon), 630));

%download bathy file from etopo2
%[ELEV,LONG,LAT]=m_etopo2([min(ctd.lon) max(ctd.lon) min(ctd.lat) max(ctd.lat)]);
[ELEV,LONG,LAT]=m_etopo2([min(lat_lon(:,2)) max(lat_lon(:,2)) min(lat_lon(:,1)) max(lat_lon(:,1))]);

%find row/column that best matches exact station locations interpolated
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
    if index1 == 1 || index1 == 2 || index1 ==3 %no flag matrix for transmission
        %remove flags
        %unique(ctd.fluorescence_flag)
        %flag 1, 2, and 6 are good
        formatSpec = 'w4 = (ctd.%s_flag == 1 | ctd.%s_flag == 2 | ctd.%s_flag == 6);';
        eval(sprintf(formatSpec, category, category, category))
        w4_test = w & w4;
        w = w4_test;
    end
    
    % %makes flagged 6 data NaN %6 flag means: interpolated_over_a_pressure_interval_larger_than_2_dbar
    % w4 = find(ctd.fluorescence_flag == 6);
    % ctd.fluorescence(w4) = NaN;

    if index1 == 1
        cmap_bins = [min(value(w)) -1 0 0.25 0.5 0.75 1 1.25 1.5 1.75 2 max(value(w))]; %i06s 0 1 2 3 5 7.5 10 15 20
    end
    if index1 == 2
        cmap_bins = [min(value(w)) 34 34.25 34.5 34.6 34.65 34.7 34.71 34.72 34.73 max(value(w))];
    end
    if index1 == 3 
        cmap_bins = [min(value(w)) 0 25 50 75 100 130 135 140 145 150 max(value(w))];
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
    lon_axes = min(wrapTo360(ctd.lon)):0.1: max(wrapTo360(ctd.lon));
    [X1,Y1] = meshgrid(lon_axes,zbin);
    lon_stack = [];
    for in = 1:length(ctd.lon)
        lon_stack  = [lon_stack, repelem(wrapTo360(ctd.lon(in)), length(ctd.depth))'];
    end
    
    var_data=griddata(lon_stack(w),depth,dtr,X1,Y1);
    
    w2=find(var_data == min(min(var_data))); %EDITED 3/18/25
    var_data(w2) = min(dtr);%EDITED 3/18/25
    w2=find(var_data == max(max(var_data)));%EDITED 3/18/25
    var_data(w2) = max(dtr);%EDITED 3/18/25
    clear w2;%EDITED 3/18/25
    ax2 = axes;

    if index1 == 1
        set(ax2, 'Units', 'inches', 'Position', [0.45 4.19 3.36 1.75]) %0.45 5.94 3.36 1.75
    elseif index1 == 2
        set(ax2, 'Units', 'inches', 'Position', [4.03 4.19 3.36 1.75]) %4.03 5.94 3.36 1.75
    elseif index1 == 3
        set(ax2, 'Units', 'inches', 'Position', [0.45 2.44 3.36 1.75]) %0.45 4.19 3.36 1.75
    elseif index1 == 4
        set(ax2, 'Units', 'inches', 'Position', [4.03 2.44 3.36 1.75]) %4.03 4.19 3.36 1.75
    end

    [C,h] = contourf(X1, Y1, var_data); 
    c = parula(N_colorbins - 1);
    colormap(ax2, c); %8/14 I had to specify the axis here because it was editing all of the colormaps at once
    set(h, 'LineColor', 'none');
    hold on

    if index1 == 1 || index1 == 2
        plot(ax2,unique(lon_stack(w)),zeros([1 length(unique(lon_stack(w)))]),'r|','MarkerSize',5)
    end
    temp4 = unique(lon_stack(w));
    ax2.YDir = 'reverse';
    %Bathymetry
    hold on
    p = patch([long long(end) long(1)], [elevation.*-1 4810 4810],'k');
    set(p, 'facecolor',[0.5 0.5 0.5], 'edgecolor', [0.5 0.5 0.5]);
    ax2.YLim = [0 4810]; ax2.XLim = [168.4755  286.5002]; %[173.5405 286.5010]; %edited 18Sept2025

    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
    end
    if index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        yticklabels([]);
    end
    if index1 == 5 || index1 == 6
        xlabel('Longitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
        xticks([180 200 220 240 260 280]);
        xticklabels({'180^oE','160^oW','140^oW','120^oW','100^oW','80^oW'});
        xtickangle(30);
    end
    if index1 == 1 || index1 == 2 || index1 == 3 || index1 == 4 
        xticklabels([]);
        xlabel([]);
    end
    cblh = colorbar;
    if index1 == 1 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'-2', '-1', '0', '0.25', '0.5', '0.75', '1', '1.25', '1.5', '1.75', '2', ''}); %I06s '-2', '0', '1', '2', '3', '5', '7.5', '10', '15', '20', ''
    end
    if index1 == 2 
        cblh.YTick = y;
        set(cblh,'yticklabel',{'33.3', '34', '34.25', '34.5', '34.6', '34.65', '34.7', '34.71', '34.72', '34.73', ''});
    end 
    if index1 == 3 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'', '0', '25', '50', '75', '100', '130', '135', '140', '145', '150', ''});
    end
    if index1 == 4
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'0', '10^-^4', '10^-^3', '5*10^-^3', '10^-^2','2*10^-^2', '5*10^-^2', '10^-^1', ''});
    end
    cblh.Label.String = char(color_bar_label(index1)); 
    set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 8)
    hold on
    %plot MLD
    plot(wrapTo360(stn_lon_mld_pt(:,2)), stn_lon_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);
    %plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'MarkerEdgeColor', 'r', 'LineWidth', 1.5);

    ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
    value = ctd.pden;
    cmap_bins =  [27.2 27.3 27.4 27.5 27.6 27.7 27.8 27.83 27.85]; %[23.5 24 24.5 25 25.5 26 26.5 27 27.5 27.6 27.7 27.8 27.85 27.9];
    y = 1:length(cmap_bins); 
    dtr = interp1(cmap_bins, y, value(w)); %this is for irregularly spaced intervals
    var_data=griddata(lon_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr
    if index1 == 1
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 4.19 2.75 1.75]); %0.45 5.94 2.75 1.75
    elseif index1 == 2
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 4.19 2.75 1.75]); %4.03 5.94 2.75 1.75
    elseif index1 == 3
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 2.44 2.75 1.75]); %0.45 4.19 2.75 1.75 
    elseif index1 == 4
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 2.44 2.75 1.75]); %4.03 4.19 2.75 1.75
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

    %add lines and text labeling fronts and zones
    line([wrapTo360(-131.252) wrapTo360(-131.252)], [0 4810],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
    line([wrapTo360(-104.0791) wrapTo360(-104.0791)], [0 4810],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
    line([wrapTo360(-78.4832) wrapTo360(-78.4832)], [0 4810],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5

    %label fronts on bottom
    temp4 = unique(lon_stack(w));
        
    %split upper 1000m to be half of the panel
    xlim1 = ax2.XLim;
    % change limits and shrink positions
    ax2.YLim = [1000 4810]; ax2.Position(4) = ax2.Position(4)/2;
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
    ax4.YLim = [1000 4810]; ax4.Position(4) = ax4.Position(4)/2;
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
        %add zone labels to the top 
        text(ax2, 185, -3150, "Subpolar Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, 229, -3150, "Boundary Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, 256.2, -3150, "Antarctic Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, 282, -3150, "BZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
    end
    %add subplot letter
    subplot_letter = sublet(index1);
    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        text(ax4_top, 155, 140, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    elseif index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        text(ax4_top, 157, 140, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    end
end

% fluorescence plot
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
        cmap_bins = [min(value(w)) 0.06 0.07 0.08 0.09 0.10 0.15 0.20 0.30 0.40 max(value(w))];
    end
    N_colorbins = length(cmap_bins);
    y = 0:N_colorbins-1; 
    dtr = interp1(cmap_bins, y, value(w));

    %plot UVP data over latitude with colorbar created
    depth = ctd.depth(w);
    zbin = min(depth):2:max(depth); % zbin = 0:5:max(depth(w)); 
    zbin = zbin';
    lon_axes = min(wrapTo360(ctd.lon)) :0.1: max(wrapTo360(ctd.lon));
    [X1,Y1] = meshgrid(lon_axes,zbin);
    lon_stack = [];
    for in = 1:length(ctd.lon)
        lon_stack  = [lon_stack, repelem(wrapTo360(ctd.lon(in)), length(ctd.depth))'];
    end
    
    var_data=griddata(lon_stack(w),depth,dtr,X1,Y1);
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
    temp4 = unique(lon_stack(w));
    ax2.YDir = 'reverse';
    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
    end
    if index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        yticklabels([]);
    end
    if index1 == 5 || index1 == 6
        xlabel('Longitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
        xticks([180 200 220 240 260 280]);
        xticklabels({'180^oE','160^oW','140^oW','120^oW','100^oW','80^oW'});
        xtickangle(30);
    end
    if index1 == 1 || index1 == 2 || index1 == 3 || index1 == 4 
        xticklabels([]);
        xlabel([]);
    end
    cblh = colorbar;
    
    if index1 == 5
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'0','0.06', '0.07', '0.08', '0.09', '0.10', '0.15', '0.20',  '0.30', '0.40', ''});
    end
    cblh.Label.String = char(color_bar_label(index1)); 
    set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 8)
    hold on
    %plot MLD
    plot(wrapTo360(stn_lon_mld_pt(:,2)), stn_lon_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);
    ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
    value = ctd.pden;
    
    %set colorbar
    %cmap_bins = [24.5 24.75 25 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9 26 26.1 26.2 26.3 26.4 26.5 26.6 26.7 26.8 26.9 27 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
    cmap_bins =  [27.2 27.3 27.4 27.5 27.6 27.7 27.8 27.83 27.85]; %[24.5 25 25.25 25.5 25.75 26 26.25 26.5 26.75 27 27.2 27.25 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
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
    var_data=griddata(lon_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr

    if index1 == 1
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 5.94 2.75 1.75]); 
    elseif index1 == 2
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 5.94 2.75 1.75]);
    elseif index1 == 3
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 4.19 2.75 1.75]); 
    elseif index1 == 4
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 4.19 2.75 1.75]);
    elseif index1 == 5
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 0.5 2.75 1.94]);
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
    
    ax2.YLim = [0 300];ax2.XLim = [168.4755  286.5002];  %ax2.XLim = [134.8611  235.1631];
    set(h, 'LineColor', 'w'); clabel(C,h, 'Color','w', 'LabelSpacing', 200, 'FontSize', 7);
    ax4.YDir = 'reverse';
    ax4.XTick = []; ax4.YTick = [];
    %ax4.XTickLabel = {'','','','','','','','','','',''};
    set(ax4, 'Color','none');%ax4.XLim = [134.8611  235.1631];
    
    %add lines and text labeling fronts and zones
    line([wrapTo360(-131.252) wrapTo360(-131.252)], [0 300],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
    line([wrapTo360(-104.0791) wrapTo360(-104.0791)], [0 300],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
    line([wrapTo360(-78.4832) wrapTo360(-78.4832)], [0 300],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5

    %label fronts on bottom
    temp4 = unique(lon_stack(w));
    
    if index1 == 5 || index1 == 6
        text(ax2, 180+(180-136), 306, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, 180+(180-110), 306, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, 180+(180-85), 306, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
    end

    %add subplot letter
    subplot_letter = sublet(index1);
    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        text(ax2, 155, 20, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    elseif index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        text(ax2, 157, 20, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    end
    % %fix colorbar position to match 6000 m
    % cblh.Position = [0.8986-0.001 0.3126 0.0290 0.2244];
end

% adding bottle nutrients
for index1 = 6%:8
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
        cmap_bins = [min(value(w)) 25 26 27 28 29 30 31 32 33 34 max(value(w))]; %20 30 40 50 60 70 80 90
    end
    if index1 == 7
        cmap_bins = [min(value(w)) 25 26 27 28 29 30 31 32 33 34 max(value(w))];
    end
    if index1 == 8 
        cmap_bins = [min(value(w)) 1.7 1.8 1.9 2 2.1 2.2 2.25 2.3 max(value(w))];
    end

    N_colorbins = length(cmap_bins);
    y = 0:N_colorbins-1; 
    dtr = interp1(cmap_bins, y, value(w));

    %plot UVP data over longitude with colorbar created
    depth = bot.CTDPRS;
    zbin = min(depth(w)):5:max(depth(w)); % zbin = 0:5:max(depth(w)); 
    zbin = zbin';
    lon_axes = min(wrapTo360(bot.LONGITUDE(w))) :0.1: max(wrapTo360(bot.LONGITUDE(w)));
    [X1,Y1] = meshgrid(lon_axes,zbin);
    var_data=griddata(wrapTo360(bot.LONGITUDE(w)),depth(w),dtr,X1,Y1);
    
    w2=find(var_data == min(min(var_data))); %EDITED 3/18/25
    var_data(w2) = min(dtr);%EDITED 3/18/25
    w2=find(var_data == max(max(var_data)));%EDITED 3/18/25
    var_data(w2) = max(dtr);%EDITED 3/18/25
    clear w2;%EDITED 3/18/25

    ax2 = axes;
    if index1 == 6
        set(ax2, 'Units', 'inches', 'Position', [4.03 0.5 3.36 1.94]) %4.03 2.44 3.36 1.75
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
    scatter(wrapTo360(bot.LONGITUDE(w)), depth(w), 1,'MarkerFaceColor','k','MarkerEdgeColor','none') %mark sample locations

    temp4 = unique(lon_stack(w));
    ax2.YDir = 'reverse';

    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
    end
    if index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        yticklabels([]);
    end
    if index1 == 5 || index1 == 6
        xlabel('Longitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
        xticks([180 200 220 240 260 280]);
        xticklabels({'180^oE','160^oW','140^oW','120^oW','100^oW','80^oW'});
        xtickangle(30);
    end
    if index1 == 1 || index1 == 2 || index1 == 3 || index1 == 4 
        xticklabels([]);
        xlabel([]);
    end
    cblh = colorbar;
    if index1 == 6 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'23','25', '26', '27', '28', '29', '30', '31', '32',  '33', '34', ''}); %'19', '20', '30', '40', '50', '60', '70', '80', '90', ''
    end
    if index1 == 7 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'23','25', '26', '27', '28', '29', '30', '31', '32',  '33', '34', ''}); 
    end
    if index1 == 8 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'1.6', '1.7', '1.8', '1.9', '2','2.1', '2.2', '2.25', '2.3', ''});
    end
    
    cblh.Label.String = char(color_bar_label(index1)); 
    set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 8)
    hold on
    %plot MLD
    plot(wrapTo360(stn_lon_mld_pt(:,2)), stn_lon_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);

    ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
    value = ctd.pden;
    
    %set colorbar
    %cmap_bins = [24.5 24.75 25 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9 26 26.1 26.2 26.3 26.4 26.5 26.6 26.7 26.8 26.9 27 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
    cmap_bins =  [27.2 27.3 27.4 27.5 27.6 27.7 27.8 27.83 27.85]; %[24.5 25 25.25 25.5 25.75 26 26.25 26.5 26.75 27 27.2 27.25 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
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
    lon_axes = min(wrapTo360(ctd.lon)) :0.1: max(wrapTo360(ctd.lon));
    [X1,Y1] = meshgrid(lon_axes,zbin);
    lon_stack = [];
    for in = 1:length(ctd.lon)
        lon_stack  = [lon_stack, repelem(wrapTo360(ctd.lon(in)), length(ctd.depth))'];
    end

    var_data=griddata(lon_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr
    
    if index1 == 6
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 0.5 2.75 1.94]); %4.03 2.44 2.75 1.76
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
    
     %add lines and text labeling fronts and zones
    line([wrapTo360(-131.252) wrapTo360(-131.252)], [0 300],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
    line([wrapTo360(-104.0791) wrapTo360(-104.0791)], [0 300],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
    line([wrapTo360(-78.4832) wrapTo360(-78.4832)], [0 300],'color',[0 0 0],'linewi',1); %, 'alpha', 0.
    
    if index1 == 5 || index1 == 6
        text(ax2, 180+(180-136), 306, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, 180+(180-110), 306, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, 180+(180-85), 306, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
    end

    %add subplot letter
    subplot_letter = sublet(index1);
    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        text(ax2, 155, 20, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    elseif index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        text(ax2, 157, 20, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    end
end
%save figure
print("G:/Cruises/2018_S04P/S04p_multi_panel_CTD_Environment_6panel", "-dpng","-r300");


%% Plot data 6000 from CTD file multiplot

fig2 = figure;
set(fig2, 'Units', 'inches', 'Position', [0.4417 0.6167 7.67 7.8]); 
%stations = unique(ctd.stn)'; 
%I need to remove stations that aren't on the main line
stations = load('G:\Cruises\2018_S04P\S04P_transect_main5_CTD.txt');
stations = stations';

%pull out lat and long from each station location
for in = 1:length(stations)
   w=find(ctd.stn == stations(in));
   lat_lon(in,1) = ctd.lat(w);
   lat_lon(in,2) = wrapTo360(ctd.lon(w));
   %find bottom depth in each sample
   %bottom_depth(in,1) = ctd.depth(end,w(1));
end
lat_lon = sortrows(lat_lon, 2); %sort so lat is from min to max, added on 5/13/2025

%Interpolate between stations to 5KM resolution
%lat = interp(ctd.lat,15);
%long = interp(ctd.lon,15);
lat = interp1([1:length(lat_lon(:,1))]',lat_lon(:,1), linspace(1,length(lat_lon), 630)); 
long = interp1([1:length(lat_lon(:,2))]',lat_lon(:,2), linspace(1,length(lat_lon), 630));

%download bathy file from etopo2
%[ELEV,LONG,LAT]=m_etopo2([min(ctd.lon) max(ctd.lon) min(ctd.lat) max(ctd.lat)]);
[ELEV,LONG,LAT]=m_etopo2([min(lat_lon(:,2)) max(lat_lon(:,2)) min(lat_lon(:,1)) max(lat_lon(:,1))]);

%find row/column that best matches exact station locations interpolated
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
        cmap_bins = [min(value(w)) -1 0 0.25 0.5 0.75 1 1.25 1.5 1.75 2 max(value(w))]; %i06s 0 1 2 3 5 7.5 10 15 20
    end
    if index1 == 2
        cmap_bins = [min(value(w)) 34 34.25 34.5 34.6 34.65 34.7 34.71 34.72 34.73 max(value(w))];
    end
    if index1 == 3 
        cmap_bins = [min(value(w)) 180 190 200 210 220 230 240 250 300 350 max(value(w))];
    end
    if index1 == 4
        cmap_bins = [min(value(w)) 0 25 50 75 100 130 135 140 145 150 max(value(w))];
    end
    N_colorbins = length(cmap_bins);
    y = 0:N_colorbins-1; 
    dtr = interp1(cmap_bins, y, value(w));

   %plot UVP data over latitude with colorbar created
    depth = ctd.depth(w);
    zbin = min(depth):2:max(depth); % zbin = 0:5:max(depth(w)); 
    zbin = zbin';
    lon_axes = min(wrapTo360(ctd.lon)):0.1: max(wrapTo360(ctd.lon));
    [X1,Y1] = meshgrid(lon_axes,zbin);
    lon_stack = [];
    for in = 1:length(ctd.lon)
        lon_stack  = [lon_stack, repelem(wrapTo360(ctd.lon(in)), length(ctd.depth))'];
    end
    
    var_data=griddata(lon_stack(w),depth,dtr,X1,Y1);
    
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
        plot(ax2,unique(lon_stack(w)),zeros([1 length(unique(lon_stack(w)))]),'r|','MarkerSize',5)
    end
    temp4 = unique(lon_stack(w));
    ax2.YDir = 'reverse';
    %Bathymetry
    hold on
    p = patch([long long(end) long(1)], [elevation.*-1 4810 4810],'k');
    set(p, 'facecolor',[0.5 0.5 0.5], 'edgecolor', [0.5 0.5 0.5]);
    ax2.YLim = [0 4810]; ax2.XLim = [168.4755  286.5002]; %[173.5405 286.5010]; %edited 18Sept2025

    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
    end
    if index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        yticklabels([]);
    end
    if index1 == 5 || index1 == 6
        xlabel('Longitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
        xticks([180 200 220 240 260 280]);
        xticklabels({'180^oE','160^oW','140^oW','120^oW','100^oW','80^oW'});
        xtickangle(30);
    end
    if index1 == 1 || index1 == 2 || index1 == 3 || index1 == 4 
        xticklabels([]);
        xlabel([]);
    end
    cblh = colorbar;
    if index1 == 1 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'-2', '-1', '0', '0.25', '0.5', '0.75', '1', '1.25', '1.5', '1.75', '2', ''}); %I06s '-2', '0', '1', '2', '3', '5', '7.5', '10', '15', '20', ''
    end
    if index1 == 2 
        cblh.YTick = y;
        set(cblh,'yticklabel',{'33.3', '34', '34.25', '34.5', '34.6', '34.65', '34.7', '34.71', '34.72', '34.73', ''});
    end 
    if index1 == 3 
        cblh.YTick = y; 
        %set(cblh,'yticklabel',{'10', '15', '25', '50', '100', '150', '200', '210', '220', '230', '240', ''});
        set(cblh,'yticklabel',{'170','180', '190', '200', '210', '220', '230', '240', '250', '300', '350', ''});
    end
    if index1 == 4
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'', '0', '25', '50', '75', '100', '130', '135', '140', '145', '150', ''});
    end
    cblh.Label.String = char(color_bar_label(index1)); 
    set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 8)
    hold on
    %plot MLD
    plot(wrapTo360(stn_lon_mld_pt(:,2)), stn_lon_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);
    %plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'MarkerEdgeColor', 'r', 'LineWidth', 1.5);

    ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
    value = ctd.pden;
    cmap_bins =  [27.2 27.3 27.4 27.5 27.6 27.7 27.8 27.83 27.85]; %[23.5 24 24.5 25 25.5 26 26.5 27 27.5 27.6 27.7 27.8 27.85 27.9];
    y = 1:length(cmap_bins); 
    dtr = interp1(cmap_bins, y, value(w)); %this is for irregularly spaced intervals
    var_data=griddata(lon_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr
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
    
    set(h, 'LineColor', 'w'); clabel(C,h, 'Color','w', 'LabelSpacing', 100, 'FontSize', 7);
    ax4.YDir = 'reverse';
    ax4.XTick = []; ax4.YTick = [];
    set(ax4, 'Color','none');
    %ylim([0 300]);

    %add lines and text labeling fronts and zones
    line([wrapTo360(-131.252) wrapTo360(-131.252)], [0 4810],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
    line([wrapTo360(-104.0791) wrapTo360(-104.0791)], [0 4810],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
    line([wrapTo360(-78.4832) wrapTo360(-78.4832)], [0 4810],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5

    %label fronts on bottom
    temp4 = unique(lon_stack(w));
        
    %split upper 1000m to be half of the panel
    xlim1 = ax2.XLim;
    % change limits and shrink positions
    ax2.YLim = [1000 4810]; ax2.Position(4) = ax2.Position(4)/2;
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
    ax4.YLim = [1000 4810]; ax4.Position(4) = ax4.Position(4)/2;
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
        %add zone labels to the top 
        text(ax2, 185, -3150, "Subpolar Region", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, 229, -3150, "Southern Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, 256.2, -3150, "Antarctic Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, 282, -3150, "SZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
    end
    %add subplot letter
    subplot_letter = sublet(index1);
    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        text(ax4_top, 155, 140, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    elseif index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        text(ax4_top, 157, 140, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    end
end

% fluorescence plot
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
        cmap_bins = [min(value(w)) 0.06 0.07 0.08 0.09 0.10 0.15 0.20 0.30 0.40 max(value(w))];
    end
    N_colorbins = length(cmap_bins);
    y = 0:N_colorbins-1; 
    dtr = interp1(cmap_bins, y, value(w));

    %plot UVP data over latitude with colorbar created
    depth = ctd.depth(w);
    zbin = min(depth):2:max(depth); % zbin = 0:5:max(depth(w)); 
    zbin = zbin';
    lon_axes = min(wrapTo360(ctd.lon)) :0.1: max(wrapTo360(ctd.lon));
    [X1,Y1] = meshgrid(lon_axes,zbin);
    lon_stack = [];
    for in = 1:length(ctd.lon)
        lon_stack  = [lon_stack, repelem(wrapTo360(ctd.lon(in)), length(ctd.depth))'];
    end
    
    var_data=griddata(lon_stack(w),depth,dtr,X1,Y1);
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
    temp4 = unique(lon_stack(w));
    ax2.YDir = 'reverse';
    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
    end
    if index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        yticklabels([]);
    end
    if index1 == 7 || index1 == 8
        xlabel('Longitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
        xticks([180 200 220 240 260 280]);
        xticklabels({'180^oE','160^oW','140^oW','120^oW','100^oW','80^oW'});
        xtickangle(30);
    end
    if index1 == 1 || index1 == 2 || index1 == 3 || index1 == 4 || index1 == 5 || index1 == 6
        xticklabels([]);
        xlabel([]);
    end
    cblh = colorbar;
    
    if index1 == 5
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'0','0.06', '0.07', '0.08', '0.09', '0.10', '0.15', '0.20',  '0.30', '0.40', ''});
    end
    cblh.Label.String = char(color_bar_label(index1)); 
    set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 8)
    hold on
    %plot MLD
    plot(wrapTo360(stn_lon_mld_pt(:,2)), stn_lon_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);
    ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
    value = ctd.pden;
    
    %set colorbar
    %cmap_bins = [24.5 24.75 25 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9 26 26.1 26.2 26.3 26.4 26.5 26.6 26.7 26.8 26.9 27 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
    cmap_bins =  [27.2 27.3 27.4 27.5 27.6 27.7 27.8 27.83 27.85]; %[24.5 25 25.25 25.5 25.75 26 26.25 26.5 26.75 27 27.2 27.25 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
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
    var_data=griddata(lon_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr

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
    
    ax2.YLim = [0 300];ax2.XLim = [168.4755  286.5002];  %ax2.XLim = [134.8611  235.1631];
    set(h, 'LineColor', 'w'); clabel(C,h, 'Color','w', 'LabelSpacing', 200, 'FontSize', 8);
    ax4.YDir = 'reverse';
    ax4.XTick = []; ax4.YTick = [];
    %ax4.XTickLabel = {'','','','','','','','','','',''};
    set(ax4, 'Color','none');%ax4.XLim = [134.8611  235.1631];
    
    %add lines and text labeling fronts and zones
    line([wrapTo360(-131.252) wrapTo360(-131.252)], [0 300],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
    line([wrapTo360(-104.0791) wrapTo360(-104.0791)], [0 300],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
    line([wrapTo360(-78.4832) wrapTo360(-78.4832)], [0 300],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5

    %label fronts on bottom
    temp4 = unique(lon_stack(w));
    
    % text(ax2, -60.7523-1.25, 306, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 6);
    % text(ax2, -55.9998-1.6, 306, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
    % text(ax2, -53.5-0.5, 306, "PF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
    % text(ax2, -49-1, 306, "SAF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
    % text(ax2, -40.6662-1, 306, "STF", 'FontName','helvetica','fontweight','bold','fontsize', 6);

    %add subplot letter
    subplot_letter = sublet(index1);
    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        text(ax2, 155, 20, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    elseif index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        text(ax2, 157, 20, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    end
    % %fix colorbar position to match 6000 m
    % cblh.Position = [0.8986-0.001 0.3126 0.0290 0.2244];
end

% adding bottle nutrients
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
        cmap_bins = [min(value(w)) 20 30 40 50 60 70 80 90 max(value(w))];
    end
    if index1 == 7
        cmap_bins = [min(value(w)) 25 26 27 28 29 30 31 32 33 34 max(value(w))];
    end
    if index1 == 8 
        cmap_bins = [min(value(w)) 1.7 1.8 1.9 2 2.1 2.2 2.25 2.3 max(value(w))];
    end

    N_colorbins = length(cmap_bins);
    y = 0:N_colorbins-1; 
    dtr = interp1(cmap_bins, y, value(w));

    %plot UVP data over longitude with colorbar created
    depth = bot.CTDPRS;
    zbin = min(depth(w)):5:max(depth(w)); % zbin = 0:5:max(depth(w)); 
    zbin = zbin';
    lon_axes = min(wrapTo360(bot.LONGITUDE(w))) :0.1: max(wrapTo360(bot.LONGITUDE(w)));
    [X1,Y1] = meshgrid(lon_axes,zbin);
    var_data=griddata(wrapTo360(bot.LONGITUDE(w)),depth(w),dtr,X1,Y1);
    
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
    scatter(wrapTo360(bot.LONGITUDE(w)), depth(w), 1,'MarkerFaceColor','k','MarkerEdgeColor','none') %mark sample locations

    temp4 = unique(lon_stack(w));
    ax2.YDir = 'reverse';

    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
    end
    if index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        yticklabels([]);
    end
    if index1 == 7 || index1 == 8
        xlabel('Longitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
        xticks([180 200 220 240 260 280]);
        xticklabels({'180^oE','160^oW','140^oW','120^oW','100^oW','80^oW'});
        xtickangle(30);
    end
    if index1 == 1 || index1 == 2 || index1 == 3 || index1 == 4 || index1 == 5 || index1 == 6
        xticklabels([]);
        xlabel([]);
    end
    cblh = colorbar;
    if index1 == 6 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'19', '20', '30', '40', '50', '60', '70', '80', '90', ''});
    end
    if index1 == 7 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'23','25', '26', '27', '28', '29', '30', '31', '32',  '33', '34', ''}); 
    end
    if index1 == 8 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'1.6', '1.7', '1.8', '1.9', '2','2.1', '2.2', '2.25', '2.3', ''});
    end
    
    cblh.Label.String = char(color_bar_label(index1)); 
    set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 8)
    hold on
    %plot MLD
    plot(wrapTo360(stn_lon_mld_pt(:,2)), stn_lon_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);

    ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
    value = ctd.pden;
    
    %set colorbar
    %cmap_bins = [24.5 24.75 25 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9 26 26.1 26.2 26.3 26.4 26.5 26.6 26.7 26.8 26.9 27 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
    cmap_bins =  [27.2 27.3 27.4 27.5 27.6 27.7 27.8 27.83 27.85]; %[24.5 25 25.25 25.5 25.75 26 26.25 26.5 26.75 27 27.2 27.25 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
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
    lon_axes = min(wrapTo360(ctd.lon)) :0.1: max(wrapTo360(ctd.lon));
    [X1,Y1] = meshgrid(lon_axes,zbin);
    lon_stack = [];
    for in = 1:length(ctd.lon)
        lon_stack  = [lon_stack, repelem(wrapTo360(ctd.lon(in)), length(ctd.depth))'];
    end

    var_data=griddata(lon_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr
    
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
    
     %add lines and text labeling fronts and zones
    line([wrapTo360(-131.252) wrapTo360(-131.252)], [0 300],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
    line([wrapTo360(-104.0791) wrapTo360(-104.0791)], [0 300],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
    line([wrapTo360(-78.4832) wrapTo360(-78.4832)], [0 300],'color',[0 0 0],'linewi',1); %, 'alpha', 0.
    
    if index1 == 7 || index1 == 8
        text(ax2, 180+(180-136), 306, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, 180+(180-110), 306, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, 180+(180-85), 306, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
    end

    %add subplot letter
    subplot_letter = sublet(index1);
    if index1 == 1 || index1 == 3 || index1 == 5 || index1 == 7
        text(ax2, 155, 20, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    elseif index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
        text(ax2, 157, 20, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    end
end
%save figure
print("G:/Cruises/2018_S04P/S04p_multi_panel_CTD_Environment", "-dpng","-r300");


%% Plot Transmission individually
stations = load('G:\Cruises\2018_S04P\S04P_transect_main5_CTD.txt');
stations = stations';

%pull out lat and long from each station location
for in = 1:length(stations)
   w=find(ctd.stn == stations(in));
   lat_lon(in,1) = ctd.lat(w);
   lat_lon(in,2) = wrapTo360(ctd.lon(w));
   %find bottom depth in each sample
   %bottom_depth(in,1) = ctd.depth(end,w(1));
end
lat_lon = sortrows(lat_lon, 2); %sort so lat is from min to max, added on 5/13/2025

%Interpolate between stations to 5KM resolution
%lat = interp(ctd.lat,15);
%long = interp(ctd.lon,15);
lat = interp1([1:length(lat_lon(:,1))]',lat_lon(:,1), linspace(1,length(lat_lon), 630)); 
long = interp1([1:length(lat_lon(:,2))]',lat_lon(:,2), linspace(1,length(lat_lon), 630));

% %Interpolate between stations to 5KM resolution
% lat = interp(ctd.lat,15);
% long = interp(ctd.lon,15);

%download bathy file from etopo2
[ELEV,LONG,LAT]=m_etopo2([min(wrapTo360(ctd.lon)) max(wrapTo360(ctd.lon)) min(ctd.lat) max(ctd.lat)]);
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

% %remove flags
% %unique(ctd.fluorescence_flag)
% %flag 1, 2, and 6 are good
% w4 = (ctd.transmission_flag == 1 | ctd.transmission_flag == 2 | ctd.transmission_flag == 6);
% w4_test = w & w4;
% w = w4_test;

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
lon_axes = min(wrapTo360(ctd.lon)):0.1: max(wrapTo360(ctd.lon));
[X1,Y1] = meshgrid(lon_axes,zbin);
lon_stack = [];
for in = 1:length(ctd.lon)
    lon_stack  = [lon_stack, repelem(wrapTo360(ctd.lon(in)), length(ctd.depth))'];
end

var_data=griddata(lon_stack(w),depth,dtr,X1,Y1);

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

plot(ax2,unique(lon_stack(w)),zeros([1 length(unique(lon_stack(w)))]),'r|','MarkerSize',5)

temp4 = unique(lon_stack(w));
ax2.YDir = 'reverse';
%Bathymetry
hold on
p = patch([wrapTo360(long) wrapTo360(long(end)) wrapTo360(long(1))], [elevation.*-1 4810 4810],'k');
set(p, 'facecolor',[0.5 0.5 0.5], 'edgecolor', [0.5 0.5 0.5]);
ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
xlabel('Longitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
xticks([180 200 220 240 260 280]);
xticklabels({'180^oE','160^oW','140^oW','120^oW','100^oW','80^oW'});
xtickangle(30);
cblh = colorbar;
cblh.YTick = y; 
set(cblh,'yticklabel',{'0', '10^-^4', '10^-^3', '5*10^-^3', '10^-^2','2*10^-^2', '5*10^-^2', '10^-^1', '>10^-^1'});

cblh.Label.String = ('Transmission (m^-^1)'); 
set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 14)
fig2.Position = [559.4000 191.4000 935.2000 521.6000];
ax2.Position = [0.1218 0.1680 0.7264 0.7570];
hold on
%plot MLD
plot(wrapTo360(stn_lon_mld_pt(:,2)), stn_lon_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);
%plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'MarkerEdgeColor', 'r', 'LineWidth', 1.5);

ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
value = ctd.pden;
cmap_bins =  [27.2 27.3 27.4 27.5 27.6 27.7 27.8 27.83 27.85]; %[23.5 24 24.5 25 25.5 26 26.5 27 27.5 27.6 27.7 27.8 27.85 27.9];
%cmap_bins = [24.5 24.75 25 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9 26 26.1 26.2 26.3 26.4 26.5 26.6 26.7 26.8 26.9 27 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
y = 1:length(cmap_bins); 
dtr = interp1(cmap_bins, y, value(w)); %this is for irregularly spaced intervals
var_data=griddata(lon_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr
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

%label fronts on bottom
temp4 = unique(lon_stack(w));

% hold on
%add lines and text labeling fronts and zones
line([wrapTo360(-131.252) wrapTo360(-131.252)], [0 4810],'color',[0 0 0],'linewi',3); %, 'alpha', 0.5
line([wrapTo360(-104.0791) wrapTo360(-104.0791)], [0 4810],'color',[0 0 0],'linewi',3); %, 'alpha', 0.5
line([wrapTo360(-78.4832) wrapTo360(-78.4832)], [0 4810],'color',[0 0 0],'linewi',3); %, 'alpha', 0.

text(ax2, 180+(180-136), 4810+150, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, 180+(180-110),  4810+150, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, 180+(180-85),  4810+150, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 14);

%split upper 1000m to be half of the panel
xlim1 = ax2.XLim;
% change limits and shrink positions
ax2.YLim = [1000 4810]; ax2.Position(4) = ax2.Position(4)/2;
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
ax4.YLim = [1000 4810]; ax4.Position(4) = ax4.Position(4)/2;
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
text(ax2, 185, -3150, "Subpolar Region", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, 229, -3150, "Southern Zone", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, 256.2, -3150, "Antarctic Zone", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, 282, -3150, "SZ", 'FontName','helvetica','fontweight','bold','fontsize', 14); 


print('G:\Cruises\2018_S04P\S04p_ctd_transmission_isopycnals_fronts','-dpng','-r300');

%% plot beam transmission

stations = load('G:\Cruises\2018_S04P\S04P_transect_main5_CTD.txt');
stations = stations';

%pull out lat and long from each station location
for in = 1:length(stations)
   w=find(ctd.stn == stations(in));
   lat_lon(in,1) = ctd.lat(w);
   lat_lon(in,2) = wrapTo360(ctd.lon(w));
   %find bottom depth in each sample
   %bottom_depth(in,1) = ctd.depth(end,w(1));
end
lat_lon = sortrows(lat_lon, 2); %sort so lat is from min to max, added on 5/13/2025

%Interpolate between stations to 5KM resolution
%lat = interp(ctd.lat,15);
%long = interp(ctd.lon,15);
lat = interp1([1:length(lat_lon(:,1))]',lat_lon(:,1), linspace(1,length(lat_lon), 630)); 
long = interp1([1:length(lat_lon(:,2))]',lat_lon(:,2), linspace(1,length(lat_lon), 630));

% %Interpolate between stations to 5KM resolution
% lat = interp(ctd.lat,15);
% long = interp(ctd.lon,15);

%download bathy file from etopo2
[ELEV,LONG,LAT]=m_etopo2([min(wrapTo360(ctd.lon)) max(wrapTo360(ctd.lon)) min(ctd.lat) max(ctd.lat)]);
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
lon_axes = min(wrapTo360(ctd.lon)):0.1: max(wrapTo360(ctd.lon));
[X1,Y1] = meshgrid(lon_axes,zbin);
lon_stack = [];
for in = 1:length(ctd.lon)
    lon_stack  = [lon_stack, repelem(wrapTo360(ctd.lon(in)), length(ctd.depth))'];
end

var_data=griddata(lon_stack(w),depth,dtr,X1,Y1);

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

plot(ax2,unique(lon_stack(w)),zeros([1 length(unique(lon_stack(w)))]),'r|','MarkerSize',5)

temp4 = unique(lon_stack(w));
ax2.YDir = 'reverse';
%Bathymetry
hold on
p = patch([wrapTo360(long) wrapTo360(long(end)) wrapTo360(long(1))], [elevation.*-1 4810 4810],'k');
set(p, 'facecolor',[0.5 0.5 0.5], 'edgecolor', [0.5 0.5 0.5]);
ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
xlabel('Longitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
xticks([180 200 220 240 260 280]);
xticklabels({'180^oE','160^oW','140^oW','120^oW','100^oW','80^oW'});
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
plot(wrapTo360(stn_lon_mld_pt(:,2)), stn_lon_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);
%plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'MarkerEdgeColor', 'r', 'LineWidth', 1.5);

ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
value = ctd.pden;
cmap_bins =  [27.2 27.3 27.4 27.5 27.6 27.7 27.8 27.83 27.85]; %[23.5 24 24.5 25 25.5 26 26.5 27 27.5 27.6 27.7 27.8 27.85 27.9];
%cmap_bins = [24.5 24.75 25 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9 26 26.1 26.2 26.3 26.4 26.5 26.6 26.7 26.8 26.9 27 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
y = 1:length(cmap_bins); 
dtr = interp1(cmap_bins, y, value(w)); %this is for irregularly spaced intervals
var_data=griddata(lon_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr
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

%label fronts on bottom
temp4 = unique(lon_stack(w));

% hold on
%add lines and text labeling fronts and zones
line([wrapTo360(-131.252) wrapTo360(-131.252)], [0 4810],'color',[0 0 0],'linewi',3); %, 'alpha', 0.5
line([wrapTo360(-104.0791) wrapTo360(-104.0791)], [0 4810],'color',[0 0 0],'linewi',3); %, 'alpha', 0.5
line([wrapTo360(-78.4832) wrapTo360(-78.4832)], [0 4810],'color',[0 0 0],'linewi',3); %, 'alpha', 0.

text(ax2, 180+(180-136), 4810+150, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, 180+(180-110),  4810+150, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, 180+(180-85),  4810+150, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 14);

%split upper 1000m to be half of the panel
xlim1 = ax2.XLim;
% change limits and shrink positions
ax2.YLim = [1000 4810]; ax2.Position(4) = ax2.Position(4)/2;
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
ax4.YLim = [1000 4810]; ax4.Position(4) = ax4.Position(4)/2;
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
text(ax2, 185, -3150, "Subpolar Region", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, 229, -3150, "Southern Zone", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, 256.2, -3150, "Antarctic Zone", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, 282, -3150, "SZ", 'FontName','helvetica','fontweight','bold','fontsize', 14); 

print('G:\Cruises\2018_S04P\S04p_ctd_beta700_isopycnals_fronts','-dpng','-r300');

%% plot beam transmission

% High N: A high Brunt-Väisälä frequency means the water column is highly stratified and stable, resisting vertical mixing. 
% Low N: A low frequency indicates a less stable, less stratified water column, where vertical mixing is easier. 

addpath('G:\MATLAB\GSW-Matlab-master\Toolbox')
lat_stack = [];
    for in = 1:length(ctd.lat)
        lat_stack  = [lat_stack, repelem(ctd.lat(in), length(ctd.depth))'];
    end

%convert practical salinity to absolute salinity 
%[SA, in_ocean] = gsw_SA_from_SP(SP,p,long,lat)
[SA, in_ocean] = gsw_SA_from_SP(ctd.salinity,ctd.depth,lon_stack,lat_stack);
[N2, p_mid] = gsw_Nsquared(SA,ctd.temperature,ctd.depth,lat_stack);

stations = load('G:\Cruises\2018_S04P\S04P_transect_main5_CTD.txt');
stations = stations';

%pull out lat and long from each station location
for in = 1:length(stations)
   w=find(ctd.stn == stations(in));
   lat_lon(in,1) = ctd.lat(w);
   lat_lon(in,2) = wrapTo360(ctd.lon(w));
   %find bottom depth in each sample
   %bottom_depth(in,1) = ctd.depth(end,w(1));
end
lat_lon = sortrows(lat_lon, 2); %sort so lat is from min to max, added on 5/13/2025

%Interpolate between stations to 5KM resolution
%lat = interp(ctd.lat,15);
%long = interp(ctd.lon,15);
lat = interp1([1:length(lat_lon(:,1))]',lat_lon(:,1), linspace(1,length(lat_lon), 630)); 
long = interp1([1:length(lat_lon(:,2))]',lat_lon(:,2), linspace(1,length(lat_lon), 630));

% %Interpolate between stations to 5KM resolution
% lat = interp(ctd.lat,15);
% long = interp(ctd.lon,15);

%download bathy file from etopo2
[ELEV,LONG,LAT]=m_etopo2([min(wrapTo360(ctd.lon)) max(wrapTo360(ctd.lon)) min(ctd.lat) max(ctd.lat)]);
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
lon_axes = min(wrapTo360(ctd.lon)):0.1: max(wrapTo360(ctd.lon));
[X1,Y1] = meshgrid(lon_axes,zbin);
lon_stack = [];
for in = 1:length(ctd.lon)
    lon_stack  = [lon_stack, repelem(wrapTo360(ctd.lon(in)), length(ctd.depth))'];
end

var_data=griddata(lon_stack(w),depth,dtr,X1,Y1);

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

plot(ax2,unique(lon_stack(w)),zeros([1 length(unique(lon_stack(w)))]),'r|','MarkerSize',5)

temp4 = unique(lon_stack(w));
ax2.YDir = 'reverse';
%Bathymetry
hold on
p = patch([wrapTo360(long) wrapTo360(long(end)) wrapTo360(long(1))], [elevation.*-1 4810 4810],'k');
set(p, 'facecolor',[0.5 0.5 0.5], 'edgecolor', [0.5 0.5 0.5]);
ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
xlabel('Longitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
xticks([180 200 220 240 260 280]);
xticklabels({'180^oE','160^oW','140^oW','120^oW','100^oW','80^oW'});
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
plot(wrapTo360(stn_lon_mld_pt(:,2)), stn_lon_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);
%plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'MarkerEdgeColor', 'r', 'LineWidth', 1.5);

ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
value = ctd.pden;
cmap_bins =  [27.2 27.3 27.4 27.5 27.6 27.7 27.8 27.83 27.85]; %[23.5 24 24.5 25 25.5 26 26.5 27 27.5 27.6 27.7 27.8 27.85 27.9];
%cmap_bins = [24.5 24.75 25 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9 26 26.1 26.2 26.3 26.4 26.5 26.6 26.7 26.8 26.9 27 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.75 27.8 27.85 27.9];
y = 1:length(cmap_bins); 
dtr = interp1(cmap_bins, y, value(w)); %this is for irregularly spaced intervals
var_data=griddata(lon_stack(w),depth,value(w),X1,Y1); %changed value(w) from dtr
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

%label fronts on bottom
temp4 = unique(lon_stack(w));

% hold on
%add lines and text labeling fronts and zones
line([wrapTo360(-131.252) wrapTo360(-131.252)], [0 4810],'color',[0 0 0],'linewi',3); %, 'alpha', 0.5
line([wrapTo360(-104.0791) wrapTo360(-104.0791)], [0 4810],'color',[0 0 0],'linewi',3); %, 'alpha', 0.5
line([wrapTo360(-78.4832) wrapTo360(-78.4832)], [0 4810],'color',[0 0 0],'linewi',3); %, 'alpha', 0.

text(ax2, 180+(180-136), 4810+150, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, 180+(180-110),  4810+150, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 14);
text(ax2, 180+(180-85),  4810+150, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 14);

%split upper 1000m to be half of the panel
xlim1 = ax2.XLim;
% change limits and shrink positions
ax2.YLim = [1000 4810]; ax2.Position(4) = ax2.Position(4)/2;
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
ax4.YLim = [1000 4810]; ax4.Position(4) = ax4.Position(4)/2;
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
text(ax2, 185, -3150, "Subpolar Region", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, 229, -3150, "Southern Zone", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, 256.2, -3150, "Antarctic Zone", 'FontName','helvetica','fontweight','bold','fontsize', 14); 
text(ax2, 282, -3150, "SZ", 'FontName','helvetica','fontweight','bold','fontsize', 14); 

print('G:\Cruises\2018_S04P\S04p_ctd_n_squared_isopycnals_fronts','-dpng','-r300');