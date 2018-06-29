%% Example of using KST class for interfacing with KUKA iiwa robots
% moving end-effector of the robot on an elliptical path using soft realtime
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


%% Go to some initial configuration
jPos={0., pi / 180 * 30, 0, -pi / 180 * 60, 0,...
                    pi / 180 * 90, 0};
relVel=0.15;
% Start the KST, move robot to initial configuration, start directServo function
iiwa.movePTPJointSpace(jPos, relVel);

% move a little bit back on the X direction
deltaX=-60;deltaY=0;deltaZ=0.;
Pos{1}=deltaX;
Pos{2}=deltaY;
Pos{3}=deltaZ;
vel=50;
iiwa.movePTPLineEefRelBase(Pos, vel);
% put the pen on the level of the page
deltaX=0;deltaY=0;deltaZ=-85.;
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

T0=iiwa.directKinematics(qs); % EEF frame transformation matrix
p0=T0(1:3,4);
Tt=T0;

%% Define the ellipse, dimentsions are in (meter)
p=p0; % this is the starting point of the ellipse
c=p+([0; 50; 0]/1000); % this is the center of the ellipse
dir=[1 0 0]; % the direction vector of the (a) axis of the ellipse
ratio=0.5; % the radious ratio (a/b) of the ellipse
%% Claulcate ellipse parameters
[R,theta0,a,b,c,errorFlag]=getEllipseParameters(p,c,ratio,dir);
if errorFlag==true % this happens when the start point is on the (dir) vector direction.
    % in such case the ellipse plane can not be specified in space.
    % Stop the realtime motion
    iiwa.realTime_stopDirectServoJoints();
    % Turn off the server
    iiwa.net_turnOffServer(  );
    return;
end
%% Draw the length of the ellipse arc as a function of the parametric angle (theta)
theta=2*pi;

theta1=theta0+theta;

[ thetaVec,sVec ] = getEllipseLengthVector( a,b, theta0,theta1 );
sizesVec=max(size(sVec));
L=sVec(end); % L is the length of the curve


%% Calculate the times:
velocity=40/1000; % steady velcotiy, m/sec;
accel=25/1000; % linear acceleration, m/sec2
[t0,t1,t2]=calculateInterpolationTimes(L,velocity,accel);

%% Joint space control
[Ttemp,J]=iiwa.gen_DirectKinematics(qs); 
vec=Ttemp(1:3,4);   

% dls solver parameters        
numberOfIterationForSolver=100;
lambda=0.5;

sCoordinate=0;
interpolationCounter=1;
thetaVar=theta0;

% start of time
dateVector0=datevec(now);
time0=dateVector0(6)+dateVector0(5)*60+dateVector0(4)*60*60; % calculate time at this instant
while true

% Calculate the elapsed time
    dateVector=datevec(now);
    timeNow=dateVector(6)+dateVector(5)*60+dateVector(4)*60*60; % calculate time at this instant
    deltaT=timeNow-time0; % elapsed is zero at first excution

% calculate position of servo point
if deltaT<t0
    sCoordinate=0.5*accel*deltaT*deltaT;
elseif(deltaT<t1)
    s0=0.5*accel*t0*t0;
    sCoordinate=velocity*(deltaT-t0)+s0;
elseif(deltaT<t2)
       s0=0.5*accel*t0*t0;
       s1=velocity*(t1-t0)+s0; 
       sCoordinate=velocity*(deltaT-t1)-0.5*accel*(deltaT-t1)*(deltaT-t1)+s1;
end
%% when time ends break the loop   
if deltaT>t2
    break;
end
%% Interpolate theta from the sVec,thetaVec
for counter=interpolationCounter:(sizesVec-1)
    if(sCoordinate>sVec(counter))
        tetaRange=thetaVec(counter+1)-thetaVec(counter);
        sRange=sVec(counter+1)-sVec(counter);
        thetaVar=(sCoordinate-sVec(counter))...
            *tetaRange/sRange+thetaVec(counter);
        interpolationCounter=counter;
    end
end

pPrime=R*ellipseParametricFunction( a,b,thetaVar );
p=c+pPrime;

% calculate target transform
Tt(1:3,4)=p;

[ qs ] = iiwa.gen_InverseKinematics( qs, Tt,numberOfIterationForSolver,lambda );

for i=1:7
    jPos{i}=qs(i);
end

%% Send joint positions to robot
iiwa.sendJointsPositions(jPos);

end

% Stop the realtime motion
iiwa.realTime_stopDirectServoJoints();

% put the pen up the page
deltaX=0;deltaY=0;deltaZ=+85.;
Pos{1}=deltaX;
Pos{2}=deltaY;
Pos{3}=deltaZ;
vel=50;
iiwa.movePTPLineEefRelBase(Pos, vel);

% Turn off the server
iiwa.net_turnOffServer();

