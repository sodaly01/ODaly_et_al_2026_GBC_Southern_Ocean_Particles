%boxplot for different detritus taxa comparing size, shape, brightness, and
%structure

%modeled from Trudnowska et al., 2021 Figure 2d
%size = log(perimeter) object_perim_
%shape = circularity object_circ_
%brightness = mean grey level object_mean
%structure = kurtosis object_kurt

%load data
zoo_txt_i06s = readtable('C:/Users/steph/OneDrive/Documents/MS_Southern_Ocean/data/i06s_ecotaxa_export_5Sept2024.txt');
zoo_txt_s04p = readtable('C:/Users/steph/OneDrive/Documents/MS_Southern_Ocean/data/s04p_ecotaxa_export_5Sept2024.txt');

%only validated
% Filter only validated taxa from the loaded data
w = find(strcmp(zoo_txt_i06s.object_annotation_status(:), {'validated'}));
zoo_txt_i06s = zoo_txt_i06s(w,:);

w = find(strcmp(zoo_txt_s04p.object_annotation_status(:), {'validated'}));
zoo_txt_s04p = zoo_txt_s04p(w,:);

%merge tables
zoo_txt_i06s.object_link = num2cell(zoo_txt_i06s.object_link);
zoo_txt_i06s.object_rawvig = num2cell(zoo_txt_i06s.object_rawvig);
zoo_txt_i06s.sample_ctdrosettefilename = num2cell(zoo_txt_i06s.sample_ctdrosettefilename);
zoo_txt_s04p.acq_file_description = num2cell(zoo_txt_s04p.acq_file_description);

zoo_txt = [zoo_txt_i06s; zoo_txt_s04p];


%Replace category names that are too long with shorter ones
zoo_txt.object_annotation_category(:) = strrep(zoo_txt.object_annotation_category(:), ... 
    {'mc+aggregate-dense-two-black-elements-to-aggregate-fluffy-dark'},{'mc+aggregate-dense-2-black-to-aggregate-fluffy-dark'}); 
zoo_txt.object_annotation_category(:) = strrep(zoo_txt.object_annotation_category(:), ... 
    {'mc+aggregate-fluffy-elongated-to-aggregate-dense-elongated'},{'mc+aggregate-fluffy-elongated-to-aggregate-dense-elong'}); 

%all categories and hierarchies:
categories = unique(zoo_txt.object_annotation_hierarchy);
for index = 1:length(categories)
    w=find(strcmp(categories(index,1),zoo_txt.object_annotation_hierarchy));
    categories(index,2) = zoo_txt.object_annotation_category(w(1));
end
clear w

%change all special variables 
categories(:,3)= categories(:,2);
categories(:,3) = strrep(categories(:,3),'+','_'); 
categories(:,3) = strrep(categories(:,3),'<','_');
categories(:,3) = strrep(categories(:,3),'-','_');
categories(:,3) = strrep(categories(:,3),' ','_');


% define super categories
Fluffy_agg = {'mc_aggregate_fluffy';'mc_aggregate_dark_round_to_puff';
'mc_aggregate_fluffy_dark_to_aggregate_dense'; 'mc_aggregate_fluffy_elongated';
'mc_aggregate_fluffy_elongated_to_aggregate_dense_elong'; 'mc_aggregate_fluffy_grainy';
'mc_aggregate_fluffy_grainy_elongated'; 'mc_aggregate_fluffy_grainy_to_aggregate_dense'; 
'mc_aggregate_fluffy_grey'; 'mc_aggregate_fluffy_grey_elongated';
'mc_aggregate_fluffy_grey_to_aggregate_badfocus'; 'mc_aggregate_fluffy_grey_to_rhizaria'; 'Phaeocystis'};

Dense_agg = {'mc_aggregate_dense_amorphous_to_detritus_dense_round'; 'mc_aggregate_dense_dark_round_to_rhizaria';
'mc_aggregate_dense_elongated_to_aggregate_fluffy'; 'mc_aggregate_dense_elongated_two_elements_to_bubbles';
'mc_aggregate_dense_to_aggregate_fluffy_dark'; 'mc_aggregate_dense_to_crustacea';
'mc_aggregate_dense_to_feces'; 'mc_aggregate_dense_2_black_to_aggregate_fluffy_dark'};

Fiber = {'mc_fiber_fluffy_to_feces'; 'mc_fiber_thin_to_fiber_fluffy'; 'mc_fiber_thin_straight'; 
'mc_fiber_thin_straight_with_black_element'};

Feces = {'feces_little_fluffy'; 'mc_feces_bent_circular_fluffy'; 'mc_feces_bent_thin'; 
'mc_feces_bent_to_crustacea'; 'mc_feces_dark_roundish'; 'mc_feces_dark_small_irregular_shape';
'mc_feces_short_straight'; 'mc_feces_small_round_grey'; 'mc_feces_straight_to_feces_bent';
'mc_feces_straight_fluffy'; 'mc_feces_straight_fluffy_to_trichodesmium_tuff';
'mc_feces_straight_thin'; 'mc_feces_to_copepoda'; 'mc_feces_to_fiber'; 'mc_feces_straight_thin_to_fiber';
't006'}; 

% make supercategory column in categories variable
categories(:,4) = cell(height(categories), 1);
for in =1:length(categories)
    if any(strcmp(categories{in,3}, Fluffy_agg))
        categories{in,4} = 'Fluffy_agg';
    elseif any(strcmp(categories{in,3}, Dense_agg))
        categories{in,4} = 'Dense_agg';
    elseif any(strcmp(categories{in,3}, Fiber))
        categories{in,4} = 'Fiber';
    elseif any(strcmp(categories{in,3}, Feces))
        categories{in,4} = 'Feces';
    end
end

w = strcmp(categories(:,4),'Fluffy_agg');
Fluffy_agg_2 = categories(w,2);
w = strcmp(categories(:,4),'Dense_agg');
Dense_agg_2 = categories(w,2);
w = strcmp(categories(:,4),'Fiber');
Fiber_2 = categories(w,2);
w = strcmp(categories(:,4),'Feces');
Feces_2 = categories(w,2);

%find location of each super category
w_fluffy_agg= ismember(zoo_txt.object_annotation_category, Fluffy_agg_2);
w_fluffy_agg2 = find(w_fluffy_agg);
w_dense_agg= ismember(zoo_txt.object_annotation_category, Dense_agg_2);
w_dense_agg2 = find(w_dense_agg);
w_fiber= ismember(zoo_txt.object_annotation_category, Fiber_2);
w_fiber2 = find(w_fiber);
w_feces= ismember(zoo_txt.object_annotation_category, Feces_2);
w_feces2 = find(w_feces);

%% make box plot

fig1 = figure('Units', 'inches','Position', [0 2.5312 13.3125 3.1562]);
h = 2.6;
w = 2.7;
ax1 = axes('Units', 'inches', 'Position', [0.5 0.3 w h]);

boxplot([log10(zoo_txt.object_perim_(w_fluffy_agg2));
     log10(zoo_txt.object_perim_(w_dense_agg2));
     log10(zoo_txt.object_perim_(w_feces2));
     log10(zoo_txt.object_perim_(w_fiber2))], ...
    [repmat({'Fluffy'},length(w_fluffy_agg2),1);
     repmat({'Dense'}, length(w_dense_agg2),1);
     repmat({'Feces'}, length(w_feces2),1);
     repmat({'Fiber'}, length(w_fiber2),1)], ...
    'Notch','on', 'Symbol','')

set(ax1,'fontname', 'helvetica', 'fontsize', 10, 'fontweight', 'bold')
ylabel('log(Perimeter)')
title('Size', 'fontname', 'helvetica', 'fontsize', 14, 'fontweight', 'bold')
ylim([1.3735    3.5]);

%test which are significant from each other
[p12,~] = ranksum(log10(zoo_txt.object_perim_(w_fluffy_agg2)),log10(zoo_txt.object_perim_(w_dense_agg2)));
[p13,~] = ranksum(log10(zoo_txt.object_perim_(w_fluffy_agg2)),log10(zoo_txt.object_perim_(w_feces2)));
[p14,~] = ranksum(log10(zoo_txt.object_perim_(w_fluffy_agg2)),log10(zoo_txt.object_perim_(w_fiber2)));
%fluffy agg is sig diff from all other groups

[p15,~] = ranksum(log10(zoo_txt.object_perim_(w_dense_agg2)),log10(zoo_txt.object_perim_(w_feces2)));
[p16,~] = ranksum(log10(zoo_txt.object_perim_(w_dense_agg2)),log10(zoo_txt.object_perim_(w_fiber2)));
[p17,~] = ranksum(log10(zoo_txt.object_perim_(w_feces2)),log10(zoo_txt.object_perim_(w_fiber2)));
%all groups are significantly different from each other

%All pairwise group comparisons were statistically significant (p<0.001).


ax2 = axes('Units', 'inches', 'Position', [2*0.5+w 0.3 w h]);
boxplot([zoo_txt.object_circ_(w_fluffy_agg2);
     zoo_txt.object_circ_(w_dense_agg2);
     zoo_txt.object_circ_(w_feces2);
     zoo_txt.object_circ_(w_fiber2)], ...
    [repmat({'Fluffy'},length(w_fluffy_agg2),1);
     repmat({'Dense'}, length(w_dense_agg2),1);
     repmat({'Feces'}, length(w_feces2),1);
     repmat({'Fiber'}, length(w_fiber2),1)], ...
    'Notch','on', 'Symbol','')

set(ax2,'fontname', 'helvetica', 'fontsize', 10, 'fontweight', 'bold')
ylabel('Circularity')
title('Shape','fontname', 'helvetica', 'fontsize', 14, 'fontweight', 'bold')

%test which are significant from each other
[p22,~] = ranksum(zoo_txt.object_circ_(w_fluffy_agg2),zoo_txt.object_circ_(w_dense_agg2));
[p23,~] = ranksum(zoo_txt.object_circ_(w_fluffy_agg2),zoo_txt.object_circ_(w_feces2));
[p24,~] = ranksum(zoo_txt.object_circ_(w_fluffy_agg2),zoo_txt.object_circ_(w_fiber2));
[p25,~] = ranksum(zoo_txt.object_circ_(w_dense_agg2),zoo_txt.object_circ_(w_feces2));
[p26,~] = ranksum(zoo_txt.object_circ_(w_dense_agg2),zoo_txt.object_circ_(w_fiber2));
[p27,~] = ranksum(zoo_txt.object_circ_(w_feces2),zoo_txt.object_circ_(w_fiber2));
%all groups are significantly different from each other
%All pairwise group comparisons were statistically significant (p<0.001).


ax3 = axes('Units', 'inches', 'Position', [3*0.5+2*w 0.3 w h]);
boxplot([zoo_txt.object_mean(w_fluffy_agg2);
     zoo_txt.object_mean(w_dense_agg2);
     zoo_txt.object_mean(w_feces2);
     zoo_txt.object_mean(w_fiber2)], ...
    [repmat({'Fluffy'},length(w_fluffy_agg2),1);
     repmat({'Dense'}, length(w_dense_agg2),1);
     repmat({'Feces'}, length(w_feces2),1);
     repmat({'Fiber'}, length(w_fiber2),1)], ...
    'Notch','on', 'Symbol','')
set(ax3,'fontname', 'helvetica', 'fontsize', 10, 'fontweight', 'bold')
ylabel('Mean Grey Level')
title('Brightness', 'fontname', 'helvetica', 'fontsize', 14, 'fontweight', 'bold')

%test which are significant from each other
[p32,~] = ranksum(zoo_txt.object_mean(w_fluffy_agg2),zoo_txt.object_mean(w_dense_agg2));
[p33,~] = ranksum(zoo_txt.object_mean(w_fluffy_agg2),zoo_txt.object_mean(w_feces2));
[p34,~] = ranksum(zoo_txt.object_mean(w_fluffy_agg2),zoo_txt.object_mean(w_fiber2));
[p35,~] = ranksum(zoo_txt.object_mean(w_dense_agg2),zoo_txt.object_mean(w_feces2));
[p36,~] = ranksum(zoo_txt.object_mean(w_dense_agg2),zoo_txt.object_mean(w_fiber2));
[p37,~] = ranksum(zoo_txt.object_mean(w_feces2),zoo_txt.object_mean(w_fiber2));
%all groups are significantly different from each other
%All pairwise group comparisons were statistically significant (p<0.001).


ax4 = axes('Units', 'inches', 'Position', [4*0.5+3*w 0.3 w h]);
boxplot([zoo_txt.object_kurt(w_fluffy_agg2);
     zoo_txt.object_kurt(w_dense_agg2);
     zoo_txt.object_kurt(w_feces2);
     zoo_txt.object_kurt(w_fiber2)], ...
    [repmat({'Fluffy'},length(w_fluffy_agg2),1);
     repmat({'Dense'}, length(w_dense_agg2),1);
     repmat({'Feces'}, length(w_feces2),1);
     repmat({'Fiber'}, length(w_fiber2),1)], ...
    'Notch','on', 'Symbol','')
set(ax4,'fontname', 'helvetica', 'fontsize', 10, 'fontweight', 'bold')
ylabel('Kurtosis')
title('Structure', 'fontname', 'helvetica', 'fontsize', 14, 'fontweight', 'bold')
ylim([-3    16]);


%test which are significant from each other
[p42,~] = ranksum(zoo_txt.object_kurt(w_fluffy_agg2),zoo_txt.object_kurt(w_dense_agg2));
[p43,~] = ranksum(zoo_txt.object_kurt(w_fluffy_agg2),zoo_txt.object_kurt(w_feces2));
[p44,~] = ranksum(zoo_txt.object_kurt(w_fluffy_agg2),zoo_txt.object_kurt(w_fiber2));
[p45,~] = ranksum(zoo_txt.object_kurt(w_dense_agg2),zoo_txt.object_kurt(w_feces2));
[p46,~] = ranksum(zoo_txt.object_kurt(w_dense_agg2),zoo_txt.object_kurt(w_fiber2));
[p47,~] = ranksum(zoo_txt.object_kurt(w_feces2),zoo_txt.object_kurt(w_fiber2));
%all groups are significantly different from each other
%All pairwise group comparisons were statistically significant (p<0.001).


%expprint("D:/G/MS_Southern_Ocean/Figures/I06s_S04p_boxplot_morphocluster", "-dpng","-r300");

exportgraphics(gcf, 'C:\Users\steph\OneDrive\Documents\MS_Southern_Ocean/Figures/I06s_S04p_boxplot_morphocluster_08June2026.pdf','ContentType','vector')
