function [R,theta0,a,b,c,errorFlag]=getEllipseParameters(p,c,ratio,dir)

%% About
% This function returns the parameters of the ellipse

%% Arreguments:
% p: the starting point of the ellipse
% c: the center of the ellipse
% ratio: the ratio (a/b) of the ellipse
% dir: direction of the 


%% Return values:
% R, the rotation matrix from the ellipse frame to the base frame of the
% robot
% theta0: the starting angle of the ellipse (given by the parametric equation of the ellipse)
% a,b: the big and the small radious of the ellipse
% c: is the center of the ellipse
% error flag: returns true if an error happens, this error is when the
% vector (p-c) is coinsident with the vector (dir).

% Mohammad SAFEEA 10-Nov-2017

p=colVec(p);
c=colVec(c);
dir=colVec(dir);

% X dirction vector
i=dir/norm(dir);

u=p-c;
% 
k=cross(u,i);
normk=norm(k);

if(normk==0)
    errorFlag=true;
else
    errorFlag=false;
end

k=k/norm(k);
j=cross(k,i);

% rotation matrix from ellipse frame to base frame
R=[i,j,k];
% calculate a,b minimum,maximum radious of the ellipse
x=u'*i; % x coordinate of the starting point of the ellipse in the ellipse frame
y=u'*j; % y coordinate of the starting point of the ellipse in the ellipse frame
a=(x*x+y*y/(ratio*ratio))^0.5;
b=ratio*a;
% calculate theta0, begining angle of the ellipse
theta0=atan2(y,x);

end


function y=colVec(x)
    if size(x,2)==1
        y=x;
    else
        y=x';
    end
end