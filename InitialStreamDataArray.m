function [ streamDataArray ] = InitialStreamDataArray()
%INITIALSTREAMDATAARRAY Ran at beginning of program to initially fill in
%Streams.Data
% Set this to the path to your MySQL Connector/J JAR
%javaaddpath('mysql-connector-java-5.1.12\mysql-connector-java-5.1.12-bin.jar');
% javaaddpath('c:\program files\mysql-connector-java-3.1.14\mysql-connector-java-3.1.14-bin.jar');

% Create the database connection object
dbConn = database('vega','vegas','vegaselect','com.mysql.jdbc.Driver','jdbc:mysql://mysql.uwcfl.org/vega');

flag = 0;
% Check to make sure that we successfully connected, then determine Max and
% Min
if isconnection(dbConn)
    Ranges = get(fetch(exec(dbConn, ['SELECT * FROM `Ranges`', 'Data'])));
    Streams = get(fetch(exec(dbConn, ['SELECT StreamID, VariableID, UnitID FROM `Streams`', 'Data'])));
    
    streamDataArray = zeros(size(Streams.Data,1),5);
    count = 1;
    for i=1:size(Streams.Data,1)
        StreamID = Streams.Data{i,1};
        VariableID = Streams.Data{i,2};
        UnitID = Streams.Data{i,3};
        for j=1:size(Ranges.Data,1)
            if VariableID == Ranges.Data{j,2} && UnitID == Ranges.Data{j,3}
                Max = Ranges.Data{j,4};
                Min = Ranges.Data{j,5};
                flag = 1;
                break;
            end
        end
        if flag == 0
            Max = Inf;
            Min = -Inf;
        end
        streamDataArray(count,1) = StreamID;
        streamDataArray(count,2) = VariableID;
        streamDataArray(count,3) = UnitID;
        streamDataArray(count,4) = Max;
        streamDataArray(count,5) = Min;
        count = count + 1;
    end
end
% Close the connection so we don't run out of MySQL threads
close(dbConn);
clearvars -except streamDataArray