function Copy_of_virtualTeachPendant_main()
%% Main script of the Virtual teachPendant
% Copyright: Mohammad SAFEEA, 23-July-2018
global virtual_smartPad_ControlLoopeEnabled;
% Turn off the feedback
global read_state_var;
read_state_var=false;
% Create interface
virtualTeachPendant_Interface()
pause(1);
% Conrol loop
tic;
counter=0;
while virtual_smartPad_ControlLoopeEnabled
    pause(0.003);
    counter=counter+1;
end
k=toc;
disp('The rate of execution HZ')
disp(counter/k)
% Turn on the feedback
read_state_var=true;
end