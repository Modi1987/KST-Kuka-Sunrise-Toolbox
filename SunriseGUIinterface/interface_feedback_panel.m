function interface_feedback_panel(h, frame_width,frame_height,feedback_panel_width,...
    feedback_panel_height,feedback_panel_margin)
%% About:
% Construct the interface for the connection setup

%% Areguments:
% h: handle of the main frame
% frame_width: width of the main frame (pixels)
% frame_height: height of the main frame (pixels)

% Copyright: Mohammad SAFEEA, 10th-July-2018

global txt_torque_Handles;
global txt_jpos_Handles;
global txt_pos_Handles;
txt_torque_Handles=[];
txt_jpos_Handles=[];
txt_pos_Handles=[];

panel_Width=feedback_panel_width;
panel_height=feedback_panel_height;

margin=feedback_panel_margin;
x0=frame_width-panel_Width-margin;
y0=frame_height-margin-panel_height;

pnl_h = uipanel(h,'Title','Sensory feedback from robot',...
                'Units','pixels');
            %     'FontSize',12,...
            %    'BackgroundColor','white',...
pnl_h.Position=[x0 y0 panel_Width panel_height];

% number of labels
I=8;
J=5;
% separation ratio
r=0.5;
labels_width=panel_Width/(J+(J+1)*r);
labels_height=panel_height/(I+(I+1)*r);

texts={'Joint','M.Torques','Jpos','EEF','Pos';
    'J1','','','X','';
    'J2','','','Y','';
    'J3','','','Z','';
    'J4','','','alfa','';
    'J5','','','beta','';
    'J6','','','gama','';
    'J7','','','',''};
handles_Array=[];
for i=1:I
    for j=1:J
        labels_text=texts{i,j};
%         lbl_handle=uicontrol(pnl_h,'Style','axes',...
%     'Units','pixels',...
%     'String',labels_text);
%     lbl_handle=axes('Parent',pnl_h,...
%                  'Units','pixels',...
%                  'String',labels_text);
	lbl_handle= uicontrol(pnl_h,'Style', 'pushbutton', 'String', labels_text,...
            'Units','pixels');
    x0=panel_Width-(labels_width*(1+r))*(J+1-j);
    y0=panel_height-(labels_height*(1+r))*(i)-0.5*r*labels_height;
    lbl_handle.HorizontalAlignment='center';
    lbl_handle.Position=[x0 y0 labels_width labels_height];
    lbl_handle.Enable='inactive';
    handles_Array{i,j}=lbl_handle;
    end
end

for i=1:7
    txt_torque_Handles{i}=handles_Array{i+1,2};
    txt_jpos_Handles{i}=handles_Array{i+1,3};
end

for i=1:6
    txt_pos_Handles{i}=handles_Array{i+1,5};
end
end