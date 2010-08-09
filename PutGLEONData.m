function [YearFrac Result] = PutGLEONData(Final)

% print out to SQL text file...
%
% out = fopen('sqlresult.txt','w');
% fprintf(out, '--\n');
% fprintf(out, '-- Gleon QA Result\n');
% fprintf(out, '-- # Records: %s\n', num2str(size(Final,1)));
% fprintf(out, '--\n');
% fprintf(out, '\n');
% fprintf(out, 'SET SQL_MODE=''NO_AUTO_VALUE_ON_ZERO''\n');
% fprintf(out, '\n');
% fprintf(out, 'INSERT DELAYED INTO `values` (`ValueID`, `Value`, `DateTime`, `UTCOffset`, `StreamID`, `Flag`) VALUES\n')
% 
% for i=1:size(Final,1)
%     if Final{i, 6} == 'null'
%         Final{i, 6} = 'NULL';
%     end
%     
%     fprintf(out, '(%s, %s, ''%s'', %s, %s, %s)', ...
%         num2str(Final{i,1}), ...
%         num2str(Final{i,2}), ...
%         Final{i,3},          ...
%         num2str(Final{i,4}), ...
%         num2str(Final{i,5}), ...
%         Final{i,6})
%     
%     if mod(i, 500) == 0
%         fprintf(out, ';\n');
%         fprintf(out, 'INSERT DELAYED INTO `values` (`ValueID`, `Value`, `DateTime`, `UTCOffset`, `StreamID`, `Flag`) VALUES\n')
%     else
%         fprintf(out, ',\n');
%     end
%     
% end

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
    for i=1:size(Final,1)
        % fix null flag field
        if Final{i, 6} == 'null'
            Final{i, 6} = '';
        end
        QResult = exec(dbConn, ['insert into `values` values (' ...
            '''' num2str(Final{i,1}) ''',' ...
            '''' num2str(Final{i,2}) ''',' ...
            '''' Final{i,3} ''',' ...
            '''' num2str(Final{i,4}) ''',' ...
            '''' num2str(Final{i,5}) ''',' ...
            '''' Final{i,6} '''' ...
            ')']);
    end
    
    disp(['Size of record set: ' num2str(size(QResult))]);
    
else % If the connection failed, print the error message
    disp(sprintf('Connection failed: %s', dbConn.Message));
    YearFrac = [];
    Result = [];
end

close(dbConn);