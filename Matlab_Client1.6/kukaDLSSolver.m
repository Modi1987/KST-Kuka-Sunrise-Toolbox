%% This is a DLS sovler of the inverse kinematics for the KUKA iiwa 7 R 800 robot.

% Syntax: 
%------------
% [ qs ] = kukaDLSSolver( qin, Tt, TefTool,n,llambda )

% Arreguments:
%-------------
% qin: the initial (current) configuration (joint angles in radians) of
% the robot.
% Tt: is the target transformation matrix position/orientation of the
% TefTool: is the transform matrix from the tool to the flange of the robot
% robot in Cartesian space 
% lambda: is the damping constant
% n: is the number of iterations

% Return value:
%-------------
% qs: the solution joint angles of the robot.


% Copyright:
% Mohammad SAFEEA
% 16th-Aug-2017