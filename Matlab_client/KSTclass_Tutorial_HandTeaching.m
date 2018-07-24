%% Example
% This script is used to initialize the hand guiding functionality on KUKA
% robot remotely

% Mohammad SAFEEA, 9th of June 2017

% TO use this example:
% 1- Start the server on KUKA
% 2- Start the client on Matlab
% 3- Press the white button and hand guide the robot
% 4- To save the coordinates of the robot, long click on the green button
% 5- Repeat three times
% 6- The robot gives you an interval of five seconds, clear the area around
% the robot directly, the robot will reproduce the motion tought.

close all;clear;clc;
warning('off')
%% Create the robot object
ip='172.31.1.147'; % The IP of the controller
arg1=KST.LBR7R800; % choose the robot iiwa7R800 or iiwa14R820
arg2=KST.Medien_Flansch_Touch_pneumatisch; % choose the type of flange
Tef_flange=eye(4); % transofrm matrix of EEF with respect to flange
iiwa=KST(ip,arg1,arg2,Tef_flange); % create the object

%% Start a connection with the server
flag=iiwa.net_establishConnection();
if flag==0
  return;
end
pause(1);

   
iiwa.startHandGuiding()

p1 = iiwa.getJointsPos();
      
iiwa.startHandGuiding()       
 
p2 = iiwa.getJointsPos();

iiwa.startHandGuiding()     
 
p3 = iiwa.getJointsPos();

iiwa.startHandGuiding()        
 

fprintf('CLear the area round the robot, the robot is going to move');

pause(5)


relVel=0.1;
iiwa.movePTPJointSpace(p1, relVel)
iiwa.movePTPJointSpace(p2, relVel)
iiwa.movePTPJointSpace(p3, relVel)

%% turn off the server
iiwa.net_turnOffServer();

