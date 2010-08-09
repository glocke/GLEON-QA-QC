% program to test wavelets on discontinuities
clear all;
warning off MATLAB:javaclasspath:duplicateEntry;

% config
% I will set this the first time the program is run, and we start from
% there.
initValID = 47375; %IMPORTANT
currentValID = 0; % stores the last valueID cleaned

if initValID == 47375 % remember need to change this, for first startup IMPORTANT
    currentValID = initValID;
end

% Begin the QA
%IterationLimit = 50 * span; % number of allowable iterations to remove
%outliers before moving on WAVELET
Threshold = 0.75; % Required bins
MinGapLength = 0.08; % Min year frac to be considered a gap
TimeFormat = 2; % Year fraction
Interactive = 0; % Graph data and use interactive interface
PutResults = 0; % Store the results to the clean data db

Interpolate = 0; %
Filter = 1; % 0=off, 1=wavelet, 2=MA,
TargetPeriod = 60; % minutes, for interpolation and filtering

% user chooses site, stream
%Sites = GetGLEONSites();
%[nSites c] = size(Sites);
%SiteID = input(['Choose a site (1-' num2str(nSites) ') ']);
%Streams = GetGLEONStreams(SiteID);
%[nStreams c] = size(Streams);
%StreamID = input(['Choose a value (1-' num2str(nStreams) ') ']);

ticmajor = tic; % time whole process
records = 0; % and count total # records
timeToWait = 15; % time before clean occurs again, in seconds
moveOn = 1;
% Contains metadata about a stream as follows:
% Each row is a different stream.
% Col1 = streamID, Col2 = VariableID, Col3 = UnitID, Col4 = Max, Col5 = Min
streamDataArray = {};

% iterate from here
% ---------------------------------------
while moveOn == 1
    ticminor = tic; % time this stream
    disp(':::::::::::::::::::::::::::::::::::');
    disp([':: Cleaning from ID ' num2str(currentValID)]);
    
    D = {}; % our working copy of the data
    
    % get the data
    tryagain = 1;
    %    while tryagain
    %        try
    [D.YearFrac D.Data D.QResult Removable TS Streams] = GetGLEONData(currentValID);
    %            tryagain = 0;
    %        catch exception
    %           pause(60)
    %           tryagain = 1;
    %       end
    %   end
    
    if size(D.QResult,1) > 20 % Needs at least 20 data points for TS to work
        if strcmp(D.QResult, 'No Data')
            disp([':: No data from ID ' num2str(currentValID)]);
        else
            records = records + size(D.Data.OutputData); % count the data
            
            % scope locally
            YearFrac = D.YearFrac;
            Data = D.Data;
            
            % Plot original data
            if Interactive
                figure(1); clf;
                plot(YearFrac, Data);
                title('Original Data');
            end
            
            % run range checks, updating the new array containing metadata
            % about a certain stream
            disp(': Running range checks...');
            tryagain = 1;
            %while tryagain
            %try
            [ newYearFrac newData newStreamDataArray] = ...
                RangeChecks(D.YearFrac, Removable, Streams, TS, streamDataArray);
            %tryagain = 0;
            %catch exception
            % pause(60)
            % tryagain = 1;
            % end
            %end
            streamDataArray = newStreamDataArray;
            YearFrac = newYearFrac;
            Data = newData;
            
            % find gaps
            % get valid indices & segmented data
            [iValid YFs Ds] = FindGaps(YearFrac, Data, MinGapLength);
            disp([': Segmented data into ' num2str(size(Ds, 2)) ' chunk(s)']);
            
            % transform each segment & concat back onto single vector
            TFData = {};
            TFData.OutputData = [];
            TFYearFrac = [];
            for e=1:size(Ds,2)
                [segYF segD] = TransformData(YFs{e}, Ds{e}, Interactive, e);
                TFData.OutputData = [TFData.OutputData; segD.OutputData];
                TFYearFrac = [TFYearFrac; segYF];
            end
            
            % clean data of outliers
            Done = 0;
            Counter = 0;
            CData = TFData;
            CYearFrac = TFYearFrac;
            CData.OutputData = CData.OutputData(diff(CData.OutputData) < 50); % remove ridiculous data immediately
            %           while ~Done WAVELET
            %               [iBad iGood] = QAWavelet(CYearFrac,CData,Interactive,Threshold);
            %               CYearFrac = CYearFrac(iGood);
            %               CData.OutputData = CData.OutputData(iGood);
            %               for i=1:numel(iBad) % remove the iBad from our iValid indices
            %                    iValid(iValid == iBad(i)) = [];
            %               end
            %               if isempty(iBad) % if no bad data, we're done
            %                    Done = 1;
            %               end
            %               Counter = Counter + 1;
            %               if Counter > IterationLimit  % cleaning took too many iterations
            %                    Done = 1;
            %                   disp([': Cleaning hit iteration limit of ' num2str(IterationLimit)]);
            %               end
            %           end
            
            % display record count
            disp([': Time to process ' num2str(size(D.QResult, 1)) ' records: ' num2str(toc(ticminor)) ' seconds']);
            
            % graph our clean data
            if Interactive
                figure(300); clf; hold on;
                for i=1:size(CData,2)
                    plot(CYearFrac, CData.OutputData);
                    title('Cleaned data');
                end
                hold off;
            end
            
            % finally, filter the original SQL result set against our clean
            % data
            Final = D.QResult(iValid, :);
            disp([': Removed ' num2str(size(D.QResult,1) - size(Final,1)) ' data points']);
            
            % if we're storing the results to db...
            if PutResults
                disp([': Putting cleaned data to database (' num2str(size(Final,1)) ' records)']);
                while tryagain
                    try
                        PutGLEONData(Final);
                        tryagain = 0;
                    catch exception
                        pause(60)
                        tryagain = 1;
                    end
                end
            end
            
            disp([':: Records processed so far: ' num2str(records(1))]);
            disp([':: Run time so far: ' num2str(toc(ticmajor))]);
            currentValID = D.QResult{size(D.QResult,1),1};
        end
    end
    clearvars -except records ticmajor TimeFormat Interactive ...
        Threshold MinGapLength PutResults ...% WAVELET>IterationLimit...
        Interpolate Filter TargetPeriod timeToWait moveOn streamDataArray currentValID
    pause(timeToWait); % Wait, clean again.
end