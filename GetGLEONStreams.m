function QResult = GetGLEONStreams(SiteID)

% function to download data from Vega
% returns a matrix of data

% char(39) = '
% char(96) = `

% Set this to the path to your MySQL Connector/J JAR
javaaddpath('mysql-connector-java-5.1.12\mysql-connector-java-5.1.12-bin.jar');

% Create the database connection object
dbConn = database('vega','vegas','vegaselect','com.mysql.jdbc.Driver','jdbc:mysql://mysql.uwcfl.org/vega');

% Check to make sure that we successfully connected
if isconnection(dbConn)
    % Fetch some data
    % disp(['SELECT `StreamID`, `SiteID` FROM `streams` WHERE `SiteID` = ''' num2str(SiteID) '''']);
    if ~isempty(SiteID)
        QResult = fetch(dbConn, ['SELECT `StreamID`, `SiteID` FROM `streams` WHERE `SiteID` = ''' num2str(SiteID) '''']);
    else
        QResult = fetch(dbConn, ['SELECT `StreamID`, `SiteID` FROM `streams`']);
    end
        % disp(['Size of record set: ' num2str(size(QResult))]);
else % If the connection failed, print the error message
    disp(sprintf('Connection failed: %s', dbConn.Message));
    Result = [];
end
% Close the connection so we don't run out of MySQL threads
close(dbConn);