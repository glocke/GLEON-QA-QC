function [iGood TimeFracs Datas] = FindGaps(TimeFrac, Data, Threshold)
% Detects gaps greater than a given length in the time vector of a
% dataset, as specified by the Threshold parameter. Returns the indices
% of all valid data points, as well as the new time and iddata vectors.

% get indices where (time step > threshold) & format them into an array
iGaps = [find(diff(TimeFrac) > Threshold);
        find(diff(TimeFrac) > Threshold) + 1];
iGaps = [1;
        sort(reshape(iGaps, numel(iGaps), 1));
        length(TimeFrac)];

% if no gaps, just return the input data as single items in lists
if size(iGaps,1) == 2
    TimeFracs{1} = TimeFrac;
    Datas{1} = Data;
    iGood = 1:size(Data);
    
% if there are gaps, segment data & timefracs, put the segments into lists
else
    i = iGaps(1); % start at the beginning of the first valid segment
    j = 1; % start filling at the start of the list
    iGood = []; % keep the indices of the good data
    while i < length(iGaps)
        % add valid segment to list
        TimeFracs{j} = TimeFrac(iGaps(i):iGaps(i+1));
        segData = Data;
        segData.OutputData = segData.OutputData(iGaps(i):iGaps(i+1));
        Datas{j} = segData;
        
        % keep the indices of the valid segments
        iGood = [iGood iGaps(i):iGaps(i+1)];
        
        i = i+2; % jump to the start of the next valid segment of data
        j = j+1; % move to next list item
    end
end