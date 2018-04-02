%% This function is used to establish a connection with the server on KUKA
% function [ t ] = net_establishConnection( ip )
% This function is used to establish a connection with the server on KUKA.
% t: is a TCP/IP object, this object is empty when the connection could not be established.
% ip: a string variable, the IP of the robot, examble '172.31.1.147'
% from the teach pendant, click on 'Station' button, then the 'information'
% button, check your KUKA iiwa IP from that page.
% Copy right, Mohammad SAFEEA, 3rd of May 2017

