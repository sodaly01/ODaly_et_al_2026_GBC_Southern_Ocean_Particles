%Southern Ocean Manuscript 4 paneled Map 

%A: S04p stations on top of SSH with Orsi Fronts overlayed (blue to white to red colorbar)
%B: S04p stations on top of CHLA with Orsi Fronts overlayed (parula colorbar)
%C: I06S stations on top of SSH with Orsi Fronts overlayed (blue to white to red colorbar)
%D: I06S stations on top of CHLA with Orsi Fronts overlayed (parula colorbar)

%SSH data downloaded from here: Global Ocean Gridded L 4 Sea Surface Heights And Derived Variables Reprocessed Copernicus Climate Service
%https://data.marine.copernicus.eu/product/SEALEVEL_GLO_PHY_CLIMATE_L4_MY_008_057/download?dataset=c3s_obs-sl_glo_phy-ssh_my_twosat-l4-duacs-0.25deg_P1D_202112

addpath('G:\MATLAB\m_map'); addpath('G:\Cruises\2018_S04P');

%load particle data
par_s04p = load('G:\Cruises\2018_S04P\uvp5_sn207_2018_s04p_ecotaxa_export_par2_filtered_AOU_fluor_sitecorrect_flux_loncorr.mat');
load('S04P_transect_main5.txt')
par_i06s = load('G:\Cruises\2019_I06S\uvp5_sn207_2019_i06s_tcn322_ecotaxa_export_par2_AOU_fluor_flux_corr.mat');

%load ORSI fronts data
load('G:\MATLAB\PF_circle.mat')
load('G:\MATLAB\SACCF_circle.mat')
load('G:\MATLAB\SAF_circle.mat')
load('G:\MATLAB\SBDY_circle.mat')
load('G:\MATLAB\STF_circle')

%resave these files to have the first number also be the last%%%
s04p = [];
for in = 1:length(S04P_transect_main5)
    % w1 = strcmp(par_s04p.par.profile,S04Ptransectmain(in));
    % w2 = find(w1 == 1);
    % s04p(in,1) = par_s04p.par.site(w2(1));
    % s04p(in,2) = par_s04p.par.latitude(w2(1));
    % s04p(in,3) = par_s04p.par.longitude(w2(1));
    w=find(par_s04p.par.site == S04P_transect_main5(in));
    s04p(in,1) = par_s04p.par.site(w(1));
    s04p(in,2) = par_s04p.par.latitude(w(1));
    s04p(in,3) = par_s04p.par.longitude(w(1));
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

%% A: S04p stations on top of SSH with Orsi Fronts overlayed (blue to white to red colorbar)

%Load data SSH
%ncdisp('G:/MS_Southern_Ocean/data/c3s_obs-sl_glo_phy-ssh_my_twosat-l4-duacs-0.25deg_P1D_1704841582823.nc'); %view discription of data
ssh.lat = ncread('G:/MS_Southern_Ocean/data/c3s_obs-sl_glo_phy-ssh_my_twosat-l4-duacs-0.25deg_P1D_1704841582823.nc','latitude'); 
ssh.lon = ncread('G:/MS_Southern_Ocean/data/c3s_obs-sl_glo_phy-ssh_my_twosat-l4-duacs-0.25deg_P1D_1704841582823.nc','longitude'); 
ssh.time = ncread('G:/MS_Southern_Ocean/data/c3s_obs-sl_glo_phy-ssh_my_twosat-l4-duacs-0.25deg_P1D_1704841582823.nc','time'); 
ssh.sla = ncread('G:/MS_Southern_Ocean/data/c3s_obs-sl_glo_phy-ssh_my_twosat-l4-duacs-0.25deg_P1D_1704841582823.nc','sla'); 

%% A:  plot data ssh S04P
for index = 1:length(ssh.time)
    minLAT = -75;
    maxLAT = -60;
    minLON = wrapTo360(-200);
    maxLON = wrapTo360(-60);
    [PLT, PLG] = meshgrid(ssh.lat-0.25, ssh.lon-0.25); 

    fig1 = figure;
    fig1.Position = [394 399 560 180]; %[488 502 560 260]; 
    ax1 = axes; %[488 488.2000 676.2000 273.8000]
    %ax1.Position = [0.2195 0.1100 0.7005 0.8150]; %[0.070 0.1100 0.85 0.8150]; %[0.1300 0.1100 0.7750 0.8150]
    m_proj('mercator','long',[minLON maxLON],'lat',[minLAT maxLAT]);
    hold on
    %add SSH contour
    m_pcolor(wrapTo360(PLG),PLT,ssh.sla(:,:,index)); colormap(parula); %shading flat;
    %add ORSI Fronts
    % m_line(wrapTo360(PF(:,2)), PF(:,1),'color',[0.894 0.779 0.396],'linewi',1);
    % t1 = m_text(wrapTo360(-93),-63,{'PF'},'Fontname','helvetica','fontweight','bold','color', [0.894 0.779 0.396],'fontsize',10);
    % m_line(wrapTo360(SACCF(:,1)), SACCF(:,2),'color',[0.855 0.674 0.125],'linewi',1);
    % t2 = m_text(wrapTo360(-125),-64,{'SACCF'},'Fontname','helvetica','fontweight','bold','color', [0.855 0.674 0.125],'fontsize',10);
    % %m_line(wrapTo360(SAF(:,1)), SAF(:,2),'color',[0.933 0.919 0.667],'linewi',1);
    % %t3 = m_text(wrapTo360(40),-45,{'SAF'},'Fontname','helvetica','fontweight','bold','color', [0.933 0.919 0.667],'fontsize',10);
    % m_line(wrapTo360(SBDY(:,1)), SBDY(:,2),'color',[0.722, 0.525, 0.043],'linewi',1);
    % t4 = m_text(wrapTo360(-130),-70,{'SBDY'},'Fontname','helvetica','fontweight','bold','color', [0.722, 0.525, 0.043],'fontsize',10);
    % %m_line(wrapTo360(STF(:,1)), STF(:,2),'color','w','linewi',1);
    % %t5 = m_text(wrapTo360(40),-39,{'STF'},'Fontname','helvetica','fontweight','bold','color', 'w','fontsize',10);

    colors = copper(5);
    %m_line(wrapTo360(STF(:,1)), STF(:,2),'color',colors(1,:),'linewi',1);
    %t5 = m_text(wrapTo360(40),-39,{'STF'},'Fontname','helvetica','fontweight','bold','color', colors(1,:),'fontsize',10);
    %m_line(wrapTo360(SAF(:,1)), SAF(:,2),'color',colors(2,:),'linewi',1);
    %t3 =m_text(wrapTo360(40),-45,{'SAF'},'Fontname','helvetica','fontweight','bold','color', colors(2,:),'fontsize',10);
    m_line(wrapTo360(PF(:,2)), PF(:,1),'color',colors(3,:),'linewi',1);
    t1 = m_text(wrapTo360(-93),-63,{'PF'},'Fontname','helvetica','fontweight','bold','color', colors(3,:),'fontsize',10);
    m_line(wrapTo360(SACCF(:,1)), SACCF(:,2),'color',colors(4,:),'linewi',1);
    t2 = m_text(wrapTo360(-125),-64,{'SACCF'},'Fontname','helvetica','fontweight','bold','color', colors(4,:),'fontsize',10);
    m_line(wrapTo360(SBDY(:,1)), SBDY(:,2),'color',colors(5,:),'linewi',1);
    t4 = m_text(wrapTo360(-130),-71,{'SBDY'},'Fontname','helvetica','fontweight','bold','color', colors(5,:),'fontsize',10);


    m_gshhs_h('patch',[0.7 0.7 0.7],'linestyle','none');
    m_grid('xtick',[minLON:20:maxLON],'ytick',[minLAT:5:maxLAT],'box','fancy');
    set(findobj('tag','m_grid_color'),'facecolor','none')
    set(gcf,'color','w');
    axis(ax1,'off')

    %m_text(wrapTo360(-140),-77,'Antarctica','Fontname','helvetica','fontweight','bold','fontsize',14)
    m_text(wrapTo360(-185),-73,'Ross Sea','Fontname','helvetica','fontweight','bold', 'FontAngle', 'italic', 'fontsize',14)
    m_text(wrapTo360(-73),-71,'WAP','Fontname','helvetica','fontweight','bold','fontsize',10)
    m_plot(wrapTo360(s04p(:,3)),s04p(:,2),'oK','MarkerFaceColor','none','MarkerSize',3,'clipping','on', 'MarkerEdgeColor', 'k');
    w3 = find(s04p(:,1) >81 & s04p(:,1) <98);
    m_plot(wrapTo360(s04p(w3,3)),s04p(w3,2),'o','MarkerFaceColor','none','MarkerSize',3,'clipping','on', 'MarkerEdgeColor', 'g'); %just BZ
    %m_plot(i06s(:,3),i06s(:,2),'oK','MarkerFaceColor','m','MarkerSize',7,'clipping','on');

    %add date
    TT = datetime(1950,01,01, 'Format','d-MMM-y') + days(ssh.time(index)); % character vector
    m_text(wrapTo360(-95),-74, char(TT),'Fontname','helvetica','fontsize',10)

    % set colorbar
    colmp = colormap(ax1,m_colmap('diverging',100)); 
    cb = colorbar; cb.Location = 'westoutside';
    caxis([-max(max(max(ssh.sla(:,:,:)))) max(max(max(ssh.sla(:,:,:))))]);
    cb.Label.String = 'SSHa [m]';
    cb.FontName = 'helvetica';cb.FontSize = 10; %cb.FontWeight = 'bold'
    %caxis(cblimits);
    %labels = -str2num(char(cb.TickLabels));
    %cb.TickLabels = num2str(labels);
    %set(gcf, 'InvertHardCopy', 'off');
    
    %save fig
    formatSpec = 'print("G:/MS_Southern_Ocean/SSH_CHLA_figures/I06s_S04p_map_SSH_ncb_day%u", "-dpng","-r300");';
    eval(sprintf(formatSpec, index))
    close all;
end

%% B: S04p stations on top of CHLA with Orsi Fronts overlayed (parula colorbar)
% load monthly averaged CHLA data
ncdisp('G:/MS_Southern_Ocean/data/AQUA_MODIS.20171201_20171231.L3m.MO.CHL.chlor_a.4km.nc'); %view discription of data
chla.chlor_a = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20171201_20171231.L3m.MO.CHL.chlor_a.4km.nc', 'chlor_a');
chla.lat = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20171201_20171231.L3m.MO.CHL.chlor_a.4km.nc', 'lat');
chla.lon = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20171201_20171231.L3m.MO.CHL.chlor_a.4km.nc', 'lon');
chla.time = datenum(2017, 12, 01) - datenum(1950,01,01);
chla.chlor_a(:,:,2) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20180101_20180131.L3m.MO.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(2,1) = datenum(2018, 01, 01) - datenum(1950,01,01);
chla.chlor_a(:,:,3) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20180201_20180228.L3m.MO.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(3,1) = datenum(2018, 02, 01) - datenum(1950,01,01);
chla.chlor_a(:,:,4) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20180301_20180331.L3m.MO.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(4,1) = datenum(2018, 03, 01) - datenum(1950,01,01);
chla.chlor_a(:,:,5) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20180401_20180430.L3m.MO.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(5,1) = datenum(2018, 04, 01) - datenum(1950,01,01);
chla.chlor_a(:,:,6) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20180501_20180531.L3m.MO.CHL.chlor_a.4km.nc', 'chlor_a');
chla.time(6,1) = datenum(2018, 05, 01) - datenum(1950,01,01);

% %load 8 day averaged CHLA data
% ncdisp('G:/MS_Southern_Ocean/data/AQUA_MODIS.20180314_20180321.L3m.8D.CHL.chlor_a.4km.nc'); %view discription of data
% chla.chlor_a = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20180314_20180321.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.lat = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20180314_20180321.L3m.8D.CHL.chlor_a.4km.nc', 'lat');
% chla.lon = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20180314_20180321.L3m.8D.CHL.chlor_a.4km.nc', 'lon');
% chla.time = datenum(2018, 03, 17) - datenum(1950,01,01);
% chla.chlor_a(:,:,2) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20180322_20180329.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(2,1) = datenum(2018, 03, 25) - datenum(1950,01,01);
% chla.chlor_a(:,:,3) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20180330_20180406.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(3,1) = datenum(2018, 04, 02) - datenum(1950,01,01);
% chla.chlor_a(:,:,4) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20180407_20180414.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(4,1) = datenum(2018, 04, 10) - datenum(1950,01,01);
% chla.chlor_a(:,:,5) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20180415_20180422.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(5,1) = datenum(2018, 04, 18) - datenum(1950,01,01);
% chla.chlor_a(:,:,6) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20180423_20180430.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(6,1) = datenum(2018, 04, 26) - datenum(1950,01,01);
% chla.chlor_a(:,:,7) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20180501_20180508.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(7,1) = datenum(2018, 05, 04) - datenum(1950,01,01);
% chla.chlor_a(:,:,8) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20180509_20180516.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(8,1) = datenum(2018, 05, 12) - datenum(1950,01,01);

%subsample data for S04P
minLAT = -75; maxLAT = -60;
minLON = wrapTo360(-200); maxLON = wrapTo360(-60);
w = find(chla.lat>= minLAT & chla.lat<= maxLAT);
w2 = find(wrapTo360(chla.lon)>= minLON & wrapTo360(chla.lon)<= maxLON);
chla_sub.lat = chla.lat(w);
chla_sub.lon = chla.lon(w2);
chla_sub.chlor_a = chla.chlor_a(w2,w,:);
chla_sub.time = chla.time;

%% B: plot data
for index = 1:length(chla_sub.time)
    minLAT = -75;
    maxLAT = -60;
    minLON = wrapTo360(-200);
    maxLON = wrapTo360(-60);
    [PLT, PLG] = meshgrid(chla_sub.lat, chla_sub.lon); 

    fig1 = figure;
    fig1.Position = [394 399 560 180];%[488 502 560 260]; 
    ax1 = axes; %[488 488.2000 676.2000 273.8000]
    %ax1.Position = [0.070 0.1100 0.85 0.8150]; %[0.1300 0.1100 0.7750 0.8150]
    m_proj('mercator','long',[minLON maxLON],'lat',[minLAT maxLAT]);
    hold on
    %add CHLA contour
    h_pcol = m_pcolor(wrapTo360(PLG([2881:end 1:2880], :)),PLT([2881:end 1:2880], :),chla_sub.chlor_a([2881:end 1:2880], :,index)); 
    shading flat;
    %m_pcolor(wrapTo360(PLG),PLT,chla_sub.chlor_a(:,:,index)); colormap(parula); shading flat;
    Levls = [min(min(min(chla_sub.chlor_a([2881:end 1:2880], :,index)))) 0.1 0.25 0.5 0.75 1 2.5 5 7.5 10]; %0.1 0.25 0.5 0.75 1 2 3 4 5
    N_colorbins = length(Levls);
    c = parula(N_colorbins);
    colormap(c)
    C = chla_sub.chlor_a([2881:end 1:2880], :,index);

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
    %m_line(wrapTo360(STF(:,1)), STF(:,2),'color',colors(1,:),'linewi',1);
    %t5 = m_text(wrapTo360(40),-39,{'STF'},'Fontname','helvetica','fontweight','bold','color', colors(1,:),'fontsize',10);
    %m_line(wrapTo360(SAF(:,1)), SAF(:,2),'color',colors(2,:),'linewi',1);
    %t3 =m_text(wrapTo360(40),-45,{'SAF'},'Fontname','helvetica','fontweight','bold','color', colors(2,:),'fontsize',10);
    m_line(wrapTo360(PF(:,2)), PF(:,1),'color',colors(3,:),'linewi',1);
    t1 = m_text(wrapTo360(-93),-63,{'PF'},'Fontname','helvetica','fontweight','bold','color', colors(3,:),'fontsize',10);
    m_line(wrapTo360(SACCF(:,1)), SACCF(:,2),'color',colors(4,:),'linewi',1);
    t2 = m_text(wrapTo360(-125),-64,{'SACCF'},'Fontname','helvetica','fontweight','bold','color', colors(4,:),'fontsize',10);
    m_line(wrapTo360(SBDY(:,1)), SBDY(:,2),'color',colors(5,:),'linewi',1);
    t4 = m_text(wrapTo360(-130),-71,{'SBDY'},'Fontname','helvetica','fontweight','bold','color', colors(5,:),'fontsize',10);

    m_gshhs_h('patch',[0.7 0.7 0.7],'linestyle','none');
    m_grid('xtick',[minLON:20:maxLON],'ytick',[minLAT:5:maxLAT],'box','fancy');
    set(findobj('tag','m_grid_color'),'facecolor','none')
    set(gcf,'color','w');
    axis(ax1,'off')

    %m_text(wrapTo360(-140),-77,'Antarctica','Fontname','helvetica','fontweight','bold','fontsize',14)
    m_text(wrapTo360(-185),-73,'Ross Sea','Fontname','helvetica','fontweight','bold', 'FontAngle', 'italic', 'fontsize',14)
    m_text(wrapTo360(-73),-71,'WAP','Fontname','helvetica','fontweight','bold','fontsize',10)
    m_plot(wrapTo360(s04p(:,3)),s04p(:,2),'o','MarkerFaceColor','none','MarkerSize',3,'clipping','on', 'MarkerEdgeColor', 'r');
    w3 = find(s04p(:,1) >81 & s04p(:,1) <98);
    m_plot(wrapTo360(s04p(w3,3)),s04p(w3,2),'o','MarkerFaceColor','none','MarkerSize',3,'clipping','on', 'MarkerEdgeColor', [1 153/255 204/255]); %just BZ
    %m_plot(i06s(:,3),i06s(:,2),'oK','MarkerFaceColor','m','MarkerSize',7,'clipping','on',);

    %add date
    %TT = datetime(1950,01,01, 'Format','d-MMM-y') + days(chla_sub.time(index)); % character vector
    TT = datetime(1950,01,01, 'Format','MMM y') + days(chla_sub.time(index)); % character vector
    m_text(wrapTo360(-95),-74, char(TT),'Fontname','helvetica','fontsize',10)

    % set colorbar
    colmp = colormap(ax1); %,m_colmap('jet',100)); 
    cb = colorbar; cb.Location = 'westoutside'; %set(ax1,'ColorScale','log');
    %caxis([min(min(min(chla_sub.chlor_a(:,:,:)))) max(max(max(chla_sub.chlor_a(:,:,:))))]);
    %set(cb,'YTick',[10^-1, 10^0, 10^1])
    scale = (cb.Limits(2)-cb.Limits(1))/10;
    cb.YTick = [cb.Limits(1) cb.Limits(1)+scale cb.Limits(1)+2*scale cb.Limits(1)+3*scale ...
        cb.Limits(1)+4*scale cb.Limits(1)+5*scale cb.Limits(1)+6*scale cb.Limits(1)+7*scale ...
        cb.Limits(1)+8*scale cb.Limits(1)+9*scale cb.Limits(2)]; 
    set(cb,'yticklabel',{'', '0.1', '0.25','0.5', '0.75', '1', '2.5', '5', '7.5', '10', ''}); %{'', '0.1', '0.25','0.5', '0.75', '1', '2', '3', '4', '5', ''}

    cb.Label.String = 'Chla [\mug/l]';
    cb.FontName = 'helvetica';cb.FontSize = 10; %cb.FontWeight = 'bold'
    %cb.TickLabels = {'0.1', '1', '10'}; %fix this if there is a different colorbar for other slides
    %caxis(cblimits);
    %labels = -str2num(char(cb.TickLabels));
    %cb.TickLabels = num2str(labels);
    %set(gcf, 'InvertHardCopy', 'off');
    
    %save fig
    %formatSpec ='print("G:/MS_Southern_Ocean/SSH_CHLA_figures/S04p_map_chla_ncb_day%u", "-dpng","-r300");'; %use this for 8-day average
    formatSpec = 'print("G:/MS_Southern_Ocean/SSH_CHLA_figures/S04p_map_chla_ncb_month%u", "-dpng","-r300");'; %use this for monthly
    eval(sprintf(formatSpec, index))
    close all;
end

%% %C: I06S stations on top of SSH with Orsi Fronts overlayed (blue to white to red colorbar)

%Load data
%ncdisp('G:/MS_Southern_Ocean/data/c3s_obs-sl_glo_phy-ssh_my_twosat-l4-duacs-0.25deg_P1D_1704998477168.nc'); %view discription of data

ssh.lat = ncread('G:/MS_Southern_Ocean/data/c3s_obs-sl_glo_phy-ssh_my_twosat-l4-duacs-0.25deg_P1D_1704998477168.nc','latitude'); 
ssh.lon = ncread('G:/MS_Southern_Ocean/data/c3s_obs-sl_glo_phy-ssh_my_twosat-l4-duacs-0.25deg_P1D_1704998477168.nc','longitude'); 
ssh.time = ncread('G:/MS_Southern_Ocean/data/c3s_obs-sl_glo_phy-ssh_my_twosat-l4-duacs-0.25deg_P1D_1704998477168.nc','time'); 
ssh.sla = ncread('G:/MS_Southern_Ocean/data/c3s_obs-sl_glo_phy-ssh_my_twosat-l4-duacs-0.25deg_P1D_1704998477168.nc','sla'); 

%% Plot Figure
for index = 1:length(ssh.time)
    minLAT = -72; maxLAT = -30;
    minLON = wrapTo360(20); maxLON = wrapTo360(40);
    [PLT, PLG] = meshgrid(ssh.lat-0.25, ssh.lon-0.25); 

    fig1 = figure;
    fig1.Position = [1086 108 284 660]; %[1215 297 250 466];
    ax1 = axes; ax1.Position = [0.15 0.1100 0.7 0.8150]; %[0.1010 0.1100 0.6019 0.8150]; 
    m_proj('mercator','long',[minLON maxLON],'lat',[minLAT maxLAT]);
    hold on
    %add SSH contour
    m_pcolor(wrapTo360(PLG),PLT,ssh.sla(:,:,index)); colormap(parula); %shading flat;
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
    m_plot(i06s(:,3),i06s(:,2),'ok','MarkerFaceColor','none','MarkerSize',3,'clipping','on', 'MarkerEdgeColor', 'k');
    w3 = find(i06s(:,1) >23 & i06s(:,1) <34);
    m_plot(wrapTo360(i06s(w3,3)),i06s(w3,2),'o','MarkerFaceColor','none','MarkerSize',3,'clipping','on', 'MarkerEdgeColor', 'g'); %just BZ


    %add date
    TT = datetime(1950,01,01, 'Format','d-MMM-y') + days(ssh.time(index)); % character vector
    m_text(21,-69, char(TT),'Fontname','helvetica','fontsize',10)

    % set colorbar
    colmp = colormap(ax1,m_colmap('diverging',100)); 
    cb = colorbar; cb.Location = 'eastoutside';
    caxis([-max(max(max(ssh.sla(:,:,:)))) max(max(max(ssh.sla(:,:,:))))]);
    cb.Label.String = 'SSHa [m]';
    cb.FontName = 'helvetica';cb.FontSize = 10; %cb.FontWeight = 'bold'
    %caxis(cblimits);      
    %labels = -str2num(char(cb.TickLabels));
    %cb.TickLabels = num2str(labels);
    %set(gcf, 'InvertHardCopy', 'off');

    %save fig
    formatSpec = 'print("G:/MS_Southern_Ocean/SSH_CHLA_figures/I06s_map_SSH_ncb_day%u", "-dpng","-r300");';
    eval(sprintf(formatSpec, index))
    close all;
end

%% %D: I06S stations on top of CHLA with Orsi Fronts overlayed (parula colorbar)
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

% % Load 8-day average chla data
% ncdisp('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181203_20181210.L3m.8D.CHL.chlor_a.4km.nc'); %view discription of data
% chla.chlor_a = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181203_20181210.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.lat = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181203_20181210.L3m.8D.CHL.chlor_a.4km.nc', 'lat');
% chla.lon = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181203_20181210.L3m.8D.CHL.chlor_a.4km.nc', 'lon');
% chla.time = datenum(2018, 12, 06) - datenum(1950,01,01);
% chla.chlor_a(:,:,2) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181211_20181218.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(2,1) = datenum(2019, 12, 14) - datenum(1950,01,01);
% chla.chlor_a(:,:,3) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181219_20181226.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(3,1) = datenum(2019, 12, 22) - datenum(1950,01,01);
% chla.chlor_a(:,:,4) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20181227_20181231.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(4,1) = datenum(2019, 12, 29) - datenum(1950,01,01);
% chla.chlor_a(:,:,5) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190101_20190108.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(5,1) = datenum(2019, 01, 04) - datenum(1950,01,01);
% chla.chlor_a(:,:,6) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190109_20190116.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(6,1) = datenum(2019, 01, 12) - datenum(1950,01,01);
% chla.chlor_a(:,:,7) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190117_20190124.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(7,1) = datenum(2019, 01, 20) - datenum(1950,01,01);
% chla.chlor_a(:,:,8) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190125_20190201.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(8,1) = datenum(2019, 01, 28) - datenum(1950,01,01);
% chla.chlor_a(:,:,9) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190202_20190209.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(9,1) = datenum(2019, 02, 05) - datenum(1950,01,01);
% chla.chlor_a(:,:,10) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190210_20190217.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(10,1) = datenum(2019, 02, 13) - datenum(1950,01,01);
% chla.chlor_a(:,:,11) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190218_20190225.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(11,1) = datenum(2019, 02, 21) - datenum(1950,01,01);
% chla.chlor_a(:,:,12) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190226_20190305.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(12,1) = datenum(2019, 03, 01) - datenum(1950,01,01);
% chla.chlor_a(:,:,13) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190306_20190313.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(13,1) = datenum(2019, 03, 09) - datenum(1950,01,01);
% chla.chlor_a(:,:,14) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190314_20190321.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(14,1) = datenum(2019, 03, 17) - datenum(1950,01,01);
% chla.chlor_a(:,:,15) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190322_20190329.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(15,1) = datenum(2019, 03, 25) - datenum(1950,01,01);
% chla.chlor_a(:,:,16) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190330_20190406.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(16,1) = datenum(2019, 04, 02) - datenum(1950,01,01);
% chla.chlor_a(:,:,17) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190407_20190414.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(17,1) = datenum(2019, 04, 10) - datenum(1950,01,01);
% chla.chlor_a(:,:,18) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190415_20190422.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(18,1) = datenum(2019, 04, 18) - datenum(1950,01,01);
% chla.chlor_a(:,:,19) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190423_20190430.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(19,1) = datenum(2019, 04, 26) - datenum(1950,01,01);
% chla.chlor_a(:,:,20) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190501_20190508.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(20,1) = datenum(2019, 05, 04) - datenum(1950,01,01);
% chla.chlor_a(:,:,21) = ncread('G:/MS_Southern_Ocean/data/AQUA_MODIS.20190509_20190516.L3m.8D.CHL.chlor_a.4km.nc', 'chlor_a');
% chla.time(21,1) = datenum(2019, 05, 12) - datenum(1950,01,01);

%subsample data for I06s
minLAT = -72; maxLAT = -30;
minLON = wrapTo360(20); maxLON = wrapTo360(40);
w = find(chla.lat>= minLAT & chla.lat<= maxLAT);
w2 = find(chla.lon>= minLON & wrapTo360(chla.lon)<= maxLON);
chla_sub.lat = chla.lat(w);
chla_sub.lon = chla.lon(w2);
chla_sub.chlor_a = chla.chlor_a(w2,w,:);
chla_sub.time = chla.time;

%% Plot Figure
for index = 1:length(chla.time)
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
    Levls = [min(min(min(chla_sub.chlor_a(:,:,index)))) 0.1 0.25 0.5 0.75 1 2.5 5 7.5 10]; % 0.1 0.25 0.5 0.75 1 2 3 4 5
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
    w3 = find(i06s(:,1) >23 & i06s(:,1) <34);
    m_plot(wrapTo360(i06s(w3,3)),i06s(w3,2),'o','MarkerFaceColor','none','MarkerSize',3,'clipping','on', 'MarkerEdgeColor', 'g'); %just BZ


    %add date
    %TT = datetime(1950,01,01, 'Format','d-MMM-y') + days(chla_sub.time(index)); % character vector
    TT = datetime(1950,01,01, 'Format','MMM y') + days(chla_sub.time(index)); % character vector
    m_text(21,-69, char(TT),'Fontname','helvetica','fontsize',10, 'color', 'r')

    % set colorbar
    colmp = colormap(ax1); %,m_colmap('diverging',100)); 
    cb = colorbar; cb.Location = 'eastoutside';%set(ax1,'ColorScale','log');
    scale = (cb.Limits(2)-cb.Limits(1))/10;
    cb.YTick = [cb.Limits(1) cb.Limits(1)+scale cb.Limits(1)+2*scale cb.Limits(1)+3*scale ...
    cb.Limits(1)+4*scale cb.Limits(1)+5*scale cb.Limits(1)+6*scale cb.Limits(1)+7*scale ...
    cb.Limits(1)+8*scale cb.Limits(1)+9*scale cb.Limits(2)]; 
    set(cb,'yticklabel',{'', '0.1', '0.25','0.5', '0.75', '1', '2.5', '5', '7.5', '10', ''}); %{'', '0.1', '0.25','0.5', '0.75', '1', '2', '3', '4', '5', ''}


    %caxis([min(min(min(chla_sub.chlor_a(:,:,:)))) max(max(max(chla_sub.chlor_a(:,:,:))))]);
    cb.Label.String = 'Chla [\mug/l]';
    cb.FontName = 'helvetica';cb.FontSize = 10; %cb.FontWeight = 'bold'
    %cb.TickLabels = {'0.01', '0.1', '1', '10'}; %fix this if there is a different colorbar for other slides
    %caxis(cblimits);      
    %labels = -str2num(char(cb.TickLabels));
    %cb.TickLabels = num2str(labels);
    %set(gcf, 'InvertHardCopy', 'off');

    %save fig
    %formatSpec = 'print("G:/MS_Southern_Ocean/SSH_CHLA_figures/I06s_map_CHLA_ncb_day%u", "-dpng","-r300");';
    formatSpec = 'print("G:/MS_Southern_Ocean/SSH_CHLA_figures/I06s_map_CHLA_ncb_ystn_month_%u", "-dpng","-r300");';
    eval(sprintf(formatSpec, index))
    close all;
end