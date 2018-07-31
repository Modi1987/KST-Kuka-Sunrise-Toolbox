function interface_handguiding_home(main_frame_h)
%% About:
% Construct the interface for the main buttons.

%% Areguments:
% main_frame_h: handle of the main frame.

% Copyright: Mohammad SAFEEA, 10th-July-2018

btn_width=100;
btn_height=100;
btn_margin_x=20;
btn_margin_y=20;
%% Home, precise, kuka hand guiding and virtual teachPendant buttons
    btn = uicontrol(main_frame_h,'Style', 'pushbutton', 'String', 'Home',...
            'Units','pixels',...
            'tag', 'btn_home',...
            'Callback', 'fcnCallback_Home');
    btn.Position= [btn_margin_x btn_margin_y btn_width btn_height];
    % Precise HG button
    btn = uicontrol(main_frame_h,'Style', 'pushbutton', 'String', 'Precise HG',...
            'Units','pixels',...
            'tag','btn_preciseHG',...
            'Callback', 'fcnCallback_StartPreciseHandGuiding');
    x0=btn_margin_x+btn_width+btn_margin_x;
    y0=btn_margin_y+btn_height+btn_margin_y;
    btn.Position= [x0 y0 btn_width btn_height];
    % KUKA HG button
    btn = uicontrol(main_frame_h,'Style', 'pushbutton', 'String', 'KUKA HG',...
            'Units','pixels',...
            'tag', 'btn_handGuiding',...
            'Callback', 'fcnCallback_StartHandGuiding');
	x0=btn_margin_x;
    y0=btn_margin_y+btn_height+btn_margin_y;
    btn.Position= [x0 y0 btn_width btn_height];
    % Virtual teach pendant
    btn = uicontrol(main_frame_h,'Style', 'pushbutton', 'String', 'teach Pendant',...
            'Units','pixels',...
            'tag', 'btn_virtualTeachPendant',...
            'Callback', 'fcnCallback_virtualTeachPendant');
	x0=btn_margin_x+btn_width+btn_margin_x;
    y0=btn_margin_y;
    btn.Position= [x0 y0 btn_width btn_height];
    %% add icons to buttons
    fcn_add_icons_to_buttons();
end