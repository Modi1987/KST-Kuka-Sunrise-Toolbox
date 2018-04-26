function [ torque ] = getExternalTorqueAtJoint( tKuka,k )
%% This function is used to get the external torque at some joint, for the KUKA iiwa robot.

%% Syntax:
% [ torque ] = getExternalTorqueAtJoint( tKuka,k )

%% About:
% This function is used to get external torque (due to external forces) at
% some joint of the robot.

%% Arreguments:
% tKuka: is the TCP/IP connection
% k: is joint index. A number from 1 to 7.
% torque: is the value of the torque measured at joint (k) due to external
% force/moment acting on the robot. Unit (Newton.meter)

% Copyright, Mohammad SAFEEA, 11th of May 2017

	if(k>7)
	    disp('Error KUKA has only 7 joints');
	    return;
	end

	if(k<1)
	disp('Error, joint number shall be more than zero and less than eight');
	    return;
	end
	    
	[ torques ] = getJointsExternalTorques( tKuka );
	torque=torques{k};
end


