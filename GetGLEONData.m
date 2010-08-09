function [YearFrac Result QResult Removable TS Streams] = GetGLEONData(lastValID)

% function to download data from Vega
% returns a vector of year fractions and a data object
% example of a StreamID = 1030, which is Sunapee water T, depth 0
% format for StartDate and EndDate: '2008-1-1' or yyyy-mm-dd
% char(39) = '
% char(96) = `

% Set this to the path to your MySQL Connector/J JAR
javaaddpath('mysql-connector-java-5.1.12\mysql-connector-java-5.1.12-bin.jar');
% javaaddpath('c:\program files\mysql-connector-java-3.1.14\mysql-connector-java-3.1.14-bin.jar');

% Create the database connection object
dbConn = database('vega','vegas','vegaselect','com.mysql.jdbc.Driver','jdbc:mysql://mysql.uwcfl.org/vega');

% Check to make sure that we successfully connected
if isconnection(dbConn)
    QResult = get(fetch(exec(dbConn, ['SELECT * FROM `values` WHERE `ValueID` > ' ...
        num2str(lastValID) ' ORDER BY `ValueID` ASC LIMIT 25' ])), 'Data');
    % disp(['Size of record set: ' num2str(size(QResult))]);
% If the connection failed, print the error message
else
    disp(sprintf('Connection failed: %s', dbConn.Message));
    YearFrac = [];
    Result = [];
end

% check for results
if ~strcmp(QResult, 'No Data')
    % Get the year vector
    %[Y, M, D, H, MN, S] = datevec(DateStr,'yyyy-mm-dd HH:MM:SS')
    Y = datevec(QResult(:,3),'yyyy-mm-dd HH:MM:SS');
    % Get the number vector
    N = datenum(QResult(:,3),'yyyy-mm-dd HH:MM:SS');
    % Get the difference between number vector and number from 31 December
    % of the previous year (i.e., the current julian day)
    %JDay = (N - datenum(Y(:,1)-1,12,31));
    JDay = N - datenum(Y(:,1),0,0);
    DaysInYear = (datenum(Y(:,1),12,31) - datenum(Y(:,1),0,0)) + 1; % Add a day because 
    % otherwise, e.g., noon on day 365 would be > 365
    YearFrac = Y(:,1) + JDay ./ DaysInYear;
    TS = mean(YearFrac(2:end)-YearFrac(1:end-1)) .* (60*60*24*mean(DaysInYear)); % approximate time step in seconds
    Result = iddata(cell2mat(QResult(:,2)),[],TS);
    Removable = QResult(:,2);
    Streams = QResult(:,5);
else
    YearFrac = [];
    Result = [];
    Removable = [];
    Streams = [];
    TS = 0;
end

% Close the connection so we don't run out of MySQL threads
close(dbConn); 





































% %BELOW IS ORIGINAL GetGLEONData IF NEEDED AGAIN
% function [YearFrac Result QResult Removable TS] = GetGLEONData(StreamID,StartDate,EndDate) 
% % function to download data from Vega
% % returns a vector of year fractions and a data object
% % example of a StreamID = 1030, which is Sunapee water T, depth 0
% % format for StartDate and EndDate: '2008-1-1' or yyyy-mm-dd
% % char(39) = '
% % char(96) = `
% 
% % Set this to the path to your MySQL Connector/J JAR
% javaaddpath('mysql-connector-java-5.1.12\mysql-connector-java-5.1.12-bin.jar');
% % javaaddpath('c:\program files\mysql-connector-java-3.1.14\mysql-connector-java-3.1.14-bin.jar');
% 
% % Create the database connection object
% dbConn = database('vega','vegas','vegaselect','com.mysql.jdbc.Driver','jdbc:mysql://mysql.uwcfl.org/vega');
% 
% % Check to make sure that we successfully connected
% if isconnection(dbConn)
%     QResult = get(fetch(exec(dbConn, ['select * from `Values` where `StreamID` = ' num2str(StreamID) ...
%         ' and `DateTime` > ' char(39) StartDate char(39) ' and `DateTime` < ' char(39) EndDate char(39) ...
%         ' order by `DateTime`'])), 'Data');
%     % disp(['Size of record set: ' num2str(size(QResult))]);
% % If the connection failed, print the error message
% else
%     disp(sprintf('Connection failed: %s', dbConn.Message));
%     YearFrac = [];
%     Result = [];
% end
% 
% % check for results
% if ~strcmp(QResult, 'No Data')
%     % Get the year vector
%     %[Y, M, D, H, MN, S] = datevec(DateStr,'yyyy-mm-dd HH:MM:SS')
%     Y = datevec(QResult(:,3),'yyyy-mm-dd HH:MM:SS');
%     % Get the number vector
%     N = datenum(QResult(:,3),'yyyy-mm-dd HH:MM:SS');
%     % Get the difference between number vector and number from 31 December
%     % of the previous year (i.e., the current julian day)
%     %JDay = (N - datenum(Y(:,1)-1,12,31));
%     JDay = N - datenum(Y(:,1),0,0);
%     DaysInYear = (datenum(Y(:,1),12,31) - datenum(Y(:,1),0,0)) + 1; % Add a day because 
%     % otherwise, e.g., noon on day 365 would be > 365
%     YearFrac = Y(:,1) + JDay ./ DaysInYear;
%     TS = mean(YearFrac(2:end)-YearFrac(1:end-1)) .* (60*60*24*mean(DaysInYear)); % approximate time step in seconds
%     Result = iddata(cell2mat(QResult(:,2)),[],TS);
%     Removable = QResult(:,2);
% else
%     YearFrac = [];
%     Result = [];
%     Removable = [];
%     TS = 0;
% end
% 
% % Close the connection so we don't run out of MySQL threads
% close(dbConn); 
