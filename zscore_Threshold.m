function [above_tresh_event] = zscore_Threshold(data)

sample_span = 6;
threshold = 2.91;
above_tresh_event_idx = [];
below_tresh_event_idx = [];
above_tresh_event = [];
below_tresh_event = [];
above_tresh_event_idx_all = [];
below_tresh_event_idx_all = [];
for i = 1:size(data,1)
    data_window = data(i,:);
    mad_trial = mad(data_window,1);
    
    aboveThreshold = abs(data_window) >= (mad_trial * threshold);
    %aboveThreshold is a logical array, where 1 when above threshold, 0, below.
    %we thus want to calculate the difference between rising and falling edges
    aboveThreshold = [false, aboveThreshold, false];  %pad with 0's at ends
    edges = diff(aboveThreshold);
    rising = find(edges==1);     %rising/falling edges
    falling = find(edges==-1);
    spanWidth = falling - rising;  %width of span of 1's (above threshold)
    wideEnough = spanWidth >= sample_span;
    startPos = rising(wideEnough);    %start of each span
    endPos = falling(wideEnough)-1;   %end of each span
    %all points which are in the sample span (i.e. between startPos and endPos).
    allInSpan = cell2mat(arrayfun(@(x,y) x:1:y, startPos, endPos, 'uni', false));
    if ~isempty(allInSpan)
        above_tresh_event_idx = [above_tresh_event_idx ; i];
        above_tresh_event = [above_tresh_event ; data_window ];
        
    else
        below_tresh_event_idx = [below_tresh_event_idx ; i];
        below_tresh_event = [below_tresh_event ; data_window ];
        
    end

end
    above_tresh_event_idx_all = [above_tresh_event_idx_all; above_tresh_event_idx];
    below_tresh_event_idx_all = [below_tresh_event_idx_all; below_tresh_event_idx];
end

