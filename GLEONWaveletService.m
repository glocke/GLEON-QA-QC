% program to test wavelets on discontinuities
clear all;
warning off MATLAB:javaclasspath:duplicateEntry;

% config
history = {}; % Used to store ring buffers of histories for all streams
tail = 7500; % How much history each stream will carry
currValID = 1; % The current valueID to construct a wavelet from, possibly need to deal with crashes here...
moveOn = 1; % loop variable
Threshold = 0.15 % CHANGE THIS TO WHATEVER WORKS BEST
% Set this to the path to your MySQL Connector/J JAR
javaaddpath('mysql-connector-java-5.1.12\mysql-connector-java-5.1.12-bin.jar');

% wavelet loop
while moveOn
    [currValIDTail history] = getHistory(currValID, history, tail);
    if size(currValIDTail,1) == tail+2 % tail+2 is because of unique tail characteristics, explained in getHistory
        
    end
end

%This is For Dates...Still need to handle TimeFrac
    % Get the year vector
    %[Y, M, D, H, MN, S] = datevec(DateStr,'yyyy-mm-dd HH:MM:SS')
    Y = datevec(QResult(:,3),'yyyy-mm-dd HH:MM:SS');
    % Get the number vector
    N = datenum(QResult(:,3),'yyyy-mm-dd HH:MM:SS');
    % Get the difference between number vector and number from 31 December
    % of the previous year (i.e., the current julian day)
    JDay = N - datenum(Y(:,1),0,0);
    DaysInYear = (datenum(Y(:,1),12,31) - datenum(Y(:,1),0,0)) + 1; % Add a day because 
    % otherwise, e.g., noon on day 365 would be > 365
    YearFrac = Y(:,1) + JDay ./ DaysInYear;