%% Example
% This script is used to detect the double touch of the kuka end effector
% in the Z direction

% Mohammad SAFEEA, 20th of May 2017

close all,clear all,clc

global binaryValArray
global averageVal
binaryValArray=zeros(40,1);
averageVal=0;

fprintf('Double touch the robot up to hear the event')

ip='172.31.1.147'; % The IP of the controller
% start a connection with the server
t=net_establishConnection( ip );

if ~exist('t','var') || isempty(t)
  warning('Connection could not be establised, script aborted');
  return;
else

   

    num=60*100; % for 1 minute
    for(i=1:num)
        pause(0.01);
        performEventFunctionAtDoubleHit(t);
    end

      
           
 
      %% turn off the server
       net_turnOffServer( t );


       fclose(t);
end

