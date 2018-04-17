function [ output_args ] = net_turnOffServer( t )
%% This function is used to turn off the server on the robot
% function [ output_args ] = net_turnOffServer( t )
% t: is the TCP/IP connection object
% Copy right, Mohammad SAFEEA, 3rd of May 2017

theCommand='end';
fprintf(t, theCommand);
fclose(t);
%message=fgets(t);
end

