%% Example of using KST class for interfacing with KUKA iiwa robots

% soft real-time control of the KUKA robot with
% impedence
% Moving the joints of the robot using a sinusoidal function

% The external torques are plotted in real-time during the test
% the feedback from the measured torques can be used to for a closed loop
% control

% First start the server on the KUKA iiwa controller
% Then run this script using Matlab

% This code was tested using Matlab 2013b

% This example works with Sunrise application version KST_1.7  and higher.
% Copyright Mohammad SAFEEA, 26th-June-2018

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
    
%% Move point to point to an initial position
jPos={0,0,0,-pi/2,0,pi/2,0};
relVel=0.15;
iiwa.movePTPJointSpace(jPos, relVel); % move to initial configuration

%% Pause for 3 seocnds
pause(3); 

%% Tool/Impedance parameters   
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
duration=0.5*60; %0.5 minutes

%% Control loop
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
 %% perform trajectory calculation here
  a=datevec(now);
  time=a(6)+a(5)*60+a(4)*60*60;
  dt=time-t0;

  temp=A*(1-cos(w*dt));
    for dacount=1:7
        jPosCommand{dacount}=jPos{dacount}+temp;
    end
  counter=counter+1;
  %% Send joint positions to robot
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


%% Stop the realtime control with impedence motion
iiwa.realTime_stopImpedanceJoints();
fprintf('\n Motion stopped \n');
pause(2);

%% turn off the server
iiwa.net_turnOffServer();

warning('on')
