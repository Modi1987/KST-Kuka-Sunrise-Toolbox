function [plotFlag,corArray]=loadPltFileFun(fileName)
%% load the plt file into arrays
% Copyright: Mohammad SAFEEA, 7th-Nov-2018

%% Areguments:
% fileName: is the name of the file, it shall be with PLT format

%% Return values:
% plotFlag: 1 for up, 0 for down.
% corArray: is an array of the coordinates, in meters.

fid = fopen(fileName);
x=fread(fid);
n=max(size(x));
corArray=[];
plotFlag=[];
line='';
oldCoord=[0;
    0];
for i=1:n
    daChar=char(x(i));
    line=[line,daChar];
    if daChar==';'
        [isValid,upDown,coord]=processLine(line,oldCoord);
        line='';
        if isValid==1
            oldCoord=coord;
            corArray=[corArray,coord];
            plotFlag=[plotFlag,upDown];
        end
    end
end
% plot(corArray(1,:),corArray(2,:))
corArray=corArray*25.4/1016; % convert coordinates to mm
corArray=corArray/1000; % convert coordinates to meter
fclose(fid)
end