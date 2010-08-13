function [ newYearFrac newData newStreamDataArray] = RangeChecks( YearFrac, Removable, Streams, TS, oldStreamDataArray )
%RANGECHECKS function to check acceptable ranges of data
%   Uses the "ranges" table in Vega to make sure data is in between the 
%   data listed. IMPORTANT, TEST ALL THESE PARTS INDIVIDUALLY
for i2=size(Streams,1):-1:1
    [VariableID UnitID Max Min newStreamDataArray] = StreamData(Streams{i2,1}, oldStreamDataArray);
    if isnan(VariableID) || isnan(UnitID)
        % We do no comparisons if these don't exist, and just go to next
        % point.
    else
        % check to see if Max or Min are null
        if isnan(Max)
            max = Inf;
        else
            max = Max;
        end
        if isnan(Min)
            min = -Inf;
        else
            min = Min;
        end
        
        if max ~= Inf || min ~= -Inf
            % remove data that is out of range
            test = Removable{i2,1};
            % assuming Data(i) is a number
            if test > max || test < min
                Removable(i2,:) = [];
                YearFrac(i2,:) = [];
                Streams(i2,:) = [];
            end
        end
    end
    oldStreamDataArray = newStreamDataArray;
    clearvars -except YearFrac Removable Streams TS oldStreamDataArray newStreamDataArray
end
newYearFrac = YearFrac;
newData = iddata(cell2mat(Removable),[],TS); 











% %Old Range Checks Starts Below
% 
% function [ newYearFrac newData ] = RangeChecks( YearFrac, Removable, StreamID, TS )
% %RANGECHECKS function to check acceptable ranges of data
% %   Uses the "ranges" table in Vega to make sure data is in between the 
% %   data listed.
% 
% % Set this to the path to your MySQL Connector/J JAR
% javaaddpath('mysql-connector-java-5.1.12\mysql-connector-java-5.1.12-bin.jar');
% % javaaddpath('c:\program files\mysql-connector-java-3.1.14\mysql-connector-java-3.1.14-bin.jar');
% 
% % Create the database connection object
% dbConn = database('vega','vegas','vegaselect','com.mysql.jdbc.Driver','jdbc:mysql://mysql.uwcfl.org/vega');
% 
% % Check to make sure that we successfully connected, then determine Max and
% % Min
% if isconnection(dbConn)
%     cellvar = get(fetch(exec(dbConn, ['select `VariableID` from `streams` where `StreamID` = ' num2str(StreamID)])), 'Data');
%     cellunit = get(fetch(exec(dbConn, ['select `UnitID` from `streams` where `StreamID` = ' num2str(StreamID)])), 'Data');
%     % Check to make sure unit id and variable id exist in db, if not,
%     % no changes are made
%     check = get(fetch(exec(dbConn, ['select `UnitID` from `ranges` where `VariableID` = ' num2str(cellvar{1,1}) ...
%             ' and UnitID = ' num2str(cellunit{1,1})])), 'Data');
%     if strcmp(check, 'No Data')
%         disp(sprintf('UnitID or VariableID is not in database'));
%         newYearFrac = YearFrac;
%         newData = iddata(cell2mat(Removable),[],TS);
%     else   
%         maxcell = get(fetch(exec(dbConn, ['select `Max` from `ranges` where `VariableID` = ' num2str(cellvar{1,1}) ...
%             ' and UnitID = ' num2str(cellunit{1,1})])), 'Data');
%         mincell = get(fetch(exec(dbConn, ['select `Min` from `ranges` where `VariableID` = ' num2str(cellvar{1,1}) ...
%             ' and UnitID = ' num2str(cellunit{1,1})])), 'Data');
%         % check to see if max or min are null
%         if isnan(maxcell{1,1})
%             max = Inf;
%         else
%             max = double(maxcell{1,1});
%         end
%         if isnan(mincell{1,1})
%             min = -Inf;
%         else
%             min = double(mincell{1,1});
%         end
%         
%         if max ~= Inf || min ~= -Inf
%             % remove data that is out of range
%             [a,b] = size(Removable);
%             for i=a:-1:1
%                 test = Removable{i,1};
%                 % assuming Data(i) is a number
%                 if test > max || test < min
%                     Removable(i,:) = [];
%                     YearFrac(i,:) = [];
%                 end
%             end
%         end
% 
%         newYearFrac = YearFrac;
%         newData = iddata(cell2mat(Removable),[],TS);
%     end
% % If the connection failed, print the error message
% else
%     disp(sprintf('Connection failed: %s', dbConn.Message));
%     newYearFrac = YearFrac;
%     newData = Data;
% end
% 
% % Close the connection so we don't run out of MySQL threads
% close(dbConn); 
% 
