function i=constInertialDataOf14R820()
%% This function returns a structure 
% representing the inertial data of the KUKA iiwa 14R820, those data are
% as listed in the article:

%     @article{sturz2017parameter,
%       title={Parameter Identification of the KUKA LBR iiwa Robot Including Constraints on Physical Feasibility},
%       author={St{\"u}rz, Yvonne R and Affolter, Lukas M and Smith, Roy S},
%       journal={IFAC-PapersOnLine},
%       volume={50},
%       number={1},
%       pages={6863--6868},
%       year={2017},
%       publisher={Elsevier}
%     }

%% Masses and positions of center of masses
i.m=[3.9781,4.50275,2.4552,2.61155,3.41,3.38795,0.35432];
i.pcii= [-0.00351    ,-0.00767   ,-0.00225   ,0.0002        ,0.0005     ,0.00049    ,-0.03466;
            0.00016     ,0.16669    ,-0.03492   ,-0.05268     ,-0.00237  ,0.02019    ,-0.02324;
            -0.03139    ,-0.00355   ,-0.02652   ,0.03818      ,-0.21134  ,-0.0275     ,0.07138];
%% Inertial matrices of the links
I=zeros(3,3,7);
j=1;
I(:,:,j)=getInertialMatrix(0.00455,0,0,0.00454,0.00001,0.00029);
j=j+1;
I(:,:,j)=getInertialMatrix(0.00032,0.0,0.0,0.0001,0.0,0.00042);
j=j+1;
I(:,:,j)=getInertialMatrix(0.00223,-0.00005,0.00007,0.00219,0.00007,0.00073);
j=j+1;
I(:,:,j)=getInertialMatrix(0.03844,0.00088,-0.00112,0.01144,-0.00111,0.04988);
j=j+1;
I(:,:,j)=getInertialMatrix(0.00277,-0.00001,0.00001,0.00284,-0.0,0.00012);
j=j+1;
I(:,:,j)=getInertialMatrix(0.0005,-0.00005,-0.00003,0.00281,-0.00004,0.00232);
j=j+1;
I(:,:,j)=getInertialMatrix(0.00795,0.00022,-0.00029,0.01089,-0.00029,0.00294);
i.I=I;


% Viscous friction
i.Fiv=[0.24150,0.37328,0.11025,0.1,0.1,0.12484,0.1]';
% Static friction
i.Fis=[0.31909,0.18130,0.07302,0.17671,0.03463,0.13391,0.08710]';
end

function I=getInertialMatrix(ixx,ixy,ixz,iyy,iyz,izz)
I=[ixx,ixy,ixz;
     ixy,iyy,iyz;
     ixz,iyz,izz];

end