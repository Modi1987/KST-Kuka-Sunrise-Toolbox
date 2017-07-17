%% Example
% An example script, it is used to show how to use the different
% functions of the KUKA Sunrise matlab toolbox
% First start the server on the KUKA iiwa controller
% Then run the following script in Matlab

% Copy right: Mohammad SAFEEA, 3rd of May 2017

close all,clear all;clc
warning('off')
ip='172.31.1.147'; % The IP of the controller
% start a connection with the server
t=net_establishConnection( ip );

if ~exist('t','var') || isempty(t)
  warning('Connection could not be establised, script aborted');
  return;
else
    %% move to initial position
pinit={0,pi*20/180,0,-pi*70/180,0,pi*90/180,0}; % initial confuguration
relVel=0.15; % relative velocity
movePTPJointSpace( t , pinit, relVel); % point to point motion in joint space

    %% Get the joints positions
      jPos  = getJointsPos( t );
      fprintf('The joints positions of the robot are: \n');
      disp(jPos);
 % jPos = 

 %   [-8.6886e-06]    [0.3491]    [9.9110e-05]    [-1.2218]    [-8.1109e-05]    [1.5708]    [7.7778e-05]  
 
      %% Get position roientation of end effector
      fprintf('Cartesian position/orientation of end-effector:\n');
      pos=getEEFPos( t );
      disp(pos);
% pos = 

%    [536.8023]    [0.0255]    [563.8379]    [-3.1416]    [-1.1624e-04]    [-3.1415]

      
      %% Get position of end effector
      fprintf('Cartesian position of end-effecotr:\n')
      cpos=getEEFCartesianPosition( t );
      disp(cpos);
%cpos = 

%    [536.8023]    [0.0254]    [563.8380]      
      %% Get orientation of end effector
      fprintf('Cartesian orientation of end-effecotr:\n')
      orie=getEEFCartesianOrientation( t );
      disp(orie);
% orie = 

%    [-3.1416]    [-1.1606e-04]    [-3.1415]      
      %% Get force at end effector
      fprintf('Cartesian force acting at end effector:\n')
      f=getEEF_Force(t);
      disp(f);
% f = 

%    [-2.6678]    [-0.3954]    [10.5507]      
      %% Get moment at end effector
      fprintf('moment at eef\n');
      m=getEEF_Moment(t);
      disp(m);
% m = 

%    [-0.1500]    [0.3462]    [-0.0949]      
      %% turn off the server
       net_turnOffServer( t );


       fclose(t);
end

