% Calculates the direct kinematics of the KUKA iiwa 7 R 800 robot

% Syntax:
% [eef_transform,J]=directKinematics(q,TefTool)

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

