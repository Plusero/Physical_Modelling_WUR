L = 0.32;                    % length brass rod (m)
a_b = 3.420638058834975e-05;                     % thermal diffusivity (m2/s)
alpha_ba=2.05516442564545;
lambda_b=109; % W/m/K
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Information from measured data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load PM_case3_data           % measured data
dt = t(2)-t(1);              % time step measurement (s)

T0 = 21.6;                      % temperature (constant) at t = 0 s (�C)
TL = 40;                      % temperature (vector = function of time t) at x = 0 m (�C)
Tw = max(TL);                % temperature water (�C)

% plot measured data
figure(1)
plot(t,T)
xlabel('time {\it{t}} (s)')
ylabel('temperatures {\it{T}} (�C)')
title('measured data')
legend('0 cm','2 cm','4 cm','8 cm','16 cm','20 cm','30 cm','location','southeast')
V = axis; axis([0 max(t) floor(T0) ceil(max(max(T)))]);
shg

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dt = 1;                      % step size time (s)
dx = 0.02;                   % step size position (m)

tsim = [0:dt:t(end)]';       % vector time (s)
xsim = [0:dx:L];             % vector place (m)
Nx = length(xsim);           % length xsim
Nt = length(tsim);           % length tsim

h = a_b*dt/dx^2;             % dimensionless step
g=h*alpha_ba*dx/lambda_b;

% Cranck Nicolson, without b.c.
one = ones(Nx,1);
one_1 = ones(Nx-1,1);
ML = diag((1+h)*one,0)+diag((-1/2*h)*one_1,-1)+diag((-1/2*h)*one_1,1);
MR = diag((1-h)*one,0)+diag((1/2*h)*one_1,-1)+diag((1/2*h)*one_1,1);
B = zeros(Nx,1);

% Dirichlet boundary condition at x=0
ML(1,1) = 1;  
ML(1,2)=0;
MR(1,1) = 0;  
MR(1,2) = 0;
B(1,1)=Tw;

T_a=25;
% Neumann boundary condition at x=L
ML(Nx,Nx) = 1+h+g;  
ML(Nx,Nx-1) = -h; 
MR(Nx,Nx) = 1-h-g; 
MR(Nx,Nx-1) = h;
B(Nx,1)=2*g*T_a;

Tsim = T0*one;               % temperature at t = 0 s (�C)

% TLx = interp1(t,TL,tsim);    % resample
T_exp_avg=mean(T(:,1));

for i = 1:Nt-1
%    Tw = TLx(i);
   % count=1;
   % if mod(i,20)==0
   %      B(count)=T(count,1);
   %      count=count+1;
   % end
   B(1) = Tw;
   % B(1) = T_exp_avg;
   Tsim(:,i+1) = inv(ML)*(MR*Tsim(:,i)+B);
end
Tsim = Tsim';

                             % title for plots
tt = 'Cranck-Nicolson, b.c.({\it{x}}=0) = Dirichlet, b.c.({\it{x}}={\it{L}}) = Neumann';

tplot = [0 40 80 120];
for j = 1:length(tplot)      % find positions where tsim=[0 40 80 120] s
   tpos(j) = find(tplot(j)==tsim);
end
xplot = [0 0.02 0.04 0.08 0.16 0.2 0.3];
for j = 1:length(xplot)      % find positions where xsim=[0 0.02 0.04 0.08 0.12 0.16 0.2 0.3] m
   xpos(j) = find(xplot(j)==xsim);
end

                             % minimum and maximum temperature for plots
minT = floor(min([min(min(Tsim)) min(min(T))]));
maxT = ceil(max([max(max(Tsim)) max(max(T))]));

% temperature against time
figure(2)
plot(t,T,tsim,Tsim(:,xpos),'--')
xlabel('time {\it{t}} (s)'); ylabel('temperatures {\it{T}} (�C)')
legend('0 cm','2 cm','4 cm','8 cm','16 cm','20 cm','30 cm','0 cm CN','2 cm CN','4 cm CN','8 cm CN','16 cm CN','20 cm CN','30 cm CN','location','southeast')
title(tt)
% V = axis; axis([0 max(t) minT maxT]);
shg

% temperature against position
figure(3)
plot(xplot,T([1 3 5 7],:)',xsim(xpos),Tsim(tpos,xpos)','--')
xlabel('position {\it{x}} (m)'); ylabel('temperatures {\it{T}} (�C)')
legend('0 s','40 s','80 s','120 s','0 s CN','40 s CN','80 s CN','120 s CN','location','southeast')
title(tt)
V = axis; axis([0 max(xplot) minT maxT]);
shg

% 3D: temperature against position and time
figure(4)
mesh(xsim,tsim,Tsim)
xlabel('position {\it{x}} (m)'); ylabel('time {\it{t}} (s)'); zlabel('temperatures {\it{T}} (�C)')
title(tt)
view([45 30])
V = axis; axis([0 max(xsim) 0 max(tsim) minT maxT]);
shg