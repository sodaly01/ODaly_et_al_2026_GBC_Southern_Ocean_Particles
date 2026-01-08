%make a map with I06S stations and S04P stations plotted and ORSI front
%lines marked
close all; clear all;

addpath('G:\MATLAB\seawater_ver3_3.1')
addpath('G:\MATLAB\m_map')
addpath('G:\Cruises\2018_S04P')

par_s04p = load('G:\Cruises\2018_S04P\uvp5_sn207_2018_s04p_ecotaxa_export_par2_filtered_AOU_fluor_sitecorrect_flux_loncorr.mat');
load('S04Ptransectmain.mat')
par_i06s = load('G:\Cruises\2019_I06S\uvp5_sn207_2019_i06s_tcn322_ecotaxa_export_par2_AOU_fluor_flux_corr.mat');

%load ORSI fronts data
load('G:\MATLAB\PF_circle.mat')
load('G:\MATLAB\SACCF_circle.mat')
load('G:\MATLAB\SAF_circle.mat')
load('G:\MATLAB\SBDY_circle.mat')
load('G:\MATLAB\STF_circle')
%make a seperate STF file so that the line doesn't connect across South America
STF_west = [STF(1:59, :); [-72,-30.4000000000000]];

%resave these files to have the first number also be the last%%%

s04p = [];
for in = 1:length(S04Ptransectmain)
    w1 = strcmp(par_s04p.par.profile,S04Ptransectmain(in));
    w2 = find(w1 == 1);
    s04p(in,1) = par_s04p.par.site(w2(1));
    s04p(in,2) = par_s04p.par.latitude(w2(1));
    s04p(in,3) = par_s04p.par.longitude(w2(1));
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

fig1 = figure;
fig1.Position = [1974 330 737 596];
ax1 = axes;
%ax1.Position = [0.1700 0.0500 0.85 0.90];
m_proj('Azimuthal Equidistant','lon',wrapTo360(-10),'lat',-60,'rec','on'); %,'lat',[minLAT maxLAT],'lon',[minLON maxLON],'rect','on');
m_elev('contourf', 100,'edgecolor','none')
hold on
 m_gshhs_l('patch',[0.7 0.7 0.7],'linestyle','none');
m_grid('xtick', 9,'ytick', 8,'fontsize', 14);
m_plot(s04p(:,3),s04p(:,2),'oK','MarkerFaceColor','g','MarkerSize',7,'clipping','on');
m_plot(i06s(:,3),i06s(:,2),'oK','MarkerFaceColor','m','MarkerSize',7,'clipping','on');
m_text(wrapTo360(20),-13,'Africa','Fontname','helvetica','fontweight','bold','fontsize',14)
m_text(wrapTo360(-60),-5,{'South';'America'},'Fontname','helvetica','fontweight','bold','fontsize',14)
m_text(wrapTo360(-80),-80,'Antarctica','Fontname','helvetica','fontweight','bold','fontsize',14)
m_text(wrapTo360(-25),-20,{'Atlantic';'Ocean'},'Fontname','helvetica','fontweight','bold','fontangle','italic','fontsize',14)
%m_text(wrapTo360(-80),-80,{'Southern';'Ocean'},'Fontname','helvetica','fontweight','bold','fontangle','italic','fontsize',14)
m_line(wrapTo360(PF(:,2)), PF(:,1),'color',[0.894 0.779 0.396],'linewi',1);
t1 = m_text(wrapTo360(40),-50,{'PF'},'Fontname','helvetica','fontweight','bold','color', [0.894 0.779 0.396],'fontsize',10);
set(t1,'Rotation',310);
m_line(wrapTo360(SACCF(:,1)), SACCF(:,2),'color',[0.855 0.674 0.125],'linewi',1);
t2 = m_text(wrapTo360(40),-56,{'SACCF'},'Fontname','helvetica','fontweight','bold','color', [0.855 0.674 0.125],'fontsize',10);
set(t2,'Rotation',300);
m_line(wrapTo360(SAF(:,1)), SAF(:,2),'color',[0.933 0.919 0.667],'linewi',1);
t3 = m_text(wrapTo360(40),-45,{'SAF'},'Fontname','helvetica','fontweight','bold','color', [0.933 0.919 0.667],'fontsize',10);
set(t3,'Rotation',310);
m_line(wrapTo360(SBDY(:,1)), SBDY(:,2),'color',[0.722, 0.525, 0.043],'linewi',1);
t4 = m_text(wrapTo360(40),-67,{'SBDY'},'Fontname','helvetica','fontweight','bold','color', [0.722, 0.525, 0.043],'fontsize',10);
set(t4,'Rotation',300);
m_line(wrapTo360(STF(:,1)), STF(:,2),'color','w','linewi',1);
t5 = m_text(wrapTo360(40),-39,{'STF'},'Fontname','helvetica','fontweight','bold','color', 'w','fontsize',10);
set(t5,'Rotation',310);

%add station labels
%t6 = m_text(s04p(:,3),s04p(:,2)-0.5,string(s04p(:,1)),'Fontname','helvetica','fontweight','bold','color', 'w','fontsize',10);
%t7 = m_text(i06s(:,3)-1,i06s(:,2),string(i06s(:,1)),'Fontname','helvetica','fontweight','bold','color', 'w','fontsize',10);

ylabel('Latitide','Fontname','helvetica','fontweight','bold','fontsize',14)
xlabel('Longitude','Fontname','helvetica','fontweight','bold','fontsize',14)
set(gca,'ydir','normal')
% set colorbar for bathymetry
colmp = colormap(ax1,m_colmap('blues',100)); 
cb = colorbar;
cblimits = [-6000 0];
cb.Limits = cblimits;
cb.Label.String = 'Bathymetry [m]';
cb.FontAngle = 'italic';cb.FontName = 'helvetica'; cb.FontWeight = 'bold';cb.FontSize = 14;
caxis(cblimits);
labels = -str2num(char(cb.TickLabels));
cb.TickLabels = num2str(labels);
set(gcf, 'InvertHardCopy', 'off');

print('-dpng','-r300','I06s_S04p_map')


%% Center of map at south pole
fig1 = figure;
fig1.Position = [367 130 738 595];
ax1 = axes;
m_proj('Azimuthal Equidistant','lon',wrapTo360(45),'lat',-90,'rec','on'); 
m_elev('contourf', 100,'edgecolor','none')
hold on
m_gshhs_l('patch',[0.7 0.7 0.7],'linestyle','none');
m_grid('xtick', 9,'ytick', 8,'fontsize', 14);
m_plot(s04p(:,3),s04p(:,2),'oK','MarkerFaceColor','g','MarkerSize',7,'clipping','on');
m_plot(i06s(:,3),i06s(:,2),'oK','MarkerFaceColor','m','MarkerSize',7,'clipping','on');
m_text(wrapTo360(18),-24,'Africa','Fontname','helvetica','fontweight','bold','fontsize',14)
m_text(wrapTo360(-62),-25,{'South';'America'},'Fontname','helvetica','fontweight','bold','fontsize',14)
m_text(wrapTo360(0),-80,'Antarctica','Fontname','helvetica','fontweight','bold','fontsize',14)
t = m_text(wrapTo360(125),-28,'Australia','Fontname','helvetica','fontweight','bold','fontsize',14);
set(t, 'Rotation', 270);
m_text(wrapTo360(-25),-25,{'Atlantic';'Ocean'},'Fontname','helvetica','fontweight','bold','fontangle','italic','fontsize',14)
m_text(wrapTo360(80),-35,{'Indian';'Ocean'},'Fontname','helvetica','fontweight','bold','fontangle','italic','fontsize',14)
m_text(wrapTo360(-125),-32,{'Pacific Ocean'},'Fontname','helvetica','fontweight','bold','fontangle','italic','fontsize',14)
%add ORSI Fronts
colors = copper(5);
m_line(wrapTo360(STF_west(:,1)), STF_west(:,2),'color',colors(1,:),'linewi',1);
m_line(wrapTo360(STF([60:end 1],1)), STF([60:end 1],2),'color',colors(1,:),'linewi',1);
t5 = m_text(wrapTo360(40),-39,{'STF'},'Fontname','helvetica','fontweight','bold','color', colors(1,:),'fontsize',10);
m_line(wrapTo360(SAF(:,1)), SAF(:,2),'color',colors(2,:),'linewi',1);
t3 = m_text(wrapTo360(40),-45,{'SAF'},'Fontname','helvetica','fontweight','bold','color', colors(2,:),'fontsize',10);
m_line(wrapTo360(PF(:,2)), PF(:,1),'color',colors(3,:),'linewi',1);
t1 = m_text(wrapTo360(40),-50,{'PF'},'Fontname','helvetica','fontweight','bold','color', colors(3,:),'fontsize',10);
m_line(wrapTo360(SACCF(:,1)), SACCF(:,2),'color',colors(4,:),'linewi',1);
t2 = m_text(wrapTo360(40),-56,{'SACCF'},'Fontname','helvetica','fontweight','bold','color', colors(4,:),'fontsize',10);
m_line(wrapTo360(SBDY(:,1)), SBDY(:,2),'color',colors(5,:),'linewi',1);
t4 = m_text(wrapTo360(40),-67,{'SBDY'},'Fontname','helvetica','fontweight','bold','color', colors(5,:),'fontsize',10);

%add frontal zone labels
t6 = m_text(wrapTo360(82),-65,{'Subpolar'},'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',10);
set(t6, 'Rotation', 310);
t62 = m_text(wrapTo360(120),-65,{'Region'},'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',10);
set(t62, 'Rotation', 270);
t7 = m_text(wrapTo360(82),-60,{'Southern'},'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',10);
set(t7, 'Rotation', 310);
t72 = m_text(wrapTo360(114),-60,{'Zone'},'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',10);
set(t72, 'Rotation', 270);
t8 = m_text(wrapTo360(86),-53,{'Antarctic'},'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',10);
set(t8, 'Rotation', 300);
t82 = m_text(wrapTo360(112),-56,{'Zone'},'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',10);
set(t82, 'Rotation', 280);
t9 = m_text(wrapTo360(84),-49,{'Polar'},'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',10);
set(t9, 'Rotation', 310);
t92 = m_text(wrapTo360(98),-50,{'Frontal'},'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',10);
set(t92, 'Rotation', 295);
t93 = m_text(wrapTo360(118),-52,{'Zone'},'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',10);
set(t93, 'Rotation', 275);
t10 = m_text(wrapTo360(84),-43,{'Subantarctic'},'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',10);
set(t10, 'Rotation', 305);
t102 = m_text(wrapTo360(112),-45,{'Zone'},'Fontname','helvetica','fontweight','bold','color', 'k','fontsize',10);
set(t102, 'Rotation', 285);

%add station labels
%t6 = m_text(s04p(:,3),s04p(:,2)-0.5,string(s04p(:,1)),'Fontname','helvetica','fontweight','bold','color', 'w','fontsize',10);
%t7 = m_text(i06s(:,3)-1,i06s(:,2),string(i06s(:,1)),'Fontname','helvetica','fontweight','bold','color', 'w','fontsize',10);

%ylabel('Latitide','Fontname','helvetica','fontweight','bold','fontsize',14)
%xlabel('Longitude','Fontname','helvetica','fontweight','bold','fontsize',14)
set(gca,'ydir','normal')
% set colorbar for bathymetry
colmp = colormap(ax1,m_colmap('blues',100)); 
cb = colorbar;
cblimits = [-6000 0];
cb.Limits = cblimits;
cb.Label.String = 'Bathymetry [m]';
cb.FontAngle = 'italic';cb.FontName = 'helvetica'; cb.FontWeight = 'bold';cb.FontSize = 14;
caxis(cblimits);
labels = -str2num(char(cb.TickLabels));
cb.TickLabels = num2str(labels);
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'color','w')

print('-dpng','-r300','G:/MS_Southern_Ocean/Figures/I06s_S04p_map_centered_no_station_fronts_zones_25Sept2025')
