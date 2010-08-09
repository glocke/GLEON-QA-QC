% Program to interpolate data to new time step
function [TimeFrac Data] = InterpIt(TimeFrac,Data,TimeFormat,newTS,GraphIt)

% TimeFrac is either day fraction or year fraction
% Data is an iddata object
% TimeFormat is a switch
% newTS is the new time step in minutes
% Program returns a new data set interpolated to the new time step

% Convert new time step to seconds
newTS = newTS .* 60;

switch TimeFormat
    case 1 % DayFrac
        TS = newTS ./ (60*60*24);
    case 2 % YearFrac
        TS = newTS ./ (60*60*24*365);
end

newTimeFrac = TimeFrac(1):TS:TimeFrac(end);

% convert outputs
if isempty(Data.OutputData) | isempty(find(~isnan(Data.OutputData)))
    newOutputData = [];
else
    newOutputData = interp1(TimeFrac,Data.OutputData,newTimeFrac');
end

if GraphIt

    if ~isempty(find(~isnan(Data.OutputData)))
        figure(); clf;
        plot(TimeFrac,Data.OutputData); hold on;
        plot(newTimeFrac,newOutputData,'linewidth',2); hold off;
        title('Interpolation Output Data');
    end
    garbage = input('press any key...');
end

Data.OutputData = newOutputData;
Data.TS = TS;
TimeFrac = newTimeFrac;


