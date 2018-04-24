function [time_stamps,time_delay]=net_updateDelay(t_Kuka)

%% ABout
% A function used to test the timing characteristic of the connection between IIWA and PC 

%% Syntax:
% [time_stamps,time_delay]=net_updateDelay(t_Kuka)

%% Arreguments
% t_Kuka: is the TCP/IP connection object

%% Return values:
% The function plots the timing data
% [time_stamps,time_delay]: the time stamp of each socket and the delay
% for each socket

% Copy right: Mohammad SAFEEA, 5th of April 2018

counter=0;
iterationsNum=5000;
time_delay=zeros(1,iterationsNum);
time_stamps=zeros(1,iterationsNum);

jPos=[];
for i=1:7
    jPos{i}=rand(1);
end

tic;
tstart=toc; % calculate initial time
while(counter<iterationsNum)
      counter=counter+1;
      t0=toc;
      sendJointsPositions( t_Kuka ,jPos);
      t1=toc;
      time_delay(counter)=t1-t0;
      time_stamps(counter)=t0-tstart;
end
tend=toc;
rate=counter/(tend-tstart);
%% Stop the direct servo motion
fprintf('\nThe rate of joint nagles update per second is: \n');
disp(rate);
fprintf('\n')
pause(2);
time_delay=time_delay*1000;
%% draw the timing data
plot(time_stamps,time_delay);
limVec=[time_stamps(1),time_stamps(end)];
xlim(limVec);
xlabel('Time (seconds)');
ylabel('Socket duration (milliseconds)')
end

