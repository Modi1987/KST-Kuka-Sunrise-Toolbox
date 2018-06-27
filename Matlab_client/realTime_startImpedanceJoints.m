function [ ret ] = realTime_startImpedanceJoints(t,weightOfTool,cOMx,cOMy,cOMz,...
        cStiness,rStifness,nStifness)
%% realTime_startImpedanceJoints 
% This function is used to turn on the realtime control with impedance on the robot
% This function is for realtime control in joint space, i.e. controlling the
% robot at joint level.

%% Syntax:
% realTime_startImpedanceJoints(t,weightOfTool,cOMx,cOMy,cOMz,...
%        cStiness,rStifness,nStifness)

%% Arreguments:
% t: TCP/IP connection 
% weightOfTool: The weight of the tool attached to the flange
% cOMx: X poistion of the center of mass of the tool in the flange
%                              reference frame
% cOMy: Y poistion of the center of mass of the tool in the flange
%                              reference frame
% cOMz: Z poistion of the center of mass of the tool in the flange
%                              reference frame
% cStiness: Cartezian (linear) stifness in the range of [0 to 4000]
% rStiness: Cartezian (anguar) stifness in the range of [0 to 300]
% nStifness: nulls pace stifness

% Copy right, Mohammad SAFEEA, 8th of Nov 2017

theCommand='startSmartImpedneceJoints';

theCommand=[theCommand,'_',num2str(weightOfTool)];
theCommand=[theCommand,'_',num2str(cOMx)];
theCommand=[theCommand,'_',num2str(cOMy)];
theCommand=[theCommand,'_',num2str(cOMz)];
theCommand=[theCommand,'_',num2str(cStiness)];
theCommand=[theCommand,'_',num2str(rStifness)];
theCommand=[theCommand,'_',num2str(nStifness)];
theCommand=[theCommand,'_'];

disp(theCommand)

fprintf(t, theCommand);
message=fgets(t);

[ret]=checkAcknowledgment(message);

if ret==true
        disp('Acknowledge, realtime control with impedance turned on');   
end
delay(0.1); % introduce some time delay, so the robot turns on the direct servo before starting the motion
end

