function [GCAMP] = GCAMP_Zscore_All(GCAMP)
AUC_bin_samples = 2; %GCAMP.AUC_bin_time / (1/GCAMP.SR);
%AUC_bin_windows = 1:AUC_bin_samples:length(GCAMP.baseline_z_score_First_HE_On);
plot_time = GCAMP.base_time_end:1/GCAMP.SR:GCAMP.time_end;
AUC_bin_windows = 1:AUC_bin_samples:length(plot_time);
%% First Head Entry After Reward
delta_F_First_HE_ON_baseline_z_score_smooth = [];
delta_F_First_HE_ON_baseline = [];
delta_F_First_HE_ON = [];
window_AUC_First_HE_On = [];
for i = 1:length(GCAMP.First_HE_ON_timestamps) %for each first head entry after reward timestamp
    Closest_First_HE_ON_idx = nearestpoint(GCAMP.First_HE_ON_timestamps(i), GCAMP.gcampdata_timestamps);
    data_window_First_HE_ON = GCAMP.delta_F_p(Closest_First_HE_ON_idx + GCAMP.base_time_end * GCAMP.SR : Closest_First_HE_ON_idx + GCAMP.time_end * GCAMP.SR)';
    data_window_First_HE_ON_baseline = GCAMP.delta_F_p(Closest_First_HE_ON_idx + GCAMP.base_time_start * GCAMP.SR : Closest_First_HE_ON_idx + GCAMP.base_time_end * GCAMP.SR);
    delta_F_First_HE_ON_baseline = [delta_F_First_HE_ON_baseline; data_window_First_HE_ON_baseline'];
    delta_F_First_HE_ON = [delta_F_First_HE_ON; data_window_First_HE_ON];
    baseline_mean = mean(data_window_First_HE_ON_baseline);
    baseline_std = std(data_window_First_HE_ON_baseline);
    delta_F_First_HE_ON_baseline_z_score = (data_window_First_HE_ON - baseline_mean) ./baseline_std;
    delta_F_First_HE_ON_baseline_z_score_smooth = [delta_F_First_HE_ON_baseline_z_score_smooth; smoothdata(delta_F_First_HE_ON_baseline_z_score, 'gaussian',10)];
    window_AUC = [];
    for window_idx = 1:length(AUC_bin_windows)-1
        bin_window = [AUC_bin_windows(window_idx) AUC_bin_windows(window_idx+1)];
        data_window = delta_F_First_HE_ON_baseline_z_score_smooth(bin_window(1):bin_window(2));
        window_AUC = [window_AUC trapz(data_window)];
    end
    window_AUC_First_HE_On = [window_AUC_First_HE_On; window_AUC];
end
GCAMP.baseline_z_score_First_HE_On = delta_F_First_HE_ON_baseline_z_score_smooth;
GCAMP.baseline_z_score_First_HE_On_above = zscore_Threshold(delta_F_First_HE_ON_baseline_z_score_smooth);
GCAMP.baseline_z_score_First_HE_On_above_mean = mean(GCAMP.baseline_z_score_First_HE_On_above);
GCAMP.baseline_z_score_First_HE_On_AUC = window_AUC_First_HE_On;
GCAMP.baseline_First_HE_On = delta_F_First_HE_ON_baseline;
GCAMP.delta_F_First_HE_On = delta_F_First_HE_ON;

%% All Head Entries 
delta_F_HE_ON_baseline_z_score_smooth = [];
delta_F_HE_ON_baseline = [];
delta_F_HE_ON = [];
window_AUC_HE_On = [];
for i = 1:length(GCAMP.HE_ON_timestamps) %for each first head entry after reward timestamp
    Closest_HE_ON_idx = nearestpoint(GCAMP.HE_ON_timestamps(i), GCAMP.gcampdata_timestamps);
    data_window_HE_ON = GCAMP.delta_F_p(Closest_HE_ON_idx + GCAMP.base_time_end * GCAMP.SR : Closest_HE_ON_idx + GCAMP.time_end * GCAMP.SR)';
    data_window_HE_ON_baseline = GCAMP.delta_F_p(Closest_HE_ON_idx + GCAMP.base_time_start * GCAMP.SR : Closest_HE_ON_idx + GCAMP.base_time_end * GCAMP.SR);
    delta_F_HE_ON_baseline = [delta_F_HE_ON_baseline; data_window_HE_ON_baseline'];
    delta_F_HE_ON = [delta_F_HE_ON; data_window_HE_ON];
    baseline_mean = mean(data_window_HE_ON_baseline);
    baseline_std = std(data_window_HE_ON_baseline);
    delta_F_HE_ON_baseline_z_score = (data_window_HE_ON - baseline_mean) ./baseline_std;
    delta_F_HE_ON_baseline_z_score_smooth = [delta_F_HE_ON_baseline_z_score_smooth; smoothdata(delta_F_HE_ON_baseline_z_score, 'gaussian',10)];
    window_AUC = [];
    for window_idx = 1:length(AUC_bin_windows)-1
        bin_window = [AUC_bin_windows(window_idx) AUC_bin_windows(window_idx+1)];
        data_window = delta_F_HE_ON_baseline_z_score_smooth(bin_window(1):bin_window(2));
        window_AUC = [window_AUC trapz(data_window)];
    end
    window_AUC_HE_On = [window_AUC_HE_On; window_AUC];
end
GCAMP.baseline_z_score_HE_On = delta_F_HE_ON_baseline_z_score_smooth;
GCAMP.baseline_z_score_HE_On_above = zscore_Threshold(delta_F_HE_ON_baseline_z_score_smooth);
GCAMP.baseline_z_score_HE_On_above_mean = mean(GCAMP.baseline_z_score_First_HE_On_above);
GCAMP.baseline_z_score_HE_On_AUC = window_AUC_HE_On;
GCAMP.baseline_HE_On = delta_F_HE_ON_baseline;
GCAMP.delta_F_HE_On = delta_F_HE_ON;

%% Left Lever Press
delta_F_LLP_ON_baseline_z_score_smooth = [];
delta_F_LLP_ON_baseline = [];
delta_F_LLP_ON = [];
window_AUC_LLP_On = [];
for i = 1:length(GCAMP.LLP_ON_timestamps) %for each left lever press timestamp
    Closest_LLP_ON_idx = nearestpoint(GCAMP.LLP_ON_timestamps(i), GCAMP.gcampdata_timestamps);
    data_window_LLP_ON = GCAMP.delta_F_p(Closest_LLP_ON_idx + GCAMP.base_time_end * GCAMP.SR : Closest_LLP_ON_idx + GCAMP.time_end * GCAMP.SR)';
    data_window_LLP_ON_baseline = GCAMP.delta_F_p(Closest_LLP_ON_idx + GCAMP.base_time_start * GCAMP.SR : Closest_LLP_ON_idx + GCAMP.base_time_end * GCAMP.SR);
    delta_F_LLP_ON_baseline = [delta_F_LLP_ON_baseline; data_window_LLP_ON_baseline'];
    delta_F_LLP_ON = [delta_F_LLP_ON; data_window_LLP_ON];
    baseline_mean = mean(data_window_LLP_ON_baseline);
    baseline_std = std(data_window_LLP_ON_baseline);
    delta_F_LLP_ON_baseline_z_score = (data_window_LLP_ON - baseline_mean) ./baseline_std;
    delta_F_LLP_ON_baseline_z_score_smooth = [delta_F_LLP_ON_baseline_z_score_smooth; smoothdata(delta_F_LLP_ON_baseline_z_score, 'gaussian',10)];
    window_AUC = [];
    for window_idx = 1:length(AUC_bin_windows)-1
        bin_window = [AUC_bin_windows(window_idx) AUC_bin_windows(window_idx+1)];
        data_window = delta_F_LLP_ON_baseline_z_score_smooth(bin_window(1):bin_window(2));
        window_AUC = [window_AUC trapz(data_window)];
    end
    window_AUC_LLP_On = [window_AUC_LLP_On; window_AUC];
end
GCAMP.baseline_z_score_LLP_On = delta_F_LLP_ON_baseline_z_score_smooth;
GCAMP.baseline_z_score_LLP_On_above = zscore_Threshold(delta_F_LLP_ON_baseline_z_score_smooth);
GCAMP.baseline_z_score_LLP_On_above_mean = mean(GCAMP.baseline_z_score_LLP_On_above);
GCAMP.baseline_z_score_LLP_On_AUC = window_AUC_LLP_On;
GCAMP.baseline_LLP_On = delta_F_LLP_ON_baseline;
GCAMP.delta_F_LLP_On = delta_F_LLP_ON;
%% Left Lever Press Bout
delta_F_LLPBout_ON_baseline_z_score_smooth = [];
delta_F_LLPBout_ON_baseline = [];
delta_F_LLPBout_ON = [];
window_AUC_LLPBout_On = [];
for i = 1:length(GCAMP.LLPBout_ON_timestamps) %for each left lever press timestamp
    Closest_LLPBout_ON_idx = nearestpoint(GCAMP.LLPBout_ON_timestamps(i), GCAMP.gcampdata_timestamps);
    data_window_LLPBout_ON = GCAMP.delta_F_p(Closest_LLPBout_ON_idx + GCAMP.base_time_end * GCAMP.SR : Closest_LLPBout_ON_idx + GCAMP.time_end * GCAMP.SR)';
    data_window_LLPBout_ON_baseline = GCAMP.delta_F_p(Closest_LLPBout_ON_idx + GCAMP.base_time_start * GCAMP.SR : Closest_LLPBout_ON_idx + GCAMP.base_time_end * GCAMP.SR);
    delta_F_LLPBout_ON_baseline = [delta_F_LLPBout_ON_baseline; data_window_LLPBout_ON_baseline'];
    delta_F_LLPBout_ON = [delta_F_LLPBout_ON; data_window_LLPBout_ON];
    baseline_mean = mean(data_window_LLPBout_ON_baseline);
    baseline_std = std(data_window_LLPBout_ON_baseline);
    delta_F_LLPBout_ON_baseline_z_score = (data_window_LLPBout_ON - baseline_mean) ./baseline_std;
    delta_F_LLPBout_ON_baseline_z_score_smooth = [delta_F_LLPBout_ON_baseline_z_score_smooth; smoothdata(delta_F_LLPBout_ON_baseline_z_score, 'gaussian',10)];
    window_AUC = [];
    for window_idx = 1:length(AUC_bin_windows)-1
        bin_window = [AUC_bin_windows(window_idx) AUC_bin_windows(window_idx+1)];
        data_window = delta_F_LLPBout_ON_baseline_z_score_smooth(bin_window(1):bin_window(2));
        window_AUC = [window_AUC trapz(data_window)];
    end
    window_AUC_LLPBout_On = [window_AUC_LLPBout_On; window_AUC];
end
GCAMP.baseline_z_score_LLPBout_On = delta_F_LLPBout_ON_baseline_z_score_smooth;
GCAMP.baseline_z_score_LLPBout_On_above = zscore_Threshold(delta_F_LLPBout_ON_baseline_z_score_smooth);
GCAMP.baseline_z_score_LLPBout_On_above_mean = mean(GCAMP.baseline_z_score_LLPBout_On_above);
GCAMP.baseline_z_score_LLPBout_On_AUC = window_AUC_LLPBout_On;
GCAMP.baseline_LLPBout_On = delta_F_LLPBout_ON_baseline;
GCAMP.delta_F_LLPBout_On = delta_F_LLPBout_ON;

%% Left Lever Press Bout - 2nd press
delta_F_LLPBout_2nd_ON_baseline_z_score_smooth = [];
delta_F_LLPBout_2nd_ON_baseline = [];
delta_F_LLPBout_2nd_ON = [];
window_AUC_LLPBout_2nd_On = [];
for i = 1:length(GCAMP.LLPBout_2nd_ON_timestamps) %for each left lever press timestamp
    Closest_LLPBout_2nd_ON_idx = nearestpoint(GCAMP.LLPBout_2nd_ON_timestamps(i), GCAMP.gcampdata_timestamps);
    data_window_LLPBout_2nd_ON = GCAMP.delta_F_p(Closest_LLPBout_2nd_ON_idx + GCAMP.base_time_end * GCAMP.SR : Closest_LLPBout_2nd_ON_idx + GCAMP.time_end * GCAMP.SR)';
    data_window_LLPBout_2nd_ON_baseline = GCAMP.delta_F_p(Closest_LLPBout_2nd_ON_idx + GCAMP.base_time_start * GCAMP.SR : Closest_LLPBout_2nd_ON_idx + GCAMP.base_time_end * GCAMP.SR);
    delta_F_LLPBout_2nd_ON_baseline = [delta_F_LLPBout_2nd_ON_baseline; data_window_LLPBout_2nd_ON_baseline'];
    delta_F_LLPBout_2nd_ON = [delta_F_LLPBout_2nd_ON; data_window_LLPBout_2nd_ON];
    baseline_mean = mean(data_window_LLPBout_2nd_ON_baseline);
    baseline_std = std(data_window_LLPBout_2nd_ON_baseline);
    delta_F_LLPBout_2nd_ON_baseline_z_score = (data_window_LLPBout_2nd_ON - baseline_mean) ./baseline_std;
    delta_F_LLPBout_2nd_ON_baseline_z_score_smooth = [delta_F_LLPBout_2nd_ON_baseline_z_score_smooth; smoothdata(delta_F_LLPBout_2nd_ON_baseline_z_score, 'gaussian',10)];
    window_AUC = [];
    for window_idx = 1:length(AUC_bin_windows)-1
        bin_window = [AUC_bin_windows(window_idx) AUC_bin_windows(window_idx+1)];
        data_window = delta_F_LLPBout_2nd_ON_baseline_z_score_smooth(bin_window(1):bin_window(2));
        window_AUC = [window_AUC trapz(data_window)];
    end
    window_AUC_LLPBout_2nd_On = [window_AUC_LLPBout_2nd_On; window_AUC];
end
GCAMP.baseline_z_score_LLPBout_2nd_On = delta_F_LLPBout_2nd_ON_baseline_z_score_smooth;
GCAMP.baseline_z_score_LLPBout_2nd_On_above = zscore_Threshold(delta_F_LLPBout_2nd_ON_baseline_z_score_smooth);
GCAMP.baseline_z_score_LLPBout_2nd_On_above_mean = mean(GCAMP.baseline_z_score_LLPBout_On_above);
GCAMP.baseline_z_score_LLPBout_2nd_On_AUC = window_AUC_LLPBout_2nd_On;
GCAMP.baseline_LLPBout_2nd_On = delta_F_LLPBout_2nd_ON_baseline;
GCAMP.delta_F_LLPBout_2nd_On = delta_F_LLPBout_2nd_ON;
%% Right Lever Press
delta_F_RLP_ON_baseline_z_score_smooth = [];
delta_F_RLP_ON_baseline = [];
delta_F_RLP_ON = [];
window_AUC_RLP_On = [];
for i = 1:length(GCAMP.RLP_ON_timestamps) %for each left lever press timestamp
    Closest_RLP_ON_idx = nearestpoint(GCAMP.RLP_ON_timestamps(i), GCAMP.gcampdata_timestamps);
    data_window_RLP_ON = GCAMP.delta_F_p(Closest_RLP_ON_idx + GCAMP.base_time_end * GCAMP.SR : Closest_RLP_ON_idx + GCAMP.time_end * GCAMP.SR)';
    data_window_RLP_ON_baseline = GCAMP.delta_F_p(Closest_RLP_ON_idx + GCAMP.base_time_start * GCAMP.SR : Closest_RLP_ON_idx + GCAMP.base_time_end * GCAMP.SR);
    delta_F_RLP_ON_baseline = [delta_F_RLP_ON_baseline; data_window_RLP_ON_baseline'];
    delta_F_RLP_ON = [delta_F_RLP_ON; data_window_RLP_ON];
    baseline_mean = mean(data_window_RLP_ON_baseline);
    baseline_std = std(data_window_RLP_ON_baseline);
    delta_F_RLP_ON_baseline_z_score = (data_window_RLP_ON - baseline_mean) ./baseline_std;
    delta_F_RLP_ON_baseline_z_score_smooth = [delta_F_RLP_ON_baseline_z_score_smooth; smoothdata(delta_F_RLP_ON_baseline_z_score, 'gaussian',10)];
     window_AUC = [];
    for window_idx = 1:length(AUC_bin_windows)-1
        bin_window = [AUC_bin_windows(window_idx) AUC_bin_windows(window_idx+1)];
        data_window = delta_F_RLP_ON_baseline_z_score_smooth(bin_window(1):bin_window(2));
        window_AUC = [window_AUC trapz(data_window)];
    end
    window_AUC_RLP_On = [window_AUC_RLP_On; window_AUC];
end
GCAMP.baseline_z_score_RLP_On = delta_F_RLP_ON_baseline_z_score_smooth;
GCAMP.baseline_z_score_RLP_On_above = zscore_Threshold(delta_F_RLP_ON_baseline_z_score_smooth);
GCAMP.baseline_z_score_RLP_On_above_mean = mean(GCAMP.baseline_z_score_RLP_On_above);
GCAMP.baseline_z_score_RLP_On_AUC = window_AUC_RLP_On;
GCAMP.baseline_RLP_On = delta_F_RLP_ON_baseline;
GCAMP.delta_F_RLP_On = delta_F_RLP_ON;
end

