function z_callBack_virtualTeachPendant_J7_plus()
%% Soft realtime joints control Joint X button callback
% Copyright: Mohammad SAFEEA, 27th-July-2018
global virtual_smartPad_w_joints_command;
disp('Moving J7 in positive direction');
virtual_smartPad_w_joints_command(7)=1;
end