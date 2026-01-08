%% %opening morphocluster image file and doing some preliminenary analyses
% 
% %set directory
% 
% 
%% Edit these variable names if you need to re run these!

% %this file will take a about 20 min to load into matlab
%
% tic
% % %t = readtable("G:/MS_Southern_Ocean/data/ecotaxa_export_9566_20231130_2020.tsv", "FileType","text",'Delimiter', '\t');
% % t = readtable("G:/MS_Southern_Ocean/data/ecotaxa_export_9566_20240905_2205.tsv", "FileType","text",'Delimiter', '\t');
% t = readtable("G:/MS_Southern_Ocean/data/ecotaxa_export__TSV_9566_20251205_2346_05Dec2025.tsv", "FileType","text",'Delimiter', '\t');
% toc
% tic
% %writetable(t,'G:/MS_Southern_Ocean/data/ecotaxa_export_5Sept2024.txt','Delimiter','\t')
% writetable(t,'G:/MS_Southern_Ocean/data/ecotaxa_export_05Dec2025.txt','Delimiter','\t')
% toc
% tic
% %t_txt = readtable('G:/MS_Southern_Ocean/data/ecotaxa_export_5Sept2024.txt');
% t_txt = readtable('G:/MS_Southern_Ocean/data/ecotaxa_export_05Dec2025.txt');
% toc
% 
% % 
% % cruise = unique(t.sample_cruise);
% % %find lines nuumbers from each cruise
% %P2
% w = find(strcmp({'sn201_2022_p2'},t.sample_cruise));
% p2 = t(w,:);
% tic
% %writetable(p2,'G:/MS_Southern_Ocean/data/p2_ecotaxa_export.txt','Delimiter','\t')
% writetable(p2,'G:/MS_Southern_Ocean/data/p2_ecotaxa_export_05Dec2025.txt','Delimiter','\t')
% toc
tic
%p2_txt = readtable('G:/MS_Southern_Ocean/data/p2_ecotaxa_export.txt');
p2_txt = readtable('G:/MS_Southern_Ocean/data/p2_ecotaxa_export_05Dec2025.txt');
toc

% %A22
% w = find(strcmp({'sn207_2021_a22'},t.sample_cruise));
% a22 = t(w,:);
% tic
% writetable(a22,'G:/MS_Southern_Ocean/data/a22_ecotaxa_export.txt','Delimiter','\t')
% toc
% tic
% a22_txt = readtable('G:/MS_Southern_Ocean/data/a22_ecotaxa_export.txt');
% toc
% 
% %S04P
% tic
% %w = find(strcmp({'sn207_2018_s04p'},t.sample_cruise));
% %s04p = t(w,:);
% w = find(strcmp({'sn207_2018_s04p'},t_txt.sample_cruise));
% s04p = t_txt(w,:);
% toc
% tic
% %writetable(s04p,'G:/MS_Southern_Ocean/data/s04p_ecotaxa_export.txt','Delimiter','\t')
% writetable(s04p,'G:/MS_Southern_Ocean/data/s04p_ecotaxa_export_5Sept2024.txt','Delimiter','\t')
% toc
% tic
% %s04p_txt = readtable('G:/MS_Southern_Ocean/data/s04p_ecotaxa_export.txt');
% s04p_txt = readtable('G:/MS_Southern_Ocean/data/s04p_ecotaxa_export_5Sept2024.txt');
% toc
% 
%I06S
%w = find(strcmp({'sn207_2019_i06s_tcn322'},t.sample_cruise));
%i06s = t(w,:);
% w = find(strcmp({'sn207_2019_i06s_tcn322'},t_txt.sample_cruise));
% i06s = t_txt(w,:);
% tic
% %writetable(i06s,'G:/MS_Southern_Ocean/data/i06s_ecotaxa_export.txt','Delimiter','\t')
% writetable(i06s,'G:/MS_Southern_Ocean/data/i06s_ecotaxa_export_5Sept2024.txt','Delimiter','\t')
% toc
% clear all
% tic
% %i06s_txt = readtable('G:/MS_Southern_Ocean/data/i06s_ecotaxa_export.txt');
% i06s_txt = readtable('G:/MS_Southern_Ocean/data/i06s_ecotaxa_export_5Sept2024.txt');
% toc

%% for P2 leg 2

tic
% %t = readtable("G:/MS_Southern_Ocean/data/ecotaxa_export_9922_20240325_1815_p2_leg2_25Mar2024.tsv", "FileType","text",'Delimiter', '\t');
t = readtable("G:/MS_Southern_Ocean/data/ecotaxa_export__TSV_9922_20251205_2253_p2_leg2_05Dec2025.tsv", "FileType","text",'Delimiter', '\t', 'VariableNamingRule', 'Preserve');
toc
tic
%writetable(t,'G:/MS_Southern_Ocean/data/ecotaxa_export_p2_leg2.txt','Delimiter','\t')
writetable(t,'G:/MS_Southern_Ocean/data/ecotaxa_export_p2_leg_2_05Dec2025.txt','Delimiter','\t')
toc
tic
%t_txt = readtable('G:/MS_Southern_Ocean/data/ecotaxa_export_p2_leg2.txt');
t_txt = readtable('G:/MS_Southern_Ocean/data/ecotaxa_export_p2_leg_2_05Dec2025.txt');
toc

%% Load data files (processed?)
%this take 5 minutes to load for only one cruise
tic
%zoo_txt = readtable('G:/MS_Southern_Ocean/data/i06s_ecotaxa_export_5Sept2024.txt');
%zoo_txt = readtable('G:/MS_Southern_Ocean/data/s04p_ecotaxa_export_5Sept2024.txt');
%zoo_txt = readtable('G:/MS_Southern_Ocean/data/a22_ecotaxa_export.txt');
%zoo_txt = readtable('G:/MS_Southern_Ocean/data/p2_ecotaxa_export.txt');
%zoo_txt = readtable('G:/MS_Southern_Ocean/data/ecotaxa_export_p2_leg2.txt');
zoo_txt = readtable('G:/MS_Southern_Ocean/data/p2_ecotaxa_export_05Dec2025.txt');
%zoo_txt = readtable('G:/MS_Southern_Ocean/data/ecotaxa_export_p2_leg_2_05Dec2025.txt', "FileType","text",'Delimiter', '\t', 'VariableNamingRule', 'Preserve');
toc

%Replace category names that are too long with shorter ones
zoo_txt.object_annotation_category(:) = strrep(zoo_txt.object_annotation_category(:), ... 
    {'mc+aggregate-dense-two-black-elements-to-aggregate-fluffy-dark'},{'mc+aggregate-dense-2-black-to-aggregate-fluffy-dark'}); 
zoo_txt.object_annotation_category(:) = strrep(zoo_txt.object_annotation_category(:), ... 
    {'mc+aggregate-fluffy-elongated-to-aggregate-dense-elongated'},{'mc+aggregate-fluffy-elongated-to-aggregate-dense-elong'}); 

%making profile IDs match with Par file
zoo_txt.sample_id(:) = strrep(zoo_txt.sample_id(:), {'s058a'}, {'s058A'});
zoo_txt.sample_id(:) = strrep(zoo_txt.sample_id(:), {'s058b'}, {'s058B'});

% % %%
% %remove predicted variables
% %only run this for just validated data
% w = find(strcmp(zoo_txt.object_annotation_status(:), {'validated'}));
% zoo_txt = zoo_txt(w,:);

%%
%load Zoo and Par data files, skip Zoo if you haven't run this script before
%load('G:/MS_Southern_Ocean/data/zoo_s04p_val_pred.mat') %only load this if you don't was to start from scratch zoo s04p (this is the file that this script writes)
%load Par S04P
%load('G:/Cruises/2018_S04P/uvp5_sn207_2018_s04p_ecotaxa_export_par.mat'); 
%load('G:\Cruises\2018_S04P\uvp5_sn207_2018_s04p_ecotaxa_export_par2_filtered_AOU_fluor_sitecorrect') %use this one


% %load Par I06S
% %load('G:/Cruises/2019_I06S/uvp5_sn207_2019_i06s_tcn322_ecotaxa_export_par2.mat'); %use this one
% %load('G:/Cruises/2019_I06S/uvp5_sn207_2019_i06s_tcn322_ecotaxa_export_par.mat'); %I think they're the same
% %load I06S Zoo: skip Zoo if you haven't run this script before
% load('G:/MS_Southern_Ocean/data/zoo_i06s_val_pred.mat') %only load this if you don't was to start from scratch zoo i06s (this is the file that this script writes)

%load Zoo and Par data files, skip Zoo if you haven't run this script before
%add zoo file here once I finish making one
%load Par A22
%load('G:/Cruises/2021_A20_A22/A22/uvp5_sn207_2021_a22_ecotaxa_export_par.mat'); 

%load Zoo and Par data files, skip Zoo if you haven't run this script before
%add zoo file here once I finish making one
%load Par P2
load('G:/Cruises/2022_P02/P2_UVP/uvp5_sn201_2022_p2_ecotaxa_export_par_updated_calibration.mat');
%load('G:/Cruises/2022_P02/P2_UVP/uvp5_sn201_2022_p2_part2_ecotaxa_export_par.mat');

% example data files from another cruise
%load('G:/MS_Southern_Ocean/data/2019_summer_lter_ecopart_datafiles/uvp5_sn009_2019_nga_lter_summer_ecotaxa_export_zoo.mat');
%load('G:/MS_Southern_Ocean/data/2019_summer_lter_ecopart_datafiles/uvp5_sn009_2019_nga_lter_summer_ecotaxa_export_par');

%% set pixel size for each cruise
%pixel_size = 97; %S04P %updated 3april 2024 from 172 which I think was a typo
pixel_size = 94; %I06S, A22, and P2 %updated 3april 2024 from 172 which I think was a typo

%%
%make new structure for zoo
zoo.cruise = par.cruise;
zoo.site = par.site;
zoo.profile = par.profile;
zoo.dataowner = par.dataowner;
zoo.rawfilename = par.rawfilename;
zoo.instrument = par.instrument;
zoo.sn = par.sn;
zoo.ctdrosettefilename = par.ctdrosettefilename;
zoo.datetime = par.datetime;
zoo.latitude = par.latitude;
zoo.longitude = par.longitude;
zoo.Depth = par.Depth;
zoo.SampledVolume_L_ = par.SampledVolume_L_;

%%
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

%%

%create structural array variables of NaNs
formatSpec_num  = 'zoo.%s_num = NaN(length(zoo.Depth),1);'; %number of particles
for index = 1:length(categories)
    eval(sprintf(formatSpec_num, char(categories(index,3))));
end
formatSpec_conc = 'zoo.%s_M_3 = NaN(length(zoo.Depth),1);'; %concentration
for index = 1:length(categories)
    eval(sprintf(formatSpec_conc, char(categories(index,3))));
end
formatSpec_biov = 'zoo.%s_mm3L_1 = NaN(length(zoo.Depth),1);';%biovolume
for index = 1:length(categories)
    eval(sprintf(formatSpec_biov, char(categories(index,3))));
end
formatSpec_avgsz = 'zoo.%s_mm = NaN(length(zoo.Depth),1);'; %average size
for index = 1:length(categories)
    eval(sprintf(formatSpec_avgsz, char(categories(index,3))));
end
formatSpec_grey = 'zoo.%s_grey = NaN(length(zoo.Depth),1);'; %adding structure for grey
for index = 1:length(categories)
    eval(sprintf(formatSpec_grey, char(categories(index,3))));
end

%loop through each cast/depth bin; this take about an hour to run
tic 

for index = 1:length(zoo.Depth)
    %location of lines in a certian cast 
    w = find(strcmp(zoo_txt.sample_id,zoo.profile(index)));
    %location of lines in cast within each depth bin
    depth_range = [zoo.Depth(index)-2.5, zoo.Depth(index)+2.5]; 
    w2 = find(zoo_txt.object_depth_min(w) > depth_range(1) & ...
        zoo_txt.object_depth_min(w) <= depth_range(2));
    %calculate concentration within cast/depth bin for each particle type
    %loop through each category  present in this depth bin and sum them 
    categories2 = unique(zoo_txt(w(w2),:).object_annotation_category);
    categories2(:,2)= categories2(:,1);
    categories2(:,2) = strrep(categories2(:,2),'+','_'); 
    categories2(:,2) = strrep(categories2(:,2),'<','_');
    categories2(:,2) = strrep(categories2(:,2),'-','_');
    categories2(:,2) = strrep(categories2(:,2),' ','_');
    height = size(categories2);
    for in = 1:height(1) %length(categories2)
        num = length(find(strcmp(zoo_txt.object_annotation_category(w(w2)), categories2(in,1)))); %concentration and number
        formatSpec_num = 'zoo.%s_num(index) = num;'; %number of particles
        eval(sprintf(formatSpec_num, char(categories2(in, 2)))); %number of particles        
        formatSpec_conc = 'zoo.%s_M_3(index) = num/zoo.SampledVolume_L_(index)*1000;'; %concentration in #/M^3
        eval(sprintf(formatSpec_conc, char(categories2(in, 2)))); %concentration
        grey = mean(zoo_txt.object_mean(w(w2(find(strcmp(zoo_txt.object_annotation_category(w(w2)), categories2(in,1))))))); %grey area
        formatSpec_grey = 'zoo.%s_grey(index) = grey;'; %grey area
        eval(sprintf(formatSpec_grey, char(categories2(in, 2)))); %grey area
        biovolume = sum((4/3)*(((2*sqrt((zoo_txt.object_area(w(w2(find(strcmp(zoo_txt.object_annotation_category(w(w2)),...
            categories2(in,1)))))))/pi))*pixel_size)/2).^3 * pi*(1e-9)); %mm^3 
        %biovolume = sum((4/3)*pi*(((object_esd*pixel_size*0.001)./2).^3));  % this is a simpler way to calculate biovolume if I want to change it, but they're the same
        formatSpec_biov = 'zoo.%s_mm3L_1(index) = biovolume/zoo.SampledVolume_L_(index);'; %biovolume
        eval(sprintf(formatSpec_biov, char(categories2(in, 2)))); %biovolume
        %use zoo_txt.object_esd for avg size
        avgsz = mean(zoo_txt.object_esd(w(w2(find(strcmp(zoo_txt.object_annotation_category(w(w2)), categories2(in,1))))))); %avg size
        formatSpec_avgsz = 'zoo.%s_mm(index) = avgsz;'; %avg size
        eval(sprintf(formatSpec_avgsz, char(categories2(in, 2)))); %avg size
    end
end
toc

%% skip this section- this is now obsolate because these two stations have been deleted
% %QCing S04P- 
% % 
% %tentacles_Cnidaria
% w7 = find(zoo.site == 27);
% zoo.tentacle_Cnidaria_M_3(w7(end)-310:w7(end)) = NaN(length(w7(end)-310:w7(end)),1);
% zoo.tentacle_Cnidaria_mm3L_1(w7(end)-310:w7(end)) = NaN(length(w7(end)-310:w7(end)),1);
% zoo.tentacle_Cnidaria_mm(w7(end)-310:w7(end)) = NaN(length(w7(end)-310:w7(end)),1);
% zoo.tentacle_Cnidaria_grey(w7(end)-310:w7(end)) = NaN(length(w7(end)-310:w7(end)),1);
% %mc_fiber_thin_straight
% w7 = find(zoo.site == 26);
% zoo.mc_fiber_thin_straight_M_3(w7(end)-370:w7(end)) = NaN(length(w7(end)-370:w7(end)),1);
% zoo.mc_fiber_thin_straight_M_3(w7(end)-370:w7(end)) = NaN(length(w7(end)-370:w7(end)),1);
% zoo.mc_fiber_thin_straight_M_3(w7(end)-370:w7(end)) = NaN(length(w7(end)-370:w7(end)),1);
% zoo.mc_fiber_thin_straight_M_3(w7(end)-370:w7(end)) = NaN(length(w7(end)-370:w7(end)),1);

%% make summary variables S04p
% % 
% %moving phaeocystis to fluffy_agg and 
% Fluffy_agg = {'mc_aggregate_fluffy';'mc_aggregate_dark_round_to_puff';
% 'mc_aggregate_fluffy_dark_to_aggregate_dense'; 'mc_aggregate_fluffy_elongated';
% 'mc_aggregate_fluffy_elongated_to_aggregate_dense_elong'; 'mc_aggregate_fluffy_grainy';
% 'mc_aggregate_fluffy_grainy_elongated'; 'mc_aggregate_fluffy_grainy_to_aggregate_dense'; 
% 'mc_aggregate_fluffy_grey'; 'mc_aggregate_fluffy_grey_elongated';
% 'mc_aggregate_fluffy_grey_to_aggregate_badfocus'; 'mc_aggregate_fluffy_grey_to_rhizaria'; 'Phaeocystis'};
% 
% Dense_agg = {'mc_aggregate_dense_amorphous_to_detritus_dense_round'; 'mc_aggregate_dense_dark_round_to_rhizaria';
% 'mc_aggregate_dense_elongated_to_aggregate_fluffy'; 'mc_aggregate_dense_elongated_two_elements_to_bubbles';
% 'mc_aggregate_dense_to_aggregate_fluffy_dark'; 'mc_aggregate_dense_to_crustacea';
% 'mc_aggregate_dense_to_feces'; 'mc_aggregate_dense_2_black_to_aggregate_fluffy_dark'};
% 
% Fiber = {'mc_fiber_fluffy_to_feces'; 'mc_fiber_thin_to_fiber_fluffy'; 'mc_fiber_thin_straight'; 
% 'mc_fiber_thin_straight_with_black_element'};
% 
% Feces = {'feces_little_fluffy'; 'mc_feces_bent_circular_fluffy'; 'mc_feces_bent_thin'; 
% 'mc_feces_bent_to_crustacea'; 'mc_feces_dark_roundish'; 'mc_feces_dark_small_irregular_shape';
% 'mc_feces_short_straight'; 'mc_feces_small_round_grey'; 'mc_feces_straight_to_feces_bent';
% 'mc_feces_straight_fluffy'; 'mc_feces_straight_fluffy_to_trichodesmium_tuff';
% 'mc_feces_straight_thin'; 'mc_feces_to_copepoda'; 'mc_feces_to_fiber'; 'mc_feces_straight_thin_to_fiber';
% 't006'}; 
% 
% Bad_focus = {'badfocus_to_small_aggregates'; 'badfocus_to_turbid'; 'mc_badfocus_aggregate_elongated'; 
% 'mc_badfocus_aggregate_fluffy'; 'mc_badfocus_aggregate_fluffy_to_badfocus_rhizaria'}; 
% 
% Not_relevant = {'bubble'; 'not_relevant_duplicate'}; 
% 
% Photosynthetic = {'like_Trichodesmium'; 'puff'; 'tuff'; 't020'}; %; 'mc_fiber_fluffy_to_feces'; ...
% %'mc_fiber_thin_to_fiber_fluffy'; 'mc_fiber_thin_straight'; 'mc_fiber_thin_straight_with_black_element'
% 
% Rhizaria_harosa = {'Rhizaria'; 'Phaeodaria'; 'Castanellidae'; 'Circoporidae'; 'Tuscaroridae'; 
% 'Aulacantha'; 'Aulographis'; 'mc_aulacantha_to_foraminifera'; 'Coelodendrum'; 'Coelographis';
% 'leg_Coelodendridae'; 'Medusettidae'; 'Aulosphaeridae'; 'Aulatractus'; 'colonial_Aulosphaeridae';
% 'mc_aulosphaeridae_to_cannosphaeridae'; 'Cannosphaeridae'; 'colonial_Cannosphaeridae';
% 'unknown_Phaeodaria'; 'Acantharea'; 'Foraminifera'; 'Collodaria'; 'colonial_Collodaria'; 
% 'mc_solitary_black_to_puff'; 'solitaryblack'}; 
% 
% Arthro_crustacea = {'Crustacea'; 'Eumalacostraca'; 'Hyperia'; 'like_Amphipoda'; 'shrimp_like';
% 'Copepoda_Maxillopoda'; 'Eucalanidae'; 'like_Copepoda'; 'Ostracoda'};
% 
% % %for S04p validated and predicted
% % Gelatinous = {'house'; 'Doliolida'; 'Salpida'; 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 
% % 'Narcomedusae'; 'Solmundella_bitentaculata'; 'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 't005'}; 
% 
% %for s04p validated only
% Gelatinous = {'house'; 'Salpida'; 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 
% 'Narcomedusae'; 'Solmundella_bitentaculata'; 'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 't005'}; 
% 
% % % %for S04p validated and predicted
% % Metazoa = {'Annelida'; 'Polychaeta'; 'Poeobius'; 'Crustacea'; 'Eumalacostraca'; 'Hyperia';
% % 'like_Amphipoda'; 'shrimp_like'; 'Copepoda_Maxillopoda'; 'Eucalanidae'; 'like_Copepoda'; 
% % 'Ostracoda'; 'Chaetognatha'; 'Teleostei'; 'fish_egg'; 'house'; 'Doliolida'; 'Salpida';
% % 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 'Narcomedusae'; 'Solmundella_bitentaculata';
% % 'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 'Mollusca'; 'Cephalopoda'; 't005'}; 
% 
% %for s04p validated only
% Metazoa = {'Annelida'; 'Polychaeta'; 'Poeobius'; 'Crustacea'; 'Eumalacostraca'; 'Hyperia';
% 'like_Amphipoda'; 'shrimp_like'; 'Copepoda_Maxillopoda'; 'Eucalanidae'; 'like_Copepoda'; 
% 'Ostracoda'; 'Chaetognatha'; 'Teleostei'; 'fish_egg'; 'house'; 'Salpida';
% 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 'Narcomedusae'; 'Solmundella_bitentaculata';
% 'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 'Mollusca'; 'Cephalopoda'; 't005'}; 
% 
% Living = [Metazoa; Rhizaria_harosa; Photosynthetic]; 
% 
% Detritus = [Fluffy_agg; Dense_agg; Fiber; Feces]; 

%%
% %QCing I06S
% 
% % fiber thin straight
% w7 = find(zoo.site == 38);
% zoo.mc_fiber_thin_straight_M_3(w7(1):w7(75)) = NaN(length(w7(1):w7(75)),1);
% zoo.mc_fiber_thin_straight_mm3L_1(w7(1):w7(75)) = NaN(length(w7(1):w7(75)),1);
% zoo.mc_fiber_thin_straight_mm(w7(1):w7(75)) = NaN(length(w7(1):w7(75)),1);
% zoo.mc_fiber_thin_straight_grey(w7(1):w7(75)) = NaN(length(w7(1):w7(75)),1);
% 
% w7 = find(zoo.site == 41);
% zoo.mc_fiber_thin_straight_M_3(w7(end)-600:w7(end)-200) = NaN(length(w7(end)-600:w7(end)-200),1);
% zoo.mc_fiber_thin_straight_mm3L_1(w7(end)-600:w7(end)-200) = NaN(length(w7(end)-600:w7(end)-200),1);
% zoo.mc_fiber_thin_straight_mm(w7(end)-600:w7(end)-200) = NaN(length(w7(end)-600:w7(end)-200),1);
% zoo.mc_fiber_thin_straight_grey(w7(end)-600:w7(end)-200) = NaN(length(w7(end)-600:w7(end)-200),1);
% zoo.mc_fiber_thin_to_fiber_fluffy_M_3(w7(end)-600:w7(end)-200) = NaN(length(w7(end)-600:w7(end)-200),1);
% zoo.mc_fiber_thin_to_fiber_fluffy_mm3L_1(w7(end)-600:w7(end)-200) = NaN(length(w7(end)-600:w7(end)-200),1);
% zoo.mc_fiber_thin_to_fiber_fluffy_mm(w7(end)-600:w7(end)-200) = NaN(length(w7(end)-600:w7(end)-200),1);
% zoo.mc_fiber_thin_to_fiber_fluffy_grey(w7(end)-600:w7(end)-200) = NaN(length(w7(end)-600:w7(end)-200),1);
% zoo.mc_fiber_thin_straight_with_black_element_M_3(w7(end)-600:w7(end)-200) = NaN(length(w7(end)-600:w7(end)-200),1);
% zoo.mc_fiber_thin_straight_with_black_element_mm3L_1(w7(end)-600:w7(end)-200) = NaN(length(w7(end)-600:w7(end)-200),1);
% zoo.mc_fiber_thin_straight_with_black_element_mm(w7(end)-600:w7(end)-200) = NaN(length(w7(end)-600:w7(end)-200),1);
% zoo.mc_fiber_thin_straight_with_black_element_grey(w7(end)-600:w7(end)-200) = NaN(length(w7(end)-600:w7(end)-200),1);


%% summary variables for I06S
% Fluffy_agg = {'mc_aggregate_fluffy';'mc_aggregate_dark_round_to_puff';
% 'mc_aggregate_fluffy_dark_to_aggregate_dense'; 'mc_aggregate_fluffy_elongated';
% 'mc_aggregate_fluffy_elongated_to_aggregate_dense_elong'; 'mc_aggregate_fluffy_grainy';
% 'mc_aggregate_fluffy_grainy_elongated'; 'mc_aggregate_fluffy_grainy_to_aggregate_dense'; 
% 'mc_aggregate_fluffy_grey'; 'mc_aggregate_fluffy_grey_elongated';
% 'mc_aggregate_fluffy_grey_to_aggregate_badfocus'; 'mc_aggregate_fluffy_grey_to_rhizaria'; 'Phaeocystis'};
% 
% Dense_agg = {'mc_aggregate_dense_amorphous_to_detritus_dense_round'; 'mc_aggregate_dense_dark_round_to_rhizaria';
% 'mc_aggregate_dense_elongated_to_aggregate_fluffy'; 'mc_aggregate_dense_elongated_two_elements_to_bubbles';
% 'mc_aggregate_dense_to_aggregate_fluffy_dark'; 'mc_aggregate_dense_to_crustacea';
% 'mc_aggregate_dense_to_feces'; 'mc_aggregate_dense_2_black_to_aggregate_fluffy_dark'};
% 
% Fiber = {'mc_fiber_fluffy_to_feces'; 'mc_fiber_thin_to_fiber_fluffy'; 'mc_fiber_thin_straight'; 
% 'mc_fiber_thin_straight_with_black_element'};
% 
% Feces = {'feces_little_fluffy'; 'mc_feces_bent_circular_fluffy'; 'mc_feces_bent_thin'; 
% 'mc_feces_bent_to_crustacea'; 'mc_feces_dark_roundish'; 'mc_feces_dark_small_irregular_shape';
% 'mc_feces_short_straight'; 'mc_feces_small_round_grey'; 'mc_feces_straight_to_feces_bent';
% 'mc_feces_straight_fluffy'; 'mc_feces_straight_fluffy_to_trichodesmium_tuff';
% 'mc_feces_straight_thin'; 'mc_feces_to_copepoda'; 'mc_feces_to_fiber'; 'mc_feces_straight_thin_to_fiber';
% 't006'}; 
% 
% Bad_focus = {'badfocus_to_small_aggregates'; 'badfocus_to_turbid'; 'mc_badfocus_aggregate_elongated'; 
% 'mc_badfocus_aggregate_fluffy'; 'mc_badfocus_aggregate_fluffy_to_badfocus_rhizaria'}; 
% 
% Not_relevant = {'bubble'; 'not_relevant_duplicate'}; 
%  
% Photosynthetic = {'like_Trichodesmium'; 'puff'; 'tuff'; 't020'}; %; 'mc_fiber_fluffy_to_feces'; ...
% %'mc_fiber_thin_to_fiber_fluffy'; 'mc_fiber_thin_straight'; 'mc_fiber_thin_straight_with_black_element'
% 
% % % %I06s val and pred
% % Rhizaria_harosa = {'Rhizaria'; 'Phaeodaria'; 'unknown_Phaeodaria'; 'Castanellidae'; 'Circoporidae'; 'Tuscaroridae'; 
% % 'Aulacantha'; 'Aulographis'; 'mc_aulacantha_to_foraminifera'; 'Coelodendrum'; 'Coelographis';
% % 'leg_Coelodendridae'; 'Medusettidae'; 'Aulosphaeridae'; 'Aulatractus'; 'colonial_Aulosphaeridae';
% % 'mc_aulosphaeridae_to_cannosphaeridae'; 'Cannosphaeridae'; 'colonial_Cannosphaeridae';
% % 'Acantharea'; 'Foraminifera'; 'Collodaria'; 'colonial_Collodaria'; 
% % 'mc_solitary_black_to_puff'; 'solitaryblack'}; 
% 
% %I06s val
% Rhizaria_harosa = {'Rhizaria'; 'Phaeodaria'; 'Castanellidae'; 'Circoporidae'; 'Tuscaroridae'; 
% 'Aulacantha'; 'Aulographis'; 'mc_aulacantha_to_foraminifera'; 'Coelodendrum'; 'Coelographis';
% 'leg_Coelodendridae'; 'Medusettidae'; 'Aulosphaeridae'; 'Aulatractus'; 'colonial_Aulosphaeridae';
% 'mc_aulosphaeridae_to_cannosphaeridae'; 'Cannosphaeridae'; 'colonial_Cannosphaeridae';
% 'Acantharea'; 'Foraminifera'; 'Collodaria'; 'colonial_Collodaria'; 
% 'mc_solitary_black_to_puff'; 'solitaryblack'}; 
% 
% % %I06s val and pred
% % Arthro_crustacea = {'Crustacea'; 'Hyperia'; 'like_Amphipoda'; 'shrimp_like';
% % 'Copepoda_Maxillopoda'; 'part_Copepoda'; 'like_Copepoda'; 'Ostracoda'};
% 
% %I06s validated
% Arthro_crustacea = {'Crustacea'; 'Hyperia'; 'like_Amphipoda'; 'shrimp_like';
% 'Copepoda_Maxillopoda'; 'like_Copepoda'; 'Ostracoda'};
% 
% %for I06S validated and predicted
% % Gelatinous = {'Appendicularia'; 'house'; 'Salpida'; 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 
% % 'Narcomedusae'; 'Solmundella_bitentaculata'; 'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 't005'}; 
% 
% %for I06S validated
% Gelatinous = {'Appendicularia'; 'house'; 'Salpida'; 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 
% 'Narcomedusae'; 'tentacle_Cnidaria'; 'Ctenophora_Metazoa'}; 
% 
% % %for I06S validated and predicted
% % Metazoa = {'Annelida'; 'Polychaeta'; 'Poeobius'; 'Crustacea'; 'Hyperia';
% % 'like_Amphipoda'; 'shrimp_like'; 'Copepoda_Maxillopoda'; 'like_Copepoda'; 'part_Copepoda'; 
% % 'Ostracoda'; 'Chaetognatha'; 'Teleostei'; 'egg_Teleostei'; 'fish_egg'; 'Appendicularia'; 'house'; 'Salpida';
% % 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 'Narcomedusae'; 'Solmundella_bitentaculata';
% % 'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 'Mollusca'; 'Cephalopoda'; 't005'}; 
% 
% %for I06S validated
% Metazoa = {'Annelida'; 'Polychaeta'; 'Poeobius'; 'Crustacea'; 'Hyperia';
% 'like_Amphipoda'; 'shrimp_like'; 'Copepoda_Maxillopoda'; 'like_Copepoda'; 
% 'Ostracoda'; 'Chaetognatha'; 'Teleostei'; 'egg_Teleostei'; 'fish_egg'; 'Appendicularia'; 'house'; 'Salpida';
% 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 'Narcomedusae'; 
% 'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 'Mollusca'; 'Cephalopoda'}; 
% 
% Living = [Metazoa; Rhizaria_harosa; Photosynthetic]; 
% 
% Detritus = [Fluffy_agg; Dense_agg; Fiber; Feces]; 

%% make summary variables A22
% % % 
% %moving phaeocystis to fluffy_agg and 
% % %% summary variables for A22
% Fluffy_agg = {'mc_aggregate_fluffy';'mc_aggregate_dark_round_to_puff';
% 'mc_aggregate_fluffy_dark_to_aggregate_dense'; 'mc_aggregate_fluffy_elongated';
% 'mc_aggregate_fluffy_elongated_to_aggregate_dense_elong'; 'mc_aggregate_fluffy_grainy';
% 'mc_aggregate_fluffy_grainy_elongated'; 'mc_aggregate_fluffy_grainy_to_aggregate_dense'; 
% 'mc_aggregate_fluffy_grey'; 'mc_aggregate_fluffy_grey_elongated';
% 'mc_aggregate_fluffy_grey_to_aggregate_badfocus'; 'mc_aggregate_fluffy_grey_to_rhizaria'; 'Phaeocystis'};
% 
% Dense_agg = {'mc_aggregate_dense_amorphous_to_detritus_dense_round'; 'mc_aggregate_dense_dark_round_to_rhizaria';
% 'mc_aggregate_dense_elongated_to_aggregate_fluffy'; 'mc_aggregate_dense_elongated_two_elements_to_bubbles';
% 'mc_aggregate_dense_to_aggregate_fluffy_dark'; 'mc_aggregate_dense_to_crustacea';
% 'mc_aggregate_dense_to_feces'; 'mc_aggregate_dense_2_black_to_aggregate_fluffy_dark'};
% 
% Fiber = {'mc_fiber_fluffy_to_feces'; 'mc_fiber_thin_to_fiber_fluffy'; 'mc_fiber_thin_straight'; 
% 'mc_fiber_thin_straight_with_black_element'};
% 
% Feces = {'feces_little_fluffy'; 'mc_feces_bent_circular_fluffy'; 'mc_feces_bent_thin'; 
% 'mc_feces_bent_to_crustacea'; 'mc_feces_dark_roundish'; 'mc_feces_dark_small_irregular_shape';
% 'mc_feces_short_straight'; 'mc_feces_small_round_grey'; 'mc_feces_straight_to_feces_bent';
% 'mc_feces_straight_fluffy'; 'mc_feces_straight_fluffy_to_trichodesmium_tuff';
% 'mc_feces_straight_thin'; 'mc_feces_to_copepoda'; 'mc_feces_to_fiber'; 'mc_feces_straight_thin_to_fiber';
% 't006'}; 
% 
% Bad_focus = {'badfocus_to_small_aggregates'; 'badfocus_to_turbid'; 'mc_badfocus_aggregate_elongated'; 
% 'mc_badfocus_aggregate_fluffy'; 'mc_badfocus_aggregate_fluffy_to_badfocus_rhizaria'}; 
% 
% Not_relevant = {'bubble'; 'not_relevant_duplicate'}; 
%  
% Photosynthetic = {'like_Trichodesmium'; 'puff'; 'tuff'; 't020'}; %; 'mc_fiber_fluffy_to_feces'; ...
% %'mc_fiber_thin_to_fiber_fluffy'; 'mc_fiber_thin_straight'; 'mc_fiber_thin_straight_with_black_element'
% 
% % %A22 val and pred
% % Rhizaria_harosa = {'Rhizaria'; 'Phaeodaria'; 'unknown_Phaeodaria'; 'Castanellidae'; 'Circoporidae'; 'Tuscaroridae'; 
% % 'Aulacantha'; 'Aulographis'; 'mc_aulacantha_to_foraminifera'; 'Coelodendrum'; 'Coelographis';
% % 'leg_Coelodendridae'; 'Medusettidae'; 'Aulosphaeridae'; 'Aulatractus'; 'colonial_Aulosphaeridae';
% % 'mc_aulosphaeridae_to_cannosphaeridae'; 'Cannosphaeridae'; 'colonial_Cannosphaeridae';
% % 'Acantharea'; 'Foraminifera'; 'Collodaria'; 'colonial_Collodaria'; 
% % 'mc_solitary_black_to_puff'; 'solitaryblack'}; 
% 
% %A22 val
% Rhizaria_harosa = {'Rhizaria'; 'Phaeodaria'; 'Circoporidae'; 'Tuscaroridae'; 
% 'Aulacantha'; 'Aulographis'; 'mc_aulacantha_to_foraminifera'; 'Coelodendrum'; 'Coelographis';
% 'leg_Coelodendridae'; 'Medusettidae'; 'Aulosphaeridae'; 'Aulatractus'; 'colonial_Aulosphaeridae';
% 'mc_aulosphaeridae_to_cannosphaeridae'; 'Cannosphaeridae'; 'colonial_Cannosphaeridae';
% 'Acantharea'; 'Foraminifera'; 'Collodaria'; 'colonial_Collodaria'; 
% 'mc_solitary_black_to_puff'; 'solitaryblack'}; % 'unknown_Phaeodaria';'Castanellidae'; 
% 
% % %A22 val and pred
% % Arthro_crustacea = {'Crustacea'; 'Hyperia'; 'like_Amphipoda'; 'shrimp_like'; 
% % 'Copepoda_Maxillopoda'; 'like_Copepoda'; 'Eucalanidae'; 'Ostracoda'}; %'Eumalacostraca';  'part_Copepoda';
% 
% %A22 val
% Arthro_crustacea = {'Crustacea'; 'Hyperia'; 'like_Amphipoda'; 'shrimp_like'; 
% 'Copepoda_Maxillopoda'; 'like_Copepoda'; 'Ostracoda'}; %'Eumalacostraca';  'part_Copepoda'; 'Eucalanidae';
% 
% %A22 val and pred
% % Gelatinous = {'Appendicularia'; 'house'; 'Salpida'; 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 
% % 'Narcomedusae'; 'Solmundella_bitentaculata'; 'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 't005'}; 
% 
% %A22 val
% Gelatinous = {'house'; 'Salpida'; 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 
% 'Narcomedusae'; 'Solmundella_bitentaculata'; 'tentacle_Cnidaria'; 'Ctenophora_Metazoa'}; %'Appendicularia'; 't005'
% 
% %A22 val and pred
% % Metazoa = {'Annelida'; 'Polychaeta'; 'Poeobius'; 'Crustacea'; 'Hyperia'; 'Eucalanidae';
% % 'like_Amphipoda'; 'shrimp_like'; 'Copepoda_Maxillopoda'; 'like_Copepoda'; 
% % 'Ostracoda'; 'Chaetognatha'; 'Teleostei'; 'fish_egg'; 'Appendicularia'; 'house'; 'Salpida';
% % 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 'Narcomedusae'; 'Solmundella_bitentaculata';
% % 'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 'Mollusca'; 'Cephalopoda'; 't005'}; %'Eumalacostraca'; 'part_Copepoda'; 'egg_Teleostei';
% 
% %A22 val
% Metazoa = {'Annelida'; 'Polychaeta'; 'Poeobius'; 'Crustacea'; 'Hyperia'; 
% 'like_Amphipoda'; 'shrimp_like'; 'Copepoda_Maxillopoda'; 'like_Copepoda'; 
% 'Ostracoda'; 'Chaetognatha'; 'Teleostei'; 'fish_egg'; 'house'; 'Salpida';
% 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 'Narcomedusae'; 'Solmundella_bitentaculata';
% 'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 'Mollusca'; 'Cephalopoda'}; %'Eumalacostraca'; 'part_Copepoda'; 'egg_Teleostei'; 'Eucalanidae'; 'Appendicularia'; ; 't005'
% 
% Living = [Metazoa; Rhizaria_harosa; Photosynthetic]; 
% 
% Detritus = [Fluffy_agg; Dense_agg; Fiber; Feces]; 

%% make summary variables P2

%moving phaeocystis to fluffy_agg and 
% %% summary variables for P2
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

Bad_focus = {'badfocus_to_small_aggregates'; 'badfocus_to_turbid'; 'mc_badfocus_aggregate_elongated'; 
'mc_badfocus_aggregate_fluffy'; 'mc_badfocus_aggregate_fluffy_to_badfocus_rhizaria'}; 

% P2 leg 1 
Not_relevant = {'bubble'; 'not_relevant_duplicate'}; 

% P2 leg 2
%Not_relevant = {'bubble'}; %; 'not_relevant_duplicate'

% %P2 leg 1 and leg 2 val
% Photosynthetic = {'like_Trichodesmium'; 'puff'; 'tuff'}; %'t020'; ; 'mc_fiber_fluffy_to_feces'; ...
% %'mc_fiber_thin_to_fiber_fluffy'; 'mc_fiber_thin_straight'; 'mc_fiber_thin_straight_with_black_element'

%P2 leg 1 and 2 val and pred
Photosynthetic = {'like_Trichodesmium'; 'puff'; 'tuff'; 't020'}; %; ; 'mc_fiber_fluffy_to_feces'; ...
%'mc_fiber_thin_to_fiber_fluffy'; 'mc_fiber_thin_straight'; 'mc_fiber_thin_straight_with_black_element'

%P2 val and pred
% Rhizaria_harosa = {'Rhizaria'; 'Phaeodaria'; 'unknown_Phaeodaria'; 'Castanellidae'; 'Circoporidae'; 
% 'Aulacantha'; 'Aulographis'; 'mc_aulacantha_to_foraminifera'; 'Coelodendrum'; 'Coelographis';
% 'leg_Coelodendridae'; 'Medusettidae'; 'Aulosphaeridae'; 'Aulatractus'; 'colonial_Aulosphaeridae';
% 'mc_aulosphaeridae_to_cannosphaeridae'; 'Cannosphaeridae'; 'colonial_Cannosphaeridae';
% 'Acantharea'; 'Foraminifera'; 'Collodaria'; 'colonial_Collodaria'; 
% 'mc_solitary_black_to_puff'; 'solitaryblack'}; %'Tuscaroridae'; 

% %P2 val
% Rhizaria_harosa = {'Rhizaria'; 'Circoporidae'; 
% 'Aulacantha'; 'mc_aulacantha_to_foraminifera'; 'Coelodendrum'; 
% 'leg_Coelodendridae'; 'Medusettidae'; 'Aulosphaeridae'; 'Aulatractus';
% 'mc_aulosphaeridae_to_cannosphaeridae'; 'Cannosphaeridae'; 
% 'Acantharea'; 'Foraminifera'; 'Collodaria'; 'colonial_Collodaria'; 
% 'mc_solitary_black_to_puff'; 'solitaryblack'}; %'Tuscaroridae'; 'Phaeodaria'; 'unknown_Phaeodaria';
% %'Castanellidae'; 'Aulographis'; 'Coelographis';  'colonial_Aulosphaeridae';
% %'colonial_Cannosphaeridae';

%P2 part1 val
Rhizaria_harosa = {'Rhizaria'; 'Phaeodaria';
'Aulacantha';'Aulographis'; 'mc_aulacantha_to_foraminifera'; 'Coelodendrum'; 'Coelographis';  
'leg_Coelodendridae'; 'Medusettidae'; 'Aulosphaeridae'; 'Aulatractus';  'colonial_Aulosphaeridae';
'mc_aulosphaeridae_to_cannosphaeridae'; 'Cannosphaeridae'; 'colonial_Cannosphaeridae';
'unknown_Phaeodaria';'Acantharea'; 'Foraminifera'; 'Collodaria'; 'colonial_Collodaria'; 
'mc_solitary_black_to_puff'; 'solitaryblack'}; %'Tuscaroridae'; 
%'Castanellidae';  'Circoporidae'; 

% %P2 part2 val and pred
% Rhizaria_harosa = {'Rhizaria'; 'Phaeodaria'; 'Castanellidae'; 'Circoporidae'; 'Tuscaroridae'; 
% 'Aulacantha';'Aulographis'; 'mc_aulacantha_to_foraminifera'; 'Coelodendrum'; 'Coelographis';  
% 'leg_Coelodendridae'; 'Medusettidae'; 'Aulosphaeridae'; 'Aulatractus';  'colonial_Aulosphaeridae';
% 'mc_aulosphaeridae_to_cannosphaeridae'; 'Cannosphaeridae'; 'colonial_Cannosphaeridae';
% 'unknown_Phaeodaria';'Acantharea'; 'Foraminifera'; 'Collodaria'; 'colonial_Collodaria'; 
% 'mc_solitary_black_to_puff'; 'solitaryblack'}; 


Arthro_crustacea = {'Crustacea'; 'Hyperia'; 'like_Amphipoda'; 'shrimp_like'; 
'Copepoda_Maxillopoda'; 'like_Copepoda'; 'Ostracoda'}; %'Eucalanidae';'Eumalacostraca';  ; 'part_Copepoda'

% P2 val and pred
% Gelatinous = {'house'; 'Salpida'; 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 
% 'Narcomedusae'; 'Solmundella_bitentaculata'; 'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 't005'}; %'Appendicularia';  

% %P2 val part1
Gelatinous = {'house';'Doliolida'; 'Salpida'; 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 
'Narcomedusae'; 'Solmundella_bitentaculata'; 'tentacle_Cnidaria'; 'Ctenophora_Metazoa'}; %'Appendicularia';  ; 't005'

% %P2 val  and val and pred part2
% Gelatinous = {'house';'Doliolida'; 'Salpida'; 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 
% 'Narcomedusae'; 'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 't005'}; %'Appendicularia';  'Solmundella_bitentaculata';

%P2 val and pred
% Metazoa = {'Annelida'; 'Poeobius'; 'Crustacea'; 'Hyperia';
% 'like_Amphipoda'; 'shrimp_like'; 'Copepoda_Maxillopoda'; 'like_Copepoda'; 
% 'Ostracoda'; 'Chaetognatha'; 'Teleostei'; 'fish_egg'; 'house'; 'Salpida';
% 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 'Narcomedusae'; 
% 'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 'Mollusca'; 't005'}; % 'Eucalanidae';'Eumalacostraca';'part_Copepoda'; 'Appendicularia';  'Polychaeta'; 'Cephalopoda'; 'egg_Teleostei' 'Solmundella_bitentaculata';

% % %P2 part1 val
Metazoa = {'Annelida'; 'Polychaeta'; 'Poeobius'; 'Crustacea'; 'Hyperia';
'like_Amphipoda'; 'shrimp_like'; 'Copepoda_Maxillopoda'; 'like_Copepoda'; 
'Ostracoda'; 'Chaetognatha'; 'Teleostei'; 'fish_egg'; 'house'; 'Doliolida'; 'Salpida';
'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 'Narcomedusae'; 'Solmundella_bitentaculata';
'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 'Mollusca'}; % 'Eucalanidae';'Eumalacostraca';'part_Copepoda'; 'Appendicularia';   'Cephalopoda'; 'egg_Teleostei'  ; 't005' 

% % %P2 part2 val
% Metazoa = {'Annelida'; 'Polychaeta'; 'Poeobius'; 'Crustacea'; 'Hyperia';
% 'like_Amphipoda'; 'shrimp_like'; 'Copepoda_Maxillopoda'; 'like_Copepoda'; 
% 'Ostracoda'; 'Chaetognatha'; 'Teleostei'; 'fish_egg'; 'house'; 'Doliolida'; 'Salpida';
% 'Cnidaria_Metazoa'; 'Hydrozoa'; 'Siphonophorae'; 'Narcomedusae'; 
% 'tentacle_Cnidaria'; 'Ctenophora_Metazoa'; 'Mollusca'; 't005' }; % 'Solmundella_bitentaculata'; 'Eucalanidae';'Eumalacostraca';'part_Copepoda'; 'Appendicularia';   'Cephalopoda'; 'egg_Teleostei'  

Living = [Metazoa; Rhizaria_harosa; Photosynthetic]; 

Detritus = [Fluffy_agg; Dense_agg; Fiber; Feces]; 

%% assign values to summary variables in zoo file
summary_categories = {'Fluffy_agg'; 'Dense_agg'; 'Fiber'; 'Feces'; 'Bad_focus';...
    'Not_relevant'; 'Photosynthetic'; 'Rhizaria_harosa'; 'Arthro_crustacea'; ...
    'Gelatinous'; 'Metazoa'; 'Living'; 'Detritus'};
for in1 = 1:length(summary_categories)
    formatSpec_num = 'zoo.%s_num = NaN(length(zoo.Depth),1);';
    eval(sprintf(formatSpec_num, char(summary_categories(in1)))); %add one for num
    formatSpec_conc = 'zoo.%s_M_3 = NaN(length(zoo.Depth),1);';
    eval(sprintf(formatSpec_conc, char(summary_categories(in1))));
    formatSpec_biov = 'zoo.%s_mm3L_1 = NaN(length(zoo.Depth),1);';
    eval(sprintf(formatSpec_biov, char(summary_categories(in1))));
    formatSpec_avgsz = 'zoo.%s_mm = NaN(length(zoo.Depth),1);';
    eval(sprintf(formatSpec_avgsz, char(summary_categories(in1))));
    formatSpec_grey = 'zoo.%s_grey = NaN(length(zoo.Depth),1);';
    eval(sprintf(formatSpec_grey, char(summary_categories(in1))));
end

for in = 1:length(Fluffy_agg)
    formatSpec_conc = 'zoo.Fluffy_agg_M_3 = sum([zoo.Fluffy_agg_M_3, zoo.%s_M_3], 2, "omitnan");'; %concentration
    eval(sprintf(formatSpec_conc, char(Fluffy_agg(in)))); %concentration
    formatSpec_biov = 'zoo.Fluffy_agg_mm3L_1 = sum([zoo.Fluffy_agg_mm3L_1, zoo.%s_mm3L_1], 2, "omitnan");'; %biovol
    eval(sprintf(formatSpec_biov, char(Fluffy_agg(in)))); %biovol
    formatSpec_avgsz = 'zoo.Fluffy_agg_mm = sum([zoo.Fluffy_agg_mm, zoo.%s_mm], 2, "omitnan");'; %avg size
    eval(sprintf(formatSpec_avgsz, char(Fluffy_agg(in)))); %avg size
    formatSpec_grey = 'zoo.Fluffy_agg_grey = sum([zoo.Fluffy_agg_grey, zoo.%s_grey], 2, "omitnan");'; %grey
    eval(sprintf(formatSpec_grey, char(Fluffy_agg(in)))); %grey
    formatSpec_num = 'zoo.Fluffy_agg_num = sum([zoo.Fluffy_agg_num, zoo.%s_num], 2, "omitnan");'; %number of particles
    eval(sprintf(formatSpec_num, char(Fluffy_agg(in)))); %number of particles
end
zoo.Fluffy_agg_mm = zoo.Fluffy_agg_mm./ zoo.Fluffy_agg_num; %divide by number of particles in each bin
zoo.Fluffy_agg_grey = zoo.Fluffy_agg_grey./ zoo.Fluffy_agg_num; %divide by number of particles in each bin

for in = 1:length(Dense_agg)
    formatSpec_conc = 'zoo.Dense_agg_M_3 = sum([zoo.Dense_agg_M_3, zoo.%s_M_3], 2, "omitnan");'; %concentration
    eval(sprintf(formatSpec_conc, char(Dense_agg(in)))); %concentration
    formatSpec_biov = 'zoo.Dense_agg_mm3L_1 = sum([zoo.Dense_agg_mm3L_1, zoo.%s_mm3L_1], 2, "omitnan");'; %biovol
    eval(sprintf(formatSpec_biov, char(Dense_agg(in)))); %biovol
    formatSpec_avgsz = 'zoo.Dense_agg_mm = sum([zoo.Dense_agg_mm, zoo.%s_mm], 2, "omitnan");'; %avg size
    eval(sprintf(formatSpec_avgsz, char(Dense_agg(in)))); %avg size
    formatSpec_grey = 'zoo.Dense_agg_grey = sum([zoo.Dense_agg_grey, zoo.%s_grey], 2, "omitnan");'; %grey
    eval(sprintf(formatSpec_grey, char(Dense_agg(in)))); %grey
    formatSpec_num = 'zoo.Dense_agg_num = sum([zoo.Dense_agg_num, zoo.%s_num], 2, "omitnan");'; %number of particles
    eval(sprintf(formatSpec_num, char(Dense_agg(in)))); %number of particles
end
zoo.Dense_agg_mm = zoo.Dense_agg_mm./ zoo.Dense_agg_num; %divide by number of particles in each bin
zoo.Dense_agg_grey = zoo.Dense_agg_grey./ zoo.Dense_agg_num; %divide by number of particles in each bin

for in = 1:length(Fiber)
    formatSpec_conc = 'zoo.Fiber_M_3 = sum([zoo.Fiber_M_3, zoo.%s_M_3], 2, "omitnan");'; %concentration
    eval(sprintf(formatSpec_conc, char(Fiber(in)))); %concentration
    formatSpec_biov = 'zoo.Fiber_mm3L_1 = sum([zoo.Fiber_mm3L_1, zoo.%s_mm3L_1], 2, "omitnan");'; %biovol
    eval(sprintf(formatSpec_biov, char(Fiber(in)))); %biovol
    formatSpec_avgsz = 'zoo.Fiber_mm = sum([zoo.Fiber_mm, zoo.%s_mm], 2, "omitnan");'; %avg size
    eval(sprintf(formatSpec_avgsz, char(Fiber(in)))); %avg size
    formatSpec_grey = 'zoo.Fiber_grey = sum([zoo.Fiber_grey, zoo.%s_grey], 2, "omitnan");'; %grey
    eval(sprintf(formatSpec_grey, char(Fiber(in)))); %grey
    formatSpec_num = 'zoo.Fiber_num = sum([zoo.Fiber_num, zoo.%s_num], 2, "omitnan");'; %number of particles
    eval(sprintf(formatSpec_num, char(Fiber(in)))); %number of particles
end
zoo.Fiber_mm = zoo.Fiber_mm./ zoo.Fiber_num; %divide by number of particles in each bin
zoo.Fiber_grey = zoo.Fiber_grey./ zoo.Fiber_num; %divide by number of particles in each bin

for in = 1:length(Feces)
    formatSpec_conc = 'zoo.Feces_M_3 = sum([zoo.Feces_M_3, zoo.%s_M_3], 2, "omitnan");'; %concentration
    eval(sprintf(formatSpec_conc, char(Feces(in)))); %concentration
    formatSpec_biov = 'zoo.Feces_mm3L_1 = sum([zoo.Feces_mm3L_1, zoo.%s_mm3L_1], 2, "omitnan");'; %biovol
    eval(sprintf(formatSpec_biov, char(Feces(in)))); %biovol
    formatSpec_avgsz = 'zoo.Feces_mm = sum([zoo.Feces_mm, zoo.%s_mm], 2, "omitnan");'; %avg size
    eval(sprintf(formatSpec_avgsz, char(Feces(in)))); %avg size
    formatSpec_grey = 'zoo.Feces_grey = sum([zoo.Feces_grey, zoo.%s_grey], 2, "omitnan");'; %grey
    eval(sprintf(formatSpec_grey, char(Feces(in)))); %grey
    formatSpec_num = 'zoo.Feces_num = sum([zoo.Feces_num, zoo.%s_num], 2, "omitnan");'; %number of particles
    eval(sprintf(formatSpec_num, char(Feces(in)))); %number of particles
end
zoo.Feces_mm = zoo.Feces_mm./ zoo.Feces_num; %divide by number of particles in each bin
zoo.Feces_grey = zoo.Feces_grey./ zoo.Feces_num; %divide by number of particles in each bin

for in = 1:length(Bad_focus)
    formatSpec_conc = 'zoo.Bad_focus_M_3 = sum([zoo.Bad_focus_M_3, zoo.%s_M_3], 2, "omitnan");'; %concentration
    eval(sprintf(formatSpec_conc, char(Bad_focus(in)))); %concentration
    formatSpec_biov = 'zoo.Bad_focus_mm3L_1 = sum([zoo.Bad_focus_mm3L_1, zoo.%s_mm3L_1], 2, "omitnan");'; %biovol
    eval(sprintf(formatSpec_biov, char(Bad_focus(in)))); %biovol
    formatSpec_avgsz = 'zoo.Bad_focus_mm = sum([zoo.Bad_focus_mm, zoo.%s_mm], 2, "omitnan");'; %avg size
    eval(sprintf(formatSpec_avgsz, char(Bad_focus(in)))); %avg size
    formatSpec_grey = 'zoo.Bad_focus_grey = sum([zoo.Bad_focus_grey, zoo.%s_grey], 2, "omitnan");'; %grey
    eval(sprintf(formatSpec_grey, char(Bad_focus(in)))); %grey
    formatSpec_num = 'zoo.Bad_focus_num = sum([zoo.Bad_focus_num, zoo.%s_num], 2, "omitnan");'; %number of particles
    eval(sprintf(formatSpec_num, char(Bad_focus(in)))); %number of particles
end
zoo.Bad_focus_mm = zoo.Bad_focus_mm./ zoo.Bad_focus_num; %divide by number of particles in each bin
zoo.Bad_focus_grey = zoo.Bad_focus_grey./ zoo.Bad_focus_num; %divide by number of particles in each bin

for in = 1:length(Not_relevant)
    formatSpec_conc = 'zoo.Not_relevant_M_3 = sum([zoo.Not_relevant_M_3, zoo.%s_M_3], 2, "omitnan");'; %concentration
    eval(sprintf(formatSpec_conc, char(Not_relevant(in)))); %concentration
    formatSpec_biov = 'zoo.Not_relevant_mm3L_1 = sum([zoo.Not_relevant_mm3L_1, zoo.%s_mm3L_1], 2, "omitnan");'; %biovol
    eval(sprintf(formatSpec_biov, char(Not_relevant(in)))); %biovol
    formatSpec_avgsz = 'zoo.Not_relevant_mm = sum([zoo.Not_relevant_mm, zoo.%s_mm], 2, "omitnan");'; %avg size
    eval(sprintf(formatSpec_avgsz, char(Not_relevant(in)))); %avg size
    formatSpec_grey = 'zoo.Not_relevant_grey = sum([zoo.Not_relevant_grey, zoo.%s_grey], 2, "omitnan");'; %grey
    eval(sprintf(formatSpec_grey, char(Not_relevant(in)))); %grey
    formatSpec_num = 'zoo.Not_relevant_num = sum([zoo.Not_relevant_num, zoo.%s_num], 2, "omitnan");'; %number of particles
    eval(sprintf(formatSpec_num, char(Not_relevant(in)))); %number of particles
end
zoo.Not_relevant_mm = zoo.Not_relevant_mm./ zoo.Not_relevant_num; %divide by number of particles in each bin
zoo.Not_relevant_grey = zoo.Not_relevant_grey./ zoo.Not_relevant_num; %divide by number of particles in each bin

for in = 1:length(Photosynthetic)
    formatSpec_conc = 'zoo.Photosynthetic_M_3 = sum([zoo.Photosynthetic_M_3, zoo.%s_M_3], 2, "omitnan");'; %concentration
    eval(sprintf(formatSpec_conc, char(Photosynthetic(in)))); %concentration
    formatSpec_biov = 'zoo.Photosynthetic_mm3L_1 = sum([zoo.Photosynthetic_mm3L_1, zoo.%s_mm3L_1], 2, "omitnan");'; %biovol
    eval(sprintf(formatSpec_biov, char(Photosynthetic(in)))); %biovol
    formatSpec_avgsz = 'zoo.Photosynthetic_mm = sum([zoo.Photosynthetic_mm, zoo.%s_mm], 2, "omitnan");'; %avg size
    eval(sprintf(formatSpec_avgsz, char(Photosynthetic(in)))); %avg size
    formatSpec_grey = 'zoo.Photosynthetic_grey = sum([zoo.Photosynthetic_grey, zoo.%s_grey], 2, "omitnan");'; %grey
    eval(sprintf(formatSpec_grey, char(Photosynthetic(in)))); %grey
    formatSpec_num = 'zoo.Photosynthetic_num = sum([zoo.Photosynthetic_num, zoo.%s_num], 2, "omitnan");'; %number of particles
    eval(sprintf(formatSpec_num, char(Photosynthetic(in)))); %number of particles
end
zoo.Photosynthetic_mm = zoo.Photosynthetic_mm./ zoo.Photosynthetic_num; %divide by number of particles in each bin
zoo.Photosynthetic_grey = zoo.Photosynthetic_grey./ zoo.Photosynthetic_num; %divide by number of particles in each bin

for in = 1:length(Rhizaria_harosa)
    formatSpec_conc = 'zoo.Rhizaria_harosa_M_3 = sum([zoo.Rhizaria_harosa_M_3, zoo.%s_M_3], 2, "omitnan");'; %concentration
    eval(sprintf(formatSpec_conc, char(Rhizaria_harosa(in)))); %concentration
    formatSpec_biov = 'zoo.Rhizaria_harosa_mm3L_1 = sum([zoo.Rhizaria_harosa_mm3L_1, zoo.%s_mm3L_1], 2, "omitnan");'; %biovol
    eval(sprintf(formatSpec_biov, char(Rhizaria_harosa(in)))); %biovol
    formatSpec_avgsz = 'zoo.Rhizaria_harosa_mm = sum([zoo.Rhizaria_harosa_mm, zoo.%s_mm], 2, "omitnan");'; %avg size
    eval(sprintf(formatSpec_avgsz, char(Rhizaria_harosa(in)))); %avg size
    formatSpec_grey = 'zoo.Rhizaria_harosa_grey = sum([zoo.Rhizaria_harosa_grey, zoo.%s_grey], 2, "omitnan");'; %grey
    eval(sprintf(formatSpec_grey, char(Rhizaria_harosa(in)))); %grey
    formatSpec_num = 'zoo.Rhizaria_harosa_num = sum([zoo.Rhizaria_harosa_num, zoo.%s_num], 2, "omitnan");'; %number of particles
    eval(sprintf(formatSpec_num, char(Rhizaria_harosa(in)))); %number of particles
end
zoo.Rhizaria_harosa_mm = zoo.Rhizaria_harosa_mm./ zoo.Rhizaria_harosa_num; %divide by number of particles in each bin
zoo.Rhizaria_harosa_grey = zoo.Rhizaria_harosa_grey./ zoo.Rhizaria_harosa_num; %divide by number of particles in each bin

for in = 1:length(Arthro_crustacea)
    formatSpec_conc = 'zoo.Arthro_crustacea_M_3 = sum([zoo.Arthro_crustacea_M_3, zoo.%s_M_3], 2, "omitnan");'; %concentration
    eval(sprintf(formatSpec_conc, char(Arthro_crustacea(in)))); %concentration
    formatSpec_biov = 'zoo.Arthro_crustacea_mm3L_1 = sum([zoo.Arthro_crustacea_mm3L_1, zoo.%s_mm3L_1], 2, "omitnan");'; %biovol
    eval(sprintf(formatSpec_biov, char(Arthro_crustacea(in)))); %biovol
    formatSpec_avgsz = 'zoo.Arthro_crustacea_mm = sum([zoo.Arthro_crustacea_mm, zoo.%s_mm], 2, "omitnan");'; %avg size
    eval(sprintf(formatSpec_avgsz, char(Arthro_crustacea(in)))); %avg size
    formatSpec_grey = 'zoo.Arthro_crustacea_grey = sum([zoo.Arthro_crustacea_grey, zoo.%s_grey], 2, "omitnan");'; %grey
    eval(sprintf(formatSpec_grey, char(Arthro_crustacea(in)))); %grey
    formatSpec_num = 'zoo.Arthro_crustacea_num = sum([zoo.Arthro_crustacea_num, zoo.%s_num], 2, "omitnan");'; %number of particles
    eval(sprintf(formatSpec_num, char(Arthro_crustacea(in)))); %number of particles
end
zoo.Arthro_crustacea_mm = zoo.Arthro_crustacea_mm./ zoo.Arthro_crustacea_num; %divide by number of particles in each bin
zoo.Arthro_crustacea_grey = zoo.Arthro_crustacea_grey./ zoo.Arthro_crustacea_num; %divide by number of particles in each bin

for in = 1:length(Gelatinous)
    formatSpec_conc = 'zoo.Gelatinous_M_3 = sum([zoo.Gelatinous_M_3, zoo.%s_M_3], 2, "omitnan");'; %concentration
    eval(sprintf(formatSpec_conc, char(Gelatinous(in)))); %concentration
    formatSpec_biov = 'zoo.Gelatinous_mm3L_1 = sum([zoo.Gelatinous_mm3L_1, zoo.%s_mm3L_1], 2, "omitnan");'; %biovol
    eval(sprintf(formatSpec_biov, char(Gelatinous(in)))); %biovol
    formatSpec_avgsz = 'zoo.Gelatinous_mm = sum([zoo.Gelatinous_mm, zoo.%s_mm], 2, "omitnan");'; %avg size
    eval(sprintf(formatSpec_avgsz, char(Gelatinous(in)))); %avg size
    formatSpec_grey = 'zoo.Gelatinous_grey = sum([zoo.Gelatinous_grey, zoo.%s_grey], 2, "omitnan");'; %grey
    eval(sprintf(formatSpec_grey, char(Gelatinous(in)))); %grey
    formatSpec_num = 'zoo.Gelatinous_num = sum([zoo.Gelatinous_num, zoo.%s_num], 2, "omitnan");'; %number of particles
    eval(sprintf(formatSpec_num, char(Gelatinous(in)))); %number of particles
end
zoo.Gelatinous_mm = zoo.Gelatinous_mm./ zoo.Gelatinous_num; %divide by number of particles in each bin
zoo.Gelatinous_grey = zoo.Gelatinous_grey./ zoo.Gelatinous_num;%divide by number of particles in each bin

for in = 1:length(Metazoa)
    formatSpec_conc = 'zoo.Metazoa_M_3 = sum([zoo.Metazoa_M_3, zoo.%s_M_3], 2, "omitnan");'; %concentration
    eval(sprintf(formatSpec_conc, char(Metazoa(in)))); %concentration
    formatSpec_biov = 'zoo.Metazoa_mm3L_1 = sum([zoo.Metazoa_mm3L_1, zoo.%s_mm3L_1], 2, "omitnan");'; %biovol
    eval(sprintf(formatSpec_biov, char(Metazoa(in)))); %biovol
    formatSpec_avgsz = 'zoo.Metazoa_mm = sum([zoo.Metazoa_mm, zoo.%s_mm], 2, "omitnan");'; %avg size
    eval(sprintf(formatSpec_avgsz, char(Metazoa(in)))); %avg size
    formatSpec_grey = 'zoo.Metazoa_grey = sum([zoo.Metazoa_grey, zoo.%s_grey], 2, "omitnan");'; %grey
    eval(sprintf(formatSpec_grey, char(Metazoa(in)))); %grey
    formatSpec_num = 'zoo.Metazoa_num = sum([zoo.Metazoa_num, zoo.%s_num], 2, "omitnan");'; %number of particles
    eval(sprintf(formatSpec_num, char(Metazoa(in)))); %number of particles
end
zoo.Metazoa_mm = zoo.Metazoa_mm./ zoo.Metazoa_num; %divide by number of particles in each bin
zoo.Metazoa_grey = zoo.Metazoa_grey./ zoo.Metazoa_num; %divide by number of particles in each bin

for in = 1:length(Living)
    formatSpec_conc = 'zoo.Living_M_3 = sum([zoo.Living_M_3, zoo.%s_M_3], 2, "omitnan");'; %concentration
    eval(sprintf(formatSpec_conc, char(Living(in)))); %concentration
    formatSpec_biov = 'zoo.Living_mm3L_1 = sum([zoo.Living_mm3L_1, zoo.%s_mm3L_1], 2, "omitnan");'; %biovol
    eval(sprintf(formatSpec_biov, char(Living(in)))); %biovol
    formatSpec_avgsz = 'zoo.Living_mm = sum([zoo.Living_mm, zoo.%s_mm], 2, "omitnan");'; %avg size
    eval(sprintf(formatSpec_avgsz, char(Living(in)))); %avg size
    formatSpec_grey = 'zoo.Living_grey = sum([zoo.Living_grey, zoo.%s_grey], 2, "omitnan");'; %grey
    eval(sprintf(formatSpec_grey, char(Living(in)))); %grey
    formatSpec_num = 'zoo.Living_num = sum([zoo.Living_num, zoo.%s_num], 2, "omitnan");'; %number of particles
    eval(sprintf(formatSpec_num, char(Living(in)))); %number of particles
end
zoo.Living_mm = zoo.Living_mm./ zoo.Living_num; %divide by number of particles in each bin
zoo.Living_grey = zoo.Living_grey./ zoo.Living_num; %divide by number of particles in each bin

for in = 1:length(Detritus)
    formatSpec_conc = 'zoo.Detritus_M_3 = sum([zoo.Detritus_M_3, zoo.%s_M_3], 2, "omitnan");'; %concentration
    eval(sprintf(formatSpec_conc, char(Detritus(in)))); %concentration
    formatSpec_biov = 'zoo.Detritus_mm3L_1 = sum([zoo.Detritus_mm3L_1, zoo.%s_mm3L_1], 2, "omitnan");'; %biovol
    eval(sprintf(formatSpec_biov, char(Detritus(in)))); %biovol
    formatSpec_avgsz = 'zoo.Detritus_mm = sum([zoo.Detritus_mm, zoo.%s_mm], 2, "omitnan");'; %avg size
    eval(sprintf(formatSpec_avgsz, char(Detritus(in)))); %avg size
    formatSpec_grey = 'zoo.Detritus_grey = sum([zoo.Detritus_grey, zoo.%s_grey], 2, "omitnan");'; %grey
    eval(sprintf(formatSpec_grey, char(Detritus(in)))); %grey
    formatSpec_num = 'zoo.Detritus_num = sum([zoo.Detritus_num, zoo.%s_num], 2, "omitnan");'; %number of particles
    eval(sprintf(formatSpec_num, char(Detritus(in)))); %number of particles
end
zoo.Detritus_mm = zoo.Detritus_mm./zoo.Detritus_num; %divide by number of particles in each bin
zoo.Detritus_grey = zoo.Detritus_grey./ zoo.Detritus_num; %divide by number of particles in each bin

%% change this for what you're running

%save('G:/MS_Southern_Ocean/data/zoo_s04p_val_photo_no_fiber_5Sept2024.mat', 'zoo') 
%save('G:/MS_Southern_Ocean/data/zoo_s04p_val_pred_photo_no_fiber_3Apr2024.mat', 'zoo') 
%save('G:/MS_Southern_Ocean/data/zoo_s04p_val_photo_no_fiber_20Feb2025.mat', 'zoo') 
%save('G:/MS_Southern_Ocean/data/zoo_i06s_val_photo_no_fiber_5Sept2024.mat', 'zoo') 
%save('G:/MS_Southern_Ocean/data/zoo_i06s_val_pred_photo_no_fiber_3Apr2024.mat', 'zoo') 
%save('G:/MS_Southern_Ocean/data/zoo_i06s_val_photo_no_fiber_3Apr2024.mat', 'zoo') 
%save('G:/MS_Southern_Ocean/data/zoo_a22_val_pred_photo_no_fiber_7Apr2024.mat', 'zoo') 
%save('G:/MS_Southern_Ocean/data/zoo_a22_val_photo_no_fiber_7Apr2024.mat', 'zoo') 
%save('G:/MS_Southern_Ocean/data/zoo_p2_val_pred_photo_no_fiber_7Apr2024.mat', 'zoo') 
%save('G:/MS_Southern_Ocean/data/zoo_p2_val_photo_no_fiber_7Apr2024.mat', 'zoo') 
%save('G:/MS_Southern_Ocean/data/zoo_p2_val_photo_no_fiber_05Dec2025.mat', 'zoo') 
save('G:/MS_Southern_Ocean/data/zoo_p2_val_pred_photo_no_fiber_05Dec2025.mat', 'zoo') 
%save('G:/MS_Southern_Ocean/data/zoo_p2_part2_val_pred_photo_no_fiber_7Apr2024.mat', 'zoo') 
%save('G:/MS_Southern_Ocean/data/zoo_p2_part2_val_photo_no_fiber_05_Dec_2025.mat', 'zoo') 
%save('G:/MS_Southern_Ocean/data/zoo_p2_part2_val_pred_photo_no_fiber_05_Dec_2025.mat', 'zoo') 



%% Old visualization simple pie chart?
% summary = readtable("G:/MS_Southern_Ocean/export_summary_9566_20230907_1918.tsv", "FileType","text",'Delimiter', '\t');
% 
% %make a pie chart with agg-fiber, agg dense, agg fluffy, fecal pellets, and
% %living as different colors
% 
% %rows for dense agg 77:90
% dense = sum(summary{77:90,2});
% %rows for fluffy agg 91:120
% fluffy = sum(summary{91:120,2});
% %rows for fiber 176:185
% fiber = sum(summary{176:185, 2});
% %rows for fecal pellets 149 : 175
% fecal = sum(summary{149:175,2});
% %rows for living 1:46 + 53:55 + 121:128 +135:148 + 196:203
% living = sum(summary{[1:46 53:55 121:128 135:148 196:203],2});
% %other = 47:52 + 56:76 + 129:134 + 186:195 + 204:214
% other = sum(summary{[47:52, 56:76, 129:134, 186:195, 204:214], 2});
% 
% X = [fluffy,dense, fecal,  fiber,living, other];
% labels = {'Fluffy','Dense','Fecal', 'Fiber', 'Living', 'Other'};
% pie(X,labels)
% 
% %check
% sum(summary{:, 2})
% sum(X)
% 
% %load new datafile
% summary_depth = readtable('G:/MS_Southern_Ocean/ecotaxa_processing_workflow_summary_7sept2023.csv');
% 
% y = [2 2 3; 2 5 6; 2 8 9; 2 11 12];
% bar(y)
% 
% x = [1 2];
% vals = [2 3 6; 11 23 26];
% b = bar(x,vals);
% 
% depth = [1 2 3]; %]['0-2000 m', '200 - 1000 m', '1000 - 6000 m'];
% values = [summary_depth{:,4}'; summary_depth{:,5}'; summary_depth{:,6}'];
% fig1 = figure(2);
% b = bar(depth,values, "stacked");