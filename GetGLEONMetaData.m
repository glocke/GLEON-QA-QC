function QResult = GetGLEONMetaData(SiteID)

% function to download data from Vega
% returns a matrix of metadata
% example of a SiteID = 18, which is Sunapee
% if SiteID is empty, then all stream metadata are returned

% char(39) = '
% char(96) = `

% Set this to the path to your MySQL Connector/J JAR
javaaddpath('mysql-connector-java-3.1.14\mysql-connector-java-3.1.14-bin.jar');

% Create the database connection object
dbConn = database('vega','vegas','vegaselect','com.mysql.jdbc.Driver','jdbc:mysql://mysql.uwcfl.org/vega');

% Check to make sure that we successfully connected
if isconnection(dbConn)
    % Fetch some data
    if isempty(SiteID)
        QResult = get(fetch(exec(dbConn, ['select `StreamID`, `Streams`.`SiteID`, `Streams`.`VariableID`, `SiteName`, `VariableName` ' ...
        ' from `Streams`,`Sites`,`Variables` ' ...
        ' where `Streams`.`SiteID` = `Sites`.`SiteID` and `Streams`.`VariableID` = `Variables`.`VariableID` ' ...
        ' order by `Streams`.`SiteID`, `Streams`.`StreamID`'])), 'Data');
    else
    QResult = get(fetch(exec(dbConn, ['select `StreamID`, `Streams`.`SiteID`, `Streams`.`VariableID`, `SiteName`, `VariableName` ' ...
        ' from `Streams`,`Sites`,`Variables` ' ...
        ' where `Streams`.`SiteID` = `Sites`.`SiteID` and `Streams`.`VariableID` = `Variables`.`VariableID` and `Streams`.`SiteID` = ' num2str(SiteID)])), 'Data');
    end
    disp(['Size of record set: ' num2str(size(QResult))]);
else % If the connection failed, print the error message
    disp(sprintf('Connection failed: %s', dbConn.Message));
    Result = [];
end
% Close the connection so we don't run out of MySQL threads
close(dbConn);