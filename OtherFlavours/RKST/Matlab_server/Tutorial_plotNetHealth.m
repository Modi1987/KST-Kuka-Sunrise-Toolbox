%% Example
% used to test the timing characteristic of the connection between IIWA and PC

% First run the following script in Matlab
% Then start the client on the KUKA iiwa controller

% Mohammad SAFEEA, 24th of April 2018

close all,clear all;clc;


ip='172.31.1.147'; % The IP of the controller
% start a connection with the server
global t_Kuka;
t_Kuka=net_establishConnection( ip );

if ~exist('t_Kuka','var') || isempty(t_Kuka) || strcmp(t_Kuka.Status,'closed')
  disp('Connection could not be establised, script aborted');
  return;
else
    disp('Connection established')
end
pause(1);
disp('This will take up a minute or so to finish, please wait')

[time_stamps,time_delay]=net_updateDelay(t_Kuka);

net_turnOffServer( t_Kuka );
    
    