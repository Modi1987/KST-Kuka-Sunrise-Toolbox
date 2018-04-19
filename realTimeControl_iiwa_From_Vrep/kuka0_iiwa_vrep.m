%% Example
% Controlling KUKA iiwa from V-rep simulation using MATLAB and KST as a
% middle-ware.
% This script works together with V-rep scene: iiwaFromVrep.ttt

%% To run this example do the following:
% 1- Run the Vrep simulation: iiwaFromVrep.ttt
% 2- Run the (MarlabToolboxServer) application on the robot
% 3- Run this script from MATLAB.

% Copyright: Mohammad SAFEEA, 19th-April-2018

%% Initiation part of the code
disp('Program started');
kst_Path=getTheKSTDirectory(pwd);
addpath(kst_Path);
vrep=remApi('remoteApi');
vrep.simxFinish(-1); 
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
ip='172.31.1.147'; 
global t_Kuka;
if (clientID>-1)  
    t_Kuka=net_establishConnection( ip );
    if ~exist('t_Kuka','var') || isempty(t_Kuka) || strcmp(t_Kuka.Status,'closed')
      warning('Connection could not be establised, script aborted');
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
movePTPJointSpace( t_Kuka , jPos, relVel);
%% Control loop
realTime_startDirectServoJoints( t_Kuka );
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
        sendJointsPositionsf( t_Kuka ,jPos);
        for i=1:7
            jpos(i,counter)=jPos{i};
        end
        t_0=toc;
	end
end
%% Turn off KST server
net_turnOffServer( t_Kuka );
%% Stop simulation
vrep.simxStopSimulation(clientID,vrep.simx_opmode_oneshot_wait);
%% End simulation
vrep.simxFinish(clientID);
vrep.delete();
