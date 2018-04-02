% KUKA sunrise toolbox example.
% moving end-effector of the robot on a circle.

% Copy right: Mohammad SAFEEA
% 16th-Oct-2017

clear all;
close all;
clc;

% Initial configuration
jPos={0., pi / 180 * 30, 0, -pi / 180 * 60, 0,...
                        pi / 180 * 90, 0};
% Start the KST, move robot to initial configuration, start directServo function
[tKuka,flag]=connectToKuka(jPos );

if flag==false
    fprintf('Can not connect to KST \n');
    fprintf('Program terminated \n');
    return;
end

% put the pen on the level of the page
    deltaX=0;deltaY=0;deltaZ=-82.;
    Pos{1}=deltaX;
    Pos{2}=deltaY;
    Pos{3}=deltaZ;
    vel=50;
    movePTPLineEefRelBase( tKuka , Pos, vel);
    pause(1);
    % get joints angles of robot
    jPos  = getJointsPos( tKuka );
    
    % start the direct servo
     realTime_startDirectServoJoints(tKuka);
     
    % calculate current position of flange point of the robot
    
    qs=zeros(7,1);
for i=1:7
    qs(i)=jPos{i};
end

        TefTool=eye(4);
        T0=directKinematics(qs,TefTool); % EEF frame transformation matrix
        p0=T0(1:3,4);
        Tt=T0;

% parameters of the circle:
r=0.05; % radius of the circle

% Joint space control

    [Ttemp,J]=directKinematics(qs,TefTool); 
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

    [ qs ] = kukaDLSSolver( qs, Tt, TefTool,n,lambda );
    
    for i=1:7
        jPos{i}=qs(i);
    end
    
	%% Send joint positions to robot
	sendJointsPositions( tKuka,jPos);

end

% Turn off the server
    net_turnOffServer( tKuka );
    fclose(tKuka);
    
