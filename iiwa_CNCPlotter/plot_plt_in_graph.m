%% Copyright, Mohammad Safeea, 7th-Nov-2018
% Use this script to plot a PLT file in a MATLAB graph
% This script is used to verify the file before executing it on the robot

close all;clear all;clc;

fileName='kst.plt';
[plotFlag,corArray]=loadPltFileFun(fileName); % load the file
n=max(max(size(corArray)));

scaleX=5;
scaleY=10;
dispY=-1.7;
dispX=-0.22;
corArray(1,:)=corArray(1,:)*scaleX+dispX;
corArray(2,:)=corArray(2,:)*scaleY+dispY;

figure();
line=[];
for i=2:n
    if plotFlag(i)==0
        line=[corArray(:,i-1),corArray(:,i)];
        plot(line(1,:),line(2,:),'r')
        hold on
    else
    end
end

xlabel('x')
ylabel('y')
