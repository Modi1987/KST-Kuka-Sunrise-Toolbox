%% Example of using KST class for interfacing with KUKA iiwa robots
% This script is used to test the timing characteristic of the connection
% between IIWA and PC.

% First start the server on the KUKA iiwa controller
% Then run this script using Matlab

% The script plots the timing delays in comunication during the test

% This example works with Sunrise application version KST_1.7  and higher.
% Copyright: Mohammad SAFEEA, 25th of June 2018

close all;clear;clc;
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
disp('This will take up a minute or so to finish, please wait')

%% Plot timing data
[time_stamps,time_delay]=iiwa.net_updateDelay();

%% Turn off server
iiwa.net_turnOffServer();
    
    