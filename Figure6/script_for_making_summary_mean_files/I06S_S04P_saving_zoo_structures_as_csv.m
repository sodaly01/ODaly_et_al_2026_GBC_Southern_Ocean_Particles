%save structure as csv for PCA
clear all;
%load('G:\MS_Southern_Ocean\data\zoo_i06s_val_pred_photo_no_fiber_3Apr2024.mat')
%load('G:\MS_Southern_Ocean\data\zoo_i06s_val_photo_no_fiber_3Apr2024.mat')
load('G:\MS_Southern_Ocean\data\zoo_i06s_val_photo_no_fiber_5Sept2024.mat')
load('G:/Cruises/2019_I06S/uvp5_sn207_2019_i06s_tcn322_ecotaxa_export_par2.mat'); %use this one
zoo.water_mass = par.water_mass;
%writetable(struct2table(zoo), 'G:\MS_Southern_Ocean\data\zoo_i06s_val_pred_photo_no_fiber.csv')
%writetable(struct2table(zoo), 'G:\MS_Southern_Ocean\data\zoo_i06s_val_photo_no_fiber.csv')
writetable(struct2table(zoo), 'G:\MS_Southern_Ocean\data\zoo_i06s_val_photo_no_fiber_5Sept2024.csv')

% %for val + pred get categories
% zoo_txt = readtable('G:/MS_Southern_Ocean/data/i06s_ecotaxa_export.txt');
% %zoo_txt = readtable('G:/MS_Southern_Ocean/data/s04p_ecotaxa_export.txt');
% %Replace category names that are too long with shorter ones
% zoo_txt.object_annotation_category(:) = strrep(zoo_txt.object_annotation_category(:), ... 
%     {'mc+aggregate-dense-two-black-elements-to-aggregate-fluffy-dark'},{'mc+aggregate-dense-2-black-to-aggregate-fluffy-dark'}); 
% zoo_txt.object_annotation_category(:) = strrep(zoo_txt.object_annotation_category(:), ... 
%     {'mc+aggregate-fluffy-elongated-to-aggregate-dense-elongated'},{'mc+aggregate-fluffy-elongated-to-aggregate-dense-elong'}); 
% categories = unique(zoo_txt.object_annotation_category);
% %change all special variables 
% categories(:) = strrep(categories(:),'+','_'); categories(:) = strrep(categories(:),'<','_');
% categories(:) = strrep(categories(:),'-','_'); categories(:) = strrep(categories(:),' ','_');
% categories = [categories; {'Fluffy_agg'}; {'Dense_agg'}; {'Fiber'}; {'Feces'}; {'Bad_focus'}; {'Not_relevant'}; {'Photosynthetic'}; ...
%     {'Rhizaria_harosa'}; {'Arthro_crustacea'}; {'Gelatinous'}; {'Metazoa'}; {'Living'}; {'Detritus'}];

%for val only: I06s val categories %edit this later
categories = {'like_Trichodesmium'; 'puff'; 'tuff'; 'Rhizaria'; 'Phaeodaria'; 'Castanellidae'; 'Circoporidae'; ...
'Tuscaroridae'; 'Aulacantha'; 'Aulographis'; 'mc_aulacantha_to_foraminifera'; 'Coelodendrum'; 'Coelographis'; ...
'leg_Coelodendridae'; 'Medusettidae'; 'Aulosphaeridae'; 'Aulatractus'; 'colonial_Aulosphaeridae'; ...
'mc_aulosphaeridae_to_cannosphaeridae'; 'Cannosphaeridae'; 'colonial_Cannosphaeridae'; ...
'Acantharea'; 'Foraminifera'; 'Collodaria'; 'colonial_Collodaria'; 'mc_solitary_black_to_puff'; 'solitaryblack'; ...
'Annelida';  'Polychaeta'; 'Poeobius'; 'Crustacea'; 'Hyperia'; 'like_Amphipoda'; 'shrimp_like'; 'Copepoda_Maxillopoda'; ...
'like_Copepoda'; 'Ostracoda'; 'Chaetognatha'; 'Teleostei'; 'fish_egg'; ...
'house';  'Salpida'; 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 'Narcomedusae';  ...
'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 'Mollusca'; 'Cephalopoda'; 'Phaeocystis'; 'badfocus_to_small_aggregates'; ...
'badfocus_to_turbid'; 'mc_badfocus_aggregate_elongated'; 'mc_badfocus_aggregate_fluffy'; ...
'mc_badfocus_aggregate_fluffy_to_badfocus_rhizaria'; 'bubble'; 'not_relevant_duplicate'; ...
'mc_aggregate_dense_amorphous_to_detritus_dense_round'; 'mc_aggregate_dense_dark_round_to_rhizaria'; ...
'mc_aggregate_dense_elongated_to_aggregate_fluffy'; 'mc_aggregate_dense_elongated_two_elements_to_bubbles'; ...
'mc_aggregate_dense_to_aggregate_fluffy_dark'; 'mc_aggregate_dense_to_crustacea'; 'mc_aggregate_dense_to_feces'; ...
'mc_aggregate_dense_2_black_to_aggregate_fluffy_dark'; 'mc_aggregate_fluffy'; 'mc_aggregate_dark_round_to_puff'; ...
'mc_aggregate_fluffy_dark_to_aggregate_dense'; 'mc_aggregate_fluffy_elongated'; ...
'mc_aggregate_fluffy_elongated_to_aggregate_dense_elong'; 'mc_aggregate_fluffy_grainy'; 'mc_aggregate_fluffy_grainy_elongated'; ...
'mc_aggregate_fluffy_grainy_to_aggregate_dense'; 'mc_aggregate_fluffy_grey'; 'mc_aggregate_fluffy_grey_elongated'; ...
'mc_aggregate_fluffy_grey_to_aggregate_badfocus'; 'mc_aggregate_fluffy_grey_to_rhizaria'; 'mc_fiber_fluffy_to_feces'; ...
'mc_fiber_thin_to_fiber_fluffy'; 'mc_fiber_thin_straight'; 'mc_fiber_thin_straight_with_black_element'; 'feces_little_fluffy'; ...
'mc_feces_bent_circular_fluffy'; 'mc_feces_bent_thin'; 'mc_feces_bent_to_crustacea'; 'mc_feces_dark_roundish'; ...
'mc_feces_dark_small_irregular_shape'; 'mc_feces_short_straight'; 'mc_feces_small_round_grey'; 'mc_feces_straight_to_feces_bent'; ...
'mc_feces_straight_fluffy'; 'mc_feces_straight_fluffy_to_trichodesmium_tuff'; 'mc_feces_straight_thin'; 'mc_feces_to_copepoda'; ...
'mc_feces_to_fiber'; 'mc_feces_straight_thin_to_fiber'; 't001'; 't003'; 't006';'t020'; 'Fluffy_agg'; ...
'Dense_agg'; 'Fiber'; 'Feces'; 'Bad_focus'; 'Not_relevant'; 'Photosynthetic'; 'Rhizaria_harosa'; 'Arthro_crustacea';...
'Gelatinous'; 'Metazoa'; 'Living'; 'Detritus'}; %'egg_Teleostei';  'Appendicularia';'Doliolida'; 'unknown_Phaeodaria'; 
% 'part_Copepoda'; 'Solmundella_bitentaculata'; 't005'; 

label_end = [{'_num'}; {'_M_3'}; {'_mm3L_1'}; {'_mm'}; {'_grey'}]; 

%% add frontal zone info
zoo.frontal_zone = {}; %create cell array within structure
w = find(zoo.latitude > -40.6662); %North of STF
zoo.frontal_zone(w,1) = {'Subtropical Zone'}; 
w = find(zoo.latitude > -49 & zoo.latitude <= -40.6662); %North of SAF
zoo.frontal_zone(w,1) = {'Subantarctic Zone'}; 
w = find(zoo.latitude > -53.5 & zoo.latitude <= -49); %North of PF
zoo.frontal_zone(w,1) = {'Polar Frontal Zone'}; 
w = find(zoo.latitude > -55.9998 & zoo.latitude <= -53.5); %North of SACCF
zoo.frontal_zone(w,1) = {'Antarctic Zone'}; 
w = find(zoo.latitude > -60.7523 & zoo.latitude <= -55.9998); %North of SBDY
zoo.frontal_zone(w,1) = {'Southern Zone'}; 
w = find(zoo.latitude <= -60.7523); %South of SBDY
zoo.frontal_zone(w,1) = {'Subpolar Region'};

%% create structure array

stations = unique(zoo.site); 
%for S04P, remove station 84
stations(74)=[]; %changed from 77 in 5Sept2024 version

for index = 1: length(stations)
    depth_bins_all = [0 50 100 200 500 1000 2000 3000 4000 5000 6000];
    w = find(zoo.site == stations(index));
    depth_bins_stn = depth_bins_all(depth_bins_all <= max(zoo.Depth(w)));
    bigger = depth_bins_all(depth_bins_all > max(zoo.Depth(w)));
    depth_bins_stn2 = [depth_bins_stn bigger(1)];
    depth_bins_stn = [depth_bins_stn max(zoo.Depth(w))];
    for index2 = 1:length(depth_bins_stn)-1
        if index2 < length(depth_bins_stn)-1
            w2 = find(zoo.Depth(w)>=depth_bins_stn(index2) & zoo.Depth(w)< depth_bins_stn(index2+1));
        else 
            w2 = find(zoo.Depth(w)>=depth_bins_stn(index2) & zoo.Depth(w)<= depth_bins_stn(index2+1));
        end
        if index == 1 && index2 == 1 %no concactionation
            zoo_summary.cruise = zoo.cruise(w(w2(1)));
            zoo_summary.site = zoo.site(w(w2(1)));
            zoo_summary.profile = zoo.profile(w(w2(1)));
            zoo_summary.dataowner = zoo.dataowner(w(w2(1)));
            zoo_summary.rawfilename = zoo.rawfilename(w(w2(1)));
            zoo_summary.instrument = zoo.instrument(w(w2(1)));
            zoo_summary.sn = zoo.sn(w(w2(1)));
            zoo_summary.ctdrosettefilename = zoo.ctdrosettefilename(w(w2(1)));
            zoo_summary.datetime = zoo.datetime(w(w2(1)));
            zoo_summary.latitude = zoo.latitude(w(w2(1)));
            zoo_summary.longitude = zoo.longitude(w(w2(1)));
            zoo_summary.Depth = zoo.Depth(w(w2(1)));
            zoo_summary.Depth_range(1) = {[depth_bins_stn(index2) depth_bins_stn(index2+1)]};
            zoo_summary.Depth_range2(1) = {[depth_bins_stn2(index2) depth_bins_stn2(index2+1)]};
            zoo_summary.SampledVolume_L_ = sum(zoo.SampledVolume_L_(w(w2)));
            zoo_summary.water_mass = zoo.water_mass(w(w2(1)));
            zoo_summary.frontal_zone = zoo.frontal_zone(w(w2(1)));
            formatSpec = 'zoo_summary.%s%s = sum([zoo.%s%s(w(w2))], "omitnan");'; 
            formatSpec_mean = 'zoo_summary.%s%s = mean([zoo.%s%s(w(w2))], "omitnan");'; 
            formatSpec_mean_w_0 = 'zoo_summary.%s%s = mean([zoo.%s%s(w(w2))]);'; 
            formatSpec_nan_zero = 'zoo.%s%s(isnan(zoo.%s%s))=0;';
            for index3 = 1:length(label_end) %loop through label_end
                for index4 = 1:length(categories) %loop through catgories
                    if index3 == 1 %%%%%%%%editing here moving index 3 = 2 and 3 to mean value
                        eval(sprintf(formatSpec, char(categories(index4)), char(label_end(index3)), char(categories(index4)), char(label_end(index3)))); 
                    end
                    if index3 == 2 || index3 == 3  %%%%edited this added index3 = 2 and 3
                        eval(sprintf(formatSpec_nan_zero, char(categories(index4)), char(label_end(index3)), char(categories(index4)), char(label_end(index3))));
                        eval(sprintf(formatSpec_mean_w_0, char(categories(index4)), char(label_end(index3)), char(categories(index4)), char(label_end(index3)))); 
                    end
                    if index3 == 4 || index3 == 5 %%%%edited this added index3 = 2 and 3
                        eval(sprintf(formatSpec_mean, char(categories(index4)), char(label_end(index3)), char(categories(index4)), char(label_end(index3)))); 
                    end
                end
            end
        else %concactionation
            zoo_summary.cruise = [zoo_summary.cruise; zoo.cruise(w(w2(1)))];
            zoo_summary.site = [zoo_summary.site; zoo.site(w(w2(1)))];
            zoo_summary.profile = [zoo_summary.profile; zoo.profile(w(w2(1)))];
            zoo_summary.dataowner = [zoo_summary.dataowner; zoo.dataowner(w(w2(1)))];
            zoo_summary.rawfilename = [zoo_summary.rawfilename; zoo.rawfilename(w(w2(1)))];
            zoo_summary.instrument = [zoo_summary.instrument; zoo.instrument(w(w2(1)))];
            zoo_summary.sn = [zoo_summary.sn ; zoo.sn(w(w2(1)))];
            zoo_summary.ctdrosettefilename = [zoo_summary.ctdrosettefilename; zoo.ctdrosettefilename(w(w2(1)))];
            zoo_summary.datetime = [zoo_summary.datetime; zoo.datetime(w(w2(1)))];
            zoo_summary.latitude = [zoo_summary.latitude; zoo.latitude(w(w2(1)))];
            zoo_summary.longitude = [zoo_summary.longitude; zoo.longitude(w(w2(1)))];
            zoo_summary.Depth = [zoo_summary.Depth; zoo.Depth(w(w2(1)))];
            zoo_summary.Depth_range = [zoo_summary.Depth_range; {[depth_bins_stn(index2) depth_bins_stn(index2+1)]}];
            zoo_summary.Depth_range2 = [zoo_summary.Depth_range2; {[depth_bins_stn2(index2) depth_bins_stn2(index2+1)]}];
            zoo_summary.SampledVolume_L_ = [zoo_summary.SampledVolume_L_; sum(zoo.SampledVolume_L_(w(w2)))];
            zoo_summary.water_mass = [zoo_summary.water_mass; zoo.water_mass(w(w2(1)))];
            zoo_summary.frontal_zone = [zoo_summary.frontal_zone; zoo.frontal_zone(w(w2(1)))];
            formatSpec = 'zoo_summary.%s%s = [zoo_summary.%s%s; sum([zoo.%s%s(w(w2))], "omitnan")];'; 
            formatSpec_mean = 'zoo_summary.%s%s = [zoo_summary.%s%s; mean([zoo.%s%s(w(w2))], "omitnan")];'; 
            formatSpec_mean_w_0 = 'zoo_summary.%s%s = [zoo_summary.%s%s; mean([zoo.%s%s(w(w2))])];'; 
            formatSpec_nan_zero = 'zoo.%s%s(isnan(zoo.%s%s))=0;';
            for index3 = 1:length(label_end) %loop through label_end
                for index4 = 1:length(categories) %loop through catgories
                    if index3 == 1 %loop through label_end
                        eval(sprintf(formatSpec, char(categories(index4)), char(label_end(index3)), char(categories(index4)), ...
                            char(label_end(index3)), char(categories(index4)), char(label_end(index3)))); 
                    end
                    if index3 == 2 || index3 == 3  %%%%edited this added index3 = 2 and 3
                        eval(sprintf(formatSpec_nan_zero, char(categories(index4)), char(label_end(index3)), char(categories(index4)), ...
                            char(label_end(index3)))); 
                        eval(sprintf(formatSpec_mean_w_0, char(categories(index4)), char(label_end(index3)), char(categories(index4)), ...
                            char(label_end(index3)), char(categories(index4)), char(label_end(index3)))); 
                    end
                    if index3 == 4 || index3 == 5 %%%%edited this added index3 = 2 and 3
                        eval(sprintf(formatSpec_mean, char(categories(index4)), char(label_end(index3)), char(categories(index4)), ...
                            char(label_end(index3)), char(categories(index4)), char(label_end(index3)))); 
                    end
                end
            end
        end
    end
end

%writetable(struct2table(zoo_summary), 'G:\MS_Southern_Ocean\data\zoo_i06s_val_pred_photo_no_fiber_summary_mean.csv')
%writetable(struct2table(zoo_summary), 'G:\MS_Southern_Ocean\data\zoo_i06s_val_photo_no_fiber_summary_mean.csv')
%writetable(struct2table(zoo_summary), 'G:\MS_Southern_Ocean\data\zoo_i06s_val_photo_no_fiber_5Sept2024_summary_mean.csv')

%writetable(struct2table(zoo_summary), 'G:\MS_Southern_Ocean\data\zoo_s04p_val_pred_photo_no_fiber_summary_mean.csv')
%writetable(struct2table(zoo_summary), 'G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_summary_mean.csv')
%writetable(struct2table(zoo_summary), 'G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_5Sept2024_summary_mean.csv')
writetable(struct2table(zoo_summary), 'G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_20Feb2025_summary_mean.csv')

%%
clear all;

%load('G:\MS_Southern_Ocean\data\zoo_s04p_val_pred_photo_no_fiber_3Apr2024.mat')
%load('G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_3Apr2024.mat')
%load('G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_5Sept2024.mat')
%load('G:\Cruises\2018_S04P\uvp5_sn207_2018_s04p_ecotaxa_export_par2')
load('G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_20Feb2025.mat')
load('G:\Cruises\2018_S04P\uvp5_sn207_2018_s04p_ecotaxa_export_par2_filtered_AOU_fluor_sitecorrect.mat')

zoo.water_mass = par.water_mass;
%writetable(struct2table(zoo), 'G:\MS_Southern_Ocean\data\zoo_s04p_val_pred_photo_no_fiber.csv')
%writetable(struct2table(zoo), 'G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber.csv')
%writetable(struct2table(zoo), 'G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_5Sept2024.csv')
writetable(struct2table(zoo), 'G:\MS_Southern_Ocean\data\zoo_s04p_val_photo_no_fiber_20Feb2025.csv')

% %S04P: add lines and text labeling fronts and zones
% line([wrapTo360(-131.252) wrapTo360(-131.252)], [0 max(zoo.Depth(w))],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5 %SBDY
% line([wrapTo360(-104.0791) wrapTo360(-104.0791)], [0 max(zoo.Depth(w))],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5 % SACCF
% line([wrapTo360(-78.4832) wrapTo360(-78.4832)], [0
% max(zoo.Depth(w))],'color',[0 0 0],'linewi',1); %, 'alpha', 0.5 %SACCF
zoo.frontal_zone = {}; %create cell array within structure
w = find(wrapTo360(zoo.longitude) <= wrapTo360(-131.252)); %West of SBDY
zoo.frontal_zone(w,1) = {'Subpolar Region'}; 
w = find(wrapTo360(zoo.longitude) >  wrapTo360(-131.252) & wrapTo360(zoo.longitude) <=  wrapTo360(-104.0791)); %West of SACCF
zoo.frontal_zone(w,1) = {'Southern Zone'}; 
w = find(wrapTo360(zoo.longitude) >  wrapTo360(-104.0791) & wrapTo360(zoo.longitude) <=  wrapTo360(-78.4832)); %West of SACCF
zoo.frontal_zone(w,1) = {'Antarctic Zone'}; 
w = find(wrapTo360(zoo.longitude) >  wrapTo360(-78.4832)); %East of SACCF
zoo.frontal_zone(w,1) = {'Southern Zone'};


% %for val + pred: get categories
% zoo_txt = readtable('G:/MS_Southern_Ocean/data/s04p_ecotaxa_export.txt');
% %Replace category names that are too long with shorter ones
% zoo_txt.object_annotation_category(:) = strrep(zoo_txt.object_annotation_category(:), ... 
%     {'mc+aggregate-dense-two-black-elements-to-aggregate-fluffy-dark'},{'mc+aggregate-dense-2-black-to-aggregate-fluffy-dark'}); 
% zoo_txt.object_annotation_category(:) = strrep(zoo_txt.object_annotation_category(:), ... 
%     {'mc+aggregate-fluffy-elongated-to-aggregate-dense-elongated'},{'mc+aggregate-fluffy-elongated-to-aggregate-dense-elong'}); 
% categories = unique(zoo_txt.object_annotation_category);
% %change all special variables 
% categories(:) = strrep(categories(:),'+','_'); categories(:) = strrep(categories(:),'<','_');
% categories(:) = strrep(categories(:),'-','_'); categories(:) = strrep(categories(:),' ','_');
% categories = [categories; {'Fluffy_agg'}; {'Dense_agg'}; {'Fiber'}; {'Feces'}; {'Bad_focus'}; {'Not_relevant'}; {'Photosynthetic'}; ...
%     {'Rhizaria_harosa'}; {'Arthro_crustacea'}; {'Gelatinous'}; {'Metazoa'}; {'Living'}; {'Detritus'}];

%for val only: S04p val categories
categories = {'like_Trichodesmium'; 'puff'; 'tuff'; 'Rhizaria'; 'Phaeodaria'; 'Castanellidae'; 'Circoporidae'; ...
'Tuscaroridae'; 'Aulacantha'; 'Aulographis'; 'mc_aulacantha_to_foraminifera'; 'Coelodendrum'; 'Coelographis'; ...
'leg_Coelodendridae'; 'Medusettidae'; 'Aulosphaeridae'; 'Aulatractus'; 'colonial_Aulosphaeridae'; ...
'mc_aulosphaeridae_to_cannosphaeridae'; 'Cannosphaeridae'; 'colonial_Cannosphaeridae'; 'unknown_Phaeodaria'; ...
'Acantharea'; 'Foraminifera'; 'Collodaria'; 'colonial_Collodaria'; 'mc_solitary_black_to_puff'; 'solitaryblack'; ...
'Annelida'; 'Poeobius'; 'Crustacea'; 'Hyperia'; 'like_Amphipoda'; 'shrimp_like'; 'Copepoda_Maxillopoda'; ...
'like_Copepoda'; 'Ostracoda'; 'Chaetognatha'; 'fish_egg'; ...
'house'; 'Salpida'; 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 'Narcomedusae'; 'Solmundella_bitentaculata'; ...
'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 'Mollusca'; 'Cephalopoda'; 'Phaeocystis'; 'badfocus_to_small_aggregates'; ...
'badfocus_to_turbid'; 'mc_badfocus_aggregate_elongated'; 'mc_badfocus_aggregate_fluffy'; ...
'mc_badfocus_aggregate_fluffy_to_badfocus_rhizaria'; 'bubble'; 'not_relevant_duplicate'; ...
'mc_aggregate_dense_amorphous_to_detritus_dense_round'; 'mc_aggregate_dense_dark_round_to_rhizaria'; ...
'mc_aggregate_dense_elongated_to_aggregate_fluffy'; 'mc_aggregate_dense_elongated_two_elements_to_bubbles'; ...
'mc_aggregate_dense_to_aggregate_fluffy_dark'; 'mc_aggregate_dense_to_crustacea'; 'mc_aggregate_dense_to_feces'; ...
'mc_aggregate_dense_2_black_to_aggregate_fluffy_dark'; 'mc_aggregate_fluffy'; 'mc_aggregate_dark_round_to_puff'; ...
'mc_aggregate_fluffy_dark_to_aggregate_dense'; 'mc_aggregate_fluffy_elongated'; ...
'mc_aggregate_fluffy_elongated_to_aggregate_dense_elong'; 'mc_aggregate_fluffy_grainy'; 'mc_aggregate_fluffy_grainy_elongated'; ...
'mc_aggregate_fluffy_grainy_to_aggregate_dense'; 'mc_aggregate_fluffy_grey'; 'mc_aggregate_fluffy_grey_elongated'; ...
'mc_aggregate_fluffy_grey_to_aggregate_badfocus'; 'mc_aggregate_fluffy_grey_to_rhizaria'; 'mc_fiber_fluffy_to_feces'; ...
'mc_fiber_thin_to_fiber_fluffy'; 'mc_fiber_thin_straight'; 'mc_fiber_thin_straight_with_black_element'; 'feces_little_fluffy'; ...
'mc_feces_bent_circular_fluffy'; 'mc_feces_bent_thin'; 'mc_feces_bent_to_crustacea'; 'mc_feces_dark_roundish'; ...
'mc_feces_dark_small_irregular_shape'; 'mc_feces_short_straight'; 'mc_feces_small_round_grey'; 'mc_feces_straight_to_feces_bent'; ...
'mc_feces_straight_fluffy'; 'mc_feces_straight_fluffy_to_trichodesmium_tuff'; 'mc_feces_straight_thin'; 'mc_feces_to_copepoda'; ...
'mc_feces_to_fiber'; 'mc_feces_straight_thin_to_fiber'; 't001'; 't003'; 't005';  'Fluffy_agg'; ...
'Dense_agg'; 'Fiber'; 'Feces'; 'Bad_focus'; 'Not_relevant'; 'Photosynthetic'; 'Rhizaria_harosa'; 'Arthro_crustacea';...
'Gelatinous'; 'Metazoa'; 'Living'; 'Detritus'}; %'t020'; 'Polychaeta'; 'Teleostei';'t006'; 'Doliolida';

label_end = [{'_num'}; {'_M_3'}; {'_mm3L_1'}; {'_mm'}; {'_grey'}]; 


