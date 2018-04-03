% Copyright Mohammad SAFEEA, 17th-Aug-2017
function [figureHandle,anglesTextHandlesCellArray,labelTextHandlesCellArray]= constructInterface( )
% figureHandle=figure;

% boundaries=[0 1 1 0 0;
%     0 0 1 1 0];
% 
% plot(boundaries(1,:),boundaries(2,:));
% 
% xlim([0 1]);
% ylim([0 1]);

% axis off;

    % Create a figure and axes
    %f = figure('Visible','off');
    figureHandle= figure()
    ax = axes('Units','pixels');
    axis off;
    
%    % Create slider
%     sld = uicontrol('Style', 'slider',...
%         'Min',1,'Max',50,'Value',41,...
%         'Position', [400 20 120 20],...
%         'Callback', @surfzlim); 
% 					
%     % Add a text uicontrol to label the slider.
%             txt = uicontrol('Style','text',...
%         'Position',[400 45 120 20],...
%         'String','Vertical Exaggeration');
    
global startHeightForGamepadKstInterface;
startHeightForGamepadKstInterface=20;
     
       labelTextHandlesCellArray= addLabels()
        jPos={0,0,0,0,0,0,0};
        anglesTextHandlesCellArray=addJointPosTexts(jPos);
        addUnitTexts();
        addExplanationText();
        

%         img=imread('nplay gx102 small.jpg');
%         img=imresize(img,[100 150]);
%         imshow(img);
scale=[.5 .3]/1.25;
    axes('pos',[.6 .7 scale])
    imshow('nplay gx102 small.jpg')

end

function handles=addLabels()
global startHeightForGamepadKstInterface;
pos=[100 startHeightForGamepadKstInterface 120 16];
step=-40;


    for i=1:7
        textString=['axis  ' ,num2str(8-i)];
    handles{8-i} = uicontrol('Style','text',...
        'Position',pos,...
        'String',textString);
    pos(2)=pos(2)-step;
    end
    
end


function handles=addJointPosTexts(jPos)
global startHeightForGamepadKstInterface;
pos=[265 startHeightForGamepadKstInterface 120 16];
step=-40;


    for i=1:7
        textString=[num2str(jPos{8-i})];
    handles{8-i} = uicontrol('Style','text',...
        'Position',pos,...
        'String',textString,'BackgroundColor',[0.8 0.4 0.4]);
    pos(2)=pos(2)-step;
    end
    
end


function handles=addUnitTexts()
global startHeightForGamepadKstInterface;
pos=[410 startHeightForGamepadKstInterface 50 16];
step=-40;


    for i=1:7
    handles{8-i} = uicontrol('Style','text',...
        'Position',pos,...
        'String','degree','BackgroundColor',[0.4 0.4 0.8]);
    pos(2)=pos(2)-step;
    end
    
end

function addExplanationText()

message = sprintf...
('\n This is an example of integrating the KST, \n With the gamepad to control the KUKA iiwa robot, \n Use up/down of left analog stick to change axes, \n Use right/left of right analog stick to move the axes');
pos=[10 320 300 78];

% pos=[410 75 50 16];
 uicontrol('Style','text',...
        'Position',pos,...
        'String',message,'BackgroundColor',[1 0.4 0.4]);

    
end