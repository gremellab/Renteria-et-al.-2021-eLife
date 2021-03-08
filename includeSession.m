function [include] = includeSession(baseline, data)
Criteria = 1;
sample_span = 2; %tried 5


mean_data = mean(data(:,1:end)); % from -2 to 5 seconds perievent
std_baseline = mean(std(baseline));


aboveThreshold = abs(mean_data) >= (std_baseline * Criteria);
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
    include = 1;
else
    include = 0;
end

end

