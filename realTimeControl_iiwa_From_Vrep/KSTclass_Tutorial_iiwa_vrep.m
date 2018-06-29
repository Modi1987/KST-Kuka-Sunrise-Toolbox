%% Example of using KST class for interfacing with KUKA iiwa robots
% Controlling KUKA iiwa from V-rep simulation using MATLAB and KST as a
% middle-ware.
% This script works together with V-rep scene: iiwaFromVrep.ttt

%% To run this example do the following:
% 1- Run the Vrep simulation: iiwaFromVrep.ttt
% 2- Run the (MarlabToolboxServer) application on the robot
% 3- Run this script from MATLAB.

% Copyright: Mohammad SAFEEA, 25th of June 2018

%% Initiation part of the code
close all;clear;clc;
warning('off')
disp('Program started');
%% Add path of KST class to work space
cDir = pwd;
cDir=getTheKSTDirectory(cDir);
addpath(cDir);

%% Declare V-rep objects
vrep=remApi('remoteApi');
vrep.simxFinish(-1); 
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);

%% Instantiate the KST object
ip='172.31.1.147'; % The IP of the controller
arg1=KST.LBR7R800; % choose the robot iiwa7R800 or iiwa14R820
arg2=KST.Medien_Flansch_elektrisch; % choose the type of flange
Tef_flange=eye(4); % transofrm matrix of EEF with respect to flange
iiwa=KST(ip,arg1,arg2,Tef_flange); % create the object

if (clientID>-1)  
    %% Start a connection with the server
    flag=iiwa.net_establishConnection();
    if flag==0
      return;
    end
    
    jHandles=zeros(7,1);
    for i=1:7
            s=['LBR_iiwa_7_R800_joint',num2str(i)];
            [res, daHandle]=vrep.simxGetObjectHandle(clientID,s,vrep.simx_opmode_oneshot_wait);
            jHandles(i)=daHandle;
    end
else 
    return;
end
jPos={0., pi / 180 * 20., 0., -pi / 180 * 70., 0.,...
                        pi / 180 * 90., 0.};
relVel=0.25;
iiwa.movePTPJointSpace(jPos, relVel);
%% Control loop
iiwa.realTime_startDirectServoJoints();
pause(10);
counter=0;
tic;
totalTimeSecs=60; % 60 seconds of execution time
vrep.simxStartSimulation(clientID,vrep.simx_opmode_oneshot_wait);
for i=1:7
        [res,tempPos]=vrep.simxGetJointPosition(clientID,jHandles(i),...
            vrep.simx_opmode_streaming);
end
vrep.simxWriteStringStream(clientID,'path_velocity','0.07',vrep.simx_opmode_oneshot_wait);
jpos=zeros(7,25000);
t_0=toc;
while(t_0<totalTimeSecs)
    for i=1:7
            [res,tempPos]=vrep.simxGetJointPosition(clientID,jHandles(i),...
                vrep.simx_opmode_buffer);
            jPos{i}=tempPos;
    end
    
    if(toc-t_0>0.003)
        counter=counter+1;
        iiwa.sendJointsPositionsf(jPos);
        for i=1:7
            jpos(i,counter)=jPos{i};
        end
        t_0=toc;
	end
end
%% Turn off KST server
iiwa.net_turnOffServer();
%% Stop simulation
vrep.simxStopSimulation(clientID,vrep.simx_opmode_oneshot_wait);
%% End simulation
vrep.simxFinish(clientID);
vrep.delete();
