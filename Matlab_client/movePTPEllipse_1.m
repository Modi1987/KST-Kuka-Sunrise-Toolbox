function movePTPEllipse_1(iiwa,c,dir,ratio,theta,velocity,accel,TefTool)
%% This funciton is used to
% Move end-effector of the robot on an ellipse.
% this function is used from within the KST class

%% Syntax:
% movePTPEllipse_1(iiwa,c,dir,ratio,TefTool)

%% Arreguments:
% iiwa: KST obejct.
% c: 3x1 vector, is a vector defining the displacment of the the center
% point of the ellipse in relation to the start point of the ellipse,
% position units in (mm).
% dir: the direction vector of the (a) axis of the ellipse.
% ratio: the radious ratio (a/b) of the ellipse.
% theta: is the angle of the ellipe part , for drawing a complete
% ellipse this angle is equal to 2*pi.
% TefTool: 4X4 Transform matrix of the end-efector in the reference frame
% of the flange of the KUKA iiwa, position units in (mm).
% accel: is the acceleration (mm/sec2).
% velocity: is the motion velocity (mm/sec).
 
% Copy right: Mohammad SAFEEA
% 25th-June-2018

%% Convert inputs to a column vectors
c=colVec(c);
dir=colVec(dir);
ratio=colVec(ratio);
theta=colVec(theta);
velocity=colVec(velocity);
accel=colVec(accel);

%% Check input variables
if(size(c,1)~=3)
fprintf('Error: the vector (c) shall be a 3x1 vector \n');
return;
end

if(size(dir,1)~=3)
fprintf('Error: the vector (dir) shall be a 3x1 vector \n');
return;
end

if(size(ratio,1)~=1)
fprintf('Error: the ratio shall be a scalar  \n');
return;
end

if(size(theta,1)~=1)
fprintf('Error: the variable (theta) shall be a scalar  \n');
return;
end

if(size(TefTool,1)~=4)
fprintf('Error: the transform matrix (TefTool) shall be 4x4  \n');
return;
end

if(size(TefTool,2)~=4)
fprintf('Error: the transform matrix (TefTool) shall be 4x4  \n');
return;
end

if(size(velocity,1)~=1)
fprintf('Error: the velocity on the path shall be a scalar  \n');
return;
end

if(size(accel,1)~=1)
fprintf('Error: the acceleration on the path shall be a scalar  \n');
return;
end

%% Convert the units to (meter)
unitConverter=1000;
c=c/unitConverter;
velocity=velocity/unitConverter;
accel=accel/unitConverter;
TefTool(1:3,4)=TefTool(1:3,4)/unitConverter;

%% start the direct servo
     iiwa.realTime_startDirectServoJoints();
     
%% get current joints angles of robot
    jPos  = iiwa.getJointsPos();
        
%% Calculate the current position of TCP point of the robot (p0)
    qs=zeros(7,1);
for i=1:7
    qs(i)=jPos{i};
end
        T0=iiwa.directKinematics(qs); % TCP point transformation matrix
        p0=T0(1:3,4); % Current position of TCP point of the robot
        Tt=T0;

%% Calculate the parameters of the ellipse, 
p=p0; % this is the starting point of the ellipse
c=c+p; % calculate the center coordinates from the center displacment vector
[R,theta0,a,b,c,errorFlag]=getEllipseParameters(p,c,ratio,dir);
if errorFlag==true % this happens when the start point is on the (dir) vector direction.
    % in such case the ellipse plane can not be specified in space.
    iiwa.realTime_stopDirectServoJoints();
    beep;
    fprintf('Error executing the ellipse function:\n');
    fprintf('Starting point of the ellipse shall not be on the line aligned with the (dir) vector and passing from the center (c)\n');
    return;
end

     
%% Get the length of the ellipse arc as a function of the parametric angle (theta)
theta1=theta0+theta;
[ thetaVec,sVec ] = getEllipseLengthVector( a,b, theta0,theta1 );
sizesVec=max(size(sVec));
L=sVec(end); % L is the length of the elliptic curve

%% Calculate the times:
[t0,t1,t2]=calculateInterpolationTimes(L,velocity,accel);

%% Joint space control

    [Ttemp,J]=iiwa.directKinematics(qs); 
    vec=Ttemp(1:3,4);   


                
%% dls solver parameters        
 numberOfIterationForSolver=100;
 lambda=0.5;
 TefTool=eye(4);
        
    sCoordinate=0;
    interpolationCounter=1;
    thetaVar=theta0;

%% start of time
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
	iiwa.sendJointsPositions( jPos);

end

    % Stop the reltime motion
    iiwa.realTime_stopDirectServoJoints();
    

end

function [R,theta0,a,b,c,errorFlag]=getEllipseParameters(p,c,ratio,dir)

%% About
% This function returns the parameters of the ellipse

%% Arreguments:
% p: the starting point of the ellipse
% c: the center of the ellipse
% ratio: the ratio (a/b) of the ellipse
% dir: direction of the 


%% Return values:
% R, the rotation matrix from the ellipse frame to the base frame of the
% robot
% theta0: the starting angle of the ellipse (given by the parametric equation of the ellipse)
% a,b: the big and the small radious of the ellipse
% c: is the center of the ellipse
% error flag: returns true if an error happens, this error is when the
% vector (p-c) is coinsident with the vector (dir).


p=colVec(p);
c=colVec(c);
dir=colVec(dir);

% X dirction vector
i=dir/norm(dir);

u=p-c;
% 
k=cross(u,i);
normk=norm(k);

if(normk==0)
    errorFlag=true;
else
    errorFlag=false;
end

k=k/norm(k);
j=cross(k,i);

% rotation matrix from ellipse frame to base frame
R=[i,j,k];
% calculate a,b minimum,maximum radious of the ellipse
x=u'*i; % x coordinate of the starting point of the ellipse in the ellipse frame
y=u'*j; % y coordinate of the starting point of the ellipse in the ellipse frame
a=(x*x+y*y/(ratio*ratio))^0.5;
b=ratio*a;
% calculate theta0, begining angle of the ellipse
theta0=atan2(y,x);

end


function y=colVec(x)
    if size(x,2)==1
        y=x;
    else
        y=x';
    end
end

function [ thetaVec,sVec ] = getEllipseLengthVector( a,b, theta0,theta1 )
%% About:
% This function is used to return the length of the ellipse as a function
% of the angle theta.

%% Inputs:
% theta0, theta1: start/end angle of the arc of the ellipse (from the parametric equation of the ellipse)
% a,b: the big and the small radious of the ellipse.

thetaSpan = [theta0 theta1];
s0 = 0;
opts = odeset('RelTol',1e-2,'AbsTol',1e-4);
[thetaVec,sVec] = ode45(@(theta,s) ((a*a*sin(theta)*sin(theta)+b*b*cos(theta)*cos(theta))^0.5), thetaSpan, s0,opts);

end

function [ vec ] = ellipseParametricFunction( a,b,theta )
%% About:
% Calculate the X and Y coordinates of the ellipse point corrsponding to
% angle (theta) from the parametric equation

%% inputs:
% theta: angle of point on the ellipse (from the parametric equation of the ellipse)
% a,b: the big and the small radious of the ellipse

%% Return value:
% The return value is a column vector, vec=[x;y;0] where:
% x: the x coordiante of the point on the ellipse correspodning to angle
% (theta) as described in the frame of the ellipse
% y: the y coordiante of the point on the ellipse  correspodning to angle
% (theta) as described in the frame of the ellipse

x=a*cos(theta);
y=b*sin(theta);
vec=[x;y;0];

end

function [t0,t1,t2]=calculateInterpolationTimes(L,v,a)
%% About:
% calculates the times of the acceleration, stable motion, deceleration

%% Arreguments:
% L: length of the curve (mm).
% v: linear velocity of eef on the the curve (mm/sec).
% a: linear acceleration of eef on the the curve (mm/sec2).

%% Return values:
% t0; time for acceleration.
% t1: time for acceleration, constant velocity.
% t2: time for acceleration, constant velocity and for deceleration

taw=v/a;

if(L>a*taw*taw)
    t0=taw;
    deltat=(L-a*taw*taw)/v;
    t1=t0+deltat;
    t2=t1+taw;
else
    taw1=(L/a)^0.5;
    t0=taw1;
    t1=taw1;
    t2=2*taw1;
end

end