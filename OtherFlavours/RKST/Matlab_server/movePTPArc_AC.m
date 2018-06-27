function [ state ] =movePTPArc_AC(t,theta,c,k,relVel)
%% This function is used for moving the endeffector on an arc, for the KUKA iiwa 7 R 800.

%% Syntax
% [ state ] =movePTPArc(t,theta,c,k,vel)

%% About:
% This function is used to move the end-effector on an arc,

%% Arreguments:
% t: is the TCP/IP connection
% theta: is the arc angle, in radians.
% c: the x,y,z coordinates of the center of the circle, it is 1x3 vector.
% k: is the normal vector on the plane of the arc, it is 1x3
% vector.
% vel : is a double, defines the motion velocity mm/sec.

% Copyright, Mohammad SAFEEA, 9th of May 2017

c=colVec(c);
k=colVec(k);

 pos=getEEFPos( t );
 p1=[pos{1};pos{2};pos{3}];
 p1=colVec(p1);
 
 r=norm(p1-c);
 
 if(or(r==0,theta==0))
     return;
 end
 normK=norm(k);
 if(normK==0)
     fprintf('Norm of direction vector k shall not be zero \n');
     return;
 end
 k=k/normK;
 
 s=(p1-c)/r;
 n=cross(k,s);
 
 c1=r*cos(theta/2)*s+r*sin(theta/2)*n+c;
 c2=r*cos(theta)*s+r*sin(theta)*n+c;
 
 f1=pos;
 i=1;
  f1{i}=c1(i);
 i=i+1;
  f1{i}=c1(i);
 i=i+1;
  f1{i}=c1(i);

 
 
 f2=pos;
 i=1;
  f2{i}=c2(i);
 i=i+1;
  f2{i}=c2(i);
 i=i+1;
  f2{i}=c2(i);



        state=movePTPCirc1OrintationInter( t , f1,f2, relVel);

    
    
    
end

function [ y ] = colVec( v)
% Convert a vector to a column vector:
    if(size(v,2)==1)
        y=v;
    else
        y=v';
    end
end

