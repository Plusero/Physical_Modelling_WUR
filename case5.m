% This script is written and read by pdetool and should NOT be edited.
% There are two recommended alternatives:
% 1) Export the required variables from pdetool and create a MATLAB script
%    to perform operations on these.
% 2) Define the problem completely using a MATLAB script. See
%    https://www.mathworks.com/help/pde/examples.html for examples
%    of this approach.
function pdemodel
[pde_fig,ax]=pdeinit;
pdetool('appl_cb',9);
pdetool('snapon','on');
set(ax,'DataAspectRatio',[3.2147544642857171 1 5.2466666666666688]);
set(ax,'PlotBoxAspectRatio',[1 0.58556548165518529 0.58556548165518529]);
set(ax,'XLim',[-0.094866071428571397 1.1305803571428577]);
set(ax,'YLim',[-0.17789072426937724 0.2033036848792884]);
set(ax,'XTickMode','auto');
set(ax,'YTickMode','auto');
pdetool('gridon','on');

% Geometry description:
pderect([0 1 0.10000000000000001 0],'R1');
set(findobj(get(pde_fig,'Children'),'Tag','PDEEval'),'String','R1')

% Boundary conditions:
pdetool('changemode',0)
pdesetbd(4,...
'dir',...
1,...
'1',...
'380')
pdesetbd(3,...
'neu',...
1,...
'0',...
'0')
pdesetbd(2,...
'dir',...
1,...
'1',...
'280')
pdesetbd(1,...
'neu',...
1,...
'0',...
'0')

% Mesh generation:
setappdata(pde_fig,'Hgrad',1.3);
setappdata(pde_fig,'refinemethod','regular');
setappdata(pde_fig,'jiggle',char('on','mean',''));
setappdata(pde_fig,'MesherVersion','preR2013a');
pdetool('initmesh')
pdetool('refine')
pdetool('refine')
pdetool('refine')

% PDE coefficients:
pdeseteq(2,...
'237',...
'0',...
'(1.00)+(0).*(25)',...
'(2700).*(880)',...
'0:10:1000',...
'280',...
'0.0',...
'[0 100]')
setappdata(pde_fig,'currparam',...
['2700';...
'880 ';...
'237 ';...
'1.00';...
'0   ';...
'25  '])

% Solve parameters:
setappdata(pde_fig,'solveparam',...
char('0','3840','10','pdeadworst',...
'0.5','longest','0','1E-4','','fixed','Inf'))

% Plotflags and user data strings:
setappdata(pde_fig,'plotflags',[1 1 1 1 1 1 10 1 0 0 1 101 1 0 0 0 0 1]);
setappdata(pde_fig,'colstring','');
setappdata(pde_fig,'arrowstring','');
setappdata(pde_fig,'deformstring','');
setappdata(pde_fig,'heightstring','');

% Solve PDE:
pdetool('solve')
