function [ qs ]=gen_InverseKinematics( qin, Tt, TefTool,n,lambda )
%% This is a DLS sovler of the inverse kinematics for the KUKA iiwa 7 R 800 robot with flange "Medien-Flansch Touch pneumatisch"
% If you have a different flange or if you are utilizing the iiwa 14 R 820 this funtion can also be used
% Please refer to instructions in the file "directKinematics.m" 
% and modify it accordingly in order to use this function with your own robot/flange configuration

% after modifying the file "directKinematics.m" the function "gen_InverseKinematics" can be used with your own robot.

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

 [ qs ] = kukaDLSSolver( qin, Tt, TefTool,n,lambda );
