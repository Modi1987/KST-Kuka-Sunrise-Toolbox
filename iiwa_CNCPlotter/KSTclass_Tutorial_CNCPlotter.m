%% Example
% Using iiwa as a plotter, the user can mount:
% 1- A pen, in such a case the robot is going to draw
% 2- A laser, in such a case the robot is going to cut the object

% This script utilizes the real time control of the KST
% where the iiwa7R800 is specified, if you have iiwa14R820 uncomment the 
% code-line:
% 

% Note that for acheiving a precise drawing do the following steps:
% A- On the Sunrise Code of the KST project:
%         1- Open the file (MatlabToolboxServer.java)
%         2- Locate the function:
%             double getTheDisplacment(double dj)
%             {
%                 double   a=0.07; 
%                 double b=a*0.75; 
%                 double exponenet=-Math.pow(dj/b, 2);
%                 return Math.signum(dj)*a*(1-Math.exp(exponenet));
% 
%             }
%         3- Change it into
%             double getTheDisplacment(double dj)
%             {
%                 return dj;
%             }
% B- Check the pdf file in the folder (Tips and tricks) of the github repo,
% and reconfigure your PC according to the recomendations of the file.
% C- Use a PC with good specifications. The PC used for running this script
% is Corei7-6850k processor @3.6GHZ with  32 G RAM.

% After performing the previous steps, synchronise the Sunrise project of
% the KST into the controller.
% Then start the MatlabToolboxServer application on the KUKA iiwa controller
% Then run this script using Matlab

% Copyright: Mohammad SAFEEA, 26th of April 2018

close all,clear all;clc;
%% Add KST to Matlab path
kst_Path=getTheKSTDirectory(pwd);
addpath(kst_Path);

warning('off')


%% Create the robot object
ip='172.31.1.147'; % The IP of the controller
arg1=KST.LBR7R800; % choose the robot iiwa7R800 
% arg1=KST.LBR14R820; % un comment this line if you have iiwa14R820
arg2=KST.Medien_Flansch_Touch_pneumatisch; % choose the type of flange
Tef_flange=eye(4); % transofrm matrix of EEF with respect to flange
Tef_flange(3,4)=0.293; % length of the tep of the pen from the surface of the flange
iiwa=KST(ip,arg1,arg2,Tef_flange); % create the object

%% Start a connection with the server
flag=iiwa.net_establishConnection();
if flag==0
  disp('Error unable to connected to the controller');
  return;
else
  disp('Successfully connected to the controller');
end
pause(0.5);

%% Go to an initial configuration
jPos={0,0,0,-pi/2,0,pi/2,0};
relVel=0.15;
iiwa.movePTPJointSpace(jPos, relVel); % move to initial configuration
%% Get Cartesian position of EEF (homing position)
fprintf('Current cartesian position:')
eefpos=iiwa.getEEFPos();
X=eefpos{1};
Y=eefpos{2};
Z=eefpos{3};
eefposDist=eefpos;
disp(eefpos);
%% Motion parameters
deltaZ=5; % Small clearance from the plotting-surface (mm)
z_sheet= 81.2; % the Z coordinates of the plotting-surface (mm)
zUp=z_sheet+deltaZ;
vFast=25/1000; % fast motion velocity, m/sec
vSlow=20/1000; % slow motion velocity, m/sec
%% Read the Cad file
fileName='kst.plt'; % this is the name of the cad file, 
% in case you have the cad file in another folder the user can use the
% total path of the file, the file shall be in plt format
[plotFlag,corArray]=loadPltFileFun(fileName); % load the file
%% Move robot down to a posiiton close to the sheet
% fast motion
eefposDist{1}=corArray(1,1)+X;
eefposDist{2}=corArray(2,1)+Y;
eefposDist{3}=zUp;
iiwa.movePTPLineEEF(eefposDist, 100);
%% Start direct servo in Joint space       
% get joints angles of robot
jPos  = iiwa.getJointsPos();
% calculate current position of flange point of the robot
qs=zeros(7,1);
for i=1:7
    qs(i)=jPos{i};
end

TefTool=eye(4);
[T0,~]=iiwa.directKinematics(qs); % Transformation matrix at the tip of the pin (TCP)
x=T0(1,4);
y=T0(2,4);

zUp1=T0(3,4);
zDown1=T0(3,4)-deltaZ/1000;

Tt=T0;
n=max(size(corArray));
%% scale and displace the drawing in the plane
scaleX=5;
scaleY=10;
dispY=-1.7;
dispX=-0.22;
corArray(1,:)=corArray(1,:)*scaleX+dispX;
corArray(2,:)=corArray(2,:)*scaleY+dispY;

for i=1:n
    corArray(1,i)=corArray(1,i)+x;
    corArray(2,i)=corArray(2,i)+y;
end
% start the direct servo
 iiwa.realTime_startDirectServoJoints();
disp('Starting direct servo joint space');
%% Start control loop
tic;
vz=0.003;
for i=1:n-1
    if(plotFlag(i)==0)
        [Tt,qs]=goDown(iiwa,qs,TefTool,vz,zDown1);
        v=vSlow;
    else
        [Tt,qs]=goUp(iiwa,qs,TefTool,vz,zUp1);
        v=vFast;
    end
    x0=x;
    x1=corArray(1,i);
    y0=y;
    y1=corArray(2,i);
    wattar=((x0-x1)*(x0-x1)+(y0-y1)*(y0-y1))^0.5;
    if wattar==0
        continue;
    end
    vx=v*(x1-x0)/wattar;
    vy=v*(y1-y0)/wattar;
    trajectoryTime0=toc;
    transmittionTime0=trajectoryTime0;
    motionFlag=1;
    while motionFlag
        deltaT=toc-trajectoryTime0;
        x=x0+vx*deltaT;
        y=y0+vy*deltaT;
        % 
        wattar1=((x0-x)*(x0-x)+(y0-y)*(y0-y))^0.5;
        if wattar1>wattar
            motionFlag=0;
        end
        if(toc-transmittionTime0)>0.003
            Tt(1,4)=x;
            Tt(2,4)=y;
            [ qs ] = iiwa.gen_InverseKinematics( qs, Tt, 10,0.1 );
            transmittionTime0=toc;
            for k=1:7
                jPos{k}=qs(k);
            end
            iiwa.sendJointsPositionsf(jPos);
        end

    end
end
[Tt,qs]=goUp(iiwa,qs,TefTool,vz,zUp1);
%% Turn off direct servo control
iiwa.realTime_stopDirectServoJoints();
%% Move robot back to home position
% fast motion
eefposDist{1}=X;
eefposDist{2}=Y;
eefposDist{3}=Z;
iiwa.movePTPLineEEF(eefposDist, 100);

iiwa.net_turnOffServer();
