%% sendJointsPositionsf 
% [ output_args ] = sendJointsPositionsf( t ,jPos)
% This function is used to send the target positions of the joints for the
% direct servo motion
% jPos: is 7 cells array of doubles
% t: is the TCP/IP connection object

%% This function is for direct-servoing in joint space, (fast mode)
% This function is tested on ASUS labtob, with an Inel(R) core i7-5500U CPU 2.4GHz laptop,
% The operating system windows 10, 64bit
% Matlab R2013b was utilized
% under the aformentioned conditions the function allowed up to 4000 update of joint
% positions per second
% In theory this function allows a maximum numerical update accuracy of 
% joint angles in the reange ]-0.0001,+0.0001[ rads.

% Copy right, Mohammad SAFEEA, 15th of June 2017
