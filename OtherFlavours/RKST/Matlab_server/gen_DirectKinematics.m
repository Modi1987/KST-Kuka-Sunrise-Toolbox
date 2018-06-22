function [eef_transform,J]=gen_DirectKinematics(q,TefTool)
% Calculates the direct kinematics of the KUKA iiwa 7 R 800 robot provided  with flange "Medien-Flansch Touch pneumatisch"
% If you have a different flange or if you are utilizing the iiwa 14 R 820 this funtion can also be used
% Please refer to instructions in the file "directKinematics.m" 
% and modify it accordingly in order to use this function with your own robot/flange configuration

% after modifying the file "directKinematics.m" the function "gen_DirectKinematics" can be used with your own robot.

% Arreguments:
% q: angles of the joints of the robot.
% TefTool: transfomr matrix from the tool frame to the flange frame of the
% robot.


% Return value:
% eef_transform: transfomration matrix from end-effector to tool
% J: jacobean at the tool center point (TCP) of the end-effector EEF.

% Copyright:
% Mohammad SAFEEA
% 16th-Aug-2017
% updated: 22nd-June-2018

[eef_transform,J]=directKinematics(q,TefTool);
