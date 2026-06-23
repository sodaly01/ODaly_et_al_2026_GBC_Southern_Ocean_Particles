%day/night anomolies for crustacea abundance
clear all; close all;

load('D:\G\Cruises\2018_S04P\uvp5_sn207_2018_s04p_ecotaxa_export_par2_filtered_AOU_fluor_sitecorrect_flux_loncorr')
load('D:\G\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_20Feb2025.mat')
stations = load('D:\G\Cruises\2018_S04P\S04P_transect_main5.txt');
%load S04P MLD (calculated in S04p_CTD_plotting_contours_multiplot.m
load('D:/G/Cruises/2018_S04P/stn_lon_mld_pt.mat')
addpath('D:/G/MATLAB/SunPosition/')
addpath('D:/G/MATLAB/SunPosition/util/')


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

%[azimuth,elevation] = sun_position(par.datetime, par.latitude, par.longitude);
[ sunrise, sunset ] = sunRiseSet( par.latitude,par.longitude,par.datetime); %,varargin UVP assumed 

par.datetime.TimeZone = 'UTC'; %add timezone 
isDay = par.datetime >= sunrise & par.datetime <= sunset;

%calculate weighted mean depth per cast 
wmd_cast = []; wmd_cast_1500 = [];
isDay_cast = []; frontal_zone = {};
for index = 1:length(stations)
    w4 = find(zoo.site == stations(index));
    wmd_cast(index) = sum(zoo.Arthro_crustacea_M_3(w4).*zoo.Depth(w4))./sum(zoo.Arthro_crustacea_M_3(w4));
    w5 = zoo.Depth < 1505; %biologically relevant depths < 1500
    w6 = intersect(w4, find(w5));
    wmd_cast_1500(index) = sum(zoo.Arthro_crustacea_M_3(w6).*zoo.Depth(w6))./sum(zoo.Arthro_crustacea_M_3(w6));
    isDay_cast(index) = isDay(w4(1));
    frontal_zone(index) = par.frontal_zone(w4(1));
end

w_spr = strcmp(frontal_zone,'Subpolar Region');
w_sz = strcmp(frontal_zone,'Southern Zone');
w_az = strcmp(frontal_zone,'Antarctic Zone');


%% box plot
fig1 = figure('Units', 'inches','Position', [0 2.5312 11.6667 3.1562]);
h = 2.1988; %2.2466;
w = 2.7;
ax1 = axes('Units', 'inches', 'Position', [0.5 0.6719-0.1403 w h+0.1403]);

boxplot([wmd_cast_1500(logical(isDay_cast'))'; wmd_cast_1500(logical(~isDay_cast'))'], ...
    [repmat({'Day (n=20)'},length(wmd_cast_1500(logical(isDay_cast'))),1);
     repmat({'Night (n=55)'}, length(wmd_cast_1500(logical(~isDay_cast'))),1)], ...
    'Notch',['off'], 'Symbol','o')

set(ax1,'fontname', 'helvetica', 'fontsize', 10, 'fontweight', 'bold')
ylabel('Weighted Mean Depth (m)')
title('                                                          Pacific Sector', 'fontname', 'helvetica', 'fontsize', 12, 'fontweight', 'bold')
set(ax1, 'YDir', 'reverse')
ylim([ 0    1060])
xtickangle(40)
text(0.6, 100, 'a', 'fontname', 'helvetica', 'fontsize', 14, 'fontweight', 'bold')
%test which are significant from each other
[p12,~] = ranksum(wmd_cast_1500(logical(isDay_cast'))',wmd_cast_1500(logical(~isDay_cast'))');
%p = 0.28, not significant

ax2 = axes('Units', 'inches', 'Position', [1.1*0.5+w 0.6719+0.05 w h-0.05]);

boxplot([wmd_cast_1500(logical(isDay_cast'& w_spr'))'; wmd_cast_1500(logical(~isDay_cast'& w_spr'))'; ...
    wmd_cast_1500(logical(isDay_cast'& w_sz'))'; wmd_cast_1500(logical(~isDay_cast'& w_sz'))'; ...
    wmd_cast_1500(logical(isDay_cast'& w_az'))'; wmd_cast_1500(logical(~isDay_cast'& w_az'))'], ...
    [repmat({'SPZ:D (n=12)'},length(wmd_cast_1500(logical(isDay_cast'& w_spr'))),1);
     repmat({'SPZ:N (n=30)'}, length(wmd_cast_1500(logical(~isDay_cast'& w_spr'))),1); ...
     repmat({'BZ:D (n=4)'},length(wmd_cast_1500(logical(isDay_cast'& w_sz'))),1);
     repmat({'BZ:N (n=15)'}, length(wmd_cast_1500(logical(~isDay_cast'& w_sz'))),1); ...
     repmat({'AZ:D (n=4)'},length(wmd_cast_1500(logical(isDay_cast'& w_az'))),1);
     repmat({'AZ:N (n=10)'}, length(wmd_cast_1500(logical(~isDay_cast'& w_az'))),1)], ...
    'Notch','off', 'Symbol','o')

set(ax2,'fontname', 'helvetica', 'fontsize', 10, 'fontweight', 'bold')
%ylabel('Weighted Mean Depth (m)')
%title('Pacific Sector', 'fontname', 'helvetica', 'fontsize', 14, 'fontweight', 'bold')
set(ax2, 'YDir', 'reverse')
ylim([ 0    1060])
yticklabels([]);
xtickangle(40)
text(0.6, 100, 'b', 'fontname', 'helvetica', 'fontsize', 14, 'fontweight', 'bold')

[p13,~] = ranksum(wmd_cast_1500(logical(isDay_cast'& w_spr'))',wmd_cast_1500(logical(~isDay_cast'& w_spr'))');
[p14,~] = ranksum(wmd_cast_1500(logical(isDay_cast'& w_sz'))',wmd_cast_1500(logical(~isDay_cast'& w_sz'))');
[p15,~] = ranksum(wmd_cast_1500(logical(isDay_cast'& w_az'))',wmd_cast_1500(logical(~isDay_cast'& w_az'))');
%none of these are significantly different

%% summary stats

% what is the wmd in day and night and all times of BZ in Pacific Sector
mean(wmd_cast_1500(w_sz)) %all: 606.7465
mean(wmd_cast_1500(w_sz&isDay_cast)) %day:  687.5031
mean(wmd_cast_1500(w_sz&~isDay_cast)) %night: 585.2113

%what were the dates sampled of BZ in Pacific Sector
w_sz_par = strcmp(par.frontal_zone,'Southern Zone');
unique((par.datetime(w_sz_par))) %April 22 - May 9, 2018


%%
clear all;
%load I06s MLD (calculated in I06s_CTD_plotting_contours_multiplot.m
load('D:/G/Cruises/2019_I06S/stn_lat_mld_pt.mat');
stn_lat_mld_pt= sortrows(stn_lat_mld_pt, 2);

load('D:\G\Cruises\2019_I06S\uvp5_sn207_2019_i06s_tcn322_ecotaxa_export_par2_AOU_fluor_flux_corr')
stations = unique(par.site);

load('D:\G\MS_Southern_Ocean\data\zoo_i06s_val_photo_no_fiber_5Sept2024_corr.mat')

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

%[azimuth,elevation] = sun_position(par.datetime, par.latitude, par.longitude);
[ sunrise, sunset ] = sunRiseSet( par.latitude,par.longitude,par.datetime); %,varargin UVP assumed 

par.datetime.TimeZone = 'UTC'; %add timezone 
isDay = par.datetime >= sunrise & par.datetime <= sunset;

%calculate weighted mean depth per cast 
wmd_cast = []; wmd_cast_1500 = [];
isDay_cast = []; frontal_zone = {};
for index = 1:length(stations)
    w4 = find(zoo.site == stations(index));
    wmd_cast(index) = sum(zoo.Arthro_crustacea_M_3(w4).*zoo.Depth(w4))./sum(zoo.Arthro_crustacea_M_3(w4));
    w5 = zoo.Depth < 1505; %biologically relevant depths < 1500
    w6 = intersect(w4, find(w5));
    wmd_cast_1500(index) = sum(zoo.Arthro_crustacea_M_3(w6).*zoo.Depth(w6))./sum(zoo.Arthro_crustacea_M_3(w6));
    isDay_cast(index) = isDay(w4(1));
    frontal_zone(index) = par.frontal_zone(w4(1));
end

w_spr = strcmp(frontal_zone,'Subpolar Region');
w_sz = strcmp(frontal_zone,'Southern Zone');
w_az = strcmp(frontal_zone,'Antarctic Zone');
w_pfz = strcmp(frontal_zone,'Polar Frontal Zone');
w_stz = strcmp(frontal_zone,'Subtropical Zone');



%% add to plot
h = 2.1988; %2.2466;
w = 2.7;
ax1 = axes('Units', 'inches', 'Position', [1.5*0.5+2*w 0.6719-0.1403 w h+0.1403]); 

boxplot([wmd_cast_1500(logical(isDay_cast'))'; wmd_cast_1500(logical(~isDay_cast'))'], ...
    [repmat({'Day (n=14)'},length(wmd_cast_1500(logical(isDay_cast'))),1);
     repmat({'Night (n=28)'}, length(wmd_cast_1500(logical(~isDay_cast'))),1)], ...
    'Notch','off', 'Symbol','o')

set(ax1,'fontname', 'helvetica', 'fontsize', 10, 'fontweight', 'bold')
%ylabel('Weighted Mean Depth (m)')
title('                                                          African Sector', 'fontname', 'helvetica', 'fontsize', 12, 'fontweight', 'bold')
set(ax1, 'YDir', 'reverse')
ylim([ 0    1060])
xtickangle(40)
yticklabels([])
text(0.6, 100, 'c', 'fontname', 'helvetica', 'fontsize', 14, 'fontweight', 'bold')


%test which are significant from each other
[p12,~] = ranksum(wmd_cast_1500(logical(isDay_cast'))',wmd_cast_1500(logical(~isDay_cast'))');
%p = 0.86, not significant

ax2 = axes('Units', 'inches', 'Position', [1.6*0.5+3*w 0.6719 w h]); 

boxplot([wmd_cast_1500(logical(isDay_cast'& w_spr'))'; wmd_cast_1500(logical(~isDay_cast'& w_spr'))'; ...
    wmd_cast_1500(logical(isDay_cast'& w_sz'))'; wmd_cast_1500(logical(~isDay_cast'& w_sz'))'; ...
    wmd_cast_1500(logical(isDay_cast'& w_az'))'; wmd_cast_1500(logical(~isDay_cast'& w_az'))'; ...
    wmd_cast_1500(logical(isDay_cast'& w_pfz'))'; wmd_cast_1500(logical(~isDay_cast'& w_pfz'))'; ...
    wmd_cast_1500(logical(isDay_cast'& w_stz'))'; wmd_cast_1500(logical(~isDay_cast'& w_stz'))'], ...
    [repmat({'SPZ:D (n=6)'},length(wmd_cast_1500(logical(isDay_cast'& w_spr'))),1);
     repmat({'SPZ:N (n=10)'}, length(wmd_cast_1500(logical(~isDay_cast'& w_spr'))),1); ...
     repmat({'BZ:D (n=2)'},length(wmd_cast_1500(logical(isDay_cast'& w_sz'))),1);
     repmat({'BZ:N (n=7)'}, length(wmd_cast_1500(logical(~isDay_cast'& w_sz'))),1); ...
     repmat({'AZ:D (n=2)'},length(wmd_cast_1500(logical(isDay_cast'& w_az'))),1);
     repmat({'AZ:N (n=0)'}, length(wmd_cast_1500(logical(~isDay_cast'& w_az'))),1); ...
     repmat({'PFZ:D (n=1)'},length(wmd_cast_1500(logical(isDay_cast'& w_pfz'))),1);
     repmat({'PFZ:N (n=4)'}, length(wmd_cast_1500(logical(~isDay_cast'& w_pfz'))),1); ...
     repmat({'STZ:D (n=3)'},length(wmd_cast_1500(logical(isDay_cast'& w_stz'))),1);
     repmat({'STZ:N (n=7)'}, length(wmd_cast_1500(logical(~isDay_cast'& w_stz'))),1)], ...
    'Notch','off', 'Symbol','o')

set(ax2,'fontname', 'helvetica', 'fontsize', 10, 'fontweight', 'bold')
%ylabel('Weighted Mean Depth (m)')
%title('African Sector', 'fontname', 'helvetica', 'fontsize', 14, 'fontweight', 'bold')
set(ax2, 'YDir', 'reverse')
ylim([ 0    1060])
yticklabels([])
text(0.6, 100, 'd', 'fontname', 'helvetica', 'fontsize', 14, 'fontweight', 'bold')

[p13,~] = ranksum(wmd_cast_1500(logical(isDay_cast'& w_spr'))',wmd_cast_1500(logical(~isDay_cast'& w_spr'))');
[p14,~] = ranksum(wmd_cast_1500(logical(isDay_cast'& w_sz'))',wmd_cast_1500(logical(~isDay_cast'& w_sz'))');
%[p15,~] = ranksum(wmd_cast_1500(logical(isDay_cast'& w_az'))',wmd_cast_1500(logical(~isDay_cast'& w_az'))');
[p17,~] = ranksum(wmd_cast_1500(logical(isDay_cast'& w_pfz'))',wmd_cast_1500(logical(~isDay_cast'& w_pfz'))');
[p18,~] = ranksum(wmd_cast_1500(logical(isDay_cast'& w_stz'))',wmd_cast_1500(logical(~isDay_cast'& w_stz'))');

%none of these are significantly different

print("D:/G/MS_Southern_Ocean/Figures/I06s_S04p_boxplot_day_night_crustaceans", "-dpng","-r300");

%% summary stats

% what is the wmdin day and night of BZ in African Sector
mean(wmd_cast_1500(w_sz)) %all:679.9217 vs Pacific: 606.7465
mean(wmd_cast_1500(w_sz&isDay_cast)) %day:653.3639 n = 2, vs Pacific:  687.5031 n = 4
mean(wmd_cast_1500(w_sz&~isDay_cast)) %night:687.5097 n = 7 vs Pacific: 585.2113 n = 15

%what were the dates sampled of BZ in African Sector
w_sz_par = strcmp(par.frontal_zone,'Southern Zone');
unique((par.datetime(w_sz_par))) %April 21 - 24, 2019 versus April 22 - May 9, 2018