function [isValid,upDown,coord]=processLine(daLine, oldCoord)
%% Decode plt line
% Copyright: Mohammad SAFEEA, 7th-Nov-2018

isValid=0;
x=0;
y=0;
upDown=[];
coord=[];
% Process data
if(daLine(1)=='P')
    daLine(1)=[];
    if(daLine(1)=='U')
        daLine(1)=[];
        upDown=1;
        isValid=1;
    elseif(daLine(1)=='D')
        daLine(1)=[];
        upDown=0;
        isValid=1;
    else
        return;
    end
else
    return;
end

if daLine(1)==';'
    coord=oldCoord;
    return;
end

xStr='';
while isValid
    daChar=daLine(1);
    daLine(1)=[];
    if(daChar==',')
        x=str2double(xStr);
        break;
    else
        xStr=[xStr,daChar];
    end
end

yStr='';
while isValid
    daChar=daLine(1);
    daLine(1)=[];
    if(daChar==';')
        y=str2double(yStr);
        break;
    else
        yStr=[yStr,daChar];
    end
end
coord=[x;
    y];
end
