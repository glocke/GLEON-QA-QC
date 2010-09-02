function [ initID ] = GetInitialValueID()
%GETINITIALVALUEID Summary of this function goes here
%   Detailed explanation goes here

% Set this to the path to your MySQL Connector/J JAR
javaaddpath('mysql-connector-java-5.1.12\mysql-connector-java-5.1.12-bin.jar');
% Create the database connection object
dbConn = database('vega_1','vegas','vegaselect','com.mysql.jdbc.Driver','jdbc:mysql://mysql.uwcfl.org/vega_1');
if isconnection(dbConn)
    initialID = get(fetch(exec(dbConn, 'SELECT * FROM `values` ORDER BY ValueID DESC LIMIT 1')), 'Data');
    initID = initialID{1,1};
else
    initID = 152177192; % Something to give it, make it recent
end
close(dbConn);
clearvars -except initID
end
