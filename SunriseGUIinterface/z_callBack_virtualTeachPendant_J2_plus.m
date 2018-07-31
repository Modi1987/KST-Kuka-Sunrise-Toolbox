function z_callBack_virtualTeachPendant_J2_plus()
%% Soft realtime joints control Joint X button callback
% Copyright: Mohammad SAFEEA, 27th-July-2018
global virtual_smartPad_w_joints_command;
disp('Moving J2 in positive direction');
virtual_smartPad_w_joints_command(2)=1;
end