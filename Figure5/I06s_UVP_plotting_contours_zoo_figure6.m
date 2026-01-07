%contour plots of I06s zoo data
clear all; close all;
%load data- UVP par file and CTD data, stations, map to tools
%load('G:/Cruises/2019_I06S/uvp5_sn207_2019_i06s_tcn322_ecotaxa_export_par2.mat'); 
load('G:\Cruises\2019_I06S\uvp5_sn207_2019_i06s_tcn322_ecotaxa_export_par2_AOU_fluor_flux_corr')
%load('G:/Cruises/2019_I06S/uvp5_sn207_2019_i06s_tcn322_ecotaxa_export_par.mat'); %I think they're the same
%load('G:\MS_Southern_Ocean\data\zoo_i06s_val_pred.mat')
%load('G:\MS_Southern_Ocean\data\zoo_i06s_val_photo_no_fiber_3Apr2024.mat')
load('G:\MS_Southern_Ocean\data\zoo_i06s_val_photo_no_fiber_5Sept2024_corr.mat')

stations = unique(zoo.site)'; 
addpath('G:\MATLAB\seawater_ver3_3.1')
addpath('G:\MATLAB\m_map'); addpath('G:\MATLAB\textborder');

%pull out lat and long from each station location
for in = 1:length(stations)
   w=find(zoo.site == stations(in));
   lat_lon(in,1) = zoo.latitude(w(1));
   lat_lon(in,2) = wrapTo360(zoo.longitude(w(1)));
   %find bottom depth in each sample
   bottom_depth(in,1) = zoo.Depth(w(end));
end
lat_lon = sortrows(lat_lon, 1); %sort so lat is from min to max, added on 5/13/2025
%Interpolate between stations to 5KM resolution
lat = interp1([1:length(lat_lon(:,1))]',lat_lon(:,1), linspace(1,42, 630)); 
long = interp1([1:length(lat_lon(:,2))]',lat_lon(:,2), linspace(1,42, 630));
% lat = interp(lat_lon(:,1),15);
% long = interp(lat_lon(:,2),15);
%download bathy file from etopo2
%[ELEV,LONG,LAT]=m_etopo2([lat_lon(1,2) lat_lon(end,2) lat_lon(1,1) lat_lon(end,1)]);
%[ELEV,LONG,LAT]=m_etopo2([lat_lon(end,2) lat_lon(1,2) lat_lon(1,1) lat_lon(end,1)]);
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

%% Define categories, plot types and labels
% I06s val categories for Figure 5 in manuscript

categories = {'Fluffy_agg'; 'Dense_agg'; 'Fiber'; 'Feces'; 'Photosynthetic';...
    'Rhizaria_harosa'; 'Arthro_crustacea'; 'Gelatinous'}; 

plot_types = {'_M_3'; '_mm3L_1'; '_mm'; '_grey';};

color_bar_label = {'Total Particle Abundance (# m^-^3)'; 'Total Particle Biovolume (mm^3 L^-^1)';...
    'Average Particle Size (mm)'; 'Mean Grey Level'};

sublet = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'}; 

%% Plot: make a multipaneled plot with the summary detritus/living categories
for index2 = 1%:length(plot_types) %loop over four plot types (concentration, biov, mean size, and grey)
    for index3 = 3 %first linear color bar, second logrithmic color bar
        fig2 = figure;
        set(fig2, 'Units', 'inches', 'Position', [0.4417 0.6167 7.67 7.8]) %+0.9
        for index1 = 1:8 %loop through desired categories of particles
            if (index3 == 3)
                %log base 2 color bar
                category = char(categories(index1));
                plot_type = char(plot_types(index2));
                logrithmic = 0; linear = 0;
                w = ismember(zoo.site, stations);
                formatSpec = 'value = zoo.%s%s;';
                eval(sprintf(formatSpec, category, plot_type))
%                 cmap_bins_long = [2^0 2^1 2^2 2^3 2^4 2^5 2^6 2^7 2^8 2^9 2^10 2^11 2^12 2^13 2^14 2^15];
%                 cmap_bins_location = [cmap_bins_long>min(value(w)) & cmap_bins_long<max(value(w))]; %remove bins that are too small
%                 cmap_bins = cmap_bins_long(cmap_bins_location);
%                 %cmap_sml_loc = cmap_bins_long>min(value(w)); cmap_sml_loc = ~cmap_sml_loc; cmap_sml = cmap_bins_long(cmap_sml_loc);
%                 cmap_big_loc = cmap_bins_long<max(value(w)); cmap_big_loc = ~cmap_big_loc; cmap_big = cmap_bins_long(cmap_big_loc);
%                 cmap_bins = [cmap_bins cmap_big(1)];
                if index1 == 1
                    cmap_bins = [min(value(w)) 10 25 50 75 100 250 500 750 1000 2500 max(value(w))]; 
                end
                if index1 == 2 || index1 == 4
                    cmap_bins = [min(value(w)) 5 10 15 20 25 50 75 100 250 500 max(value(w))];
                end
                if index1 == 3 || index1 == 5 || index1 == 6 || index1 == 7 || index1 == 8
                    cmap_bins = [min(value(w)) 1 2 3 4 5 10 15 20 30 40 max(value(w))];
                end
%                 if index1 == 7 || index1 == 8
%                     cmap_bins = [min(value(w)) 5 10 15 20 25 30 40 50 75 100 max(value(w))];
%                 end
%                 if index1 == 7 || index1 == 8
%                     cmap_bins = [min(value(w)) 5 10 15 20 25 50 75 100 200 300 max(value(w))];
%                 end
                N_colorbins = length(cmap_bins);
                y = 0:N_colorbins-1;
                dtr = interp1(cmap_bins, y, value(w));
            end

            %plot UVP data over longitude with colorbar created
            zbin = min(par.Depth(w)):5:max(par.Depth(w)); %zbin = 0:5:max(par.Depth(w));  %EDITED 3/18/25
            lat_axes = min(zoo.latitude(w)) :0.1: max(zoo.latitude(w));
            [X1,Y1] = meshgrid(lat_axes,zbin);
            var_data=griddata(zoo.latitude(w),zoo.Depth(w),dtr,X1,Y1);
            w2=find(var_data == min(min(var_data))); %EDITED 3/18/25
            var_data(w2) = min(dtr);%EDITED 3/18/25
            w2=find(var_data == max(max(var_data)));%EDITED 3/18/25
            var_data(w2) = max(dtr);%EDITED 3/18/25
            clear w2;%EDITED 3/18/25
            
            ax2 = axes;
            if index1 == 1
                set(ax2, 'Units', 'inches', 'Position', [0.45 5.94 3.36 1.75]) 
            elseif index1 == 2
                set(ax2, 'Units', 'inches', 'Position', [4.08 5.94 3.36 1.75])
            elseif index1 == 3
                set(ax2, 'Units', 'inches', 'Position', [0.45 4.19 3.36 1.75])
            elseif index1 == 4
                set(ax2, 'Units', 'inches', 'Position', [4.08 4.19 3.36 1.75])
            elseif index1 == 5
                set(ax2, 'Units', 'inches', 'Position', [0.45 2.44 3.36 1.75]) 
            elseif index1 == 6
                set(ax2, 'Units', 'inches', 'Position', [4.08 2.44 3.36 1.75])
            elseif index1 == 7
                set(ax2, 'Units', 'inches', 'Position', [0.45 0.5 3.36 1.94]) 
            elseif index1 == 8
                set(ax2, 'Units', 'inches', 'Position', [4.08 0.5 3.36 1.94])
            end
            
            [C,h] = contourf(X1, Y1, var_data); 
            c = parula(N_colorbins - 1);
            colormap(c)
            set(h, 'LineColor', 'none');
            hold on
            
%             %label stations
%             plot(ax2,unique(zoo.latitude(w)),zeros([1 length(unique(zoo.latitude(w)))]),'k^','MarkerSize',5);
%             temp4 = unique(zoo.latitude(w));
%             ax2.YDir = 'reverse';
%             ylabel('Depth (m)', 'fontname', 'helvetica','fontweight','bold','fontsize', 14);
%             xlabel('Latitude', 'fontname', 'helvetica','fontweight','bold','fontsize', 14);
%             rectangle('Position',[-67 0 3 6000], 'FaceColor', 'w', 'EdgeColor', 'none')
%             rectangle('Position',[-49.983 0 11.4837  6000], 'FaceColor', 'w', 'EdgeColor', 'none')
%             xticks([-65 -60 -55 -50 -45 -40 -35]);
%             xticklabels({'65^oS','60^oS','55^oS','50^oS','45^oS','40^oS','35^oS'});
%             xtickangle(30);
            
            if index1 == 1 || index1 == 2
                plot(ax2,unique(zoo.latitude(w)),zeros([1 length(unique(zoo.latitude(w)))]),'r|','MarkerSize',4);
            end
            temp4 = unique(zoo.latitude(w));
            ax2.YDir = 'reverse';
            %bathymetry
            p = patch([lat lat(end) lat(1)], [elevation.*-1 6000 6000],'k');
            set(p, 'facecolor',[0.5 0.5 0.5], 'edgecolor', [0.5 0.5 0.5]);

            %plot MLD
            plot(stn_lat_mld_pt(:,2), stn_lat_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);

            rectangle('Position',[-67 0 3 6000], 'FaceColor', 'w', 'EdgeColor', 'none')
            rectangle('Position',[-49.983 0 11.4837  6000], 'FaceColor', 'w', 'EdgeColor', 'none')
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
            space = (cblh.Limits(2) - cblh.Limits(1))/(length(cmap_bins)-1);
            tick_marks = [];
            for in_ytick = flip(1:length(cmap_bins))
               tick_marks = [tick_marks cblh.Limits(2)-((in_ytick-1)*space)];
            end
            cblh.YTick = tick_marks;
            set(cblh, 'YTickLabel', cmap_bins);
            %colorbar_type = 'log2';
            colorbar_type = 'manual';
            if index1 == 1 
            cblh.YTick = [0 1 2 3 4 5 6 7 8 9 10 11]; 
            set(cblh,'yticklabel',{'0', '10', '25','50', '75', '100', '250', '500', '750', '1000', '2500', ''});
            end
            if index1 == 2 || index1 == 4
            cblh.YTick = [0 1 2 3 4 5 6 7 8 9 10 11]; 
            set(cblh,'yticklabel',{'0','5', '10','15','20', '25','50', '75', '100', '250', '500', ''});
            end
            if index1 == 3 || index1 == 5 || index1 == 6 || index1 == 7 || index1 == 8
                cblh.YTick = [0 1 2 3 4 5 6 7 8 9 10 11]; 
                set(cblh,'yticklabel',{'0','1', '2','3','4', '5','10', '15', '20', '30', '40', ''});
            end
%             if index1 == 7 || index1 == 8
%                 cblh.YTick = [0 1 2 3 4 5 6 7 8 9 10 11]; 
%                 cmap_bins = [min(value(w)) 5 10 15 20 25 30 40 50 75 100 max(value(w))];
%                 set(cblh,'yticklabel',{'0','5', '10','15','20', '25','30', '40', '50', '75', '100', ''});
%             end
%             if index1 == 7 || index1 == 8
%                 cblh.YTick = [0 1 2 3 4 5 6 7 8 9 10 11]; 
%                 cmap_bins = [min(value(w)) 5 10 15 20 25 50 75 100 200 300 max(value(w))];
%                 set(cblh,'yticklabel',{'0','3', '10','15','20', '25','50', '75', '100', '200', '300', ''});
%             end
%             space = 2*(cblh.Limits(2) - cblh.Limits(1))/20;
%             cblh.YTick = [cblh.Limits(2)-10*space cblh.Limits(2)-9*space cblh.Limits(2)-8*space cblh.Limits(2)-7*space cblh.Limits(2)-6*space cblh.Limits(2)-5*space ...
%                 cblh.Limits(2)-4*space cblh.Limits(2)-3*space cblh.Limits(2)-2*space cblh.Limits(2)-space cblh.Limits(2)];
%             if (linear == 1)
%                 space = 2*(cmap_bins(end) - cmap_bins(1))/20;
%                 set(cblh,'yticklabel',round([cmap_bins(end)-10*space cmap_bins(end)-9*space cmap_bins(end)-8*space...
%                     cmap_bins(end)-7*space cmap_bins(end)-6*space cmap_bins(end)-5*space ...
%                     cmap_bins(end)-4*space cmap_bins(end)-3*space cmap_bins(end)-2*space cmap_bins(end)-space cmap_bins(end)])) ;
%                 colorbar_type = 'linear';
%             end
%             if (logrithmic == 1)
%                 labels = logspace(0,log10(cmap_bins(end)),(N_colorbins/2)+1); labels(1) = 0;
%                 set(cblh,'yticklabel',round(labels)); 
%                 colorbar_type = 'logrithmic';
%             end

            cblh.Label.String = char(color_bar_label(index2)); 
            set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 8)
            hold on

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
                ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 5.94 2.75 1.75]);
            elseif index1 == 2
                ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.08 5.94 2.75 1.75]);
            elseif index1 == 3
                ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 4.19 2.75 1.75]);
            elseif index1 == 4
                ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.08 4.19 2.75 1.75]);
            elseif index1 == 5
                ax4 = axes(fig2,'Units', 'inches', 'Position', [0.45 2.44 2.75 1.75]);
            elseif index1 == 6
                ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.08 2.44 2.75 1.75]);
            elseif index1 == 7
                ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 0.5 2.75 1.94]);
            elseif index1 == 8
                ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.08 0.5 2.75 1.94]);
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
            line([-53.5 -53.5], [0 6000],'color',[0 0 0],'linewi',1);% , 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
            %line([-49.5 -49.5], [0 6000],'color',[0 0 0],'linewi',1, 'LineStyle','--'); %PF meanders near this transect and ranges between these two latitudes
            line([-49 -49], [0 6000],'color',[0 0 0],'linewi',1); %SAF
            line([-40.6662 -40.6662], [0 6000],'color',[0 0 0],'linewi',1); %STF
            
%             %bathymetry            
%             p1 = patch([lat_lon(11:32,1)' max(lat_lon(11:32,1)) min(lat_lon(11:32,1))], [(bottom_depth(11:32))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');
%             p1 = patch([lat_lon(1:10,1)' max(lat_lon(1:10,1)) min(lat_lon(1:10,1))], [(bottom_depth(1:10))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');
%             p1 = patch([lat_lon(33:end,1)'  min(lat_lon(33:end,1)) max(lat_lon(33:end,1))], [(bottom_depth(33:end))' 6000 6000] , [0.5 0.5 0.5], 'EdgeColor', 'none');
            ax2.YLim = [0 6000]; %ax2.XLim = [173.5405 286.5010];

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
            % % save top axe so can manipulate xticklabels
            % if iv == numel(p.vars)
            %     ax_toptop = ax2_top;
            % end
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

            %imbed name of category in figure
            category_label = char(categories(index1)); category_label = strrep(category_label,'_',' ');
            if index1 == 6
                category_label = char('Rhizarians');
            end 
            if index1 == 7
                category_label = char('Crustaceans');
            end 
            textborder(lat_lon(14,1), 1500, category_label,'k','w','FontSize',12, 'FontWeight', 'Bold');
            
            %add subplot letter
            subplot_letter = sublet(index1);
            text(ax4_top, temp4(1)+2, 200, subplot_letter, 'Color','k', 'FontSize',20, 'FontWeight', 'Bold');

            if index1 == 7 || index1 == 8
                %label fronts on bottom
                text(ax2, temp4(13), 6000+300, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 6);
                text(ax2, temp4(21)-0.1, 6000+300, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
                text(ax2, temp4(26)-0.2, 6000+300, "PF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
                text(ax2, temp4(32)+0.7, 6000+300, "SAF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
                text(ax2, temp4(33)-3.1, 6000+300, "STF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
            end
            if index1 == 1 || index1 == 2            
                %add zone labels to the top 
               text(ax2, -68, -4400, "Subpolar Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
               text(ax2, -59, -4400, "BZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); %-60.5
               text(ax2, -55.5, -4400, "AZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); %-56.7
               text(ax2, -52.5, -4400, "PFZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); %-53
               text(ax2, -46, -4400, "SAZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); %-48.5
               text(ax2, -37.5, -4400, "STZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); %-40
            end
            
            %here I was thinking about making the grey level colorbar more
            %intuitive because 255 = white and 0 = black so I would ratehr 0 be
            %red and 255 be blue for the intuitiveness of the scale, but it's
            %not important because I likely won't have grey level in my paper
            %set( ax2.Colorbar, 'YDir', 'reverse' );
            %ax2.Colorbar.Direction = 'normal';
            clear linear; clear logrithmic;
        end
    %save figure
    formatSpec = 'print("G:/MS_Southern_Ocean/Zoo_Figures/I06s_multi_panel_Fig6%s_%s", "-dpng","-r300");';
    eval(sprintf(formatSpec, plot_type, colorbar_type))
    end
    %close all;
end
