%% Example
% An example script, it is used to show how to use the different
% functions of the KUKA iiwa matlab toolbox
% First start the server on the KUKA iiwa controller
% Then run the following script in Matlab

% Mohammad SAFEEA, 3rd of May 2017

close all,clear all,clc
warning('off');
ip='172.31.1.147'; % The IP of the controller
% start a connection with the server
t_Kuka=net_establishConnection( ip );

if ~exist('t_Kuka','var') || isempty(t_Kuka) || strcmp(t_Kuka.Status,'closed')
  warning('Connection could not be establised, script aborted');
  return;
else
    
for theCOunt=1:2
kuka0_motions(t_Kuka)
end   
      %% turn off the server
        net_turnOffServer( t_Kuka );
    

       fclose(t_Kuka);
end
warning('on');



