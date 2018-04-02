%% About:
% This function is used to start the handguiding functionality on the robot

%% Syntax:
% [ output_args ] = startPreciseHandGuiding( t,wightOfTool,COMofTool )

%% Arreguments:
% t: is the TCP/IP connection object
% wightOfTool: weight of the tool connected to the flange in newton, unit Newtons.
% COMofTool: coordinates of the center of mass of the tool, descirbed in
% the reference frame of the tool, unit meters.

%% Precise hand guiding functionality works with KST 1.1 and more
% i.e this functionality does not work with KST 1.0

% Copy right, Mohammad SAFEEA, 22nd of Oct 2017
