function [] = PutGLEONData(D)

% Set this to the path to your MySQL Connector/J JAR
javaaddpath('mysql-connector-java-5.1.12\mysql-connector-java-5.1.12-bin.jar');
% javaaddpath('c:\program files\mysql-connector-java-3.1.14\mysql-connector-java-3.1.14-bin.jar');

% Create the database connection object
dbConn = database('vega_1','vegas','vegaselect','com.mysql.jdbc.Driver','jdbc:mysql://mysql.uwcfl.org/vega_1');
%dbConn = database('vega_clean','vegacleaner','pass4cleaner','com.mysql.jdbc.Driver','jdbc:mysql://mysql.uwcfl.org/vega_clean');

% Check to make sure that we successfully connected
if isconnection(dbConn)
    % we're assuming the databases structures and tables are in sync
    % so we just add the values
    for i=1:size(D.QResult,1)
        % fix null flag field
       if D.QResult{i,6} == 'null'
           D.QResult{i,6} = '';
       end
            exec(dbConn, ['insert into `values` values (' ... 
            '''' num2str(D.QResult{i,1}) ''',' ...
            '''' num2str(D.QResult{i,2}) ''',' ...
            '''' D.QResult{i,3} ''',' ...
            '''' num2str(D.QResult{i,4}) ''',' ...
            '''' num2str(D.QResult{i,5}) ''',' ...
            '''' D.QResult{i,6} '''' ...
            ')']);
    end
else % If the connection failed, print the error message
    disp(sprintf('Connection failed: %s', dbConn.Message));
end
close(dbConn);
clearvars