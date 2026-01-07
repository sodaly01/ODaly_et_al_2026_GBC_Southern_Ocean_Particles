%contour plots of S04p zoo data
clear all; close all;
%load data- UVP par file and CTD data, stations, map to tools
%load('G:\Cruises\2018_S04P\uvp5_sn207_2018_s04p_ecotaxa_export_par')
load('G:\Cruises\2018_S04P\uvp5_sn207_2018_s04p_ecotaxa_export_par2_filtered_AOU_fluor_sitecorrect_flux_loncorr.mat')
%load('G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_3Apr2024.mat')
%load('G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_5Sept2024.mat')
load('G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_20Feb2025.mat')
stations = load('G:\Cruises\2018_S04P\S04P_transect_main5.txt');

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

%Interpolate between stations to 5KM resolution
lat = interp(lat_lon(:,1),15);
long = interp(lat_lon(:,2),15);
%download bathy file from etopo2
[ELEV,LONG,LAT]=m_etopo2([lat_lon(1,2) lat_lon(end,2) lat_lon(1,1) lat_lon(end,1)]);
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

%load S04P MLD (calculated in S04p_CTD_plotting_contours_multiplot.m
load('G:/Cruises/2018_S04P/stn_lon_mld_pt.mat')

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

%% Define categories, plot types and labels

% %S04p val categories for Figure 5 in manuscript
categories = {'Fluffy_agg'; 'Dense_agg'; 'Fiber'; 'Feces'; 'Photosynthetic';...
    'Rhizaria_harosa'; 'Arthro_crustacea'; 'Gelatinous'}; 

plot_types = {'_M_3'; '_mm3L_1'; '_mm'; '_grey';};

color_bar_label = {'Total Particle Abundance (# m^-^3)'; 'Total Particle Biovolume (mm^3 L^-^1)';...
    'Average Particle Size (mm)'; 'Mean Grey Level'};

sublet = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'}; 

%% Plot: make a multipaneled plot with the summary detritus/living categories
for index2 = 1%:length(plot_types) %loop over four plot types (concentration, biov, mean size, and grey)
    for index3 = 3%1:2 %first linear color bar, second logrithmic color bar
        fig2 = figure;
        set(fig2, 'Units', 'inches', 'Position', [0.4417 0.6167 7.67 7.8]) %+0.9
        for index1 = 1:8%1:length(categories) %loop through all categories of particles
            if (index3 == 3)
                %manual CB
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
%                 N_colorbins = length(cmap_bins);
%                 y = 1:N_colorbins;
%                 dtr = interp1(cmap_bins, y, value(w), 'parula');
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
                y = 0:N_colorbins-1; %y = 1:N_colorbins; %edited 7Apr2025
                dtr = interp1(cmap_bins, y, value(w));
            end

            %plot UVP data over longitude with colorbar created
            zbin = min(par.Depth(w)):5:max(par.Depth(w));
            lon_axes = min(wrapTo360(zoo.longitude(w))) :0.1: max(wrapTo360(zoo.longitude(w)));
            [X1,Y1] = meshgrid(lon_axes,zbin);
            var_data=griddata(wrapTo360(zoo.longitude(w)),zoo.Depth(w),dtr,X1,Y1);
            w2=find(var_data == min(min(var_data))); %EDITED 3/18/25
            var_data(w2) = min(dtr);%EDITED 3/18/25
            w2=find(var_data == max(max(var_data)));%EDITED 3/18/25
            var_data(w2) = max(dtr);%EDITED 3/18/25
            clear w2;%
            ax2 = axes;
            if index1 == 1
                set(ax2, 'Units', 'inches', 'Position', [0.45 5.94 3.36 1.75])
            elseif index1 == 2
                set(ax2, 'Units', 'inches', 'Position', [4.03 5.94 3.36 1.75])
            elseif index1 == 3
                set(ax2, 'Units', 'inches', 'Position', [0.45 4.19 3.36 1.75])
            elseif index1 == 4
                set(ax2, 'Units', 'inches', 'Position', [4.03 4.19 3.36 1.75])
            elseif index1 == 5
                set(ax2, 'Units', 'inches', 'Position', [0.45 2.44 3.36 1.75]) 
            elseif index1 == 6
                set(ax2, 'Units', 'inches', 'Position', [4.03 2.44 3.36 1.75])
            elseif index1 == 7
                set(ax2, 'Units', 'inches', 'Position', [0.45 0.5 3.36 1.94]) 
            elseif index1 == 8
                set(ax2, 'Units', 'inches', 'Position', [4.03 0.5 3.36 1.94])
            end
            
            [C,h] = contourf(X1, Y1, var_data); 
            c = parula(N_colorbins - 1);
            colormap(c)
            set(h, 'LineColor', 'none');
            hold on
            if index1 == 1 || index1 == 2
                plot(ax2,unique(wrapTo360(zoo.longitude(w))),zeros([1 length(unique(wrapTo360(zoo.longitude(w))))]),'r|','MarkerSize',4);
            end
            temp4 = unique(wrapTo360(zoo.longitude(w)));
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

            %space = (cblh.Limits(2) - cblh.Limits(1))/(length(cmap_bins)-1);
%             tick_marks = [];
%             for in_ytick = flip(1:length(cmap_bins))
%                tick_marks = [tick_marks cblh.Limits(2)-((in_ytick-1)*space)];
%             end
%             cblh.YTick = tick_marks;
%             set(cblh, 'YTickLabel', cmap_bins);
%            colorbar_type = 'log2';
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

%             if (index3 == 3)
%                 space = (cblh.Limits(2) - cblh.Limits(1))/(length(cmap_bins)-1);
%                 set(cblh, 'ytick', [cblh.Limits(1): space : cblh.Limits(2)]); %101)
%                 set(cblh, 'YTickLabel', cmap_bins(1:end));
%                 colorbar_type = 'log2';
%             end

            cblh.Label.String = char(color_bar_label(index2)); 
            set(ax2, 'FontName','helvetica','fontweight','bold','fontsize', 8)
            hold on
            %plot MLD
            plot(wrapTo360(stn_lon_mld_pt(:,2)), stn_lon_mld_pt(:,3), '-', 'Color', [1 0.5 0], 'LineWidth', 1.5);

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
                ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 5.94 2.75 1.75]);
            elseif index1 == 2
                ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 5.94 2.75 1.75]);
            elseif index1 == 3
                ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 4.19 2.75 1.75]);
            elseif index1 == 4
                ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 4.19 2.75 1.75]);
            elseif index1 == 5
                ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 2.44 2.75 1.75]) ;
            elseif index1 == 6
                ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 2.44 2.75 1.75]);
            elseif index1 == 7
                ax4 = axes(fig2, 'Units', 'inches', 'Position', [0.45 0.5 2.75 1.94]) ;
            elseif index1 == 8
                ax4 = axes(fig2, 'Units', 'inches', 'Position', [4.03 0.5 2.75 1.94]);
            end
        
            %labels on sigma
            [C,h] = contour(ax4, X1_CTD, Y1_CTD, var_data,cmap_bins, 'showtext','on','LabelSpacing', 300);
            h.LevelList=round(h.LevelList,2);  %rounds levels to 3rd decimal place
            clabel(C,h) 
            %no labels on sigma 2
            %[C,h] = contour(X1, Y1, var_data,cmap_bins);

            set(h, 'LineColor', 'w');clabel(C,h, 'Color','w', 'LabelSpacing', 100, 'FontSize', 7);
            ax4.YDir = 'reverse';
            ax4.XTick = [180 200 220 240 260 280]; ax4.YTick = [];
            ax4.XTickLabel = {'','','','','',''};
            set(ax4, 'Color','none');ax4.XLim = [168.4755  286.5002];%ax4.XLim = [173.5405 286.5010];

            %add lines and text labeling fronts and zones
            line([wrapTo360(-131.252) wrapTo360(-131.252)], [0 max(zoo.Depth(w))],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
            line([wrapTo360(-104.0791) wrapTo360(-104.0791)], [0 max(zoo.Depth(w))],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
            line([wrapTo360(-78.4832) wrapTo360(-78.4832)], [0 max(zoo.Depth(w))],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5
            
            %bathymetry
            %p1 = patch([lat_lon(:,2)' lat_lon(end,2) lat_lon(1,2)], [(bottom_depth)' 4810 4810] , 'w');
            p = patch([long' long(end) long(1)], [elevation.*-1 4810 4810],'k');
            %set(p1, 'facecolor','w','edgecolor','w');
            set(p, 'facecolor',[0.5 0.5 0.5], 'edgecolor', [0.5 0.5 0.5]);
            ax2.YLim = [0 4810]; ax2.XLim = [173.5405 286.5010];

            %split upper 1000m to be half of the panel
            xlim1 = ax2.XLim;
            % change limits and shrink positions
            ax2.YLim = [1000 4810]; ax2.Position(4) = ax2.Position(4)/2;
            if index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
                ax2.YTickLabels = [];
            end
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
            if index1 == 2 || index1 == 4 || index1 == 6 || index1 == 8
                ax2_top.YTickLabels = [];
            end
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

            %imbed name of category in figure
            category_label = char(categories(index1)); category_label = strrep(category_label,'_',' ');
            if index1 == 6
                category_label = char('Rhizarians');
            end 
            if index1 == 7
                category_label = char('Crustaceans');
            end 
            textborder(lat_lon(14,2), 1500, category_label,'k','w','FontSize',12, 'FontWeight', 'Bold');
            
            %add subplot letter
            subplot_letter = sublet(index1);
            text(ax4_top, 175, 200, subplot_letter, 'Color','r', 'FontSize',20, 'FontWeight', 'Bold');

            if index1 == 7 || index1 == 8
                %label fronts on bottom
                text(ax2, 180+(180-136), max(zoo.Depth(w))+200, "SBDY", 'FontName','helvetica','fontweight','bold','fontsize', 6);
                text(ax2, 180+(180-110), max(zoo.Depth(w))+200, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
                text(ax2, 180+(180-85), max(zoo.Depth(w))+200, "SACCF", 'FontName','helvetica','fontweight','bold','fontsize', 6);
            end
            if index1 == 1 || index1 == 2
                %add zone labels to the top 
                text(ax2, 185, -3100, "Subpolar Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
                text(ax2, 229, -3100, "Boundary Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
                text(ax2, 256.2, -3100, "Antarctic Zone", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
                text(ax2, 282, -3100, "BZ", 'FontName','helvetica','fontweight','bold','fontsize', 6); 
            end
            hold off
        end
    %save figure
    formatSpec = 'print("G:/MS_Southern_Ocean/Zoo_Figures/S04P_multi_panel_Fig5%s_%s", "-dpng","-r300");';
    eval(sprintf(formatSpec, plot_type, colorbar_type))
    end
%    close all;
end