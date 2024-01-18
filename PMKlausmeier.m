clear all
close all
tic

%General settings
NMPS=1024; %Number Mesh Points Space
NOT=1000; %Number of Outputs Time % This does NOT control the time step!
EndTime=100;
N=100;
L=250; %domain size
x=linspace(0,L,NMPS);
t=linspace(0,EndTime,NOT);
rng(1000); %Seed of random number generator: this way the run is reproducable

%Parameters
p=2;
l1=1;
l2=0.45;
C=182.5;
%C=182.5;
d1=500;
d2=1;

% --------------------------------------------------------------
%m corresponds to the symmetry of the problem
%m=0 (slab),1(cylinder),2(sphere)
m=0;

sol = pdepe(m,@(x,t,u,DuDx) pde(x,t,u,DuDx,p,d1,d2,l1,l2,C,L),ic(p,l1,l2,x,NMPS),@bc,x,t);
% remove the odeset thing, so that any version will work.
figure(1);
imagesc(sol(:,:,1))
%In Matlab, you manipulate the plot after the plotting command
ylabel('time');
xlabel('space');
title('component w')
colorbar
%hold off;
figure(2);
imagesc(sol(:,:,2))
ylabel('time');
xlabel('space');
title('component v')
colorbar
toc

%Below this line there are functions. Functions should always be at the
%bottom of a script

%Here the initial condition is set, pdepe requires the initial condition
%to be a function, hence the interpolation by interp1.
function [KlausmeierIC] = ic(p,l1,l2,x,NMPS)
    w=2*l2^2/(p+sqrt(p^2-4*l2^2));
    v=(p+sqrt(p^2-4*l2^2))/(2*l2);
    w=0.995*w.*(ones(1,NMPS)+rand(1,NMPS)/100);
    v=0.995*v.*(ones(1,NMPS)+rand(1,NMPS)/100);
    ICw=@(xi) interp1(x,w,xi);
    ICv=@(xi) interp1(x,v,xi);
    KlausmeierIC=@(y) [ICw(y); ICv(y)];
end

% --------------------------------------------------------------
%the PDE is of the form c*u_t = x^-m d/dx(x^m f)+ s
%where c, f, and s are functions of (x,t,u,du/dx)
%m corresponds to the symmetry of the problem
%m=0 (slab),1(cylinder),2(sphere)
function [c,f,s] = pde(x,t,u,DuDx,p,d1,d2,l1,l2,C,L)
c = [1;1];
f = [d1*DuDx(1)+C*u(1); d2*DuDx(2)];
s = [p-l1*u(1)-u(1)*u(2)^2; -l2*u(2)+u(1)*u(2)^2];
end %pde

% --------------------------------------------------------------
% the boundary condition is of the form:
% p(x,t,u) +q(x,t)f(x,t,u,du/dx)=0
% we have a left and a right boundary
% pl corresponds to p at the left, pr to p at the right
% ql ...........
% f is already specified in the pde function
% f is the flux density
% p is the precipitation
function [pl,ql,pr,qr] = bc(xl,ul,xr,ur,t)
    bcchoice=1;
    switch bcchoice
        case 0
            pl=[ul(1);ul(2)];
            ql=[0;0];
            pr=[ur(1);ur(2)];
            qr=[0;0];
        case 1
            pl=[0;0];
            ql=[1;1];
            pr=[0;0];
            qr=[1;1];
        otherwise
            disp('false value bcchoice');
    end
end %bc

