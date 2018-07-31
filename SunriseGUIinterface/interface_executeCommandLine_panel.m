% Buttons for moving the robot from insturcitons in Command Line
function interface_executeCommandLine_panel(h,xPos,yPos,executeCommandLine_panel_width,...
    executeCommandLine_panel_height)
%% About:
% Construct the interface-panel for motion buttons

%% Areguments:
% h: handle of the main frame
% frame_width: width of the main frame (pixels)
% frame_height: height of the main frame (pixels)

% Copyright: Mohammad SAFEEA, 10th-July-2018

panel_Width=executeCommandLine_panel_width;
panel_height=executeCommandLine_panel_height;

x0=xPos;
y0=yPos;

pnl_h = uipanel(h,'Title','Motion commands',...
                'Units','pixels');
            %     'FontSize',12,...
            %    'BackgroundColor','white',...
pnl_h.Position=[x0 y0 panel_Width panel_height];

% number of buttons
I=4;
J=1;
% separation ratio
rh=0.1;
rv=0.3;
labels_width=panel_Width/(J+(J+1)*rh);
labels_height=panel_height/(I+(I+1)*rv);

texts={'Play program';
    'Clear cmd';
    'Play Selected';
    'Clear Selected'};

callback_functions={'fcnCallback_cmd_PlayCommandLine';
    'fcnCallback_cmd_ClearCommandLine';
    'fcnCallback_cmd_PlaySelected_from_CommandLine';
    'fcnCallback_cmd_ClearSelected_from_CommandLine'};

handles_Array=[];
for i=1:I
    for j=1:J
        labels_text=texts{i,j};
        lbl_handle= uicontrol(pnl_h,'Style', 'pushbutton', 'String', labels_text,...
                'Units','pixels',...
                'Callback', callback_functions{i,j});
        x0=panel_Width-(labels_width*(1+rh))*(J+1-j);
        y0=panel_height-(labels_height*(1+rv))*(i)-0.5*rv*labels_height;
        lbl_handle.HorizontalAlignment='center';
        lbl_handle.Position=[x0 y0 labels_width labels_height];
    end
end

end