%% An example of MATLAB GUI to control KUKA iiwa manipualtor using KST toolbox

%% To run the program:
% 1- Start the MatlabToolboxServer application from the teach pendant of
% the robot
% 2- Run the following script

% Copyright: Mohammad SAFEEA

% Add KST path to MATLAB
cDir = pwd;
cDir=getTheKSTDirectory(cDir);
addpath(cDir);

% Run the interface
a0_interface