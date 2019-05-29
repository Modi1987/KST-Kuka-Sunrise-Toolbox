%% Example of using KST class for interfacing with KUKA iiwa robots

% An example script, it is used to show how to use the 
% non-blocking moiton functions of the KST

% First start the server on the KUKA iiwa controller
% Then run the following script in Matlab

% Note you have 60 seconds to connect to server after starting the
% application (MatlabToolboxServer) from the smart pad on the robot controller.

% This example works with Sunrise application version KST_1.7  and higher.
% Copyright Mohammad SAFEEA, 12th-May-2019

close all;clear;clc;
warning('off')
%% Create the robot object
ip='172.31.1.147'; % The IP of the controller
arg1=KST.LBR7R800; % choose the robot iiwa7R800 or iiwa14R820
arg2=KST.Medien_Flansch_elektrisch; % choose the type of flange
Tef_flange=eye(4); % transofrm matrix of EEF with respect to flange
iiwa=KST(ip,arg1,arg2,Tef_flange); % create the object

%% Start a connection with the server
flag=iiwa.net_establishConnection();
if flag==0
    return;
end
pause(1);
disp('Doing some stuff')

disp('Hold on a sec, the robot will move on a line while aquiring the force feedback at the end-effector')
disp('When motion is fully executed, Matlab will plot the (x,y,z) components of the force with time')
param=1; % to specify the feedback as the force at the EEF of the robot
%% Non blocking motion in Cartesian space
% Go to some initial position
relVel=0.35; % over ride relative joint velocities
jPos={0, -pi / 180 * 10, 0, -pi / 180 * 100, pi / 180 * 90,pi / 180 * 90, 0};   % initial cofiguration
iiwa.movePTPJointSpace(jPos, relVel);
      
% Get current position of EEF
[ Pos ] = iiwa.getEEFPos(  );
distPos=Pos;
distPos{1}=distPos{1}+100;
distPos{3}=distPos{3}-200;

% Move non-blocking
vel=15; %15 mm/sec
iiwa.nonBlocking_movePTPLineEEF(distPos, vel);
flag=true;
motionFlag=false;

maxIndex=10000;
forceFeedbackArray=zeros(3,maxIndex);
timeArray=zeros(1,maxIndex);
forceVec=zeros(3,1);
counter=0;
tic; % performing some timing
while ~motionFlag
    [motionFlag,feedBack]=iiwa.nonBlockingCheck_WithFeedback(param);
    counter=counter+1;
    for i=1:3
        forceVec(i)=feedBack{i};
    end
    forceFeedbackArray(:,counter)=forceVec;
    timeArray(counter)=toc;
end
delta_t=toc;
%% Calculate feedback rate, 
disp('Feedback rate is:');
da_rate=counter/delta_t;
disp(da_rate)
%% Turn off server
disp('Distination reached');
disp('Turning off server');
iiwa.net_turnOffServer(  );
%% Plot the force at the EEF
n=1:counter;
timeSpan=timeArray(n);
fVec=forceFeedbackArray(1,n);
plot(timeSpan,fVec);
hold on;
fVec=forceFeedbackArray(2,n);
plot(timeSpan,fVec);
fVec=forceFeedbackArray(3,n);
plot(timeSpan,fVec);
xlabel('Time span [seconds]');
ylabel('Force [N]');
legend('Fx','Fy','Fz');