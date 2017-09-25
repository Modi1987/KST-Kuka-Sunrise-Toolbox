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
    

     
       labelTextHandlesCellArray= addLabels()
        jPos={0,0,0,0,0,0,0};
        anglesTextHandlesCellArray=addJointPosTexts(jPos);
        
        

end

function handles=addLabels()

pos=[100 75 120 16];
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

pos=[275 75 120 16];
step=-40;


    for i=1:7
        textString=[num2str(jPos{8-i})];
    handles{8-i} = uicontrol('Style','text',...
        'Position',pos,...
        'String',textString);
    pos(2)=pos(2)-step;
    end
    
end
