function [ t ] = net_establishConnection( ip )
%% This function is used to establish a connection with the server on KUKA

%% Syntax:
% function [ t ] = net_establishConnection( ip )
% This function is used to establish a connection with the server on KUKA.

%% Arregument:
% ip: a string variable, the IP of the robot, example '172.31.1.147',
% To figure out your robot IP, do the following:
% from the teach pendant, click on 'Station' button, then the 'information'
% button, from the information page check out your KUKA iiwa IP.

%% Return value:
% t: is a TCP/IP object, this object is empty when the connection could not be established.

% Copy right, Mohammad SAFEEA, 3rd of May 2017

t=[];
if ~exist('ip','var') || isempty(ip)
  warning('Connection could not be establised');
  return;
else
    try
            port=30001;
            % Connect to server
            t= tcpip(ip, port, 'NetworkRole', 'client');
            t.TransferDelay='off';
            t.Timeout=3.0;
            fopen(t);
            pause(1);
    catch exception
       warning('Connection could not be establised');
    end

end

end

