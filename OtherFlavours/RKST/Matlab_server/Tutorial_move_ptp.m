%% Example
% An example script, it is used to show how to use the different
% functions of the KUKA iiwa matlab toolbox

% First run the following script in Matlab
% Then start the client on the KUKA iiwa controller

% Mohammad SAFEEA, 24th of April 2018

close all,clear all,clc

ip='172.31.1.147'; % The IP of the controller
% start a connection with the server
t_Kuka=net_establishConnection( ip );

if ~exist('t_Kuka','var') || isempty(t_Kuka) || strcmp(t_Kuka.Status,'closed')
  warning('Connection could not be establised, script aborted');
  return;
else
   
    %% move to initial position
pinit={0,pi*20/180,0,-pi*70/180,0,pi*90/180,0}; % initial confuguration
relVel=0.15; % relative velocity
movePTPJointSpace( t_Kuka , pinit, relVel); % point to point motion in joint space

      %% PTP motion
      jPos={}
      homePos={}
     [ jPos ] = getJointsPos( t_Kuka ) % get current joints position

      
           
      for ttt=1:7  % home position
          homePos{ttt}=0;
      end
      
      pause(0.1)
      relVel=0.15;
      movePTPJointSpace( t_Kuka , homePos, relVel); % go to home position
      pause(0.1)
      movePTPJointSpace( t_Kuka , jPos, relVel); % return back to original position
      
      %% turn off the server
       net_turnOffServer( t_Kuka );


       fclose(t_Kuka);
end

