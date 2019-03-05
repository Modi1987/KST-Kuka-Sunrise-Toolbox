%% Example of using KST class for interfacing with KUKA iiwa robots

% Used to test switching between various operation modes.

% First start the server on the KUKA iiwa controller
% Then run this script using Matlab

% Tested under Matlab2013b, for higher versions, the realtime plot might
% not work.

% This example works with Sunrise application version KST_1.7  and higher.
% Copyright Mohammad SAFEEA, 1st-March-2019

% Operation modes:
% 1st impedance motion
% 2nd (PTP) move on lines
% 3rd (PT) move on circles
% 4th direct servo
% 5th impedance again
% 6th (PTP) move lines again
close all;clear;clc;
warning('off');
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
disp('Testing KST under various operation modes');
    
%% Move point to point to an initial position
jPos={0,0,0,-pi/2,0,pi/2,0};
relVel=0.15;
iiwa.movePTPJointSpace(jPos, relVel); % move to initial configuration

%% Pause for 3 seocnds
pause(3); 

%% 1st
disp('First test, real time impedance mode');
% Tool/Impedance parameters   
massOfTool=0.5; % the mass of the tool attached to flange in Kg
cOMx=0; % X coordinate of the center of mass of the tool in (mm)
cOMy=0; % Y coordinate of the center of mass of the tool in (mm)
cOMz=40; % Z coordinate of the center of mass of the tool in (mm)
cStiness=900; % cartizian stifness
rStifness=80; % rotational stifness
nStifness=50; % null space stifness

% Start the soft realtime control with impedance
iiwa.realTime_startImpedanceJoints(massOfTool,cOMx,cOMy,cOMz,...
cStiness,rStifness,nStifness);

w=0.6; % motion constants, frequency rad/sec
A=0.2; % motion constants, amplitude of motion

a=datevec(now);
t0=a(6)+a(5)*60+a(4)*60*60; % calculate initial time

dt=0;
tstart=t0;
counter=0;
duration=0.2*60; %0.2 minutes

% Control loop
% real time plot handles
 colors={'k','b','r','g','c','m','y'};
 figureHandle=figure('Units','inches','Position',[0 0 5 3.75]);
 numOfSamples=120; % number of samples to show in the plot
 timeVec=1:numOfSamples;
 tawVec=zeros(7,numOfSamples);
 plotHandle=[];
 for i=1:7
    plotHandle=[plotHandle,plot(timeVec,tawVec(i,:),colors{i},'LineWidth',2)];
    hold on;
 end
% format the plot
ylim([0,8]);
temp=title('External torques');
set(temp,'FontSize',16);
temp=xlabel('Time (seconds)');
set(temp,'FontSize',14);
temp=ylabel('Distance (m)');
set(temp,'FontSize',14);


while(dt<duration)
% perform trajectory calculation here
  a=datevec(now);
  time=a(6)+a(5)*60+a(4)*60*60;
  dt=time-t0;

  temp=A*(1-cos(w*dt));
    for dacount=1:7
        jPosCommand{dacount}=jPos{dacount}+temp;
    end
  counter=counter+1;
  % Send joint positions to robot
  taw=iiwa.sendJointsPositionsExTorque(jPosCommand);

  tawTemp=zeros(7,1);
  for i=1:7
      tawTemp(i)=taw{i};
      torque_array(i,counter)=taw{i};
  end
  % delete first measurment
  tawVec(:,1)=[];
  % add new measurment to end of arrays
  tawVec=[tawVec,tawTemp];
  % update plots data
  for i=1:6
    set(plotHandle(i),'YData',tawVec(i,:));
  end
  set(plotHandle(7),'YData',tawVec(i,:));
  % show plot data
  set(figureHandle,'Visible','on');

end


% Stop the realtime control with impedence motion
iiwa.realTime_stopImpedanceJoints();
fprintf('\n impedance motion stopped \n');
pause(2);



%% 2nd
disp('Second test, point to point motion mode, move on lines');
% move to initial position
pinit={0,pi*20/180,0,-pi*70/180,0,pi*90/180,0}; % initial confuguration
relVel=0.15; % relative velocity
iiwa.movePTPJointSpace(pinit, relVel); % point to point motion in joint space

% Get position orientation of end-effector
disp('Cartesian position')
Pos=iiwa.getEEFPos();
disp(Pos)

% Move the end-effector in the X direction
Vel=50; % velocity of the end effector, mm/sec
displacment=50;
index=1;

Pos{index}=Pos{index}+displacment;
iiwa.movePTPLineEEF(Pos, Vel)


pause(0.1)

Pos{index}=Pos{index}-displacment;
iiwa.movePTPLineEEF(Pos, Vel)

% Move the end-effector in the z direction
index=3;

Pos{index}=Pos{index}+displacment;
iiwa.movePTPLineEEF(Pos, Vel)

pause(0.1)

Pos{index}=Pos{index}-displacment;
iiwa.movePTPLineEEF(Pos, Vel);

% Move the end-effector to a distination frame, 

Pos={400,0,580,-pi,0,-pi}; % first configuration
% the coordinates are:
% x=400mm, y=0mm, z=580 mm.
% the rotation angles are:
% alpha=-180 degrees, beta=0 degrees, gama=-180 degrees
iiwa.movePTPLineEEF(Pos, Vel);

Pos={500,0,580,-pi,0,-pi+pi/4}; %% second configuration
% the coordinates are:
% x=400mm, y=0mm, z=580 mm.
% the rotation angles are:
% alpha=-180 degrees, beta=0 degrees, gama=-165 degrees, 
iiwa.movePTPLineEEF(Pos, Vel);

%% 3rd
disp('Third test, point to point motion mode, move on circles');
% move on cirlces
relVel=0.25; % override relative joint velocities

pos={0, -pi / 180 * 10, 0, -pi / 180 * 100, pi / 180 * 90,pi / 180 * 90, 0};   % initial cofiguration

iiwa.movePTPJointSpace( pos, relVel); % go to initial position
% Move in an arc, the orientation of EEF changes while performing the motion,
% The function utilized (movePTPCirc1OrintationInter)
% f2 is the final frame, at which the arc motion ends
% f1 is an intermidiate frame, through wich the robot passes while
% performing the motion.

f1=iiwa.getEEFPos();
f2=f1;
r=75; % radius of arc
f1{2}=f1{2}+r;
f1{3}=f1{3}-r;
f1{6}=f1{6}+pi/8;

f2{3}=f2{3}-2*r;
f2{6}=f2{6}+pi/2;

vel=150; % linear velocity of end-effector mm/sec
iiwa.movePTPCirc1OrintationInter( f1,f2, vel)

% Move robot in joint space to some initial configuration
pinit={0,pi*20/180,0,-pi*70/180,0,pi*90/180,0}; % joint angles of initial confuguration
relVel=0.15; % the relative velocity
iiwa.movePTPJointSpace(pinit, relVel); % point to point motion in joint space

% Move EEF -100 mm in Z direction
deltaX=0.0;deltaY=0;deltaZ=-100.; % relative displacemnets of end-effector
Pos{1}=deltaX;
Pos{2}=deltaY;
Pos{3}=deltaZ;
iiwa.movePTPLineEefRelBase(Pos, vel);

% Store the current position in the memory
Cen=iiwa.getEEFPos(); % Concider the current position as the center of the arcs

% Move EEF 50mm in X direction
deltaX=100;deltaY=0;deltaZ=0.;
Pos{1}=deltaX;
Pos{2}=deltaY;
Pos{3}=deltaZ;
iiwa.movePTPLineEefRelBase(Pos, vel);
% Store the current position in the memory
circle_Starting_Point=iiwa.getEEFPos(); % Consider the current point as circle starting point

% Move in an arc, the arc is drawn on an incliend plane
% using the function ((movePTPArc_AC))
theta=pi/2; % the angle subtended by the arc at the center ((c))
k=[1;1;1]; % normal vector of the plane, on which the circle is drawn
c=[Cen{1};Cen{2};Cen{3}]; % the center of the arc
vel=100; % the motion velocity mm/sec
iiwa.movePTPArc_AC(theta,c,k,vel)
      
% Go back to ((circle_Starting_Point)) coordinates
vel=150;
iiwa.movePTPLineEEF(circle_Starting_Point, vel);
% Move in an arc, the arc is drawn in XY plane
% using the function ((movePTPArcXY_AC))
theta=1.98*pi; % the angle subtended by the arc at the center ((c))
c=[Cen{1};Cen{2}]; % the XY coordinate of the center of the arc
vel=150; % the motion velocity mm/sec
iiwa.movePTPArcXY_AC(theta,c,vel)


%% 4th
disp('Fourth test, realtime motion using direct servo mode');
% Move to an intial position
jPos={0,0,0,-pi/2,0,pi/2,0};
relVel=0.15;
iiwa.movePTPJointSpace(jPos, relVel); % move to initial configuration

% Get Cartesian position of EEF
fprintf('Cartesian position')
eefpos=iiwa.getEEFPos();
eefposDist=eefpos;
disp(eefpos)

% Start direct servo in Cartesian space       
iiwa.realTime_startDirectServoCartesian();
disp('Starting direct servo in Cartesian space');
w=2; % motion constants, frequency rad/sec
A=75; % motion constants, amplitude of motion (mm)
tic;
deltaT=0;
counter=0;
initiationFlag=0;
disp('Entering control loop, streaming EEF positions')

% Control loop
while(deltaT<(6*pi/w))
if(initiationFlag==0)
    initiationFlag=1;
    t_0=toc;
    t0=t_0;
else
    time=toc;
    deltaT=time-t0;
    %........................................
    % Perform trajectory calculation here
    eefposDist{3}=eefpos{3}-A*(1-cos(w*deltaT));
    %........................................
    % Send EEF position to robot
    if(toc-t_0>0.003)
        counter=counter+1;
        iiwa.sendEEfPositionf(eefposDist);
        t_0=toc;
    end
end
end
tstart=t0;
tend=time;
rate=counter/(tend-tstart);
% Stop the direct servo motion
iiwa.realTime_stopDirectServoCartesian( );
fprintf('\nThe rate of update per second is: \n');
disp(rate);
fprintf('\n')
pause(2);

%% 5th
disp('Fifth test, realtime impedance motion mode, repeat procedure for 3 times');
for i=1:3
    massOfTool=0.5; % the mass of the tool attached to flange in Kg
    cOMx=0; % X coordinate of the center of mass of the tool in (mm)
    cOMy=0; % Y coordinate of the center of mass of the tool in (mm)
    cOMz=40; % Z coordinate of the center of mass of the tool in (mm)
    cStiness=900; % cartizian stifness
    rStifness=80; % rotational stifness
    nStifness=50; % null space stifness

    % Start the soft realtime control with impedance
    iiwa.realTime_startImpedanceJoints(massOfTool,cOMx,cOMy,cOMz,...
    cStiness,rStifness,nStifness);

    w=0.6; % motion constants, frequency rad/sec
    A=0.2; % motion constants, amplitude of motion

    a=datevec(now);
    t0=a(6)+a(5)*60+a(4)*60*60; % calculate initial time

    dt=0;
    tstart=t0;
    counter=0;
    duration=10; %10 seconds

    % Control loop
    while(dt<duration)
    % perform trajectory calculation here
      a=datevec(now);
      time=a(6)+a(5)*60+a(4)*60*60;
      dt=time-t0;

      temp=A*(1-cos(w*dt));
        for dacount=1:7
            jPosCommand{dacount}=jPos{dacount}+temp;
        end
      counter=counter+1;
      % Send joint positions to robot
      iiwa.sendJointsPositions(jPosCommand);
    end
    % Stop the realtime control with impedence motion
    iiwa.realTime_stopImpedanceJoints();
    fprintf('\n Impedance motion stopped \n');
    pause(2);
    
    daPos_temp=iiwa.getEEFPos();
end

%% 6th
disp('Sexth test, repeated from point to point motion mode, move on lines');
% move to initial position
pinit={0,pi*20/180,0,-pi*70/180,0,pi*90/180,0}; % initial confuguration
relVel=0.15; % relative velocity
iiwa.movePTPJointSpace(pinit, relVel); % point to point motion in joint space

% Get position orientation of end effector
disp('Cartesian position')
Pos=iiwa.getEEFPos();
disp(Pos)

% Move the end-effector in the X direction
Vel=50; % velocity of the end effector, mm/sec
displacment=50;
index=1;

Pos{index}=Pos{index}+displacment;
iiwa.movePTPLineEEF(Pos, Vel)


pause(0.1)

Pos{index}=Pos{index}-displacment;
iiwa.movePTPLineEEF(Pos, Vel)

% Move the end-effector in the z direction
index=3;

Pos{index}=Pos{index}+displacment;
iiwa.movePTPLineEEF(Pos, Vel)

pause(0.1)

Pos{index}=Pos{index}-displacment;
iiwa.movePTPLineEEF(Pos, Vel);

% Move the end-effector to a distination frame, 

Pos={400,0,580,-pi,0,-pi}; % first configuration
% the coordinates are:
% x=400mm, y=0mm, z=580 mm.
% the rotation angles are:
% alpha=-180 degrees, beta=0 degrees, gama=-180 degrees
iiwa.movePTPLineEEF(Pos, Vel);

Pos={500,0,580,-pi,0,-pi+pi/4}; %% second configuration
% the coordinates are:
% x=400mm, y=0mm, z=580 mm.
% the rotation angles are:
% alpha=-180 degrees, beta=0 degrees, gama=-165 degrees, 
iiwa.movePTPLineEEF(Pos, Vel);

%% Turn off the Sunrise.Workbench application
iiwa.net_turnOffServer