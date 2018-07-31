%% Example of using KST class for interfacing with KUKA iiwa robots
% This example script is used to show how to utilise the networking
% functions integrated into the class KST of the KUKA Sunrise Toolbox

% Before using the script:
% 1- You need to establish a network between the PC and the robot
%       controller
% 2- Synchronise the application "MatlabToolboxServer" into the robot
%       controller using the SunriseWorkbench, from more info consult the
%       document "Import KST to SunriseWorkbench.pdf"
% 3- Run the application "MatlabToolboxServer" from the teach pendant of
%       the robot.
% 4- Run the following script from MATLAB on a PC that is paired to the
%       controller of the robot using an ethernet cable connected to the
%       X66 connector.


% Note: When you run the "MatlabToolboxServer" app, you have 60 seconds to
% connect to the robot from MATLAB, if the limit time is exceeded without
% establishing a connection from MATLAB, the "MatlabToolboxServer" app
% turns off automatically. You have to manyally restart the
% "MatlabToolboxServer" app before connecting to the robot again.

% Exceptions, to use the instruction "net_pingIIWA", or the general porpuse
% functions it is not required to run the "MatlabToolboxServer" app.
% Yet a pairing the PC and the controller on ethernet is still important to
% run the function "net_pingIIWA".

% Copyright Mohammad SAFEEA, 30th-June-2018

close all;clear;clc;
warning('off')

%% Create the robot object
ip='172.31.1.147'; % The IP of the controller
arg1=KST.LBR7R800; % choose the robot iiwa7R800 or iiwa14R820
arg2=KST.Medien_Flansch_elektrisch; % choose the type of flange
Tef_flange=eye(4); % transofrm matrix of EEF with respect to flange
iiwa=KST(ip,arg1,arg2,Tef_flange); % create the object
%% Check if the robot is reachable
rep=iiwa.net_pingIIWA();
disp(rep);

%% Start a connection with the server
flag=iiwa.net_establishConnection();
if flag==0
  return;
end
pause(1);
disp('This script demonstrates the networking functions of KST')

%% Read EEF position from the controller
Pos=iiwa.getEEFPos();
disp('EEF position and orientation is:')
disp(Pos)

%% turn off the server
iiwa.net_turnOffServer();
warning('on')