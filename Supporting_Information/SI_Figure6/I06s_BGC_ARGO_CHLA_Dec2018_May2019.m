%Plotting BGC ARGO Chlorophyll a from these parameters
%20 E - 40 E and 30 S - 72 S from December 1 2018 - May 8, 2019
%Notes from Nina: 
%one called 'chla' and one called "chla_corr". You can consider the former as fluorescence, 
% the data has been QC'ed for spikes, NPQ, etc. but hasn't been multiplied by a 
% fluorescence:chlorophyll slope factor. The data in the 'chla_corr' field HAS
%  been multiplied by a per-profile based slope factor (my fancy correction that 
% uses MODIS satellite data matched within a statistically sound distance)

%Set directories
addpath('G:\MATLAB\m_map');

%Load BGC ARGO data
% 
% filename = 'G:/Cruises/2019_I06S/ARGO_Chla/2902178_steffi.nc';
% filename = 'G:/Cruises/2019_I06S/ARGO_Chla/5904469_steffi.nc';
% filename = 'G:/Cruises/2019_I06S/ARGO_Chla/5904659_steffi.nc';
% filename = 'G:/Cruises/2019_I06S/ARGO_Chla/5906007_steffi.nc';
% filename = 'G:/Cruises/2019_I06S/ARGO_Chla/5906030_steffi.nc';
% 
% ncdisp(filename); %view discription of data
% bgc.pressure = ncread(filename,'pressure'); 
% bgc.date = ncread(filename,'date'); 
% bgc.bbp700 = ncread(filename,'bbp700'); 
% bgc.chla = ncread(filename,'chla'); 
% bgc.chla_corr = ncread(filename,'chla_corr'); 
% bgc.lat = ncread(filename,'lat'); 
% bgc.lon = ncread(filename,'lon'); 
% bgc.par = ncread(filename,'par'); 
% bgc.profile = ncread(filename,'profile'); 
% bgc.temp = ncread(filename,'temp'); 
% 
% 
% 
% %find profiles that fit within lat/long and time restrictions
% w=find(bgc.lon>= 20 & bgc.lon<= 40);
% start_date = days(datetime(2018,12,01, 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y'));
% end_date = days(datetime(2019,05,08, 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y'));
% w2 = find(bgc.date(w)>= start_date & bgc.date(w)<= end_date);
% %there are 7 profiles from 2902178_steffi float that fits my parameters: [37:1: 42]
% %there are 16 profiles from 5904469_steffi float that fits my parameters: [142:1:157]
% %there are 14 profiles from 5904659_steffi float that fits my parameters: [104:1:117]
% %there are 4 profiles from 5906007_steffi float that fits my parameters: [1:1:4]
% %there are 2 profiles from 5906030_steffi float that fits my parameters: [1 2]
% 
% %explore data a little 
% TT = datetime(1970,01,01, 'Format','d-MMM-y') + days(bgc.date(:)); % character vector
% figure
% scatter(bgc.lon,bgc.lat,10,bgc.date,'filled')
% cb = colorbar;
% hold on
% rectangle('Position',[20 -72 20 42]);
% scatter(bgc.lon(w(w2)), bgc.lat(w(w2)), 15,'r')
% 
% datetime(1970,01,01, 'Format','d-MMM-y') + days(19500)
% 
% cb.TickLabels = [{'6-Mar-2015'};{'18-Jul-2016'};{'30-Nov-2017'};{'14-Apr-2019'};...
%     {'14-Apr-2019'};{'8-Jan-2022'};{'23-May-2023'}];
% xlabel('Longitude')
% ylabel('Latitude')
% print('G:/Cruises/2019_I06S/ARGO_Chla/I06s_BGC_5_floats_lat_lon_date', '-r300', '-dpng')


filename = ['G:/Cruises/2019_I06S/ARGO_Chla/2902178_steffi.nc';...
    'G:/Cruises/2019_I06S/ARGO_Chla/5904469_steffi.nc'; ...
    'G:/Cruises/2019_I06S/ARGO_Chla/5904659_steffi.nc';...
    'G:/Cruises/2019_I06S/ARGO_Chla/5906007_steffi.nc';...
    'G:/Cruises/2019_I06S/ARGO_Chla/5906030_steffi.nc'];
for in  = 1:height(filename)
    ncdisp(filename(in,:)); %view discription of data
    bgc.pressure = ncread(filename(in,:),'pressure'); 
    bgc.date = ncread(filename(in,:),'date'); 
    bgc.bbp700 = ncread(filename(in,:),'bbp700'); 
    bgc.chla = ncread(filename(in,:),'chla'); 
    bgc.chla_corr = ncread(filename(in,:),'chla_corr'); 
    bgc.lat = ncread(filename(in,:),'lat'); 
    bgc.lon = ncread(filename(in,:),'lon'); 
    bgc.par = ncread(filename(in,:),'par'); 
    bgc.profile = ncread(filename(in,:),'profile'); 
    bgc.temp = ncread(filename(in,:),'temp'); 
    %find profiles that fit within lat/long and time restrictions
    w=find(bgc.lon>= 20 & bgc.lon<= 40);
    start_date = days(datetime(2018,12,01, 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y'));
    end_date = days(datetime(2019,05,08, 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y'));
    w2 = find(bgc.date(w)>= start_date & bgc.date(w)<= end_date);
    if in == 1
        figure
        scatter(bgc.lon,bgc.lat,10,bgc.date,'filled')
        cb = colorbar;
        hold on
        rectangle('Position',[20 -72 20 42]);
        scatter(bgc.lon(w(w2)), bgc.lat(w(w2)), 15,'r')
        xlabel('Longitude')
        ylabel('Latitude')
    else
        scatter(bgc.lon,bgc.lat,10,bgc.date,'filled')
        scatter(bgc.lon(w(w2)), bgc.lat(w(w2)), 15,'r')
    end
end

cb.TickLabels = [{char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(16500))};...
    {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17000))};...
    {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17500))};...
    {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(18000))};...
    {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(18500))};...
    {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(19000))};...
    {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(19500))}];
print('G:/Cruises/2019_I06S/ARGO_Chla/I06s_BGC_5_floats_lat_lon_date', '-r300', '-dpng')

%there are 7 profiles from 2902178_steffi float that fits my parameters: [37:1:42]
%there are 16 profiles from 5904469_steffi float that fits my parameters: [142:1:157]
%there are 14 profiles from 5904659_steffi float that fits my parameters: [104:1:117]
%there are 4 profiles from 5906007_steffi float that fits my parameters: [1:1:4]
%there are 2 profiles from 5906030_steffi float that fits my parameters: [1 2]
%43 profiles!
%%

%plot just these profiles
colors = [0 1 1; 0.7 0 1; 1 0 1; 1 0 0; 1 0.7 0];
for in  = 1:height(filename)
    ncdisp(filename(in,:)); %view discription of data
    bgc.pressure = ncread(filename(in,:),'pressure'); 
    bgc.date = ncread(filename(in,:),'date'); 
    bgc.bbp700 = ncread(filename(in,:),'bbp700'); 
    bgc.chla = ncread(filename(in,:),'chla'); 
    bgc.chla_corr = ncread(filename(in,:),'chla_corr'); 
    bgc.lat = ncread(filename(in,:),'lat'); 
    bgc.lon = ncread(filename(in,:),'lon'); 
    bgc.par = ncread(filename(in,:),'par'); 
    bgc.profile = ncread(filename(in,:),'profile'); 
    bgc.temp = ncread(filename(in,:),'temp'); 
    %find profiles that fit within lat/long and time restrictions
    w=find(bgc.lon>= 20 & bgc.lon<= 40);
    start_date = days(datetime(2018,12,01, 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y'));
    end_date = days(datetime(2019,05,08, 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y'));
    w2 = find(bgc.date(w)>= start_date & bgc.date(w)<= end_date);
    if in == 1
        figure
        scatter(bgc.lon(w(w2)), bgc.lat(w(w2)), 50,bgc.date(w(w2)),'filled', 'MarkerEdgeColor', colors(in,:),'LineWidth',1.5)
        cb = colorbar;
        hold on
        xlabel('Longitude')
        ylabel('Latitude')
        xlim([20 40]);
        ylim([-72 -30]);
    else
        scatter(bgc.lon(w(w2)), bgc.lat(w(w2)), 50,bgc.date(w(w2)),'filled', 'MarkerEdgeColor', colors(in,:),'LineWidth',1.5)
    end
end

cb.TickLabels = [{char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17880))};...
    {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17900))};...
    {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17920))};...
    {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17940))};...
    {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17960))};...
    {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17980))};...
    {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(18000))};...
    {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(18020))}];
print('G:/Cruises/2019_I06S/ARGO_Chla/I06s_BGC_5_floats_lat_lon_date_only_hits', '-r300', '-dpng')

%I think float 1 and 5 are not in the right date/lat/lon range

%%
%plot locations on top of my map figure with my stations
%load ORSI fronts data
load('G:\MATLAB\PF_circle.mat')
load('G:\MATLAB\SACCF_circle.mat')
load('G:\MATLAB\SAF_circle.mat')
load('G:\MATLAB\SBDY_circle.mat')
load('G:\MATLAB\STF_circle')

par_i06s = load('G:\Cruises\2019_I06S\uvp5_sn207_2019_i06s_tcn322_ecotaxa_export_par.mat');
station = unique(par_i06s.par.profile);
i06s = [];
for in = 1:length(station)
    w1 = strcmp(par_i06s.par.profile,station(in));
    w2 = find(w1 == 1);
    i06s(in,1) = par_i06s.par.site(w2(1));
    i06s(in,2) = par_i06s.par.latitude(w2(1));
    i06s(in,3) = par_i06s.par.longitude(w2(1));
end

% %load monthly average chla data
% ncdisp('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181201_20181231.L3m.MO.CHL.chlor_a.4km.nc'); %view discription of data
% chla.chlor_a = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181201_20181231.L3m.MO.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.lat = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181201_20181231.L3m.MO.CHL.chlor_a.4km.nc', 'lat');
% chla.lon = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181201_20181231.L3m.MO.CHL.chlor_a.4km.nc', 'lon');
% chla.time = datenum(2018, 12, 01) - datenum(1950,01,01);
% chla.chlor_a(:,:,2) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190101_20190131.L3m.MO.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(2,1) = datenum(2019, 01, 01) - datenum(1950,01,01);
% chla.chlor_a(:,:,3) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190201_20190228.L3m.MO.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(3,1) = datenum(2019, 02, 01) - datenum(1950,01,01);
% chla.chlor_a(:,:,4) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190301_20190331.L3m.MO.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(4,1) = datenum(2019, 03, 01) - datenum(1950,01,01);
% chla.chlor_a(:,:,5) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190401_20190430.L3m.MO.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(5,1) = datenum(2019, 04, 01) - datenum(1950,01,01);
% chla.chlor_a(:,:,6) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190501_20190531.L3m.MO.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(6,1) = datenum(2019, 05, 01) - datenum(1950,01,01);

% Load 8-day average chla data
ncdisp('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181203_20181210.L3m.8D.CHL.chlor_a.4km.nc'); %view discription of data
chla.chlor_a = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181203_20181210.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.lat = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181203_20181210.L3m.8D.CHL.chlor_a.4km.nc', 'lat');
chla.lon = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181203_20181210.L3m.8D.CHL.chlor_a.4km.nc', 'lon');
chla.time = datenum(2018, 12, 06) - datenum(1950,01,01);
chla.chlor_a(:,:,2) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181211_20181218.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(2,1) = datenum(2019, 12, 14) - datenum(1950,01,01);
chla.chlor_a(:,:,3) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181219_20181226.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(3,1) = datenum(2019, 12, 22) - datenum(1950,01,01);
chla.chlor_a(:,:,4) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181227_20181231.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(4,1) = datenum(2019, 12, 29) - datenum(1950,01,01);
chla.chlor_a(:,:,5) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190101_20190108.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(5,1) = datenum(2019, 01, 04) - datenum(1950,01,01);
chla.chlor_a(:,:,6) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190109_20190116.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(6,1) = datenum(2019, 01, 12) - datenum(1950,01,01);
chla.chlor_a(:,:,7) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190117_20190124.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(7,1) = datenum(2019, 01, 20) - datenum(1950,01,01);
chla.chlor_a(:,:,8) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190125_20190201.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(8,1) = datenum(2019, 01, 28) - datenum(1950,01,01);
chla.chlor_a(:,:,9) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190202_20190209.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(9,1) = datenum(2019, 02, 05) - datenum(1950,01,01);
chla.chlor_a(:,:,10) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190210_20190217.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(10,1) = datenum(2019, 02, 13) - datenum(1950,01,01);
chla.chlor_a(:,:,11) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190218_20190225.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(11,1) = datenum(2019, 02, 21) - datenum(1950,01,01);
chla.chlor_a(:,:,12) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190226_20190305.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(12,1) = datenum(2019, 03, 01) - datenum(1950,01,01);
chla.chlor_a(:,:,13) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190306_20190313.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(13,1) = datenum(2019, 03, 09) - datenum(1950,01,01);
chla.chlor_a(:,:,14) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190314_20190321.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(14,1) = datenum(2019, 03, 17) - datenum(1950,01,01);
chla.chlor_a(:,:,15) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190322_20190329.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(15,1) = datenum(2019, 03, 25) - datenum(1950,01,01);
chla.chlor_a(:,:,16) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190330_20190406.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(16,1) = datenum(2019, 04, 02) - datenum(1950,01,01);
chla.chlor_a(:,:,17) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190407_20190414.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(17,1) = datenum(2019, 04, 10) - datenum(1950,01,01);
chla.chlor_a(:,:,18) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190415_20190422.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(18,1) = datenum(2019, 04, 18) - datenum(1950,01,01);
chla.chlor_a(:,:,19) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190423_20190430.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(19,1) = datenum(2019, 04, 26) - datenum(1950,01,01);
chla.chlor_a(:,:,20) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190501_20190508.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(20,1) = datenum(2019, 05, 04) - datenum(1950,01,01);
chla.chlor_a(:,:,21) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190509_20190516.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(21,1) = datenum(2019, 05, 12) - datenum(1950,01,01);

%subsample data for I06s
minLAT = -72; maxLAT = -30;
minLON = wrapTo360(20); maxLON = wrapTo360(40);
w = find(chla.lat>= minLAT & chla.lat<= maxLAT);
w2 = find(chla.lon>= minLON & wrapTo360(chla.lon)<= maxLON);
chla_sub.lat = chla.lat(w);
chla_sub.lon = chla.lon(w2);
chla_sub.chlor_a = chla.chlor_a(w2,w,:);
chla_sub.time = chla.time;

filename = ['G:/Cruises/2019_I06S/ARGO_Chla/2902178_steffi.nc';...
    'G:/Cruises/2019_I06S/ARGO_Chla/5904469_steffi.nc'; ...
    'G:/Cruises/2019_I06S/ARGO_Chla/5904659_steffi.nc';...
    'G:/Cruises/2019_I06S/ARGO_Chla/5906007_steffi.nc';...
    'G:/Cruises/2019_I06S/ARGO_Chla/5906030_steffi.nc'];
color = [0 1 1; 0.7 0 1; 1 0 1; 1 0 0; 1 0.7 0];
%year = [2018 2019 2019 2019 2019 2019];
%month = [12 01 02 03 04 05];

year_8_start = [2018 2018 2018 2018 2019 2019 2019 2019 2019 2019 2019 2019 2019 2019 2019 2019 2019 2019 2019 2019 2019];
month_8_start = [12 12 12 12 01 01 01 01 02 02 02 02 03 03 03 03 04 04 04 05 05];
day_8_start = [03 11 19 27 01 09 17 25 02 10 18 26 06 14 22 30 07 15 23 01 09];

year_8_stop = [2018 2018 2018 2018 2019 2019 2019 2019 2019 2019 2019 2019 2019 2019 2019 2019 2019 2019 2019 2019 2019];
month_8_stop = [12 12 12 12 01 01 01 02 02 02 02 03 03 03 03 04 04 04 04 05 05];
day_8_stop = [10 18 26 31 08 16 24 01 09 17 25 05 13 21 29 06 14 22 30 08 16];


%% Plot

for index = 1%:length(chla.time)
    minLAT = -72; maxLAT = -30;
    minLON = wrapTo360(20); maxLON = wrapTo360(40);
    [PLT, PLG] = meshgrid(chla_sub.lat-0.25, chla_sub.lon-0.25); 

    fig1 = figure;
    fig1.Position = [1086 108 284 660]; %[1215 297 250 466];
    ax1 = axes; ax1.Position = [0.15 0.1100 0.7 0.8150]; %[0.1010 0.1100 0.6019 0.8150]; 
    m_proj('mercator','long',[minLON maxLON],'lat',[minLAT maxLAT]);
    hold on
    %add CHLA contour
    h_pcol = m_pcolor(PLG,PLT,chla_sub.chlor_a(:,:,index)); colormap(parula); shading flat;
    Levls = [min(min(min(chla_sub.chlor_a(:,:,index)))) 0.1 0.25 0.5 0.75 1 2.5 5 7.5 10];
    N_colorbins = length(Levls);
    c = parula(N_colorbins);
    colormap(c)
    C = chla_sub.chlor_a(:,:,index);
    cdt=get(h_pcol,'CData');
    Lold=Levls;
    clm=caxis;
    L1=((1:length(Levls))*(diff(caxis)/(length(Levls)+1)))+min(caxis());
    Levls=[Levls Inf];
    for k=1:length(Levls)-1,
          cdt(C>=Levls(k)&C<Levls(k+1))=L1(k);
    end 
    set(h_pcol,'CData',cdt);
    caxis(clm);

    %add ORSI Fronts
    colors = copper(5);
    m_line(STF(:,1), STF(:,2),'color',colors(1,:),'linewi',1);
    t5 = m_text(21,-42,{'STF'},'Fontname','helvetica','fontweight','bold','color', colors(1,:),'fontsize',12);
    m_line(SAF(1:end-1,1), SAF(1:end-1,2),'color',colors(2,:),'linewi',1);
    t3 = m_text(21,-46,{'SAF'},'Fontname','helvetica','fontweight','bold','color', colors(2,:),'fontsize',12);
    m_line(PF(1:end-1,2), PF(1:end-1,1),'color',colors(3,:),'linewi',1);
    t1 = m_text(21,-50.5,{'PF'},'Fontname','helvetica','fontweight','bold','color', colors(3,:),'fontsize',12);
    m_line(SACCF(560:622,1), SACCF(560:622,2),'color',colors(4,:),'linewi',1);
    t2 = m_text(21,-53,{'SACCF'},'Fontname','helvetica','fontweight','bold','color', colors(4,:),'fontsize',10);
    m_line(SBDY(1:end-1,1), SBDY(1:end-1,2),'color',colors(5,:),'linewi',1);
    t4 = m_text(21,-58.5,{'SBDY'},'Fontname','helvetica','fontweight','bold','color', colors(5,:),'fontsize',12);

    m_gshhs_h('patch',[0.7 0.7 0.7],'linestyle','none');
    m_grid('xtick',[minLON:20:maxLON],'ytick',[minLAT:5:maxLAT],'box','fancy');
    set(findobj('tag','m_grid_color'),'facecolor','none')
    set(gcf,'color','w');
    axis(ax1,'off')

    m_text(22,-71,'Antarctica','Fontname','helvetica','fontweight','bold','fontsize',12)
    m_text(21,-32,'South Africa','Fontname','helvetica','fontweight','bold', 'fontsize',10)
    m_plot(i06s(:,3),i06s(:,2),'o','MarkerFaceColor','none','MarkerSize',3,'clipping','on', 'MarkerEdgeColor', 'r');

    %add date
    TT = datetime(1950,01,01, 'Format','d-MMM-y') + days(chla_sub.time(index)); % character vector
    %TT = datetime(1950,01,01, 'Format','MMM y') + days(chla_sub.time(index)); % character vector
    m_text(21,-69, char(TT),'Fontname','helvetica','fontsize',10, 'color', 'r')

    %add ARGO locations from this date range
    for in  = 1:height(filename)
        ncdisp(filename(in,:)); %view discription of data
        bgc.pressure = ncread(filename(in,:),'pressure'); 
        bgc.date = ncread(filename(in,:),'date'); 
        bgc.bbp700 = ncread(filename(in,:),'bbp700'); 
        bgc.chla = ncread(filename(in,:),'chla'); 
        bgc.chla_corr = ncread(filename(in,:),'chla_corr'); 
        bgc.lat = ncread(filename(in,:),'lat'); 
        bgc.lon = ncread(filename(in,:),'lon'); 
        bgc.par = ncread(filename(in,:),'par'); 
        bgc.profile = ncread(filename(in,:),'profile'); 
        bgc.temp = ncread(filename(in,:),'temp'); 
        %find profiles that fit within lat/long and time restrictions
        w=find(bgc.lon>= 20 & bgc.lon<= 40);
        %start_date = days(datetime(year(index),month(index),01, 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y')); %month
        %end_date = days(datetime(year(index),month(index),31, 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y')); %month
        start_date = days(datetime(year_8_start(index),month_8_start(index),day_8_start(index), 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y')); %8 day
        end_date = days(datetime(year_8_stop(index),month_8_stop(index),day_8_stop(index), 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y')); %8 day

        w2 = find(bgc.date(w)>= start_date & bgc.date(w)<= end_date);
        
        m_scatter(bgc.lon(w(w2)), bgc.lat(w(w2)), 30, 'filled', 'MarkerFaceColor',color(in,:),'LineWidth',1.5)
    end

    % set colorbar
    colmp = colormap(ax1); %,m_colmap('diverging',100)); 
    cb = colorbar; cb.Location = 'eastoutside';%set(ax1,'ColorScale','log');
    scale = (cb.Limits(2)-cb.Limits(1))/10;
    cb.YTick = [cb.Limits(1) cb.Limits(1)+scale cb.Limits(1)+2*scale cb.Limits(1)+3*scale ...
    cb.Limits(1)+4*scale cb.Limits(1)+5*scale cb.Limits(1)+6*scale cb.Limits(1)+7*scale ...
    cb.Limits(1)+8*scale cb.Limits(1)+9*scale cb.Limits(2)]; 
    set(cb,'yticklabel',{'', '0.1', '0.25','0.5', '0.75', '1', '2.5', '5', '7.5', '10', ''});

    %caxis([min(min(min(chla_sub.chlor_a(:,:,:)))) max(max(max(chla_sub.chlor_a(:,:,:))))]);
    cb.Label.String = 'Chla [\mug/l]';
    cb.FontName = 'helvetica';cb.FontSize = 10; %cb.FontWeight = 'bold'
    %cb.TickLabels = {'0.01', '0.1', '1', '10'}; %fix this if there is a different colorbar for other slides
    %caxis(cblimits);      
    %labels = -str2num(char(cb.TickLabels));
    %cb.TickLabels = num2str(labels);
    %set(gcf, 'InvertHardCopy', 'off');

    %save fig
    formatSpec = 'print("G:/Cruises/2019_I06S/ARGO_Chla/I06s_modis_bgc_CHLA_day%u", "-dpng","-r300");';
    %formatSpec = 'print("G:/Cruises/2019_I06S/ARGO_Chla/I06s_modis_bgc_CHLA_month_%u", "-dpng","-r300");';
    eval(sprintf(formatSpec, index))
    close all;
end


%%
%It seems like plot 2 is the best 
addpath('G:\MATLAB\m_map');
%load ORSI fronts data
load('G:\MATLAB\PF_circle.mat')
load('G:\MATLAB\SACCF_circle.mat')
load('G:\MATLAB\SAF_circle.mat')
load('G:\MATLAB\SBDY_circle.mat')
load('G:\MATLAB\STF_circle')

par_i06s = load('G:\Cruises\2019_I06S\uvp5_sn207_2019_i06s_tcn322_ecotaxa_export_par.mat');
station = unique(par_i06s.par.profile);
i06s = [];
for in = 1:length(station)
    w1 = strcmp(par_i06s.par.profile,station(in));
    w2 = find(w1 == 1);
    i06s(in,1) = par_i06s.par.site(w2(1));
    i06s(in,2) = par_i06s.par.latitude(w2(1));
    i06s(in,3) = par_i06s.par.longitude(w2(1));
end

%load monthly average chla data
ncdisp('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181201_20181231.L3m.MO.CHL.chlor_a.4km.nc'); %view discription of data
chla.chlor_a = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181201_20181231.L3m.MO.CHL.chlor_a.4km.nc', 'chlor_a');
chla.lat = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181201_20181231.L3m.MO.CHL.chlor_a.4km.nc', 'lat');
chla.lon = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181201_20181231.L3m.MO.CHL.chlor_a.4km.nc', 'lon');
chla.time = datenum(2018, 12, 01) - datenum(1950,01,01);
chla.chlor_a(:,:,2) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190101_20190131.L3m.MO.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(2,1) = datenum(2019, 01, 01) - datenum(1950,01,01);
chla.chlor_a(:,:,3) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190201_20190228.L3m.MO.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(3,1) = datenum(2019, 02, 01) - datenum(1950,01,01);
chla.chlor_a(:,:,4) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190301_20190331.L3m.MO.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(4,1) = datenum(2019, 03, 01) - datenum(1950,01,01);
chla.chlor_a(:,:,5) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190401_20190430.L3m.MO.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(5,1) = datenum(2019, 04, 01) - datenum(1950,01,01);
chla.chlor_a(:,:,6) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190501_20190531.L3m.MO.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(6,1) = datenum(2019, 05, 01) - datenum(1950,01,01);

%subsample data for I06s
minLAT = -72; maxLAT = -30;
minLON = wrapTo360(20); maxLON = wrapTo360(40);
w = find(chla.lat>= minLAT & chla.lat<= maxLAT);
w2 = find(chla.lon>= minLON & wrapTo360(chla.lon)<= maxLON);
chla_sub.lat = chla.lat(w);
chla_sub.lon = chla.lon(w2);
chla_sub.chlor_a = chla.chlor_a(w2,w,:);
chla_sub.time = chla.time;

% %argo data from this float
% in  = 2;
% ncdisp(filename(in,:)); %view discription of data
% bgc.pressure = ncread(filename(in,:),'pressure'); 
% bgc.date = ncread(filename(in,:),'date'); 
% bgc.bbp700 = ncread(filename(in,:),'bbp700'); 
% bgc.chla = ncread(filename(in,:),'chla'); 
% bgc.chla_corr = ncread(filename(in,:),'chla_corr'); 
% bgc.lat = ncread(filename(in,:),'lat'); 
% bgc.lon = ncread(filename(in,:),'lon'); 
% bgc.par = ncread(filename(in,:),'par'); 
% bgc.profile = ncread(filename(in,:),'profile'); 
% bgc.temp = ncread(filename(in,:),'temp'); 
% %find profiles that fit within lat/long and time restrictions
% w=find(bgc.lon>= 20 & bgc.lon<= 40);
% start_date = days(datetime(2018,12,01, 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y'));
% end_date = days(datetime(2019,05,08, 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y'));
% w2 = find(bgc.date(w)>= start_date & bgc.date(w)<= end_date);


%plot map 

for index = 1:length(chla_sub.time);
    minLAT = -72; maxLAT = -30;
    minLON = wrapTo360(20); maxLON = wrapTo360(40);
    [PLT, PLG] = meshgrid(chla_sub.lat-0.25, chla_sub.lon-0.25); 
    
    fig1 = figure;
    fig1.Position = [1086 108 284 660]; %[1215 297 250 466];
    ax1 = axes; ax1.Position = [0.15 0.1100 0.7 0.8150]; %[0.1010 0.1100 0.6019 0.8150]; 
    m_proj('mercator','long',[minLON maxLON],'lat',[minLAT maxLAT]);
    hold on
    %add CHLA contour
    h_pcol = m_pcolor(PLG,PLT,chla_sub.chlor_a(:,:,index)); colormap(parula); shading flat;
    Levls = [min(min(min(chla_sub.chlor_a(:,:,index)))) 0.1 0.25 0.5 0.75 1 2.5 5 7.5 10];
    N_colorbins = length(Levls);
    c = parula(N_colorbins);
    colormap(c)
    C = chla_sub.chlor_a(:,:,index);
    cdt=get(h_pcol,'CData');
    Lold=Levls;
    clm=caxis;
    L1=((1:length(Levls))*(diff(caxis)/(length(Levls)+1)))+min(caxis());
    Levls=[Levls Inf];
    for k=1:length(Levls)-1,
          cdt(C>=Levls(k)&C<Levls(k+1))=L1(k);
    end 
    set(h_pcol,'CData',cdt);
    caxis(clm);
    
    %add ORSI Fronts
    colors = copper(5);
    m_line(STF(:,1), STF(:,2),'color',colors(1,:),'linewi',1);
    t5 = m_text(21,-42,{'STF'},'Fontname','helvetica','fontweight','bold','color', colors(1,:),'fontsize',12);
    m_line(SAF(1:end-1,1), SAF(1:end-1,2),'color',colors(2,:),'linewi',1);
    t3 = m_text(21,-46,{'SAF'},'Fontname','helvetica','fontweight','bold','color', colors(2,:),'fontsize',12);
    m_line(PF(1:end-1,2), PF(1:end-1,1),'color',colors(3,:),'linewi',1);
    t1 = m_text(21,-50.5,{'PF'},'Fontname','helvetica','fontweight','bold','color', colors(3,:),'fontsize',12);
    m_line(SACCF(560:622,1), SACCF(560:622,2),'color',colors(4,:),'linewi',1);
    t2 = m_text(21,-53,{'SACCF'},'Fontname','helvetica','fontweight','bold','color', colors(4,:),'fontsize',10);
    m_line(SBDY(1:end-1,1), SBDY(1:end-1,2),'color',colors(5,:),'linewi',1);
    t4 = m_text(21,-58.5,{'SBDY'},'Fontname','helvetica','fontweight','bold','color', colors(5,:),'fontsize',12);
    
    m_gshhs_h('patch',[0.7 0.7 0.7],'linestyle','none');
    m_grid('xtick',[minLON:20:maxLON],'ytick',[minLAT:5:maxLAT],'box','fancy');
    set(findobj('tag','m_grid_color'),'facecolor','none')
    set(gcf,'color','w');
    axis(ax1,'off')
    
    m_text(22,-71,'Antarctica','Fontname','helvetica','fontweight','bold','fontsize',12)
    m_text(21,-32,'South Africa','Fontname','helvetica','fontweight','bold', 'fontsize',10)
    m_plot(i06s(:,3),i06s(:,2),'o','MarkerFaceColor','none','MarkerSize',3,'clipping','on', 'MarkerEdgeColor', 'r');
    
    %add date
    %TT = datetime(1950,01,01, 'Format','d-MMM-y') + days(chla_sub.time(index)); % character vector
    TT = datetime(1950,01,01, 'Format','MMM y') + days(chla_sub.time(index)); % character vector
    m_text(21,-69, char(TT),'Fontname','helvetica','fontsize',10, 'color', 'r')
    
    %add ARGO locations from this date range
    filename = ['G:/Cruises/2019_I06S/ARGO_Chla/2902178_steffi.nc';...
        'G:/Cruises/2019_I06S/ARGO_Chla/5904469_steffi.nc'; ...
        'G:/Cruises/2019_I06S/ARGO_Chla/5904659_steffi.nc';...
        'G:/Cruises/2019_I06S/ARGO_Chla/5906007_steffi.nc';...
        'G:/Cruises/2019_I06S/ARGO_Chla/5906030_steffi.nc'];
    in  = 2
    year = [2018 2019 2019 2019 2019 2019];
    month = [12 01 02 03 04 05];
    ncdisp(filename(in,:)); %view discription of data
    bgc.pressure = ncread(filename(in,:),'pressure'); 
    bgc.date = ncread(filename(in,:),'date'); 
    bgc.bbp700 = ncread(filename(in,:),'bbp700'); 
    bgc.chla = ncread(filename(in,:),'chla'); 
    bgc.chla_corr = ncread(filename(in,:),'chla_corr'); 
    bgc.lat = ncread(filename(in,:),'lat'); 
    bgc.lon = ncread(filename(in,:),'lon'); 
    bgc.par = ncread(filename(in,:),'par'); 
    bgc.profile = ncread(filename(in,:),'profile'); 
    bgc.temp = ncread(filename(in,:),'temp'); 
    %find profiles that fit within lat/long and time restrictions
    w=find(bgc.lon>= 20 & bgc.lon<= 40);
    %start_date = days(datetime(year(index),month(index),01, 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y')); %month
    %end_date = days(datetime(year(index),month(index),31, 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y')); %month
    %start_date = days(datetime(year_8_start(index),month_8_start(index),day_8_start(index), 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y')); %8 day
    %end_date = days(datetime(year_8_stop(index),month_8_stop(index),day_8_stop(index), 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y')); %8 day
    % start_date = days(datetime(2018,12,01, 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y'));
    % end_date = days(datetime(2019,05,08, 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y'));
    start_date = days(datetime(2018,12,13, 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y'));
    end_date = days(datetime(2019,03,17, 'Format','d-MMM-y')- datetime(1970,01,01, 'Format','d-MMM-y'));
    w2 = find(bgc.date(w)>= start_date & bgc.date(w)<= end_date);
    loc = w(w2); loc = loc([1:5 7:9]);
    color = turbo(length(loc)); %hot
    
    for index2 = 1 : length(loc)
        m_scatter(bgc.lon(loc(index2)), bgc.lat(loc(index2)), 30,'filled','MarkerFaceColor', color(index2,:),'MarkerEdgeColor', 'w','LineWidth',0.5)
    end
    
    % set colorbar
    colmp = colormap(ax1); %,m_colmap('diverging',100)); 
    cb = colorbar; cb.Location = 'eastoutside';%set(ax1,'ColorScale','log');
    scale = (cb.Limits(2)-cb.Limits(1))/10;
    cb.YTick = [cb.Limits(1) cb.Limits(1)+scale cb.Limits(1)+2*scale cb.Limits(1)+3*scale ...
    cb.Limits(1)+4*scale cb.Limits(1)+5*scale cb.Limits(1)+6*scale cb.Limits(1)+7*scale ...
    cb.Limits(1)+8*scale cb.Limits(1)+9*scale cb.Limits(2)]; 
    set(cb,'yticklabel',{'', '0.1', '0.25','0.5', '0.75', '1', '2.5', '5', '7.5', '10', ''});
    
    %caxis([min(min(min(chla_sub.chlor_a(:,:,:)))) max(max(max(chla_sub.chlor_a(:,:,:))))]);
    cb.Label.String = 'Chla [\mug/l]';
    cb.FontName = 'helvetica';cb.FontSize = 10; %cb.FontWeight = 'bold'
    %cb.TickLabels = {'0.01', '0.1', '1', '10'}; %fix this if there is a different colorbar for other slides
    %caxis(cblimits);      
    %labels = -str2num(char(cb.TickLabels));
    %cb.TickLabels = num2str(labels);
    %set(gcf, 'InvertHardCopy', 'off');
    
    %save fig
    %formatSpec = 'print("G:/Cruises/2019_I06S/ARGO_Chla/I06s_modis_bgc_CHLA_day%u", "-dpng","-r300");';
    formatSpec = 'print("G:/Cruises/2019_I06S/ARGO_Chla/I06s_modis_bgc_CHLA_month_float2_%u", "-dpng","-r300");';
    eval(sprintf(formatSpec, index))
    close all;
end


% %Maybe I could make them open if they're in a different time range and
% %closed if they're in this time range
% datetime(1970,01,01, 'Format','dd-MMM-y') + days(bgc.date(w(w2)))
% 
% cb.TickLabels = [{char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17880))};...
% {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17900))};...
% {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17920))};...
% {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17940))};...
% {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17960))};...
% {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17980))};...
% {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(18000))};...
% {char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(18020))}];
% %print('G:/Cruises/2019_I06S/ARGO_Chla/I06s_BGC_5_floats_lat_lon_date_only_hits', '-r300', '-dpng')


%% plot time series
%loc=w(w2);
%find loc with data
%loc = loc([2:6 8:11]);
%loc = loc([1:5 7:9]);

[XX YY] = meshgrid(bgc.date(loc), bgc.pressure(1:201));

figure
[C,h] = contourf(XX, YY, bgc.chla_corr(1:201,loc));
set(h, 'LineColor', 'none');
set(gca, 'YDir', 'reverse');
hold on
%mark location of each profile
%plot(gca,bgc.date(loc),zeros([1 length(bgc.date(loc))]),'k^','MarkerSize',5)

for index2 = 1 : length(loc)
    %m_scatter(bgc.lon(loc(index2)), bgc.lat(loc(index2)), 30,'filled','MarkerFaceColor', color(index2,:),'LineWidth',1.5)
    scatter(bgc.date(loc(index2)),zeros([1 length(bgc.date(loc(index2)))]), 50,'filled','MarkerFaceColor', color(index2,:),'LineWidth',1.5); %'MarkerEdgeColor', 'k',
end

ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 14)

%xticks([-65 -60 -55 -50 -45 -40 -35]);
xticklabels([{char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17880))};...
{char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17890))};...
{char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17900))};...
{char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17910))};...
{char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17920))};...
{char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17930))};...
{char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17940))};...
{char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17950))};...
{char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17960))};...
{char(datetime(1970,01,01, 'Format','dd-MMM-y') + days(17970))}]);
set(gca, 'FontName','helvetica','fontweight','bold','fontsize', 14)

%descrite color bar and match with sattelite CB
cblh = colorbar;
cblh.Label.String = 'Chla (\mug/l)';
set(gca, 'FontName','helvetica','fontweight','bold','fontsize', 14)

%add MLD
bgc_new.mld = [];
for index = 1:length(loc) %bgc_new.date)
    index1 = loc(index);
    w_mld = ~isnan(bgc_new.pressure(:,index1));
    bgc_new.mld(index1) = calc_mld(bgc_new.pressure(w_mld,index1), bgc_new.pden(w_mld,index1)+1000);
    % mld_temp = calc_mld(bgc_new.pressure(w_mld,index), bgc_new.pden(w_mld,index));
    % den = bgc_new.pden(w_mld,index);
    % dep = bgc_new.pressure(w_mld,index);
    % %plot results
    % b = zeros(1,length(den(1:21)));
    % b = b + mld_temp;
    % fig = figure();
    % plot(den(1:50), dep(1:50), 'ok') 
    % hold on
    % plot(den(1:50), b, '-r')
    % ylim = [min(den(1:11)) max(dep(1:50))];
    % set(gca, 'YDir','reverse');%flip y axis
    % xlabel('Density (kg m^-^3)'); %x axis label
    % ylabel('Depth (m)');%y axis label
    % title(par.site(w(1)))
end
hold on
plot(bgc.date(loc), bgc_new.mld(loc)', '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);

% data with salinity
filename = 'G:/Cruises/2019_I06S/ARGO_Chla/GL_PR_PF_5904469.nc';
ncdisp(filename); %view discription of data
bgc_new.pressure = ncread(filename,'PRES_ADJUSTED'); 
bgc_new.date = ncread(filename,'TIME'); 
bgc_new.bbp700 = ncread(filename,'BBP700_ADJUSTED'); 
bgc_new.chla = ncread(filename,'CPHL_ADJUSTED'); 
%bgc_new.chla_corr = ncread(filename,'chla_corr'); 
bgc_new.lat = ncread(filename,'LATITUDE'); 
bgc_new.lon = ncread(filename,'LONGITUDE'); 
%bgc_new.par = ncread(filename,'par'); 
%bgc_new.profile = ncread(filename,'profile'); 
bgc_new.temp = ncread(filename,'TEMP_ADJUSTED'); 
bgc_new.sal = ncread(filename,'PSAL_ADJUSTED'); 

%add sigma-t contour lines
addpath('G:\MATLAB\seawater_ver3_3.1')
addpath('G:\MATLAB\m_map'); 
bgc_new.pden = sw_pden(bgc_new.sal,bgc_new.temp,bgc_new.pressure,0)-1000; %2000
%cmap_bins = [23.5 24 24.5 25 25.5 26 26.5 26.75 27 27.15 27.5 27.6 27.7 27.75 27.8 27.83 27.85 27.9]; 
cmap_bins = [27 27.15 27.35 27.4 27.5 27.6 27.7 27.75 27.8 27.83 27.85 27.9]; 
[XX YY] = meshgrid(bgc.date(loc), bgc_new.pressure(1:128));
hold on
%labels on sigma 2
ax4 = axes(gcf, 'Position', [0.1204 0.1649 0.7178 0.7601]);
[C,h] = contour(ax4, XX, YY, bgc_new.pden(1:128,loc),cmap_bins, 'showtext','on');
h.LevelList=round(h.LevelList,2);  %rounds levels to 3rd decimal place
clabel(C,h);
set(h, 'LineColor', 'w'); clabel(C,h, 'Color','w', 'LabelSpacing', 100, 'FontSize', 7);
ax4.YDir = 'reverse';
ax4.XTick = []; ax4.YTick = [];
set(ax4, 'Color','none');

print('G:/Cruises/2019_I06S/ARGO_Chla/I06s_BGC_5904469_contour', '-r300', '-dpng')