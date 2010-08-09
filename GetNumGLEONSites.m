function NumSites = GetNumGLEONSites()

% function to download data from Vega
% returns a matrix of metadata

% char(39) = '
% char(96) = `

% Set this to the path to your MySQL Connector/J JAR
javaaddpath('mysql-connector-java-5.1.12\mysql-connector-java-5.1.12-bin.jar');

% connect to the db
dbConn = database('vega','vegas','vegaselect','com.mysql.jdbc.Driver','jdbc:mysql://mysql.uwcfl.org/vega');

% Check to make sure that we successfully connected
if isconnection(dbConn)
    % Fetch some data
    QResult = get(fetch(exec(dbConn, ['select count(*) from `Sites`'])), 'Data');
    NumSites = QResult{1};
else % If the connection failed, print the error message
    disp(sprintf('Connection failed: %s', dbConn.Message));
    Result = [];
end

% Close the connection so we don't run out of MySQL threads
close(dbConn);