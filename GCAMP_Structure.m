function [GCAMP] = GCAMP_Structure(photometry_data, beh_data, GCAMP)
raw_gcamptimestamps = photometry_data(:,1);
raw_gcampdata = photometry_data(:,2);
% if there are an odd # of rows after removing headers, delete the last row
% in both wave and wavetime
A = raw_gcampdata(1:2:end,:);
B = raw_gcampdata(2:2:end,:);

%truncate the data from the LED that has more datapoints to match data
%dimension
if length(A) > length(B)
  A = A(1:end-1,:);
elseif length(A) < length(B)
  B = B(1:end-1,:);
end

%the raw fluorescence values from LED that are consistently greater belong
%to 470 nm (i.e. LED1)
if sum(A>B) > (length(A)*.99) %% 0.99 seems arbitrary here?
  LED1 = A;
  LED2 = B;
else
  LED1 = B;
  LED2 = A;
end

% Timestamps for gcampdata
if LED1 == A
    k = 1;
elseif LED1 == B
    k = 2;
end
gcampdata_timestamps = raw_gcamptimestamps(k:2:end,:);


%% New Method for accounting for decay across session (3.25.19)
SR = 20;
time = (1:length(LED1))/SR; % in seconds
Y_exp_fit_all = fit(time',LED1,'exp2');
f_0 = Y_exp_fit_all(0);
normDat = (LED1 .* f_0) ./ Y_exp_fit_all(time);
gcampdata = normDat;

%estimate 10th percentile of F using 15 sec. sliding window 
%this is to generate baseline fluorescence estimate
win = SR * 15;
p = 10;
[ ys ] = running_percentile(gcampdata, win, p);
delta_F = gcampdata - ys;
delta_FoverF = delta_F ./ ys ;
%exclusion criterion: only sessions where 97.5th percentile of delta_FoverF
%exceeded 1% are included
delta_F_p = delta_FoverF .* 100; %percent change from baseline fluorescence
exc = prctile(delta_F_p, 97.5);
GCAMP.pass = (exc > 1) 

%% Extract behavior timestamps from analog_inputs
% Subtract logicals from each other in LLP column
switches_LLP = diff(beh_data(:,2)); %2
% Subtract logicals from each other in RLP column
switches_RLP = diff(beh_data(:,4)); %4
% Subtract logicals from each other in HE column
switches_HE = diff(beh_data(:,3)); %3
% Subtract logicals from each other in lick column
%switches_lick = diff(beh_data(:,5)); %5

% When the difference is 1, that's event ON, find the indices for ON
LLP_ON_index = find(switches_LLP == 1)+1;
RLP_ON_index = find(switches_RLP == 1)+1;
HE_ON_index = find(switches_HE == 1)+1;
%lick_ON_index = find(switches_lick == 1)+1;

% When the difference is -1, that's event OFF, find indices for OFF
LLP_OFF_index = find(switches_LLP == -1)+1;
RLP_OFF_index = find(switches_RLP == -1)+1;
HE_OFF_index = find(switches_HE == -1)+1;
%lick_OFF_index = find(switches_lick == -1)+1;

% Get the time stamps from those event indices
LLP_ON_timestamps = beh_data(LLP_ON_index, 1);
LLP_OFF_timestamps = beh_data(LLP_OFF_index, 1);
RLP_ON_timestamps = beh_data(RLP_ON_index, 1);
RLP_OFF_timestamps = beh_data(RLP_OFF_index, 1);
HE_ON_timestamps = beh_data(HE_ON_index, 1);
HE_OFF_timestamps = beh_data(HE_OFF_index,1);
%lick_ON_timestamps = beh_data(lick_ON_index, 1);
%lick_OFF_timestamps = beh_data(lick_OFF_index,1);
%% First headentry after reinforcer
rein = RLP_ON_timestamps;
he = HE_ON_timestamps;
Clatency = zeros(size(rein));

     for q = 1:numel(rein) %for each number of reinforcer the animal got
        T = min(he(he>rein(q))); %T is equal to the minimum timestamp of a lick that's greater than the timestamp of the reinforcer
        if ~isempty(T)    %if there exists a T 
            r= find(he==T); %get the index of T
            Clatency(q) = T-rein(q);  %set the latency to the difference between T and the reinforcer timestamp
            First_HE_ON_timestamps = rein + Clatency;
        end
     end

     
%% LLP Bout
on_LLP_timestamps_thatcount = LLP_ON_timestamps([2:end],:); 
off_LLP_timestamps_thatcount = LLP_OFF_timestamps([1:end-1],:);
%calculate the inter leverpress intervals
interLLPintervals = (off_LLP_timestamps_thatcount - on_LLP_timestamps_thatcount).* -1;


figure(1)
[h,L,MX,MED,bw] = violin(interLLPintervals,{'Left LeverPress Intervals'});
close all

%locate intervals that are greater than criterion
LLPboutbreakoff = [interLLPintervals > MX]; %originally \, criterion MED
indexofLLPboutends = find(LLPboutbreakoff == 1); 

%index into original LLP off timestamp array to obtain boutend timestamps
LLPboutends = LLP_OFF_timestamps(indexofLLPboutends);
%add on the last off timestamp to the boutends vector
finalLLPboutends = [LLPboutends; LLP_OFF_timestamps(end)];

%index into original LLP on timestamp array to obtain boutstart timestamps
LLPboutstarts = LLP_ON_timestamps(indexofLLPboutends+1);

%add on the first on timestamp to the boutstarts vector
finalLLPboutstarts = [LLP_ON_timestamps(1); LLPboutstarts];


%figure out LLP bout lengths and other parameters
LLPboutlengths = (finalLLPboutends - finalLLPboutstarts)./1000 ; % in seconds
avgLLPboutlength = mean(LLPboutlengths);
maxLLPboutlength = max(LLPboutlengths);
minLLPboutlength = min(LLPboutlengths);
modeLLPboutlength = mode(LLPboutlengths);
medianLLPboutlength = median(LLPboutlengths);
stdLLPboutlength = std(LLPboutlengths);
[LLPout,LLPidx] = sort(LLPboutlengths); %out is sorted array, idx are indices that when used on original array give sorted list

%exclusion based on less than 3 LLPs in a bout
LLPboutmet = zeros(length(finalLLPboutstarts),1)';
LLPinbout = zeros(length(finalLLPboutstarts),1)';
accum = 0;
for j = 1:length(finalLLPboutstarts)
    for k = 1:length(LLP_ON_timestamps)
            if LLP_ON_timestamps(k)>= finalLLPboutstarts(j) && LLP_ON_timestamps(k)<= finalLLPboutends(j)
            accum = accum + 1;
            end
    end
if accum < 3
    LLPboutmet(j)=0;
    LLPinbout(j)=accum;
else
    LLPboutmet(j)=1;
    LLPinbout(j)=accum;
end
accum = 0;
end
totalLLP = sum(LLPinbout); %this should match the variables LLP_ON and OFF_timestamps

%APPLY EXCLUSION!
%figure out LLP bout lengths and other parameters for final subset

finalfinalLLPboutstarts = finalLLPboutstarts(find(LLPboutmet == 1));
finalfinalLLPboutends = finalLLPboutends(find(LLPboutmet == 1));
finalLLPboutlengths = (finalfinalLLPboutends - finalfinalLLPboutstarts)./1000 ; % in seconds
[LLPoutfinal,LLPidxfinal] = sort(finalLLPboutlengths);

for i = 1:length(finalfinalLLPboutstarts) %for each first head entry after reward timestamp
    LLPBout_2nd_ON_idx = nearestpoint(finalfinalLLPboutstarts(i),LLP_ON_timestamps)+1;
    LLPBout_2nd_ON_timestamps(i,:) = LLP_ON_timestamps(LLPBout_2nd_ON_idx);
end

for i = 1:length(finalfinalLLPboutstarts) 
    LLPBout_ON_idx(i,:) = nearestpoint(finalfinalLLPboutstarts(i),LLP_ON_timestamps);
    LLPBout_OFF_idx(i,:) = nearestpoint(finalfinalLLPboutends(i),LLP_ON_timestamps);
    LLPBout_IPI_means(i,:) = mean(interLLPintervals(LLPBout_ON_idx(i):(LLPBout_OFF_idx(i)-1)));
    LLPBout_pressesperbout(i,:) = (LLPBout_OFF_idx(i)-LLPBout_ON_idx(i))+1;
    LLPBout_durations(i,:) = (finalfinalLLPboutends(i) - finalfinalLLPboutstarts(i))./1000;
end


favgLLPboutlength = mean(finalLLPboutlengths);
fmaxLLPboutlength = max(finalLLPboutlengths);
fminLLPboutlength = min(finalLLPboutlengths);
fmodeLLPboutlength = mode(finalLLPboutlengths);
fmedianLLPboutlength = median(finalLLPboutlengths);
fstdLLPboutlength = std(finalLLPboutlengths);


%% Parameters for peri-event data
time_start = -5; % from negative time point (secs)
time_end = 5; % to positive time point (secs)
SR = 20; % sampling rate
base_time_start = -5;
base_time_end = -2;
plot_time = base_time_start:1/SR:time_end;
AUC_bin_time = .25;
%% Store in Data Structure
GCAMP.raw_gcamptimestamps = raw_gcamptimestamps;
GCAMP.raw_gcampdata = raw_gcampdata;
GCAMP.gcampdata  = gcampdata;
GCAMP.gcampdata_timestamps = gcampdata_timestamps;
GCAMP.delta_F_p = delta_F_p; 
GCAMP.delta_F = delta_F;
GCAMP.time_start = time_start;
GCAMP.time_end =  time_end;
GCAMP.AUC_bin_time = .25;
GCAMP.SR =  SR;
GCAMP.time_start = time_start;
GCAMP.base_time_start = base_time_start;
GCAMP.base_time_end = base_time_end;
GCAMP.plot_time = plot_time;
GCAMP.LLP_ON_timestamps = LLP_ON_timestamps;
GCAMP.LLP_OFF_timestamps = LLP_OFF_timestamps;
GCAMP.RLP_ON_timestamps = RLP_ON_timestamps;
GCAMP.RLP_OFF_timestamps = RLP_OFF_timestamps;
GCAMP.HE_ON_timestamps = HE_ON_timestamps;
GCAMP.HE_OFF_timestamps = HE_OFF_timestamps;
GCAMP.First_HE_ON_timestamps = First_HE_ON_timestamps;
GCAMP.LLPBout_ON_timestamps = finalfinalLLPboutstarts;
GCAMP.LLPBout_2nd_ON_timestamps = LLPBout_2nd_ON_timestamps;
GCAMP.LLPBout_pressesperbout = LLPBout_pressesperbout;
GCAMP.LLPBout_IPI = LLPBout_IPI_means;
GCAMP.LLPBout_durations = LLPBout_durations;
end

