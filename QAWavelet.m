% Program to test for discontinuities in data
function [iBad iGood] = QAWavelet(currValIDTail,Threshold)

% TimeFrac is either day fraction or year fraction
% Data is an iddata object
% Program returns the indeces of bad data and the cleaned vector for both
% timefraction and data
% Threshold is acceptable proportion of histogram bins full. Guidelines: 
%   0.15 for water temperature
%   0.30 for noisier data, such as wind speed
GraphIt = 1;
% BELOW STUFF IS FOR TESTING ONLY, TEMPORARY
TimeFrac = [];
for i=1:10000
    TimeFrac = [TimeFrac;2000];
end

head = currValIDTail(1,1);
half1 = currValIDTail(head+1:size(currValIDTail,1));
half2 = currValIDTail(3:head);

ourData = [half1;half2];

nRecords = size(ourData,1);
Bins = round(nRecords/1000) .* 5; % Number of bins for histogram - this should be relatively high
PadProp = 0.25; % Padding size for data to reduce edge effects

% Standard normal transform
SNData = (ourData - mean(ourData)) ./ std(ourData);

% Pad data with start and end values
PadSize = round(PadProp .* length(ourData));
Pad1 = ones(PadSize,1) .* mean(SNData);
Pad2 = ones(PadSize,1) .* mean(SNData);

SNPData = [Pad1;
           SNData;
           Pad2];

% Get the level one wavelet and check for discontinuities
C = cwt(SNPData, 1, 'haar');
C = C(PadSize+1:end-PadSize);
[N,X] = hist(C, Bins);
PropN = length(find(N>0)) ./ Bins;

iAll = 1:length(C);
% With large discontinuities, most bins will be empty
if PropN >= Threshold || PropN==0 || isempty(X)
    iBad = []; % No outliers detected, so do nothing
    iGood = iAll;
else % Get rid of the bad ones
    iBad = find(C<X(2) | C>X(end-1));
    [trash, iGood] = setdiff(iAll,iBad);
end

% Graph results
if GraphIt
    figure(200); clf;
    plot(TimeFrac,SNData,TimeFrac(iBad),SNData(iBad),'or');
    title('Signal before filtering');

    figure(201); clf;
    plot(TimeFrac,C,TimeFrac(iBad),C(iBad),'or');
    title('Wavelet coefs and bad data in red');

    figure(202); clf;
    plot(TimeFrac(iGood),ourData(iGood));
    title('Signal after filtering red circles, if any');

    figure(203); clf;
    if ~isempty(X)
        bar(X,N);
    end
    title('Distribution map of clean data');
    
    disp(['Proportion full bins = ' num2str(PropN)]);
    title('Bins for level 1 wavelet coefs');
    
    input('press any key...');
end
clearvars -except iBad iGood







































% % Program to test for discontinuities in data
% function [iBad iGood] = QAWavelet(TimeFrac,Data,GraphIt,Threshold)
% 
% % TimeFrac is either day fraction or year fraction
% % Data is an iddata object
% % Program returns the indeces of bad data and the cleaned vector for both
% % timefraction and data
% % Threshold is acceptable proportion of histogram bins full. Guidelines: 
% %   0.15 for water temperature
% %   0.30 for noisier data, such as wind speed
% 
% nRecords = size(Data.OutputData,1);
% Bins = round(nRecords/1000) .* 5; % Number of bins for histogram - this should be relatively high
% PadProp = 0.25; % Padding size for data to reduce edge effects
% 
% % Standard normal transform
% SNData = (Data.OutputData - mean(Data.OutputData)) ./ std(Data.OutputData);
% 
% % Pad data with start and end values
% PadSize = round(PadProp .* length(Data.OutputData));
% Pad1 = ones(PadSize,1) .* mean(SNData);
% Pad2 = ones(PadSize,1) .* mean(SNData);
% 
% SNPData = [Pad1;
%            SNData;
%            Pad2];
% 
% % Get the level one wavelet and check for discontinuities
% C = cwt(SNPData, 1, 'haar');
% C = C(PadSize+1:end-PadSize);
% [N,X] = hist(C, Bins);
% PropN = length(find(N>0)) ./ Bins;
% 
% iAll = 1:length(C);
% % With large discontinuities, most bins will be empty
% if PropN >= Threshold | PropN==0 | isempty(X)
%     iBad = []; % No outliers detected, so do nothing
%     iGood = iAll;
% else % Get rid of the bad ones
%     iBad = find(C<X(2) | C>X(end-1));
%     [trash, iGood] = setdiff(iAll,iBad);
% end
% 
% % Graph results
% if GraphIt
%     figure(200); clf;
%     plot(TimeFrac,SNData,TimeFrac(iBad),SNData(iBad),'or');
%     title('Signal before filtering');
% 
%     figure(201); clf;
%     plot(TimeFrac,C,TimeFrac(iBad),C(iBad),'or');
%     title('Wavelet coefs and bad data in red');
% 
%     figure(202); clf;
%     plot(TimeFrac(iGood),Data.OutputData(iGood));
%     title('Signal after filtering red circles, if any');
% 
%     figure(203); clf;
%     if ~isempty(X)
%         bar(X,N);
%     end
%     title('Distribution map of clean data');
%     
%     disp(['Proportion full bins = ' num2str(PropN)]);
%     title('Bins for level 1 wavelet coefs');
%     
%     input('press any key...');
% end
