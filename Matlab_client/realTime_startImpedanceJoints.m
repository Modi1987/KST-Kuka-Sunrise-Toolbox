%% About:
% This function is used to turn on the realtime control with impedance on the robot
% the realtime control is perfomred in joint space, i.e. controlling the
% robot at joint level.

%% Syntax:
% realTime_startImpedanceJoints(t,massOfTool,cOMx,cOMy,cOMz,...
%        cStiness,rStifness,nStifness)

%% Arreguments:
% t: TCP/IP connection 
% massOfTool: The weight of the tool attached to the flange (kg)
% cOMx: X poistion of the center of mass of the tool in the flange
%                              reference frame (mm)
% cOMy: Y poistion of the center of mass of the tool in the flange
%                              reference frame (mm)
% cOMz: Z poistion of the center of mass of the tool in the flange
%                              reference frame (mm)
% cStiness: Cartezian (linear) stifness in the range of [0 to 4000]
% rStiness: Cartezian (angular) stifness in the range of [0 to 300]
% nStifness: nulls pace stifness

% Copy right, Mohammad SAFEEA, 8th of Nov 2017
