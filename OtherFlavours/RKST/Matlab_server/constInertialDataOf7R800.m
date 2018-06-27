function i=constInertialDataOf7R800()
%% This function returns a structure 
% representing the inertial data of the KUKA iiwa 7R800, those data are
% as listed in the article, 

%     [1]
%     @article{hayatdynamic,
%       title={Dynamic Identification of Manipulator: Comparison between CAD and Actual Parameters},
%       author={Hayat, Abdullah Aamir and Abhishek, Vishal and Saha, Subir K}
%     }

% This article approximated the ienrtial data based on the cad model
% obtained from:
% [2] KUKARobotics. http://www.kuka-robotics.com/usa/en/downloads/ (last accessed
% 20-07-2015).

% And based on the type of materials used to constrcut the robot taken from:
% [3] KUKA-SUNRISE-Workbench Manual. Germany: KUKA Roboter GmBH, 2015.

% To gain an insight about the error using this approximation please
% consult [1]

%% Masses and positions of center of masses
i.m=[3.4525,3.4821,4.05623,3.4822,2.1633,2.3466,3.129];
i.pcii=[    0               ,-0.03441   ,-0.02      ,0.0               ,0.0    ,0.000001,  0.0000237;
              0.06949     ,0               ,-0.089     ,-0.034412   ,0.14   ,0.000485,0.063866;
              -0.03423     ,0.06733 ,-0.02906   ,0.067329    ,-0.02137   ,0.002115,0.01464];
%% Inertial matrices of the links
I=zeros(3,3,7);
j=1;
I(:,:,j)=getInertialMatrix(0.02183,0.007703,0.02083,-1.1785E-08,-0.003887,-8.01381E-09);
j=1;
I(:,:,j)=getInertialMatrix(0.007703,0.02179,0.00779,-4.1482E-08,-4.7255E-08,-0.003626);
j=1;
I(:,:,j)=getInertialMatrix(0.03204,0.00972,0.03042,-1.6251E-08,0.006227,4.9393E-08);
j=1;
I(:,:,j)=getInertialMatrix(0.02178,0.02075,0.007785,8.3438E-08,-0.003625,5.6097E-08);
j=1;
I(:,:,j)=getInertialMatrix(0.01287,0.005708,0.01112,4.6669E-08,-0.003946,6.2225E-08);
j=1;
I(:,:,j)=getInertialMatrix(0.006509,0.006259,0.004527,2.6398E-08,0.00031891,7.07101E-09);
j=1;
I(:,:,j)=getInertialMatrix(0.01464,0.01465,0.002872,0.0005912,1.35593E-05,-2.55604E-06);
i.I=I;

% Viscous friction
i.Fiv=zeros(7,1);
% Static friction
i.Fis=zeros(7,1);
end

function I=getInertialMatrix(ixx,iyy,izz,ixy,iyz,ixz)
I=[ixx,ixy,ixz;
     ixy,iyy,iyz;
     ixz,iyz,izz];

end