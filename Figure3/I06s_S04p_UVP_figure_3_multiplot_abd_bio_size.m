%I06s and S04p abundance, biovolume and mean size plotting contours

clear all; close all;

addpath('G:\MATLAB\seawater_ver3_3.1')
addpath('G:\MATLAB\m_map'); addpath('G:\MATLAB\textborder');

%set parameters for S04p

load('G:\Cruises\2018_S04P\uvp5_sn207_2018_s04p_ecotaxa_export_par2_filtered_AOU_fluor_sitecorrect_flux_loncorr')

stations = load('G:\Cruises\2018_S04P\S04P_transect_main5.txt');

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
load('G:/Cruises/2018_S04P/stn_lon_mld_pt.mat')

categories = {'tot_par_abundance'; 'tot_par_biovolume'; 'meansize'}; 
color_bar_label = {'Abundance (#/L)'; 'Biovolume (ppm)'; 'Mean Size (mm)'};
sublet_s04p = {'a', 'c', 'e'}; 


%% Plot: make a multipaneled plot for S04p

fig2 = figure;
set(fig2, 'Units', 'inches', 'Position', [0.4417 0.6167 7.67-0.38 6.05+0.3])  %7.8 %%% Edit this to be for only 6 panels

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
        set(ax2, 'Units', 'inches', 'Position', [0.45 4.19 2.75 1.75]) %3.36 changed to 2.75 when I removed CB
    elseif index1 == 2
        set(ax2, 'Units', 'inches', 'Position', [0.45 2.44 2.75 1.75]); %[4.03 4.19 3.36 1.75]) %3.36 changed to 2.75 when I removed CB
    elseif index1 == 3
        set(ax2, 'Units', 'inches', 'Position', [0.45 0.5 2.75 1.94]); %[0.45 2.44 3.36 1.75]) %3.36 changed to 2.75 when I removed CB
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
    stations_CTD = load('G:\Cruises\2018_S04P\S04P_transect_main5_CTD.txt');
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
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 4.19 2.75 1.75]);
    elseif index1 == 2
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 2.44 2.75 1.75]); %[4.03 4.19 2.75 1.75]);
    elseif index1 == 3
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 0.5 2.75 1.94]);%[0.45 2.44 2.75 1.75]); 
    elseif index1 == 4
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 4.19 2.75 1.75]);%[4.03 2.44 2.75 1.75]);
    elseif index1 == 5
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 2.44 2.75 1.75]); %[0.45 0.5 2.75 1.94]);
    elseif index1 == 6
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 0.5 2.75 1.94]);
    end

    %labels on sigma
    [C,h] = contour(ax4, X1_CTD, Y1_CTD, var_data,cmap_bins, 'showtext','on','LabelSpacing', 300);
    h.LevelList=round(h.LevelList,2);  %rounds levels to 3rd decimal place
    clabel(C,h) 
    %no labels on sigma 2
    %[C,h] = contour(X1, Y1, var_data,cmap_bins);

    %add lines and text labeling fronts and zones
    line([wrapTo360(-131.252) wrapTo360(-131.252)], [0 max(par.Depth(w))],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
    line([wrapTo360(-104.0791) wrapTo360(-104.0791)], [0 max(par.Depth(w))],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
    line([wrapTo360(-78.4832) wrapTo360(-78.4832)], [0 max(par.Depth(w))],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
    
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
end


%% Plotting I06s panels
clear all;
load('G:\Cruises\2019_I06S\uvp5_sn207_2019_i06s_tcn322_ecotaxa_export_par2_AOU_fluor_flux_corr.mat')

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

%load I06s MLD (calculated in I06s_CTD_plotting_contours_multiplot.m
load('G:/Cruises/2019_I06S/stn_lat_mld_pt.mat');
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
        set(ax2, 'Units', 'inches', 'Position', [3.65 4.19 3.36 1.75]); %[0.45 4.19 3.36 1.75])
    elseif index1 == 2
        set(ax2, 'Units', 'inches', 'Position', [3.65 2.44 3.36 1.75]); %[0.45 2.44 3.36 1.75]); %[4.03 4.19 3.36 1.75])
    elseif index1 == 3
        set(ax2, 'Units', 'inches', 'Position', [3.65 0.5 3.36 1.94]); %[0.45 0.5 3.36 1.94]); %[0.45 2.44 3.36 1.75])
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
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [3.65 4.19 2.75 1.75]);
    elseif index1 == 2
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [3.65 2.44 2.75 1.75]); %[4.03 4.19 2.75 1.75]);
    elseif index1 == 3
        ax4 = axes(fig2, 'Units', 'inches', 'Position', [3.65 0.5 2.75 1.94]);%[0.45 2.44 2.75 1.75]); 
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
    text(ax4_top, temp4(1)-3, 150, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');%temp4(1)+2, 200
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
end

print('G:\MS_Southern_Ocean\Figures\I06s_S04p_abd_biov_size_multiplot','-dpng','-r300');