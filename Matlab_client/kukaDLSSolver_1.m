%% A DLS sovler of the inverse kinematics for the KUKA iiwa 7 R 800 robot.

% Inputs:
%-------------
% qin: the initial (current) configuration (joint angles in radians) of
% the robot.
% Tt: is the target transformation matrix position/orientation of the
% TefTool: is the transform matrix from the tool to the flange of the robot
% robot in Cartesian space 
% lambda: is the dls constant
% n: is the number of iterations

% Outputs:
%-------------
% qs: the solution joint angles of the robot.
 
% Copyright: Mohamad SAFEEA, 23 - July - 2018