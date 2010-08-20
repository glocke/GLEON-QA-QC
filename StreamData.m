function [ VariableID UnitID Max Min newStreamDataArray] = StreamData( StreamID, oldStreamDataArray)
%STREAMDATA Function that stores and retrieves metadata of a stream
%   Checks a built in memory object to see if stream's metadata is there,
%   if not, queries for it and stores in memory object. Finally returns
%   said metadata
queryFlag = 1;
for i=1:size(oldStreamDataArray, 1)
    if oldStreamDataArray(i,1) == StreamID
        VariableID = oldStreamDataArray(i,2);
        UnitID = oldStreamDataArray(i,3);
        Max = oldStreamDataArray(i,4);
        Min = oldStreamDataArray(i,5);
        newStreamDataArray = oldStreamDataArray;
        queryFlag = 0;
        break;
    end
end

if queryFlag
    % Set this to the path to your MySQL Connector/J JAR
    javaaddpath('mysql-connector-java-5.1.12\mysql-connector-java-5.1.12-bin.jar');
    % javaaddpath('c:\program files\mysql-connector-java-3.1.14\mysql-connector-java-3.1.14-bin.jar');

    % Create the database connection object
    dbConn = database('vega','vegas','vegaselect','com.mysql.jdbc.Driver','jdbc:mysql://mysql.uwcfl.org/vega');

    % Check to make sure that we successfully connected, then determine Max and
    % Min
    if isconnection(dbConn)
        cellvar = get(fetch(exec(dbConn, ['select `VariableID` from `streams` where `StreamID` = ' num2str(StreamID)])), 'Data');
        cellunit = get(fetch(exec(dbConn, ['select `UnitID` from `streams` where `StreamID` = ' num2str(StreamID)])), 'Data');
        % Check to make sure unit id and variable id exist in db, if not,
        % no changes are made
        check = get(fetch(exec(dbConn, ['select `UnitID` from `ranges` where `VariableID` = ' num2str(cellvar{1,1}) ...
                ' and UnitID = ' num2str(cellunit{1,1})])), 'Data');
        if strcmp(check, 'No Data')
            disp(sprintf('UnitID or VariableID is not in database'));
            VariableID = 'NULL';
            UnitID = 'NULL';
            Max = 'NULL';
            Min = 'NULL';
            newStreamDataArray = oldStreamDataArray;
        else
            VariableID = cellvar{1,1};
            UnitID = cellunit{1,1};
            maxcell = get(fetch(exec(dbConn, ['select `Max` from `ranges` where `VariableID` = ' num2str(cellvar{1,1}) ...
                ' and UnitID = ' num2str(cellunit{1,1})])), 'Data');
            mincell = get(fetch(exec(dbConn, ['select `Min` from `ranges` where `VariableID` = ' num2str(cellvar{1,1}) ...
                ' and UnitID = ' num2str(cellunit{1,1})])), 'Data');
            if strcmp(maxcell, 'No Data') || strcmp(mincell, 'No Data')
                disp(sprintf('Max or Min is not in database'));
                Max = 'NULL';
                Min = 'NULL';
                newStreamDataArray = oldStreamDataArray;
            else
                Max = maxcell{1,1};
                Min = mincell{1,1};
                
                in = {StreamID, VariableID, UnitID, Max, Min};
                newStreamDataArray = [in;oldStreamDataArray];
            end
        end
    end
    % Close the connection so we don't run out of MySQL threads
    close(dbConn);
    pause(0.5); % Don't hit SQL too hard
end
clearvars -except VariableID UnitID Max Min newStreamDataArray


