%% Example
% This script is used to initialize the precise hand guiding functionality on KUKA
% robot remotely

% Mohammad SAFEEA, 22nd of Oct  2017

% TO use this example:
% 1- Start the server on KUKA
% 2- Start the client on Matlab
% 3- Run this script
% 4- To turn off the precise hand guiding, keep pressing the green button
% of the robot for more than 5 seconds (you can notice that the lights
% start to flash in blue) then the functionality is turned off
% automatically

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

%% Start handguiding functionality   
wightOfTool=10; % weight of the mounted tool and tool changer (if any)
COMofTool=[0;
    0;
    0]; % coordinates of center of mass of tool and toolcanger (if any) described in reference frame of flange.
iiwa.startPreciseHandGuiding( wightOfTool,COMofTool );
           
 
%% turn off the server
iiwa.net_turnOffServer();
