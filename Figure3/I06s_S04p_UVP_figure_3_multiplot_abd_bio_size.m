%I06s and S04p abundance, biovolume and mean size plotting contours

clear all; close all;

addpath('C:\Users\steph\OneDrive\Documents\MATLAB\seawater_ver3_3.1')
addpath('C:\Users\steph\OneDrive\Documents\MATLAB\m_map'); addpath('C:\Users\steph\OneDrive\Documents\MATLAB\textborder');

%set parameters for S04p

load('C:\Users\steph\OneDrive\Documents\Cruises\2018_S04P\uvp5_sn207_2018_s04p_ecotaxa_export_par2_filtered_AOU_fluor_sitecorrect_flux_loncorr')

stations = load('C:\Users\steph\OneDrive\Documents\Cruises\2018_S04P\S04P_transect_main5.txt');

%load CTD data
%load data, downloaded 9/17/2025
filepath = 'C:/Users/steph/OneDrive/Documents/Cruises/2018_S04P/320620180309_CTD_bottle_17Sept2025/320620180309_ctd.nc';
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

%pull out lat and long from each station location
for in = 1:length(stations)
   w=find(par.site == stations(in));
   lat_lon(in,1) = par.latitude(w(1));
   lat_lon(in,2) = wrapTo360(par.longitude(w(1)));
   %find bottom depth in each sample
   bottom_depth(in,1) = par.Depth(w(end));
end
%Interpolate between stations to 5KM resolution
lat = interp(lat_lon(:,1),15);
long = interp(lat_lon(:,2),15);
%download bathy file from etopo2
[ELEV,LONG,LAT]=m_etopo2([lat_lon(1,2) lat_lon(end,2) lat_lon(1,1) lat_lon(end,1)]);

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
w = ismember(par.site, stations);

% sigma2 over tot par abundance with frontal zone formatting
par.pden = sw_pden(par.practicalSalinity_psu_,par.temperature_degc_,par.pressure_db_, 0)-1000;

%load S04P MLD (calculated in S04p_CTD_plotting_contours_multiplot.m
load('C:/Users/steph/OneDrive/Documents/Cruises/2018_S04P/stn_lon_mld_pt.mat')

categories = {'tot_par_abundance'; 'tot_par_biovolume'; 'meansize'}; 
color_bar_label = {'Abundance (#/L)'; 'Biovolume (ppm)'; 'Mean Size (mm)'};
sublet_s04p = {'a', 'c', 'e'}; 


%% Plot: make a multipaneled plot for S04p

fig2 = figure;
set(fig2, 'Units', 'inches', 'Position', [22.6458 0.3125 7.67-0.38 6.05+0.3+3.975])  %22.6458 4.3021 7.67-0.38 6.05+0.3 %%% Edit this to be for only 6 panels

for index1 = 1:length(categories) %loop through all categories of particles
    category = char(categories(index1));
    w = ismember(par.site, stations);
    formatSpec = 'value = par.%s;';
    eval(sprintf(formatSpec, category))
    if index1 == 1
        cmap_bins = [min(value(w)) 5 10 20 30 40 50 75 100 250 500 max(value(w))]; 
    end
    if index1 == 2
        cmap_bins = [min(value(w)) 0.05 0.1 0.15 0.2 0.3 0.4 0.8 1 3 5 max(value(w))]; 
    end
    if index1 == 3 
        cmap_bins = [min(value(w)) 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 max(value(w))]; 
    end
    N_colorbins = length(cmap_bins);
    y = 0:N_colorbins-1; 
    dtr = interp1(cmap_bins, y, value(w));

    %plot UVP data over longitude with colorbar created
    zbin = min(par.Depth(w)):5:max(par.Depth(w));
    lon_axes = min(wrapTo360(par.longitude(w))) :0.1: max(wrapTo360(par.longitude(w)));
    [X1,Y1] = meshgrid(lon_axes,zbin);
    var_data=griddata(wrapTo360(par.longitude(w)),par.Depth(w),dtr,X1,Y1);
    w2=find(var_data == min(min(var_data))); %EDITED 3/18/25
    var_data(w2) = min(dtr);%EDITED 3/18/25
    w2=find(var_data == max(max(var_data)));%EDITED 3/18/25
    var_data(w2) = max(dtr);%EDITED 3/18/25
    clear w2;%
    ax2 = axes;

    if index1 == 1
        set(ax2, 'Units', 'inches', 'Position', [0.45 4.19+3.975 2.75 1.75]) %3.36 changed to 2.75 when I removed CB
    elseif index1 == 2
        set(ax2, 'Units', 'inches', 'Position', [0.45 2.44+3.975 2.75 1.75]); %[4.03 4.19 3.36 1.75]) %3.36 changed to 2.75 when I removed CB
    elseif index1 == 3
        set(ax2, 'Units', 'inches', 'Position', [0.45 0.5+3.975 2.75 1.94]); %[0.45 2.44 3.36 1.75]) %3.36 changed to 2.75 when I removed CB
    % elseif index1 == 4
    %     set(ax2, 'Units', 'inches', 'Position', [4.03 4.19 3.36 1.75])
    % elseif index1 == 5
    %     set(ax2, 'Units', 'inches', 'Position', [0.45 2.44 3.36 1.75]) 
    % elseif index1 == 6
    %     set(ax2, 'Units', 'inches', 'Position', [4.03 0.5 3.36 1.94])
    end

    [C,h] = contourf(X1, Y1, var_data); 
    c = parula(N_colorbins - 1);
    colormap(ax2, c); %8/14 I had to specify the axis here because it was editing all of the colormaps at once
    set(h, 'LineColor', 'none');
    hold on
    if index1 == 1 || index1 == 4
        plot(ax2,unique(wrapTo360(par.longitude(w))),zeros([1 length(unique(wrapTo360(par.longitude(w))))]),'r|','MarkerSize',4);
    end
    temp4 = unique(wrapTo360(par.longitude(w)));
    ax2.YDir = 'reverse';
    ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
    if index1 == 3 || index1 == 6
        xlabel('Longitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
        xticks([180 200 220 240 260 280]);
        xticklabels({'180^oE','160^oW','140^oW','120^oW','100^oW','80^oW'})
        xtickangle(30);
    end
    if index1 == 1 || index1 == 2 
        xticklabels([]);
        xlabel([]);
    end
    % cblh = colorbar;
    % if index1 == 1 
    %     cblh.YTick = y; 
    %     set(cblh,'yticklabel',{'0', '5', '10', '20', '30', '40', '50', '75', '100', '250', '500', ''});
    % end
    % if index1 == 2 
    %     cblh.YTick = y; 
    %     set(cblh,'yticklabel',{'0', '0.05', '0.1', '0.15', '0.2', '0.3', '0.4', '0.8', '1', '3', '5', ''}); 
    % end
    % if index1 == 3 
    %     cblh.YTick = y; 
    %     set(cblh,'yticklabel',{'0.09','0.10', '0.11', '0.12', '0.13', '0.14', '0.15', '0.16', '0.17', '0.18', '0.19', '0.20', ''}); 
    % end
    % 
    % cblh.Label.String = char(color_bar_label(index1)); 
    set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 8)
    if index1 == 1
        text(ax2, wrapTo360(-178), -3800, "Pacific Sector (~67^oS)", 'FontName','helvetica','fontweight','bold','fontsize', 14);
    end
    hold on
    %plot MLD
    plot(wrapTo360(stn_lon_mld_pt(:,2)), stn_lon_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);
    N_colorbins = 15;
    % par.pden = sw_pden(par.practicalSalinity_psu_,par.temperature_degc_,par.Depth,0)-1000; 
    % value = par.pden;
    
    %CTD data for density isopycnals
    stations_CTD = load('C:/Users/steph/OneDrive/Documents/Cruises/2018_S04P/S04P_transect_main5_CTD.txt');
    stations_CTD = stations_CTD';
    w_CTD = ismember(ctd.stn, stations_CTD);  

    ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
    value = ctd.pden;

    %remove nans
    w_test = ~isnan(value);
    w3_test = w_CTD.*w_test;
    w_CTD = w3_test;
    w3_test = w_CTD & w_test;
    w_CTD = w3_test;
    % if index1 == 1 || index1 == 2 || index1 ==3 %no flag matrix for transmission
    %     %remove flags
    %     %unique(ctd.fluorescence_flag)
    %     %flag 1, 2, and 6 are good
    %     formatSpec = 'w4 = (ctd.%s_flag == 1 | ctd.%s_flag == 2 | ctd.%s_flag == 6);';
    %     eval(sprintf(formatSpec, category, category, category))
    %     w4_test = w_CTD & w4;
    %     w_CTD = w4_test;
    % end

    depth_CTD = ctd.depth(w_CTD);
    zbin_CTD = min(depth_CTD):2:max(depth_CTD); % zbin = 0:5:max(depth(w)); 
    zbin_CTD = zbin_CTD';
    lon_axes_CTD = min(wrapTo360(ctd.lon)):0.1: max(wrapTo360(ctd.lon));
    [X1_CTD,Y1_CTD] = meshgrid(lon_axes_CTD,zbin_CTD);
    lon_stack = [];
    for in = 1:length(ctd.lon)
        lon_stack  = [lon_stack, repelem(wrapTo360(ctd.lon(in)), length(ctd.depth))'];
    end
    
    %set colorbar
    cmap_bins = [27.2 27.3 27.4 27.5 27.6 27.7 27.8 27.83 27.85]; 
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
    %dtr = interp1(cmap_bins, y, value(w)); %this is for irregularly spaced intervals
    var_data=griddata(lon_stack(w_CTD),depth_CTD,value(w_CTD),X1_CTD,Y1_CTD); %changed value(w) from dtr

    if index1 == 1
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 4.19+3.975 2.75 1.75]);
    elseif index1 == 2
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 2.44+3.975 2.75 1.75]); %[4.03 4.19 2.75 1.75]);
    elseif index1 == 3
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 0.5+3.975 2.75 1.94]);%[0.45 2.44 2.75 1.75]); 
    elseif index1 == 4
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 4.19+3.975 2.75 1.75]);%[4.03 2.44 2.75 1.75]);
    elseif index1 == 5
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 2.44+3.975 2.75 1.75]); %[0.45 0.5 2.75 1.94]);
    elseif index1 == 6
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 0.5+3.975 2.75 1.94]);
    end

    %labels on sigma
    [C,h] = contour(ax4, X1_CTD, Y1_CTD, var_data,cmap_bins, 'showtext','on','LabelSpacing', 300);
    h.LevelList=round(h.LevelList,2);  %rounds levels to 3rd decimal place
    clabel(C,h) 
    %no labels on sigma 2
    %[C,h] = contour(X1, Y1, var_data,cmap_bins);
    
    %bathymetry 
    %p1 = patch([lat_lon(:,2)' lat_lon(end,2) lat_lon(1,2)], [(bottom_depth)' 6000 6000] , 'w');
    p = patch([long' long(end) long(1)], [elevation.*-1 6000 6000],'k');
    %set(p1, 'facecolor','w','edgecolor','w');
    set(p, 'facecolor',[0.5 0.5 0.5], 'edgecolor', [0.5 0.5 0.5]);
    ax2.YLim = [0 4810]; ax2.XLim = [168.4755  286.5002]; %ax2.XLim = [173.5405 286.5010];
    
    set(h, 'LineColor', 'w');clabel(C,h, 'Color','w', 'LabelSpacing', 100, 'FontSize', 7);
    ax4.YDir = 'reverse';
    ax4.XTick = [180 200 220 240 260 280]; ax4.YTick = [];
    ax4.XTickLabel = {'','','','','',''};
    set(ax4, 'Color','none');ax4.XLim = [168.4755  286.5002];%ax4.XLim = [173.5405 286.5010];

    %add lines and text labeling fronts and zones
    line([wrapTo360(-131.252) wrapTo360(-131.252)], [0 max(par.Depth(w))],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
    line([wrapTo360(-104.0791) wrapTo360(-104.0791)], [0 max(par.Depth(w))],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
    line([wrapTo360(-78.4832) wrapTo360(-78.4832)], [0 max(par.Depth(w))],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
    
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
    % % resize colorbar height
    % ax2.Colorbar.Position(4) = ax2.Colorbar.Position(4)*2;
    
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
    
     %add subplot letter
    subplot_letter = sublet_s04p(index1);
    text(ax4_top, temp4(1)-9, 140, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    if index1 == 3
        %label fronts on bottom
        % text(ax2, temp4(38-2), max(par.Depth(w))+200, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        % text(ax2, temp4(53-2), max(par.Depth(w))+200, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        % text(ax2, temp4(71-2)-3, max(par.Depth(w))+200, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, 180+(180-136), 4810+150, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, 180+(180-110), 4810+150, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, 180+(180-85), 4810+150, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
   end

    if index1 == 1 
        % text(ax2, temp4(13-2), -3150, "Subpolar Region", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        % text(ax2, temp4(42-2), -3150, "Southern Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        % text(ax2, temp4(59-2), -3150, "Antarctic Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        % text(ax2, temp4(73-3), -3150, "SZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, 185, -3150, "Subpolar Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, 229, -3150, "Boundary Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, 256.2, -3150, "Antarctic Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, 282, -3150, "BZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
    end
    %add labels for sub-regions
    rectangle(ax4, 'Position',[wrapTo360(-131.252) 4610 wrapTo360(-104.0791)-wrapTo360(-131.252) 200], 'FaceColor','m', 'EdgeColor', 'none', 'clipping', 'off') 
    text(ax4, wrapTo360(-120), 4100, '1', 'Color','m', 'FontSize',20, 'FontWeight', 'Bold')
    rectangle(ax4, 'Position',[wrapTo360(-165) 4610 wrapTo360(-145)-wrapTo360(-165) 200], 'FaceColor','c', 'EdgeColor', 'none', 'clipping', 'off') 
    text(ax4, wrapTo360(-158.5), 4100, '3', 'Color','c', 'FontSize',20, 'FontWeight', 'Bold')
end


%% Plotting I06s panels
clear all;
load('C:\Users\steph\OneDrive\Documents\Cruises\2019_I06S\uvp5_sn207_2019_i06s_tcn322_ecotaxa_export_par2_AOU_fluor_flux_corr.mat')

w = find(par.tot_par_abundance == max(par.tot_par_abundance));%one datapoint seems wrong
par.tot_par_abundance(w)= mean([par.tot_par_abundance(w-1) par.tot_par_abundance(w+1)]);%one datapoint seems wrong
stations = unique(par.site)'; 

%pull out lat and long from each station location
for in = 1:length(stations)
   w=find(par.site == stations(in));
   lat_lon(in,1) = par.latitude(w(1));
   lat_lon(in,2) = wrapTo360(par.longitude(w(1)));
   %find bottom depth in each sample
   bottom_depth(in,1) = par.Depth(w(end));
end
lat_lon = sortrows(lat_lon, 1); %sort so lat is from min to max, added on 5/13/2025

%Interpolate between stations to 5KM resolution
lat = interp1([1:length(lat_lon(:,1))]',lat_lon(:,1), linspace(1,42, 630)); 
long = interp1([1:length(lat_lon(:,2))]',lat_lon(:,2), linspace(1,42, 630));
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

% create colorbar (histogram of all values from UVP variable, then decide
% how many different color bins I want to use and set the values to there
% are an even number of values in each colorbin
w = ismember(par.site, stations);

% sigma2 over tot par abundance with frontal zone formatting
par.pden = sw_pden(par.practicalSalinity_psu_,par.temperature_degc_,par.pressure_db_, 0)-1000;

%load data, downloaded 8/27/2025
%ncdisp('G:/Cruises/2019_I06S/325020190403_ctd.nc'); %view discription of data
ctd.station = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc', 'station');
%this station data is in a weird format
ctd.stn = [1:55]; %this is the same but in a better format
ctd.cast = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc', 'cast');
ctd.lat = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc','latitude'); 
ctd.lon = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc','longitude'); 
ctd.depth = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc','pressure'); 
ctd.fluorescence = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc','ctd_fluor_raw'); 
ctd.fluorescence_flag = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc','ctd_fluor_raw_qc');
ctd.transmission = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc','ctd_beamcp'); 
ctd.transmission_flag = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc','ctd_beamcp_qc'); 
ctd.temperature = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc','ctd_temperature'); 
ctd.temperature_flag = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc','ctd_temperature_qc'); 
ctd.salinity = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc','ctd_salinity'); 
ctd.salinity_flag = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc','ctd_salinity_qc'); 
ctd.salinity = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc','ctd_salinity'); 
ctd.salinity_flag = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc','ctd_salinity_qc'); 
ctd.oxygen = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc','ctd_oxygen'); 
ctd.oxygen_flag = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc','ctd_oxygen_qc'); 
ctd.beta700_raw = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc','ctd_beta700_raw'); 
ctd.ctd_beta700_raw_qc = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc','ctd_beta700_raw_qc'); 
ctd.time = ncread('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/325020190403_ctd.nc','time'); 

%load I06s MLD (calculated in I06s_CTD_plotting_contours_multiplot.m
load('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/stn_lat_mld_pt.mat');
stn_lat_mld_pt= sortrows(stn_lat_mld_pt, 2);

categories = {'tot_par_abundance'; 'tot_par_biovolume'; 'meansize'}; 
color_bar_label = {'Abundance (#/L)'; 'Biovolume (ppm)'; 'Mean Size (mm)'};
sublet_i06s = {'b', 'd', 'f'}; 

fig2 = gcf;

%% Plot I06s
for index1 = 1:length(categories) %loop through all categories of particles
    category = char(categories(index1));
    w = ismember(par.site, stations);
    formatSpec = 'value = par.%s;';
    eval(sprintf(formatSpec, category))
    if index1 == 1
        cmap_bins = [min(value(w)) 5 10 20 30 40 50 75 100 250 500 max(value(w))]; 
    end
    if index1 == 2
        cmap_bins = [min(value(w)) 0.05 0.1 0.15 0.2 0.3 0.4 0.8 1 3 5 max(value(w))]; 
    end
    if index1 == 3 
        cmap_bins = [min(value(w)) 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 max(value(w))]; 
    end
    N_colorbins = length(cmap_bins);
    y = 0:N_colorbins-1; 
    dtr = interp1(cmap_bins, y, value(w));

    %plot UVP data over longitude with colorbar created
    zbin = min(par.Depth(w)):5:max(par.Depth(w));
    lon_axes = min(par.latitude(w)) :0.1: max(par.latitude(w));;
    [X1,Y1] = meshgrid(lon_axes,zbin);
    var_data=griddata(par.latitude(w),par.Depth(w),dtr,X1,Y1);
    w2=find(var_data == min(min(var_data))); %EDITED 3/18/25
    var_data(w2) = min(dtr);%EDITED 3/18/25
    w2=find(var_data == max(max(var_data)));%EDITED 3/18/25
    var_data(w2) = max(dtr);%EDITED 3/18/25
    clear w2;%
    ax2 = axes;

    if index1 == 1
        set(ax2, 'Units', 'inches', 'Position', [3.65 4.19+3.975 3.36 1.75]); %[0.45 4.19 3.36 1.75])
    elseif index1 == 2
        set(ax2, 'Units', 'inches', 'Position', [3.65 2.44+3.975 3.36 1.75]); %[0.45 2.44 3.36 1.75]); %[4.03 4.19 3.36 1.75])
    elseif index1 == 3
        set(ax2, 'Units', 'inches', 'Position', [3.65 0.5+3.975 3.36 1.94]); %[0.45 0.5 3.36 1.94]); %[0.45 2.44 3.36 1.75])
    % elseif index1 == 4
    %     set(ax2, 'Units', 'inches', 'Position', [4.03 4.19 3.36 1.75])
    % elseif index1 == 5
    %     set(ax2, 'Units', 'inches', 'Position', [0.45 2.44 3.36 1.75]) 
    % elseif index1 == 6
    %     set(ax2, 'Units', 'inches', 'Position', [4.03 0.5 3.36 1.94])
    end

    [C,h] = contourf(X1, Y1, var_data); 
    c = parula(N_colorbins - 1);
    colormap(ax2, c); %8/14 I had to specify the axis here because it was editing all of the colormaps at once
    set(h, 'LineColor', 'none');
    hold on
    if index1 == 1 
        plot(ax2,unique(par.latitude(w)),zeros([1 length(unique(par.latitude(w)))]),'r|','MarkerSize',4);
    end
    temp4 = unique(par.latitude(w));
    ax2.YDir = 'reverse';
    %bathymetry
    p = patch([lat lat(end) lat(1)], [elevation.*-1 6000 6000],'k');
    set(p, 'facecolor',[0.5 0.5 0.5], 'edgecolor', [0.5 0.5 0.5]);
    %plot MLD
    plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);
    rectangle('Position',[-67 0 3 6000], 'FaceColor', 'w', 'EdgeColor', 'none')
    rectangle('Position',[-49.983 0 11.4837  6000], 'FaceColor', 'w', 'EdgeColor', 'none')
    ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
    if index1 == 3 
        xlabel('Latitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 8);
        xticks([-65 -60 -55 -50 -45 -40 -35]);
        xticklabels({'65^oS','60^oS','55^oS','50^oS','45^oS','40^oS','35^oS'})
        xtickangle(30);
    end
    if index1 == 1 || index1 == 2 
        xticklabels([]);
        xlabel([]);
    end
    cblh = colorbar;
    if index1 == 1 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'0', '5', '10', '20', '30', '40', '50', '75', '100', '250', '500', ''});
    end
    if index1 == 2 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'0', '0.05', '0.1', '0.15', '0.2', '0.3', '0.4', '0.8', '1', '3', '5', ''}); 
    end
    if index1 == 3 
        cblh.YTick = y; 
        set(cblh,'yticklabel',{'0.09','0.10', '0.11', '0.12', '0.13', '0.14', '0.15', '0.16', '0.17', '0.18', '0.19', '0.20', ''}); 
    end

    cblh.Label.String = char(color_bar_label(index1)); 
    set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 8)
    
    hold on
    N_colorbins = 15;
    % par.pden = sw_pden(par.practicalSalinity_psu_,par.temperature_degc_,par.Depth,0)-1000; 
    % value = par.pden;
    %CTD data for density isopycnals
    stations_CTD = unique(ctd.stn)'; 
    w_CTD = ismember(ctd.stn, stations_CTD);  

    ctd.pden = sw_pden(ctd.salinity,ctd.temperature,ctd.depth,0)-1000; %2000
    value = ctd.pden;

    %remove nans
    w_test = ~isnan(value);
    w3_test = w_CTD.*w_test;
    w_CTD = w3_test;
    w3_test = w_CTD & w_test;
    w_CTD = w3_test;
    % if index1 == 1 || index1 == 2 || index1 ==3 %no flag matrix for transmission
    %     %remove flags
    %     %unique(ctd.fluorescence_flag)
    %     %flag 1, 2, and 6 are good
    %     formatSpec = 'w4 = (ctd.%s_flag == 1 | ctd.%s_flag == 2 | ctd.%s_flag == 6);';
    %     eval(sprintf(formatSpec, category, category, category))
    %     w4_test = w_CTD & w4;
    %     w_CTD = w4_test;
    % end

    depth_CTD = ctd.depth(w_CTD);
    zbin_CTD = min(depth_CTD):2:max(depth_CTD); % zbin = 0:5:max(depth(w)); 
    zbin_CTD = zbin_CTD';
    lat_axes_CTD = min(ctd.lat):0.1: max(ctd.lat);
    [X1_CTD,Y1_CTD] = meshgrid(lat_axes_CTD,zbin_CTD);
    lat_stack = [];
    for in = 1:length(ctd.lat)
        lat_stack  = [lat_stack, repelem(ctd.lat(in), length(ctd.depth))'];
    end
    
    %set colorbar
    %cmap_bins = [23.5 24 24.5 25 25.5 26 26.5 26.75 27 27.15 27.5 27.6 27.7 27.75 27.8 27.83 27.85 27.9];
    cmap_bins = [23.5 24 24.5 25 25.5 26 26.5 26.75 27 27.15 27.5 27.6 27.7 27.75 27.8 27.83 27.85 27.9]; %[23.5 24 24.5 25 25.5 26 26.5 27 27.5 27.6 27.7 27.8 27.85 27.9];
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
    dtr = interp1(cmap_bins, y, value(w_CTD)); %this is for irregularly spaced intervals
    var_data=griddata(lat_stack(w_CTD),depth_CTD,value(w_CTD),X1_CTD,Y1_CTD); %changed value(w) from dtr

    if index1 == 1
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [3.65 4.19+3.975 2.75 1.75]);
    elseif index1 == 2
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [3.65 2.44+3.975 2.75 1.75]); %[4.03 4.19 2.75 1.75]);
    elseif index1 == 3
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [3.65 0.5+3.975 2.75 1.94]);%[0.45 2.44 2.75 1.75]); 
    end

    %labels on sigma 2
    [C,h] = contour(ax4, X1_CTD, Y1_CTD, var_data,cmap_bins, 'showtext','on','LabelSpacing', 300);
    h.LevelList=round(h.LevelList,2);  %rounds levels to 3rd decimal place
    clabel(C,h)
    %no labels on sigma 2
    %[C,h] = contour(X1, Y1, var_data,cmap_bins);
  
    set(h, 'LineColor', 'w');clabel(C,h, 'Color','w', 'LabelSpacing', 100, 'FontSize', 7);

    ax4.YDir = 'reverse';
    ax4.XTick = [180 200 220 240 260 280]; ax4.YTick = [];
    ax4.XTickLabel = {'','','','','',''};
    set(ax4, 'Color','none');%ax4.XLim = [173.5405 286.5010];

    %add lines and text labeling fronts and zones
    line([-60.7523 -60.7523], [0 6000],'color',[0 0 0],'linewi',1); %SBDY
    line([-55.9998 -55.9998], [0 6000],'color',[0 0 0],'linewi',1); %SACCF
    line([-53.5 -53.5]-0.1, [0 6000],'color',[0 0 0],'linewi',1); %, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
    %line([-49.5 -49.5], [0 6000],'color',[0 0 0],'linewi',1, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
    line([-49 -49], [0 6000],'color',[0 0 0],'linewi',1); %SAF
    line([-40.6662 -40.6662], [0 6000],'color',[0 0 0],'linewi',1); %STF
    
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
    
     %add subplot letter
    subplot_letter = sublet_i06s(index1);
    text(ax4_top, temp4(1)-3, 200, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
    if index1 == 3
        %label fronts on bottom
        text(ax2, temp4(13), 6000+300, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, temp4(21), 6000+300, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, temp4(26)-0.3, 6000+300, "PF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, temp4(32)+0.7, 6000+300, "SAF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
        text(ax2, temp4(33)-3.1, 6000+300, "STF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
   end

    if index1 == 1 
        text(ax2, -68, -4400, "Subpolar Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
        text(ax2, -59, -4400, "BZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); %-60.5
        text(ax2, -55.5, -4400, "AZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); %-56.7
        text(ax2, -52.5, -4400, "PFZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); %-53
        text(ax2, -46, -4400, "SAZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); %-48.5
        text(ax2, -37.5, -4400, "STZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); %-40
    end
    if index1 == 1
        text(ax2, -64.5, -5200, "African Sector (~30^oE)", 'FontName','helvetica','fontweight','bold','fontsize', 14);
    end
    %add labels for sub-regions
    rectangle(ax4, 'Position',[-60.7523 5800 -55.9998--60.7523 200], 'FaceColor','r', 'EdgeColor', 'none', 'clipping', 'off') 
    text(ax4, -59.25, 5200, '2', 'Color','r', 'FontSize',20, 'FontWeight', 'Bold')
    rectangle(ax4, 'Position',[-53.5 5800 -50--53.5 200], 'FaceColor',[227/255 185/255 1], 'EdgeColor', 'none', 'clipping', 'off') 
    text(ax4, -52.5, 5200, '4', 'Color',[227/255 185/255 1], 'FontSize',20, 'FontWeight', 'Bold')
end

%print('G:\MS_Southern_Ocean\Figures\I06s_S04p_abd_biov_size_multiplot','-dpng','-r300');


%%
%line plots with one panel for abundance and one for biovolume in teh
%Pacific sectors and two in the African Sectors.
%one line for each frontal zone and either SD or 95% CI around it
%clear all; 

load('C:\Users\steph\OneDrive\Documents\Cruises\2018_S04P\uvp5_sn207_2018_s04p_ecotaxa_export_par2_filtered_AOU_fluor_sitecorrect_flux_loncorr')
stations = load('C:\Users\steph\OneDrive\Documents\Cruises\2018_S04P\S04P_transect_main5.txt');
%load S04P MLD (calculated in S04p_CTD_plotting_contours_multiplot.m
load('C:/Users/steph/OneDrive/Documents/Cruises/2018_S04P/stn_lon_mld_pt.mat')

%add frontal zone parameter to par file
par.frontal_zone = {}; %create cell array within structure
w = find(wrapTo360(par.longitude) <= wrapTo360(-131.252)); %West of SBDY
par.frontal_zone(w,1) = {'Subpolar Region'}; 
w = find(wrapTo360(par.longitude) >  wrapTo360(-131.252) & wrapTo360(par.longitude) <=  wrapTo360(-104.0791)); %West of SACCF
par.frontal_zone(w,1) = {'Southern Zone'}; 
w = find(wrapTo360(par.longitude) >  wrapTo360(-104.0791) & wrapTo360(par.longitude) <=  wrapTo360(-78.4832)); %West of SACCF
par.frontal_zone(w,1) = {'Antarctic Zone'}; 
w = find(wrapTo360(par.longitude) >  wrapTo360(-78.4832)); %East of SACCF
par.frontal_zone(w,1) = {'Southern Zone'};

w = find(strcmp(par.frontal_zone(:), {'Subpolar Region'}));
w2 = ismember(par.site, stations); %only stations on the transect line
w2 = find(w2);
w = intersect(w, w2);
stations1 = unique(par.site(w));

depth_bins = [2.5:50:1002.5 1502.5:250:6502.5];
data_subpolar_region = [];
data_subpolar_region_BV = [];

%make datafile
for index1 = 1:length(stations1)
    w2 = find(par.site == stations1(index1));
    for index = 1:length(depth_bins)-1
        w3 = find(par.Depth >= depth_bins(index) & par.Depth < depth_bins(index+1));
        w4 = intersect(w2, w3);    
        data_subpolar_region(index,1) = depth_bins(index);
        data_subpolar_region(index,index1+1) = mean(par.tot_par_abundance(w4), 'omitnan');
        data_subpolar_region_BV(index,1) = depth_bins(index);
        data_subpolar_region_BV(index,index1+1) = mean(par.tot_par_biovolume(w4), 'omitnan');
    end
end

% Calculate mean, standard error, and degrees of freedom
n = length(stations1);
sampleMean_SR = mean(data_subpolar_region(:,2:end),2,'omitnan');
se = std(data_subpolar_region(:,2:end),1,2,'omitnan') / sqrt(n);
dof = n - 1;

% 95% Confidence interval limits
ci95_SR = sampleMean_SR + se * tinv([0.025, 0.975], dof);
ci95_SR(ci95_SR < 0) = 0.1;

% Calculate mean, standard error, and degrees of freedom
sampleMean_SR_BV = mean(data_subpolar_region_BV(:,2:end),2,'omitnan');
se = std(data_subpolar_region_BV(:,2:end),1,2,'omitnan') / sqrt(n);
dof = n - 1;

% 95% Confidence interval limits
ci95_SR_BV = sampleMean_SR_BV + se * tinv([0.025, 0.975], dof);
ci95_SR_BV(ci95_SR_BV < 0) = 0.1;


w = find(strcmp(par.frontal_zone(:), {'Southern Zone'}));
w2 = ismember(par.site, stations); %only stations on the transect line
w2 = find(w2);
w = intersect(w, w2);
stations1 = unique(par.site(w));
data_southern_zone = [];
data_southern_zone_BV = [];
%make datafile
for index1 = 1:length(stations1)
    w2 = find(par.site == stations1(index1));
    for index = 1:length(depth_bins)-1
        w3 = find(par.Depth >= depth_bins(index) & par.Depth < depth_bins(index+1));
        w4 = intersect(w2, w3);    
        data_southern_zone(index,1) = depth_bins(index);
        data_southern_zone(index,index1+1) = mean(par.tot_par_abundance(w4), 'omitnan');
        data_southern_zone_BV(index,1) = depth_bins(index);
        data_southern_zone_BV(index,index1+1) = mean(par.tot_par_biovolume(w4), 'omitnan');
    end
end

% Calculate mean, standard error, and degrees of freedom
n = length(stations1);
sampleMean_SZ = mean(data_southern_zone(:,2:end),2,'omitnan');
se = std(data_southern_zone(:,2:end),1,2,'omitnan') / sqrt(n);
dof = n - 1;

% 95% Confidence interval limits
ci95_SZ = sampleMean_SZ + se * tinv([0.025, 0.975], dof);
ci95_SZ(ci95_SZ < 0) = 0.1;

% Calculate mean, standard error, and degrees of freedom
sampleMean_SZ_BV = mean(data_southern_zone_BV(:,2:end),2,'omitnan');
se = std(data_southern_zone_BV(:,2:end),1,2,'omitnan') / sqrt(n);
% 95% Confidence interval limits
ci95_SZ_BV = sampleMean_SZ_BV + se * tinv([0.025, 0.975], dof);
ci95_SZ_BV(ci95_SZ_BV < 0) = 0.1;


w = find(strcmp(par.frontal_zone(:), {'Antarctic Zone'}));
w2 = ismember(par.site, stations); %only stations on the transect line
w2 = find(w2);
w = intersect(w, w2);
stations1 = unique(par.site(w));
data_antarctic_zone = [];
data_antarctic_zone_BV = [];
%make datafile
for index1 = 1:length(stations1)
    w2 = find(par.site == stations1(index1));
    for index = 1:length(depth_bins)-1
        w3 = find(par.Depth >= depth_bins(index) & par.Depth < depth_bins(index+1));
        w4 = intersect(w2, w3);    
        data_antarctic_zone(index,1) = depth_bins(index);
        data_antarctic_zone(index,index1+1) = mean(par.tot_par_abundance(w4), 'omitnan');
        data_antarctic_zone_BV(index,1) = depth_bins(index);
        data_antarctic_zone_BV(index,index1+1) = mean(par.tot_par_biovolume(w4), 'omitnan');
    end
end

% Calculate mean, standard error, and degrees of freedom
n = length(stations1);
sampleMean_AZ = mean(data_antarctic_zone(:,2:end),2,'omitnan');
se = std(data_antarctic_zone(:,2:end),1,2,'omitnan') / sqrt(n);
dof = n - 1;

% 95% Confidence interval limits
ci95_AZ = sampleMean_AZ + se * tinv([0.025, 0.975], dof);
ci95_AZ(ci95_AZ < 0) = 0.1;

sampleMean_AZ_BV = mean(data_antarctic_zone_BV(:,2:end),2,'omitnan');
se = std(data_antarctic_zone_BV(:,2:end),1,2,'omitnan') / sqrt(n);
ci95_AZ_BV = sampleMean_AZ_BV + se * tinv([0.025, 0.975], dof);
ci95_AZ_BV(ci95_AZ_BV < 0) = 0.1;


%% make plot 
C = colororder("reef");

%fig1 = figure('Units', 'inches','Position', [0.4479 0.7396 7.29  3.975]); %0.4479 0.7396 7.5208  4.1
h = 1.62;%1.67; %2.6;
w = 1.454;%1.5;
ax1 = axes('Units', 'inches', 'Position', [0.6 0.5+h w h]);
fill([ci95_SR(1:21,1);flipud(ci95_SR(1:21,2))], [transpose(depth_bins(1:21)); flipud(transpose(depth_bins(1:21)))], C(1,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
hold on
fill([ci95_SZ(1:21,1);flipud(ci95_SZ(1:21,2))], [transpose(depth_bins(1:21)); flipud(transpose(depth_bins(1:21)))], C(2,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
fill([ci95_AZ(1:21,1);flipud(ci95_AZ(1:21,2))], [transpose(depth_bins(1:21)); flipud(transpose(depth_bins(1:21)))], C(3,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
plot(sampleMean_SR(1:21), transpose(depth_bins(1:21)),  "Color", C(1,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_SZ(1:21), transpose(depth_bins(1:21)),  "Color", C(2,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_AZ(1:21), transpose(depth_bins(1:21)),  "Color", C(3,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
text(6, 100, 'g', 'color', 'k', 'fontname', 'helvetica', 'fontsize', 20, 'fontweight', 'bold')
set(ax1,'fontname', 'helvetica', 'fontsize', 10, 'fontweight', 'bold', 'YDir', 'reverse')
%ylabel('Depth (m)')
%xlabel('Abundance (#/L)')
%title('                 Pacific Sector (~67^oS)', 'fontname', 'helvetica', 'fontsize', 14, 'fontweight', 'bold')
set(ax1, 'XScale', 'log');
xlim([5 335.6549])
ylim([0 1000])
ax1.TickDir = 'in';
ax1.XAxis.TickValues = [10 100];
ax1.XAxis.MinorTickValues = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100 200 300];
ax1.TickLength = [0.03 0.06];
ax1.XTickLabel = ["", ""];

ax3 = axes('Units', 'inches', 'Position', [0.6 0.5 w h]);
fill([ci95_SR(21:34,1);flipud(ci95_SR(21:34,2))], [transpose(depth_bins(21:34)); flipud(transpose(depth_bins(21:34)))], C(1,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
hold on
fill([ci95_SZ(21:35,1);flipud(ci95_SZ(21:35,2))], [transpose(depth_bins(21:35)); flipud(transpose(depth_bins(21:35)))], C(2,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
fill([ci95_AZ(21:34,1);flipud(ci95_AZ(21:34,2))], [transpose(depth_bins(21:34)); flipud(transpose(depth_bins(21:34)))], C(3,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
plot(sampleMean_SR(21:end), transpose(depth_bins(21:end-1)),  "Color", C(1,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_SZ(21:end), transpose(depth_bins(21:end-1)),  "Color", C(2,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_AZ(21:end), transpose(depth_bins(21:end-1)),  "Color", C(3,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
set(ax3,'fontname', 'helvetica', 'fontsize', 10, 'fontweight', 'bold', 'YDir', 'reverse')
ylabel('                                        Depth (m)')
xlabel('Abundance (#/L)')
%title('                 Pacific Sector (~67^oS)', 'fontname', 'helvetica', 'fontsize', 14, 'fontweight', 'bold')
set(ax3, 'XScale', 'log');
xlim([5 335.6549])
ylim([1000 6000])
text(20, 1500, "Subpolar Zone", 'fontname', 'helvetica','fontweight','bold','fontsize', 8, 'Color', C(1,:))
text(20, 2000, "Boundary Zone", 'fontname', 'helvetica','fontweight','bold','fontsize', 8, 'Color', C(2,:))
text(20, 2500, "Antarctic Zone", 'fontname', 'helvetica','fontweight','bold','fontsize', 8, 'Color', C(3,:))
text(20, 3000, "Polar Frontal Zone", 'fontname', 'helvetica','fontweight','bold','fontsize', 8, 'Color', C(4,:))
text(20, 3500, "Subtropical Zone", 'fontname', 'helvetica','fontweight','bold','fontsize', 8, 'Color', C(5,:))
ax3.XMinorTick = 'on';
ax3.TickDir = 'in';
ax3.XAxis.TickValues = [10 100];
ax3.XAxis.MinorTickValues = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100 200 300];
ax3.TickLength = [0.03 0.06];


ax2 = axes('Units', 'inches', 'Position', [0.6+w+0.1 0.5+h w h]);
fill([ci95_SR_BV(1:21,1);flipud(ci95_SR_BV(1:21,2))], [transpose(depth_bins(1:21)); flipud(transpose(depth_bins(1:21)))], C(1,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
hold on
fill([ci95_SZ_BV(1:21,1);flipud(ci95_SZ_BV(1:21,2))], [transpose(depth_bins(1:21)); flipud(transpose(depth_bins(1:21)))], C(2,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
fill([ci95_AZ_BV(1:21,1);flipud(ci95_AZ_BV(1:21,2))], [transpose(depth_bins(1:21)); flipud(transpose(depth_bins(1:21)))], C(3,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
plot(sampleMean_SR_BV(1:21), transpose(depth_bins(1:21)),  "Color", C(1,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_SZ_BV(1:21), transpose(depth_bins(1:21)),  "Color", C(2,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_AZ_BV(1:21), transpose(depth_bins(1:21)),  "Color", C(3,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
text(0.15, 100, 'h', 'color', 'k', 'fontname', 'helvetica', 'fontsize', 20, 'fontweight', 'bold')

set(ax2,'fontname', 'helvetica', 'fontsize', 10, 'fontweight', 'bold', 'YDir', 'reverse')
%xlabel('Biovolume (ppm)')
yticklabels({});
set(ax2, 'XScale', 'log');
xlim([0.1000 100.9365])
ylim([0 1000])
ax2.XMinorTick = 'on';
ax2.TickDir = 'in';
ax2.XAxis.TickValues = [0.1 1 10 100];
ax2.XAxis.MinorTickValues = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100];
ax2.TickLength = [0.03 0.06];
ax2.XTickLabel = ["", "", "", ""];


ax4 = axes('Units', 'inches', 'Position', [0.6+w+0.1 0.5 w h]);
fill([ci95_SR_BV(21:34,1);flipud(ci95_SR_BV(21:34,2))], [transpose(depth_bins(21:34)); flipud(transpose(depth_bins(21:34)))], C(1,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
hold on
fill([ci95_SZ_BV(21:35,1);flipud(ci95_SZ_BV(21:35,2))], [transpose(depth_bins(21:35)); flipud(transpose(depth_bins(21:35)))], C(2,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
fill([ci95_AZ_BV(21:34,1);flipud(ci95_AZ_BV(21:34,2))], [transpose(depth_bins(21:34)); flipud(transpose(depth_bins(21:34)))], C(3,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
plot(sampleMean_SR_BV(21:end), transpose(depth_bins(21:end-1)),  "Color", C(1,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_SZ_BV(21:end), transpose(depth_bins(21:end-1)),  "Color", C(2,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_AZ_BV(21:end), transpose(depth_bins(21:end-1)),  "Color", C(3,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
set(ax4,'fontname', 'helvetica', 'fontsize', 10, 'fontweight', 'bold', 'YDir', 'reverse')
xlabel('Biovolume (ppm)')
yticklabels({});
set(ax4, 'XScale', 'log');
xlim([0.1000 100.9365])
ylim([1000 6000])
ax4.XMinorTick = 'on';
ax4.TickDir = 'in';
ax4.XAxis.TickValues = [0.1 1 10 100];
ax4.XAxis.MinorTickValues = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100];
ax4.TickLength = [0.03 0.06];


%%
%clear all;
%load I06s MLD (calculated in I06s_CTD_plotting_contours_multiplot.m
load('C:/Users/steph/OneDrive/Documents/Cruises/2019_I06S/stn_lat_mld_pt.mat');
stn_lat_mld_pt= sortrows(stn_lat_mld_pt, 2);

load('C:\Users\steph\OneDrive\Documents\Cruises\2019_I06S\uvp5_sn207_2019_i06s_tcn322_ecotaxa_export_par2_AOU_fluor_flux_corr')
stations = unique(par.site);

% add frontal zone info
par.frontal_zone = {}; %create cell array within structure
w = find(par.latitude > -40.6662); %North of STF
par.frontal_zone(w,1) = {'Subtropical Zone'}; 
w = find(par.latitude > -49 & par.latitude <= -40.6662); %North of SAF
par.frontal_zone(w,1) = {'Subantarctic Zone'}; 
w = find(par.latitude > -53.5 & par.latitude <= -49); %North of PF
par.frontal_zone(w,1) = {'Polar Frontal Zone'}; 
w = find(par.latitude > -55.9998 & par.latitude <= -53.5); %North of SACCF
par.frontal_zone(w,1) = {'Antarctic Zone'}; 
w = find(par.latitude > -60.7523 & par.latitude <= -55.9998); %North of SBDY
par.frontal_zone(w,1) = {'Southern Zone'}; 
w = find(par.latitude <= -60.7523); %South of SBDY
par.frontal_zone(w,1) = {'Subpolar Region'};


w = find(strcmp(par.frontal_zone(:), {'Subpolar Region'}));
w2 = ismember(par.site, stations); %only stations on the transect line
w2 = find(w2);
w = intersect(w, w2);
stations1 = unique(par.site(w));

depth_bins = [2.5:50:1002.5 1502.5:250:6502.5];
data_subpolar_region = [];
data_subpolar_region_BV = [];

%make datafile
for index1 = 1:length(stations1)
    w2 = find(par.site == stations1(index1));
    for index = 1:length(depth_bins)-1
        w3 = find(par.Depth >= depth_bins(index) & par.Depth < depth_bins(index+1));
        w4 = intersect(w2, w3);    
        data_subpolar_region(index,1) = depth_bins(index);
        data_subpolar_region(index,index1+1) = mean(par.tot_par_abundance(w4), 'omitnan');
        data_subpolar_region_BV(index,1) = depth_bins(index);
        data_subpolar_region_BV(index,index1+1) = mean(par.tot_par_biovolume(w4), 'omitnan');
    end
end

% Calculate mean, standard error, and degrees of freedom
n = length(stations1);
sampleMean_SR = mean(data_subpolar_region(:,2:end),2,'omitnan');
se = std(data_subpolar_region(:,2:end),1,2,'omitnan') / sqrt(n);
dof = n - 1;

% 95% Confidence interval limits
ci95_SR = sampleMean_SR + se * tinv([0.025, 0.975], dof);
ci95_SR(ci95_SR < 0) = 0.1;

% Calculate mean, standard error, and degrees of freedom
sampleMean_SR_BV = mean(data_subpolar_region_BV(:,2:end),2,'omitnan');
se = std(data_subpolar_region_BV(:,2:end),1,2,'omitnan') / sqrt(n);
dof = n - 1;

% 95% Confidence interval limits
ci95_SR_BV = sampleMean_SR_BV + se * tinv([0.025, 0.975], dof);
ci95_SR_BV(ci95_SR_BV < 0) = 0.1;


w = find(strcmp(par.frontal_zone(:), {'Southern Zone'}));
w2 = ismember(par.site, stations); %only stations on the transect line
w2 = find(w2);
w = intersect(w, w2);
stations1 = unique(par.site(w));
data_southern_zone = [];
data_southern_zone_BV = [];
%make datafile
for index1 = 1:length(stations1)
    w2 = find(par.site == stations1(index1));
    for index = 1:length(depth_bins)-1
        w3 = find(par.Depth >= depth_bins(index) & par.Depth < depth_bins(index+1));
        w4 = intersect(w2, w3);    
        data_southern_zone(index,1) = depth_bins(index);
        data_southern_zone(index,index1+1) = mean(par.tot_par_abundance(w4), 'omitnan');
        data_southern_zone_BV(index,1) = depth_bins(index);
        data_southern_zone_BV(index,index1+1) = mean(par.tot_par_biovolume(w4), 'omitnan');
    end
end

% Calculate mean, standard error, and degrees of freedom
n = length(stations1);
sampleMean_SZ = mean(data_southern_zone(:,2:end),2,'omitnan');
se = std(data_southern_zone(:,2:end),1,2,'omitnan') / sqrt(n);
dof = n - 1;

% 95% Confidence interval limits
ci95_SZ = sampleMean_SZ + se * tinv([0.025, 0.975], dof);
ci95_SZ(ci95_SZ < 0) = 0.1;

% Calculate mean, standard error, and degrees of freedom
sampleMean_SZ_BV = mean(data_southern_zone_BV(:,2:end),2,'omitnan');
se = std(data_southern_zone_BV(:,2:end),1,2,'omitnan') / sqrt(n);
% 95% Confidence interval limits
ci95_SZ_BV = sampleMean_SZ_BV + se * tinv([0.025, 0.975], dof);
ci95_SZ_BV(ci95_SZ_BV < 0) = 0.1;


w = find(strcmp(par.frontal_zone(:), {'Antarctic Zone'}));
w2 = ismember(par.site, stations); %only stations on the transect line
w2 = find(w2);
w = intersect(w, w2);
stations1 = unique(par.site(w));
data_antarctic_zone = [];
data_antarctic_zone_BV = [];
%make datafile
for index1 = 1:length(stations1)
    w2 = find(par.site == stations1(index1));
    for index = 1:length(depth_bins)-1
        w3 = find(par.Depth >= depth_bins(index) & par.Depth < depth_bins(index+1));
        w4 = intersect(w2, w3);    
        data_antarctic_zone(index,1) = depth_bins(index);
        data_antarctic_zone(index,index1+1) = mean(par.tot_par_abundance(w4), 'omitnan');
        data_antarctic_zone_BV(index,1) = depth_bins(index);
        data_antarctic_zone_BV(index,index1+1) = mean(par.tot_par_biovolume(w4), 'omitnan');
    end
end

% Calculate mean, standard error, and degrees of freedom
n = length(stations1);
sampleMean_AZ = mean(data_antarctic_zone(:,2:end),2,'omitnan');
se = std(data_antarctic_zone(:,2:end),1,2,'omitnan') / sqrt(n);
dof = n - 1;

% 95% Confidence interval limits
ci95_AZ = sampleMean_AZ + se * tinv([0.025, 0.975], dof);
ci95_AZ(ci95_AZ < 0) = 0.1;

sampleMean_AZ_BV = mean(data_antarctic_zone_BV(:,2:end),2,'omitnan');
se = std(data_antarctic_zone_BV(:,2:end),1,2,'omitnan') / sqrt(n);
ci95_AZ_BV = sampleMean_AZ_BV + se * tinv([0.025, 0.975], dof);
ci95_AZ_BV(ci95_AZ_BV < 0) = 0.1;



w = find(strcmp(par.frontal_zone(:), {'Polar Frontal Zone'}));
w2 = ismember(par.site, stations); %only stations on the transect line
w2 = find(w2);
w = intersect(w, w2);
stations1 = unique(par.site(w));
data_polar_frontal_zone = [];
data_polar_frontal_zone_BV = [];
%make datafile
for index1 = 1:length(stations1)
    w2 = find(par.site == stations1(index1));
    for index = 1:length(depth_bins)-1
        w3 = find(par.Depth >= depth_bins(index) & par.Depth < depth_bins(index+1));
        w4 = intersect(w2, w3);    
        data_polar_frontal_zone(index,1) = depth_bins(index);
        data_polar_frontal_zone(index,index1+1) = mean(par.tot_par_abundance(w4), 'omitnan');
        data_polar_frontal_zone_BV(index,1) = depth_bins(index);
        data_polar_frontal_zone_BV(index,index1+1) = mean(par.tot_par_biovolume(w4), 'omitnan');
    end
end

% Calculate mean, standard error, and degrees of freedom
n = length(stations1);
sampleMean_PFZ = mean(data_polar_frontal_zone(:,2:end),2,'omitnan');
se = std(data_polar_frontal_zone(:,2:end),1,2,'omitnan') / sqrt(n);
dof = n - 1;

% 95% Confidence interval limits
ci95_PFZ = sampleMean_PFZ + se * tinv([0.025, 0.975], dof);
ci95_PFZ(ci95_PFZ < 0) = 0.1;

sampleMean_PFZ_BV = mean(data_polar_frontal_zone_BV(:,2:end),2,'omitnan');
se = std(data_polar_frontal_zone_BV(:,2:end),1,2,'omitnan') / sqrt(n);
ci95_PFZ_BV = sampleMean_PFZ_BV + se * tinv([0.025, 0.975], dof);
ci95_PFZ_BV(ci95_PFZ_BV < 0) = 0.1;



w = find(strcmp(par.frontal_zone(:), {'Subtropical Zone'}));
w2 = ismember(par.site, stations); %only stations on the transect line
w2 = find(w2);
w = intersect(w, w2);
stations1 = unique(par.site(w));
data_subtropical_zone = [];
data_subtropical_zone_BV = [];
%make datafile
for index1 = 1:length(stations1)
    w2 = find(par.site == stations1(index1));
    for index = 1:length(depth_bins)-1
        w3 = find(par.Depth >= depth_bins(index) & par.Depth < depth_bins(index+1));
        w4 = intersect(w2, w3);    
        data_subtropical_zone(index,1) = depth_bins(index);
        data_subtropical_zone(index,index1+1) = mean(par.tot_par_abundance(w4), 'omitnan');
        data_subtropical_zone_BV(index,1) = depth_bins(index);
        data_subtropical_zone_BV(index,index1+1) = mean(par.tot_par_biovolume(w4), 'omitnan');
    end
end

% Calculate mean, standard error, and degrees of freedom
n = length(stations1);
sampleMean_STZ = mean(data_subtropical_zone(:,2:end),2,'omitnan');
se = std(data_subtropical_zone(:,2:end),1,2,'omitnan') / sqrt(n);
dof = n - 1;

% 95% Confidence interval limits
ci95_STZ = sampleMean_STZ + se * tinv([0.025, 0.975], dof);
ci95_STZ(ci95_STZ < 0) = 0.1;

sampleMean_STZ_BV = mean(data_subtropical_zone_BV(:,2:end),2,'omitnan');
se = std(data_subtropical_zone_BV(:,2:end),1,2,'omitnan') / sqrt(n);
ci95_STZ_BV = sampleMean_STZ_BV + se * tinv([0.025, 0.975], dof);
ci95_STZ_BV(ci95_STZ_BV < 0) = 0.1;

%% line plots with abundance of different types of particle types in BZ for pacific sector and african sector
C = colororder("reef");
h = 1.62;%1.67; %2.6;
w = 1.454;%1.5;

ax1 = axes('Units', 'inches', 'Position', [0.6+(2*w)+0.7 0.5+h w h]);
fill([ci95_SR(1:21,1);flipud(ci95_SR(1:21,2))], [transpose(depth_bins(1:21)); flipud(transpose(depth_bins(1:21)))], C(1,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
hold on
fill([ci95_SZ(1:21,1);flipud(ci95_SZ(1:21,2))], [transpose(depth_bins(1:21)); flipud(transpose(depth_bins(1:21)))], C(2,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
fill([ci95_AZ(1:21,1);flipud(ci95_AZ(1:21,2))], [transpose(depth_bins(1:21)); flipud(transpose(depth_bins(1:21)))], C(3,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
fill([ci95_PFZ(1:21,1);flipud(ci95_PFZ(1:21,2))], [transpose(depth_bins(1:21)); flipud(transpose(depth_bins(1:21)))], C(4,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
fill([ci95_STZ(1:21,1);flipud(ci95_STZ(1:21,2))], [transpose(depth_bins(1:21)); flipud(transpose(depth_bins(1:21)))], C(5,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
plot(sampleMean_SR(1:21), transpose(depth_bins(1:21)),  "Color", C(1,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_SZ(1:21), transpose(depth_bins(1:21)),  "Color", C(2,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_AZ(1:21), transpose(depth_bins(1:21)),  "Color", C(3,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_PFZ(1:21), transpose(depth_bins(1:21)),  "Color", C(4,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_STZ(1:21), transpose(depth_bins(1:21)),  "Color", C(5,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
text(4, 100, 'i','color', 'k', 'fontname', 'helvetica', 'fontsize', 20, 'fontweight', 'bold')
set(ax1,'fontname', 'helvetica', 'fontsize', 10, 'fontweight', 'bold', 'YDir', 'reverse')
%ylabel('Depth (m)')
%xlabel('Abundance (#/L)')
%title('                 African Sector (~30^oE)', 'fontname', 'helvetica', 'fontsize', 14, 'fontweight', 'bold')
set(ax1, 'XScale', 'log');
xlim([3 458.8133])
ylim([0 1000])
ax1.XMinorTick = 'on';
ax1.TickDir = 'in';
ax1.XAxis.TickValues = [10 100];
ax1.XAxis.MinorTickValues = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100 200 300 400];
ax1.TickLength = [0.03 0.06];

ax3 = axes('Units', 'inches', 'Position', [0.6+(2*w)+0.7 0.5 w h]);
fill([ci95_SR(21:37,1);flipud(ci95_SR(21:37,2))], [transpose(depth_bins(21:37)); flipud(transpose(depth_bins(21:37)))], C(1,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
hold on
fill([ci95_SZ(21:38,1);flipud(ci95_SZ(21:38,2))], [transpose(depth_bins(21:38)); flipud(transpose(depth_bins(21:38)))], C(2,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
fill([ci95_AZ(21:38,1);flipud(ci95_AZ(21:38,2))], [transpose(depth_bins(21:38)); flipud(transpose(depth_bins(21:38)))], C(3,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
fill([ci95_PFZ(21:39,1);flipud(ci95_PFZ(21:39,2))], [transpose(depth_bins(21:39)); flipud(transpose(depth_bins(21:39)))], C(4,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
fill([ci95_STZ(21:34,1);flipud(ci95_STZ(21:34,2))], [transpose(depth_bins(21:34)); flipud(transpose(depth_bins(21:34)))], C(5,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
plot(sampleMean_SR(21:end), transpose(depth_bins(21:end-1)),  "Color", C(1,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_SZ(21:end), transpose(depth_bins(21:end-1)),  "Color", C(2,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_AZ(21:end), transpose(depth_bins(21:end-1)),  "Color", C(3,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_PFZ(21:end), transpose(depth_bins(21:end-1)),  "Color", C(4,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_STZ(21:end), transpose(depth_bins(21:end-1)),  "Color", C(5,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
set(ax3,'fontname', 'helvetica', 'fontsize', 10, 'fontweight', 'bold', 'YDir', 'reverse')
ylabel('                                        Depth (m)')
xlabel('Abundance (#/L)')
%title('                 African Sector (~30^oE)', 'fontname', 'helvetica', 'fontsize', 14, 'fontweight', 'bold')
set(ax3, 'XScale', 'log');
xlim([3 458.8133])
ylim([1000 6000])
ax3.XMinorTick = 'on';
ax3.TickDir = 'in';
ax3.XAxis.TickValues = [10 100];
ax3.XAxis.MinorTickValues = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100 200 300 400];
ax3.TickLength = [0.03 0.06];

ax2 = axes('Units', 'inches', 'Position', [0.6+(3*w)+0.8 0.5+h w h]);
fill([ci95_SR_BV(1:21,1);flipud(ci95_SR_BV(1:21,2))], [transpose(depth_bins(1:21)); flipud(transpose(depth_bins(1:21)))], C(1,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
hold on
fill([ci95_SZ_BV(1:21,1);flipud(ci95_SZ_BV(1:21,2))], [transpose(depth_bins(1:21)); flipud(transpose(depth_bins(1:21)))], C(2,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
fill([ci95_AZ_BV(1:21,1);flipud(ci95_AZ_BV(1:21,2))], [transpose(depth_bins(1:21)); flipud(transpose(depth_bins(1:21)))], C(3,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
fill([ci95_PFZ_BV(1:21,1);flipud(ci95_PFZ_BV(1:21,2))], [transpose(depth_bins(1:21)); flipud(transpose(depth_bins(1:21)))], C(4,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
fill([ci95_STZ_BV(1:21,1);flipud(ci95_STZ_BV(1:21,2))], [transpose(depth_bins(1:21)); flipud(transpose(depth_bins(1:21)))], C(5,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
plot(sampleMean_SR_BV(1:21), transpose(depth_bins(1:21)),  "Color", C(1,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_SZ_BV(1:21), transpose(depth_bins(1:21)),  "Color", C(2,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_AZ_BV(1:21), transpose(depth_bins(1:21)),  "Color", C(3,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_PFZ_BV(1:21), transpose(depth_bins(1:21)),  "Color", C(4,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_STZ_BV(1:21), transpose(depth_bins(1:21)),  "Color", C(5,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
text(0.07, 100, 'j', 'color', 'k', 'fontname', 'helvetica', 'fontsize', 20, 'fontweight', 'bold')
set(ax2,'fontname', 'helvetica', 'fontsize', 10, 'fontweight', 'bold', 'YDir', 'reverse')
%xlabel('Biovolume (ppm)')
yticklabels({});
set(ax2, 'XScale', 'log');
xlim([0.05 15])
ylim([0 1000])
ax2.XMinorTick = 'on';
ax2.TickDir = 'in';
ax2.XAxis.TickValues = [0.1 1 10 100];
ax2.XAxis.MinorTickValues = [0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100];
ax2.TickLength = [0.03 0.06];

ax4 = axes('Units', 'inches', 'Position', [0.6+(3*w)+0.8 0.5 w h]);
fill([ci95_SR_BV(21:37,1);flipud(ci95_SR_BV(21:37,2))], [transpose(depth_bins(21:37)); flipud(transpose(depth_bins(21:37)))], C(1,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
hold on
fill([ci95_SZ_BV(21:38,1);flipud(ci95_SZ_BV(21:38,2))], [transpose(depth_bins(21:38)); flipud(transpose(depth_bins(21:38)))], C(2,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
fill([ci95_AZ_BV(21:38,1);flipud(ci95_AZ_BV(21:38,2))], [transpose(depth_bins(21:38)); flipud(transpose(depth_bins(21:38)))], C(3,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
fill([ci95_PFZ_BV(21:39,1);flipud(ci95_PFZ_BV(21:39,2))], [transpose(depth_bins(21:39)); flipud(transpose(depth_bins(21:39)))], C(4,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
fill([ci95_STZ_BV(21:34,1);flipud(ci95_STZ_BV(21:34,2))], [transpose(depth_bins(21:34)); flipud(transpose(depth_bins(21:34)))], C(5,:), "FaceAlpha", 0.15, "EdgeColor", "none"); %, "DisplayName", "95% CI"
plot(sampleMean_SR_BV(21:end), transpose(depth_bins(21:end-1)),  "Color", C(1,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_SZ_BV(21:end), transpose(depth_bins(21:end-1)),  "Color", C(2,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_AZ_BV(21:end), transpose(depth_bins(21:end-1)),  "Color", C(3,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_PFZ_BV(21:end), transpose(depth_bins(21:end-1)),  "Color", C(4,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
plot(sampleMean_STZ_BV(21:end), transpose(depth_bins(21:end-1)),  "Color", C(5,:), "LineWidth", 1.5, "DisplayName", "Subpolar Region")
set(ax4,'fontname', 'helvetica', 'fontsize', 10, 'fontweight', 'bold', 'YDir', 'reverse')
xlabel('Biovolume (ppm)')
yticklabels({});
set(ax4, 'XScale', 'log', 'XMinorTick', 'on');
ax4.XMinorTick = 'on';
xlim([0.05 15])
ylim([1000 6000])
ax4.XMinorTick = 'on';
ax4.TickDir = 'in';
ax4.XAxis.TickValues = [0.1 1 10 100];
ax4.XAxis.MinorTickValues = [0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100];
ax4.TickLength = [0.03 0.06];


%print("C:/Users/steph/OneDrive/Documents/MS_Southern_Ocean/Figures/I06s_S04p_abundance_biovolume_mean_95CI", "-dpng","-r300");




exportgraphics(gcf,"C:/Users/steph/OneDrive/Documents/MS_Southern_Ocean/Figures/I06s_S04p_abd_biov_size_multiplot_line_plots.tif","Resolution",600);