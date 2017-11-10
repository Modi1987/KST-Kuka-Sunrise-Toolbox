function [tKuka,flag]=connectToKuka( jPos)
%% Connect to KUKA iiwa using the KST.
% Mohammad SAFEEA 10-Nov-2017

cDir = pwd;
cDir=getTheKSTDirectory(cDir);
addpath(cDir);

warning('off');
ip='172.31.1.147'; % The IP of the controller
% start a connection with the server
tKuka=net_establishConnection( ip );

if ~exist('tKuka','var') || isempty(tKuka)
  warning('Connection could not be establised, script aborted');
  flag=false;
  return;
end
 % Move robot to home position    
      setBlueOff(tKuka); % turn Off blue light
    
      relVel=0.15;
      movePTPJointSpace( tKuka , jPos, relVel); % move to initial configuration
      
       flag=true;
end

