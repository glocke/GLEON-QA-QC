% Program to filter the data using wavelets
function [TimeFrac Data] = WaveFilter(Filter,TimeFrac,Data,TimeFormat,TargetPeriod,Interactive)

% Filter is type of filter, 1=wavelet, 2=MA
% TimeFrac is either day fraction or year fraction
% Data is an iddata object
% TimeFormat is a switch
% TargetPeriod is the filtered period in minutes
% Program returns a new data set filtered to the new time step

% Level is dyadic, given by TS * 2^level, for example...
% 10 min data at daily is 10 * 2^7 = 10*128 = 1280, or close to 1440 min,
% therefore the daily time scale level is 7

if Interactive & Filter==1
    Levels = 1:15;
    Periods = Data.TS ./ 60 .* 2.^Levels';
    Levels2 = log2(Periods ./ Data.TS .* 60);
    disp('____________________________________________');
    disp(['Current time step set to ' num2str(Data.TS) ' seconds, or ' num2str(Data.TS/60) ' min']);
    disp(['Dyadic scales in minutes are: ']);
    disp([num2str([Levels' Periods Levels2])]);
    TargetPeriod = input('Enter target period in minutes: ');
    Level = round(log2(TargetPeriod ./ Data.TS .* 60));
    disp(['Wavelet level = ' num2str(Level)]);
end

switch Filter
    case 1 % wavelet
        Level = round(log2(TargetPeriod / Data.TS * 60))
        if Level < 1; Level = 1; end % floor the level at 1
        FilterName = 'wavelet';
        [XD,CXD,LXD] = wden(Data.OutputData,'sqtwolog','s','one',Level,'db4');
    case 2 % moving average
        CurrentTSMin = Data.TS ./ 60;
        nMvAvg = round(TargetPeriod ./ CurrentTSMin);
        FilterName = 'moving avg';
        b = ones(1,nMvAvg)./nMvAvg;
        a = 1;
        XD = filtfilt(b,a,Data.OutputData);
end

if Interactive
    figure(); clf;
    subplot(2,1,1);
    plot(TimeFrac,Data.OutputData,TimeFrac,XD);
    title('Filtered, unfiltered data');
    subplot(2,1,2);
    plot(TimeFrac,XD,'g');
    title('Just filtered data');
    garbage = input('press any key...');
end

Data.OutputData = XD;