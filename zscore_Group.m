function [Grouped_GCAMP] = zscore_Group(Grouped_GCAMP)
All_HE = [];
first_HE = [];
LLP = [];
LLP_bout = [];
LLP_bout_2nd = [];
RLP = [];
HE_mean = [];
HE_mean_above = [];
first_HE_mean = [];
first_HE_mean_above = [];
LLP_mean = [];
LLP_mean_above = [];
LLP_bout_mean = [];
LLP_bout_mean_above = [];
LLP_bout_2nd_mean = [];
LLP_bout_2nd_mean_above = [];
RLP_mean = [];
RLP_mean_above = [];
HE_AUC = [];
first_HE_AUC = [];
LLP_AUC = [];
LLP_bout_AUC = [];
LLP_bout_2nd_AUC = [];
RLP_AUC = [];
LLP_bout_lengths = [];
LLP_bout_IPI_means = [];

for mouse = 1:length(Grouped_GCAMP.Mouse)
    %% All HE
    [include] = includeSession(Grouped_GCAMP.Mouse{mouse}.baseline_HE_On, Grouped_GCAMP.Mouse{mouse}.delta_F_HE_On);
    if include == 1 || include ==0 
        All_HE = [All_HE; Grouped_GCAMP.Mouse{mouse}.baseline_z_score_HE_On];
        HE_mean = [HE_mean; mean(Grouped_GCAMP.Mouse{mouse}.baseline_z_score_HE_On,1)];
         HE_mean_above = [HE_mean_above; mean(Grouped_GCAMP.Mouse{mouse}.baseline_z_score_HE_On_above,1)];
        HE_AUC = [HE_AUC; Grouped_GCAMP.Mouse{mouse}.baseline_z_score_HE_On_AUC];
    else
        ['excluded HE ' Grouped_GCAMP.Mouse{mouse}.mouseID]
    end   
    
    %% First HE
    [include] = includeSession(Grouped_GCAMP.Mouse{mouse}.baseline_First_HE_On, Grouped_GCAMP.Mouse{mouse}.delta_F_First_HE_On);
    if include == 1 || include ==0 
        first_HE = [first_HE; Grouped_GCAMP.Mouse{mouse}.baseline_z_score_First_HE_On];
        first_HE_mean = [first_HE_mean; mean(Grouped_GCAMP.Mouse{mouse}.baseline_z_score_First_HE_On,1)];
         first_HE_mean_above = [first_HE_mean_above; mean(Grouped_GCAMP.Mouse{mouse}.baseline_z_score_First_HE_On_above,1)];
        first_HE_AUC = [first_HE_AUC; Grouped_GCAMP.Mouse{mouse}.baseline_z_score_First_HE_On_AUC];
    else
        ['excluded First HE ' Grouped_GCAMP.Mouse{mouse}.mouseID]
    end  
    %% Left Lever Press
    [include] = includeSession(Grouped_GCAMP.Mouse{mouse}.baseline_LLP_On, Grouped_GCAMP.Mouse{mouse}.delta_F_LLP_On);
    if include == 1 || include ==0 
        LLP = [LLP; Grouped_GCAMP.Mouse{mouse}.baseline_z_score_LLP_On];
        LLP_mean = [LLP_mean; mean(Grouped_GCAMP.Mouse{mouse}.baseline_z_score_LLP_On,1)];
        LLP_mean_above = [LLP_mean_above; mean(Grouped_GCAMP.Mouse{mouse}.baseline_z_score_LLP_On_above,1)];
        LLP_AUC = [LLP_AUC; Grouped_GCAMP.Mouse{mouse}.baseline_z_score_LLP_On_AUC];
    else
        ['excluded LLP ' Grouped_GCAMP.Mouse{mouse}.mouseID]
    end
    %% Left Lever Press Bout
    [include] = includeSession(Grouped_GCAMP.Mouse{mouse}.baseline_LLPBout_On, Grouped_GCAMP.Mouse{mouse}.delta_F_LLPBout_On);
    if include == 1 || include ==0 
        LLP_bout = [LLP_bout; Grouped_GCAMP.Mouse{mouse}.baseline_z_score_LLPBout_On];
        LLP_bout_mean = [LLP_bout_mean; mean(Grouped_GCAMP.Mouse{mouse}.baseline_z_score_LLPBout_On,1)];
        LLP_bout_mean_above = [LLP_bout_mean_above; mean(Grouped_GCAMP.Mouse{mouse}.baseline_z_score_LLPBout_On_above,1)];
        LLP_bout_AUC = [LLP_bout_AUC; Grouped_GCAMP.Mouse{mouse}.baseline_z_score_LLPBout_On_AUC];
    else
        ['excluded LLP Bout ' Grouped_GCAMP.Mouse{mouse}.mouseID]
    end
     %% Left Lever Press Bout - 2nd press
    [include] = includeSession(Grouped_GCAMP.Mouse{mouse}.baseline_LLPBout_2nd_On, Grouped_GCAMP.Mouse{mouse}.delta_F_LLPBout_2nd_On);
    if include == 1 || include ==0 
        LLP_bout_2nd = [LLP_bout_2nd; Grouped_GCAMP.Mouse{mouse}.baseline_z_score_LLPBout_2nd_On];
        LLP_bout_2nd_mean = [LLP_bout_2nd_mean; mean(Grouped_GCAMP.Mouse{mouse}.baseline_z_score_LLPBout_2nd_On,1)];
        LLP_bout_2nd_mean_above = [LLP_bout_2nd_mean_above; mean(Grouped_GCAMP.Mouse{mouse}.baseline_z_score_LLPBout_2nd_On_above,1)];
        LLP_bout_2nd_AUC = [LLP_bout_2nd_AUC; Grouped_GCAMP.Mouse{mouse}.baseline_z_score_LLPBout_2nd_On_AUC];
    else
        ['excluded LLP Bout ' Grouped_GCAMP.Mouse{mouse}.mouseID]
    end
    %% Right Lever Press
    [include] = includeSession(Grouped_GCAMP.Mouse{mouse}.baseline_RLP_On, Grouped_GCAMP.Mouse{mouse}.delta_F_RLP_On);
    if include == 1 || include ==0 
        RLP = [RLP; Grouped_GCAMP.Mouse{mouse}.baseline_z_score_RLP_On];
        RLP_mean = [RLP_mean; mean(Grouped_GCAMP.Mouse{mouse}.baseline_z_score_RLP_On,1)];
        RLP_mean_above = [RLP_mean_above; mean(Grouped_GCAMP.Mouse{mouse}.baseline_z_score_RLP_On_above,1)];
        RLP_AUC = [RLP_AUC; Grouped_GCAMP.Mouse{mouse}.baseline_z_score_RLP_On_AUC];
    else
        ['excluded RLP ' Grouped_GCAMP.Mouse{mouse}.mouseID]
    end
end

Grouped_GCAMP.All_HE = [All_HE];
Grouped_GCAMP.HE_mean = [HE_mean];
Grouped_GCAMP.first_HE = [first_HE];
Grouped_GCAMP.LLP = [LLP];
Grouped_GCAMP.LLP_bout = [LLP_bout];
Grouped_GCAMP.LLP_bout_2nd = [LLP_bout_2nd];
Grouped_GCAMP.RLP = [RLP];
Grouped_GCAMP.first_HE_mean = [first_HE_mean];
Grouped_GCAMP.LLP_mean = [LLP_mean];
Grouped_GCAMP.LLP_bout_mean = [LLP_bout_mean];
Grouped_GCAMP.LLP_bout_2nd_mean = [LLP_bout_2nd_mean];
Grouped_GCAMP.RLP_mean = [RLP_mean];
Grouped_GCAMP.first_HE_AUC = [first_HE_AUC];
Grouped_GCAMP.LLP_AUC = [LLP_AUC];
Grouped_GCAMP.LLP_bout_AUC = [LLP_bout_AUC];
Grouped_GCAMP.LLP_bout_2nd_AUC = [LLP_bout_2nd_AUC];
Grouped_GCAMP.RLP_AUC = [RLP_AUC];

%% Threshold
[Grouped_GCAMP.HE_above] = zscore_Threshold(Grouped_GCAMP.All_HE);
[Grouped_GCAMP.HE_mean_above] = [HE_mean_above];
[Grouped_GCAMP.first_HE_above] = zscore_Threshold(Grouped_GCAMP.first_HE);
[Grouped_GCAMP.first_HE_mean_above] = [first_HE_mean_above];
[Grouped_GCAMP.LLP_above] = zscore_Threshold(Grouped_GCAMP.LLP);
[Grouped_GCAMP.LLP_mean_above] = [LLP_mean_above];
[Grouped_GCAMP.LLP_bout_above] = zscore_Threshold(Grouped_GCAMP.LLP_bout);
[Grouped_GCAMP.LLP_bout_mean_above] = [LLP_bout_mean_above];
[Grouped_GCAMP.LLP_bout_2nd_above] = zscore_Threshold(Grouped_GCAMP.LLP_bout_2nd);
[Grouped_GCAMP.LLP_bout_2nd_mean_above] = [LLP_bout_2nd_mean_above];
[Grouped_GCAMP.RLP_above] = zscore_Threshold(Grouped_GCAMP.RLP);
[Grouped_GCAMP.RLP_mean_above] = [RLP_mean_above];



end

