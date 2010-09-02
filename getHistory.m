function [ currValIDTail history ] = getHistory( currValID, history, tail )
%GETHISTORY get tail for particular value id, used for wavelets
%   getHistory takes in the value id and cell array of arrays that contain
%   previous tails for particular streams. It first checks that array for
%   the valueid's stream, and returns a ringbuffer from that if found. If
%   not, it checks to see if there are the tail variable's worth of history
%   in Vega_1. Returns -1 if error occurred.
%  
%   ring buffer: first index is current head, second index is stream id,
%   all other indexes are data points

flag = 0;
% get streamID for this valueid
% Create the database connection object
dbConn = database('vega_1','vegas','vegaselect','com.mysql.jdbc.Driver','jdbc:mysql://mysql.uwcfl.org/vega_1');
if isconnection(dbConn)
    QResult = get(fetch(exec(dbConn, ['SELECT * FROM `values` WHERE' ...
        'ValueID = ' num2str(currValID)])), 'Data');
    streamID = QResult(1,5);
    close(dbConn);
else
    currValIDTail = [];
    streamID = -1;
end

if streamID > -1
    for i=1:size(history,1)
        temp = history{i,1};
        if temp(2,1) == streamID
            flag = 1;
            if size(temp,1) < tail+2 % tail+2 is to account for the first two indexes of tail
                % this means that the particular data point needs to be added to end
                % of tail, and head index should be updated
                value = QResult(1,2);
                temp = [temp;value];
                temp(1,1) = size(temp,1);
                currValIDTail = temp;
                history{i,1} = temp;
            else
                % this means that this particular data point has all the
                % data points it needs, and just needs to be added to ring
                % buffer
                value = QResult(1,2);
                head = temp(1,1);
                if head == tail+2
                    head = 3; % wrap head around to 3
                else
                    head = head + 1; % just update head
                end
                temp(head,1) = value;
                temp(1,1) = head;
                currValIDTail = temp;
                history{i,1} = temp;
            end
        end
    end
    if flag == 0
        % this means no tail was ever created for this streamID, and we
        % need to create one
        temp(1,1) = 3; % initial head location should be 3
        temp(2,1) = streamID; % streamID is set
        value = QResult(1,2);
        temp(3,1) = value; % initial value is set
        currValIDTail = temp;
        history{size(history,1)+1,1} = temp;
    end
end
                