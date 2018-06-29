%% Example of using KST class for interfacing with KUKA iiwa robots
% moving end-effector of the robot on a circular path using soft realtime
% functions

% This example works with Sunrise application version KST_1.7  and higher.
% Copyright: Mohammad SAFEEA, 25th of June 2018

close all;clear;clc;
warning('off')
%% Add path of KST class to work space
cDir = pwd;
cDir=getTheKSTDirectory(cDir);
addpath(cDir);

%% Instantiate the KST object
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

%% Go to initial configuration
jPos={0., pi / 180 * 30, 0, -pi / 180 * 60, 0,...
                        pi / 180 * 90, 0};
relVel=0.15;
iiwa.movePTPJointSpace(jPos, relVel); % move to initial configuration

%% put the pen on the level of the page
deltaX=0;deltaY=0;deltaZ=-82.;
Pos{1}=deltaX;
Pos{2}=deltaY;
Pos{3}=deltaZ;
vel=50;
iiwa.movePTPLineEefRelBase(Pos, vel);
pause(1);
% get joints angles of robot
jPos  = iiwa.getJointsPos();

% start the direct servo
iiwa.realTime_startDirectServoJoints();

% calculate current position of flange point of the robot
qs=zeros(7,1);
for i=1:7
    qs(i)=jPos{i};
end

[T0,J]=iiwa.directKinematics(qs); % EEF frame transformation matrix
p0=T0(1:3,4);
Tt=T0;

% parameters of the circle:
r=0.05; % radius of the circle

% Joint space control

[Ttemp,J]=iiwa.directKinematics(qs); 
vec=Ttemp(1:3,4);   

a=datevec(now);
time0=a(6)+a(5)*60+a(4)*60*60; % calculate time at this instant

deltaT0=2;

% dls solver parameters        
n=10;
lambda=0.1;
TefTool=eye(4);
    
while true
    
    % Calculate the elapsed time
        a=datevec(now);
        timeNow=a(6)+a(5)*60+a(4)*60*60; % calculate time at this instant
        deltaT=timeNow-time0; % elapsed is zero at first excution

    % calculate position of servo point
    if deltaT<deltaT0
        accel=0.4;
        w=accel*deltaT;
        theta=0.5*accel*deltaT*deltaT;
    else
        accel=0.4;
        theta0=0.5*accel*deltaT0*deltaT0;
        theta=w*(deltaT-deltaT0)+theta0;
    end
    
    if theta>2*pi
        break;
    end
    
    x=p0(1)+r*(cos(theta)-1);
    y=p0(2)+r*sin(theta);
    z=p0(3);
    p=[x;y;z];
    
    % calculate target transform
    Tt(1:3,4)=p;

    [ qs ] = iiwa.gen_InverseKinematics( qs, Tt,n,lambda );
    
    for i=1:7
        jPos{i}=qs(i);
    end
    
	%% Send joint positions to robot
	iiwa.sendJointsPositions(jPos);

end

% Turn off the server
iiwa.net_turnOffServer();
    
