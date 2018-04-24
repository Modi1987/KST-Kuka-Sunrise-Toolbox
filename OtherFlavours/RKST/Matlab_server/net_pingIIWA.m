function net_pingIIWA(ip)
%% About
% Ping kuka iiwa through the network

%% Syntax
% net_pingIIWA(ip)

%% Arreguments
% ip: is the IP of the kuka controller

% Copyright: Mohammad SAFEEA 16th-April-2018

command=['ping ',ip];
dos(command);
end