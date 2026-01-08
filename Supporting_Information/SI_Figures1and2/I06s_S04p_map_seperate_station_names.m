% supporting information figure of maps of S04p and I06s with station numbers
% visibly marked

addpath('G:\MATLAB\m_map');
addpath('G:\Cruises\2018_S04P')

%load data
%par_s04p = load('G:\Cruises\2018_S04P\uvp5_sn207_2018_s04p_ecotaxa_export_par.mat');
par_s04p = load('G:\Cruises\2018_S04P\uvp5_sn207_2018_s04p_ecotaxa_export_par2_filtered_AOU_fluor_sitecorrect_flux_loncorr.mat'); 
load('S04P_transect_main5.txt')
par_i06s = load('G:\Cruises\2019_I06S\uvp5_sn207_2019_i06s_tcn322_ecotaxa_export_par2_AOU_fluor_flux_corr.mat');

%load CTD data from I06s: downloaded 8/27/2025
%ncdisp('G:/Cruises/2019_I06S/325020190403_ctd.nc'); %view discription of data
ctd.station = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc', 'station');
%this station data is in a weird format
ctd.stn = [1:55]; %this is the same but in a better format
ctd.cast = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc', 'cast');
ctd.lat = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','latitude'); 
ctd.lon = ncread('G:/Cruises/2019_I06S/325020190403_ctd.nc','longitude'); 

%load CTD data S04p
%load data, downloaded 9/17/2025
filepath = 'G:/Cruises/2018_S04P/320620180309_CTD_bottle_17Sept2025/320620180309_ctd.nc';
%ncdisp(filepath); %view discription of data
ctd_s04p.station = ncread(filepath, 'station'); %this station data is in a weird format
ctd_s04p.stn = [1:8 10:103 105:108 110:120]; %this is the same but in a better format %remove 901 test cast, no 9, 104, or 109
ctd_s04p.cast = ncread(filepath, 'cast');
ctd_s04p.lat = ncread(filepath,'latitude'); 
ctd_s04p.lon = ncread(filepath,'longitude'); 

ctd_s04p.cast = ctd_s04p.cast(2:end);
ctd_s04p.lat = ctd_s04p.lat(2:end); 
ctd_s04p.lon = ctd_s04p.lon(2:end); 

%add frontal zone information S04p
par_s04p.par.frontal_zone = {}; %create cell array within structure
w = find(wrapTo360(par_s04p.par.longitude) <= wrapTo360(-131.252)); %West of SBDY
par_s04p.par.frontal_zone(w,1) = {'Subpolar Region'}; 
w = find(wrapTo360(par_s04p.par.longitude) >  wrapTo360(-131.252) & wrapTo360(par_s04p.par.longitude) <=  wrapTo360(-104.0791)); %West of SACCF
par_s04p.par.frontal_zone(w,1) = {'Southern Zone'}; 
w = find(wrapTo360(par_s04p.par.longitude) >  wrapTo360(-104.0791) & wrapTo360(par_s04p.par.longitude) <=  wrapTo360(-78.4832)); %West of SACCF
par_s04p.par.frontal_zone(w,1) = {'Antarctic Zone'}; 
w = find(wrapTo360(par_s04p.par.longitude) >  wrapTo360(-78.4832)); %East of SACCF
par_s04p.par.frontal_zone(w,1) = {'Southern Zone'};

% add frontal zone info for I06S
par_i06s.par.frontal_zone = {}; %create cell array within structure
w = find(par_i06s.par.latitude > -40.6662); %North of STF
par_i06s.par.frontal_zone(w,1) = {'Subtropical Zone'}; 
w = find(par_i06s.par.latitude > -49 & par_i06s.par.latitude <= -40.6662); %North of SAF
par_i06s.par.frontal_zone(w,1) = {'Subantarctic Zone'}; 
w = find(par_i06s.par.latitude > -53.5 & par_i06s.par.latitude <= -49); %North of PF
par_i06s.par.frontal_zone(w,1) = {'Polar Frontal Zone'}; 
w = find(par_i06s.par.latitude > -55.9998 & par_i06s.par.latitude <= -53.5); %North of SACCF
par_i06s.par.frontal_zone(w,1) = {'Antarctic Zone'}; 
w = find(par_i06s.par.latitude > -60.7523 & par_i06s.par.latitude <= -55.9998); %North of SBDY
par_i06s.par.frontal_zone(w,1) = {'Southern Zone'}; 
w = find(par_i06s.par.latitude <= -60.7523); %South of SBDY
par_i06s.par.frontal_zone(w,1) = {'Subpolar Region'};

%load ORSI fronts data
load('G:\MATLAB\PF_circle.mat')
load('G:\MATLAB\SACCF_circle.mat')
load('G:\MATLAB\SAF_circle.mat')
load('G:\MATLAB\SBDY_circle.mat')
load('G:\MATLAB\STF_circle')

%load('G:\MATLAB\ys_fronts.mat')
%load('G:\MATLAB\fronts_Gray.mat')


%resave these files to have the first number also be the last%%%
s04p = [];
for in = 1:length(S04P_transect_main5) %S04Ptransectmain)
    % w1 = strcmp(par_s04p.par.profile,S04Ptransectmain(in)); 
    % w2 = find(w1 == 1);
    % s04p(in,1) = par_s04p.par.site(w2(1));
    % s04p(in,2) = par_s04p.par.latitude(w2(1));
    % s04p(in,3) = par_s04p.par.longitude(w2(1));

    w1 = find(par_s04p.par.site == S04P_transect_main5(in));
    s04p(in,1) = par_s04p.par.site(w1(1));
    s04p(in,2) = par_s04p.par.latitude(w1(1));
    s04p(in,3) = par_s04p.par.longitude(w1(1));
    s04p_profile(in,1) = par_s04p.par.profile(w1(1));
end
station = unique(par_i06s.par.profile);
i06s = [];
for in = 1:length(station)
    w1 = strcmp(par_i06s.par.profile,station(in));
    w2 = find(w1 == 1);
    i06s(in,1) = par_i06s.par.site(w2(1));
    i06s(in,2) = par_i06s.par.latitude(w2(1));
    i06s(in,3) = par_i06s.par.longitude(w2(1));
end

%% plot S04p figure
test = lines(7);
test2 = test([2:5 7],:);
test3 = repmat(test2, 100, 1);

minLAT = -80;
maxLAT = -60;
minLON = wrapTo360(-200);
maxLON = wrapTo360(-60);
%[PLT, PLG] = meshgrid(ssh.lat-0.25, ssh.lon-0.25); 

fig1 = figure;
fig1.Position = [100 211 1097 443]; %[307 292 845 369]; %[488 502 560 260]; 
ax1 = axes; %[488 488.2000 676.2000 273.8000]
ax1.Position = [0.070 0.1100 0.85 0.8150]; %[0.1300 0.1100 0.7750 0.8150]
m_proj('mercator','long',[minLON maxLON],'lat',[minLAT maxLAT]);
hold on
%add bathymetry contour
m_elev('contourf', 100,'edgecolor','none')
%add ORSI Fronts
colors = copper(5);
m_line(wrapTo360(PF(:,2)), PF(:,1),'color',colors(3,:),'linewi',1);
t1 = m_text(wrapTo360(-93),-63,{'PF'},'Fontname','helvetica','fontweight','bold','color', colors(3,:),'fontsize',10);
m_line(wrapTo360(SACCF(:,1)), SACCF(:,2),'color',colors(4,:),'linewi',1);
t2 = m_text(wrapTo360(-125),-64,{'SACCF'},'Fontname','helvetica','fontweight','bold','color', colors(4,:),'fontsize',10);
%m_line(wrapTo360(SAF(:,1)), SAF(:,2),'color',[0.933 0.919 0.667],'linewi',1);
%t3 = m_text(wrapTo360(40),-45,{'SAF'},'Fontname','helvetica','fontweight','bold','color', [0.933 0.919 0.667],'fontsize',10);
m_line(wrapTo360(SBDY(:,1)), SBDY(:,2),'color',colors(5,:),'linewi',1);
t4 = m_text(wrapTo360(-130),-70,{'SBDY'},'Fontname','helvetica','fontweight','bold','color', colors(5,:),'fontsize',10);
%m_line(wrapTo360(STF(:,1)), STF(:,2),'color','w','linewi',1);
%t5 = m_text(wrapTo360(40),-39,{'STF'},'Fontname','helvetica','fontweight','bold','color', 'w','fontsize',10);

m_gshhs_h('patch',[0.7 0.7 0.7],'linestyle','none');
m_grid('xtick',[minLON:20:maxLON],'ytick',[minLAT:5:maxLAT],'box','fancy');
set(findobj('tag','m_grid_color'),'facecolor','none')
set(gcf,'color','w');
axis(ax1,'off')

m_text(wrapTo360(-140),-77,'Antarctica','Fontname','helvetica','fontweight','bold','fontsize',14)
m_text(wrapTo360(-190),-75,'Ross Sea','Fontname','helvetica','fontweight','bold', 'FontAngle', 'italic', 'fontsize',14)
m_text(wrapTo360(-73),-71,'WAP','Fontname','helvetica','fontweight','bold','fontsize',10)
%m_plot(wrapTo360(s04p(:,3)),s04p(:,2),'oK','MarkerFaceColor','none','MarkerSize',3,'clipping','on', 'MarkerEdgeColor', 'k');
cmap = test3(1:length(s04p),:); %lines(length(s04p));
for k = 1:length(s04p)
    %w = find(cellfun(@(x) isequal(x, S04P_transect_main5(k)), par_s04p.par.site));
    w = find(par_s04p.par.site == S04P_transect_main5(k));
    %w2 = find(w == 1);
    if isequal(par_s04p.par.frontal_zone(w(1)), {'Subpolar Region'})
        s = 'o';
    elseif isequal(par_s04p.par.frontal_zone(w(1)), {'Southern Zone'  })
        s = 'd';
    elseif isequal(par_s04p.par.frontal_zone(w(1)), {'Antarctic Zone' })
        s = 's';
    end
    m_plot(wrapTo360(s04p(k,3)),s04p(k,2),s,'MarkerFaceColor',cmap(k,:),'MarkerSize',4,'clipping','on', 'MarkerEdgeColor', 'k');
end
    %m_plot(i06s(:,3),i06s(:,2),'oK','MarkerFaceColor','m','MarkerSize',7,'clipping','on');

%add station numbers
%t6 = m_text(wrapTo360(s04p(:,3)),s04p(:,2)-0.5,string(s04p(:,1)),'rotation', 270,'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',6);
for k = 1:length(s04p)
    t6(k) = m_text(wrapTo360(s04p(k,3)),s04p(k,2)-0.25,string(s04p(k,1)),'rotation', 270,'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',7);
    t6(k).Color = cmap(k, :); % Assign color from the colormap
end

%plot CTD stations no UVP in black
m_plot(wrapTo360(ctd_s04p.lon([2 4 6 7 8 25 26], 1)),ctd_s04p.lat([2 4 6 7 8 25 26], 1),'oK','MarkerFaceColor','k','MarkerSize',3,'clipping','on', 'MarkerEdgeColor', 'k');
%add station numbers CTD only
m_text(wrapTo360(ctd_s04p.lon([2 4 6 7 8 25 26], 1)),ctd_s04p.lat([2 4 6 7 8 25 26], 1)-0.25,...
    string(ctd_s04p.stn([2 4 6 7 8 25 26])),'Fontname','helvetica','fontweight','bold','rotation', 270,'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',7);

% set colorbar for bathymetry
colmp = colormap(ax1,m_colmap('blues',100)); 
cb = colorbar;
cblimits = [-6000 0];
cb.Limits = cblimits;
cb.Label.String = 'Bathymetry (m)';
cb.FontName = 'helvetica'; cb.FontWeight = 'bold';cb.FontSize = 14;
caxis(cblimits);
labels = -str2num(char(cb.TickLabels));
cb.TickLabels = num2str(labels);

% % testing ys_fronts
% m_line(wrapTo360(ys_fronts.pf(:,1)), ys_fronts.pf(:,2),'color','r','linewi',1);
% m_line(wrapTo360(ys_fronts.saccf(:,1)), ys_fronts.saccf(:,2),'color','r','linewi',1);
% m_line(wrapTo360(ys_fronts.sbdy(:,1)), ys_fronts.sbdy(:,2),'color','r','linewi',1);
% 
% % testing fronts_Gray
% m_line(wrapTo360(lon_pf(:)), lat_pf(:),'color','g','linewi',1);
% m_line(wrapTo360(lon_siz(:)), lat_siz(:),'color','g','linewi',1);

% %save fig
print("G:/MS_Southern_Ocean/Figures/S04p_map_station_numbers", "-dpng","-r300");


%t7 = m_text(i06s(:,3)-1,i06s(:,2),string(i06s(:,1)),'Fontname','helvetica','fontweight','bold','color', 'w','fontsize',10);


%% Plot I06S map
test = lines(7);
test2 = test([2:5 7],:);
test3 = repmat(test2, 100, 1);

minLAT = -72; maxLAT = -30;
minLON = wrapTo360(20); maxLON = wrapTo360(40);

fig1 = figure;
fig1.Position = [400 62 335 660]; %[1086 108 284 660]; %[1215 297 250 466];
ax1 = axes; ax1.Position = [0.15 0.05 0.7 0.93];  % [0.15 0.1100 0.7 0.8150]%[0.1010 0.1100 0.6019 0.8150]; 
m_proj('mercator','long',[minLON maxLON],'lat',[minLAT maxLAT]);
hold on
%add bathymetry contour
m_elev('contourf', 100,'edgecolor','none')
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
%m_plot(i06s(:,3),i06s(:,2),'oK','MarkerFaceColor','none','MarkerSize',3,'clipping','on', 'MarkerEdgeColor', 'k');

%plot CTD stations no UVP in black
m_plot(ctd.lon([7 12 13 14 15 16 22 32 35 36 37 39 40], 1),ctd.lat([7 12 13 14 15 16 22 32 35 36 37 39 40], 1),'oK','MarkerFaceColor','k','MarkerSize',3,'clipping','on', 'MarkerEdgeColor', 'k');
%add station numbers CTD only
m_text(wrapTo360(ctd.lon([7 12 13 14 15 16 22 32 35 36 37 39 40], 1))+0.5,ctd.lat([7 12 13 14 15 16 22 32 35 36 37 39 40], 1),...
    string(ctd.stn([7 12 13 14 15 16 22 32 35 36 37 39 40])),'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',7);

cmap = test3(1:length(i06s),:); %cmap = lines(length(i06s));
profile = unique(par_i06s.par.profile);
for k = 1:length(i06s)
    w = find(cellfun(@(x) isequal(x, string(profile(k))), par_i06s.par.profile));
    if isequal(par_i06s.par.frontal_zone(w(1)), {'Subpolar Region'})
        s = 'o';
    elseif isequal(par_i06s.par.frontal_zone(w(1)), {'Southern Zone'  })
        s = 'd';
    elseif isequal(par_i06s.par.frontal_zone(w(1)), {'Antarctic Zone' })
        s = 's';
    elseif isequal(par_i06s.par.frontal_zone(w(1)), {'Polar Frontal Zone'})
        s = '>';
    elseif isequal(par_i06s.par.frontal_zone(w(1)), {'Subtropical Zone'  })
        s = '<';
    end
    m_plot(wrapTo360(i06s(k,3)),i06s(k,2),s,'MarkerFaceColor',cmap(k,:),'MarkerSize',5,'clipping','on', 'MarkerEdgeColor', 'k');
end
    %m_plot(i06s(:,3),i06s(:,2),'oK','MarkerFaceColor','m','MarkerSize',7,'clipping','on');



%add station numbers
for k = 1:length(i06s)
    t6(k) = m_text(wrapTo360(i06s(k,3))+0.5,i06s(k,2),string(i06s(k,1)),'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',7);
    t6(k).Color = cmap(k, :); % Assign color from the colormap
end

% set colorbar for bathymetry
colmp = colormap(ax1,m_colmap('blues',100)); 
cb = colorbar;
cblimits = [-6000 0];
cb.Limits = cblimits;
cb.Label.String = 'Bathymetry (m)';
cb.FontName = 'helvetica'; cb.FontWeight = 'bold';cb.FontSize = 14;
caxis(cblimits);
labels = -str2num(char(cb.TickLabels));
cb.TickLabels = num2str(labels);

% % testing ys_fronts
% m_line(wrapTo360(ys_fronts.saf(930:1159,1)), ys_fronts.saf(930:1159,2),'color','r','linewi',1);
% m_line(wrapTo360(ys_fronts.pf(756:957,1)), ys_fronts.pf(756:957,2),'color','r','linewi',1);
% m_line(wrapTo360(ys_fronts.saccf(881:1098,1)), ys_fronts.saccf(881:1098,2),'color','r','linewi',1);
% m_line(wrapTo360(ys_fronts.sbdy(666:886,1)), ys_fronts.sbdy(666:886,2),'color','r','linewi',1);

% % testing fronts_Gray
% m_line(wrapTo360(lon_stf(506:877)), lat_stf(506:877),'color','g','linewi',1);
% m_line(wrapTo360(lon_saf(506:877)), lat_saf(506:877),'color','g','linewi',1);
% m_line(wrapTo360(lon_pf(1:230)), lat_pf(1:230),'color','g','linewi',1);
% m_line(wrapTo360(lon_siz(950:1104)), lat_siz(950:1104),'color','g','linewi',1);

% %save fig
print("G:/MS_Southern_Ocean/Figures/I06s_map_station_numbers", "-dpng","-r300");

%% All stations CTD S04p- this was used for QCing and determining which stations to include
addpath('G:\MATLAB\m_map');
addpath('G:\Cruises\2018_S04P')

%load data
par_s04p = load('G:\Cruises\2018_S04P\uvp5_sn207_2018_s04p_ecotaxa_export_par2_filtered_AOU_fluor_sitecorrect_flux.mat');

%load CTD data
%load data, downloaded 9/17/2025
filepath = 'G:/Cruises/2018_S04P/320620180309_CTD_bottle_17Sept2025/320620180309_ctd.nc';
%ncdisp(filepath); %view discription of data
ctd.station = ncread(filepath, 'station'); %this station data is in a weird format
ctd.stn = [1:8 10:103 105:108 110:120]; %this is the same but in a better format %remove 901 test cast, no 9, 104, or 109
ctd.cast = ncread(filepath, 'cast');
ctd.lat = ncread(filepath,'latitude'); 
ctd.lon = ncread(filepath,'longitude'); 

ctd.cast = ctd.cast(2:end);
ctd.lat = ctd.lat(2:end); 
ctd.lon = ctd.lon(2:end); 

%add frontal zone information S04p
par_s04p.par.frontal_zone = {}; %create cell array within structure
w = find(wrapTo360(par_s04p.par.longitude) <= wrapTo360(-131.252)); %West of SBDY
par_s04p.par.frontal_zone(w,1) = {'Subpolar Region'}; 
w = find(wrapTo360(par_s04p.par.longitude) >  wrapTo360(-131.252) & wrapTo360(par_s04p.par.longitude) <=  wrapTo360(-104.0791)); %West of SACCF
par_s04p.par.frontal_zone(w,1) = {'Southern Zone'}; 
w = find(wrapTo360(par_s04p.par.longitude) >  wrapTo360(-104.0791) & wrapTo360(par_s04p.par.longitude) <=  wrapTo360(-78.4832)); %West of SACCF
par_s04p.par.frontal_zone(w,1) = {'Antarctic Zone'}; 
w = find(wrapTo360(par_s04p.par.longitude) >  wrapTo360(-78.4832)); %East of SACCF
par_s04p.par.frontal_zone(w,1) = {'Southern Zone'};

%load ORSI fronts data
load('G:\MATLAB\PF_circle.mat')
load('G:\MATLAB\SACCF_circle.mat')
load('G:\MATLAB\SAF_circle.mat')
load('G:\MATLAB\SBDY_circle.mat')
load('G:\MATLAB\STF_circle')

%resave these files to have the first number also be the last%%%
s04p = [];
station = unique(ctd.stn);

for in = 1:length(station)
    s04p(in,1) = ctd.stn(in);
    s04p(in,2) = ctd.lat(in);
    s04p(in,3) = ctd.lon(in);
end

% plot S04p figure
test = lines(7);
test2 = test([2:5 7],:);
test3 = repmat(test2, 100, 1);

minLAT = -80;
maxLAT = -60;
minLON = wrapTo360(-200);
maxLON = wrapTo360(-60);
%[PLT, PLG] = meshgrid(ssh.lat-0.25, ssh.lon-0.25); 

fig1 = figure;
fig1.Position = [100 211 1097 443]; %[307 292 845 369]; %[488 502 560 260]; 
ax1 = axes; %[488 488.2000 676.2000 273.8000]
ax1.Position = [0.070 0.1100 0.85 0.8150]; %[0.1300 0.1100 0.7750 0.8150]
m_proj('mercator','long',[minLON maxLON],'lat',[minLAT maxLAT]);
hold on
%add bathymetry contour
m_elev('contourf', 100,'edgecolor','none')
%add ORSI Fronts
colors = copper(5);
m_line(wrapTo360(PF(:,2)), PF(:,1),'color',colors(3,:),'linewi',1);
t1 = m_text(wrapTo360(-93),-63,{'PF'},'Fontname','helvetica','fontweight','bold','color', colors(3,:),'fontsize',10);
m_line(wrapTo360(SACCF(:,1)), SACCF(:,2),'color',colors(4,:),'linewi',1);
t2 = m_text(wrapTo360(-125),-64,{'SACCF'},'Fontname','helvetica','fontweight','bold','color', colors(4,:),'fontsize',10);
%m_line(wrapTo360(SAF(:,1)), SAF(:,2),'color',[0.933 0.919 0.667],'linewi',1);
%t3 = m_text(wrapTo360(40),-45,{'SAF'},'Fontname','helvetica','fontweight','bold','color', [0.933 0.919 0.667],'fontsize',10);
m_line(wrapTo360(SBDY(:,1)), SBDY(:,2),'color',colors(5,:),'linewi',1);
t4 = m_text(wrapTo360(-130),-70,{'SBDY'},'Fontname','helvetica','fontweight','bold','color', colors(5,:),'fontsize',10);
%m_line(wrapTo360(STF(:,1)), STF(:,2),'color','w','linewi',1);
%t5 = m_text(wrapTo360(40),-39,{'STF'},'Fontname','helvetica','fontweight','bold','color', 'w','fontsize',10);

m_gshhs_h('patch',[0.7 0.7 0.7],'linestyle','none');
m_grid('xtick',[minLON:20:maxLON],'ytick',[minLAT:5:maxLAT],'box','fancy');
set(findobj('tag','m_grid_color'),'facecolor','none')
set(gcf,'color','w');
axis(ax1,'off')

m_text(wrapTo360(-140),-77,'Antarctica','Fontname','helvetica','fontweight','bold','fontsize',14)
m_text(wrapTo360(-190),-75,'Ross Sea','Fontname','helvetica','fontweight','bold', 'FontAngle', 'italic', 'fontsize',14)
m_text(wrapTo360(-73),-71,'WAP','Fontname','helvetica','fontweight','bold','fontsize',10)
%m_plot(wrapTo360(s04p(:,3)),s04p(:,2),'oK','MarkerFaceColor','none','MarkerSize',3,'clipping','on', 'MarkerEdgeColor', 'k');
cmap = test3(1:length(s04p),:); %lines(length(s04p));
% for k = 1:length(s04p)
%     w = find(cellfun(@(x) isequal(x, station(k)), par_s04p.par.profile));
%     if isequal(par_s04p.par.frontal_zone(w(1)), {'Subpolar Region'})
%         s = 'o';
%     elseif isequal(par_s04p.par.frontal_zone(w(1)), {'Southern Zone'  })
%         s = 'd';
%     elseif isequal(par_s04p.par.frontal_zone(w(1)), {'Antarctic Zone' })
%         s = 's';
%     end
%     m_plot(wrapTo360(s04p(k,3)),s04p(k,2),s,'MarkerFaceColor',cmap(k,:),'MarkerSize',4,'clipping','on', 'MarkerEdgeColor', 'k');
% end
%     %m_plot(i06s(:,3),i06s(:,2),'oK','MarkerFaceColor','m','MarkerSize',7,'clipping','on');

m_plot(wrapTo360(s04p(:,3)),s04p(:,2),'o','MarkerFaceColor','k','MarkerSize',4,'clipping','on', 'MarkerEdgeColor', 'k');
%m_text(wrapTo360(s04p(:,3))+1.5,s04p(:,2),string(s04p(:,1)),'rotation', 0,'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',7);
m_text(wrapTo360(s04p(:,3)),s04p(:,2)-0.25,string(s04p(:,1)),'rotation', 270,'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',7);

% %add station numbers
% %t6 = m_text(wrapTo360(s04p(:,3)),s04p(:,2)-0.5,string(s04p(:,1)),'rotation', 270,'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',6);
% for k = 1:length(s04p)
%     t6(k) = m_text(wrapTo360(s04p(k,3)),s04p(k,2)-0.25,string(s04p(k,1)),'rotation', 270,'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',7);
%     t6(k).Color = cmap(k, :); % Assign color from the colormap
% end

% set colorbar for bathymetry
colmp = colormap(ax1,m_colmap('blues',100)); 
cb = colorbar;
cblimits = [-6000 0];
cb.Limits = cblimits;
cb.Label.String = 'Bathymetry (m)';
cb.FontName = 'helvetica'; cb.FontWeight = 'bold';cb.FontSize = 14;
caxis(cblimits);
labels = -str2num(char(cb.TickLabels));
cb.TickLabels = num2str(labels);

% %save fig
% print("G:/MS_Southern_Ocean/Figures/S04p_map_station_numbers_all", "-dpng","-r300");


%t7 = m_text(i06s(:,3)-1,i06s(:,2),string(i06s(:,1)),'Fontname','helvetica','fontweight','bold','color', 'w','fontsize',10);



%% QC
s04p = [];s04p_profile = {};
stations = unique(par_s04p.par.site);
for in = 1:length(unique(par_s04p.par.site))
    w1 = find(par_s04p.par.site == stations(in));
    s04p(in,1) = par_s04p.par.site(w1(1));
    s04p(in,2) = par_s04p.par.latitude(w1(1));
    s04p(in,3) = par_s04p.par.longitude(w1(1));
    s04p_profile(in,1) = par_s04p.par.profile(w1(1));
end

