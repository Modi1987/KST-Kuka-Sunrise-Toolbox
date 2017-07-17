%% Example
% This script is used to initialize the hand guiding functionality on KUKA
% robot remotely

% Mohammad SAFEEA, 9th of June 2017

% TO use this example:
% 1- Start the server on KUKA
% 2- Start the client on Matlab
% 3- Press the white button and hand guide the robot
% 4- To save the coordinates of the robot, long click on the green button
% 5- Repeat three times
% 6- The robot gives you an interval of five seconds, clear the area around
% the robot directly, the robot will reproduce the motion tought.

fprintf('Connecting to server')

ip='172.31.1.147'; % The IP of the controller
% start a connection with the server
t=net_establishConnection( ip );

if ~exist('t','var') || isempty(t)
  warning('Connection could not be establised, script aborted');
  return;
else

   
startHandGuiding( t )

p1 = getJointsPos( t );
      
startHandGuiding( t )           
 
p2 = getJointsPos( t );

startHandGuiding( t )           
 
p3 = getJointsPos( t );

startHandGuiding( t )           
 

fprintf('CLear the area round the robot, the robot is going to move');

pause(5)


relVel=0.1;
movePTPJointSpace( t , p1, relVel)
movePTPJointSpace( t , p2, relVel)
movePTPJointSpace( t , p3, relVel)




      %% turn off the server
       net_turnOffServer( t );


       fclose(t);
end

