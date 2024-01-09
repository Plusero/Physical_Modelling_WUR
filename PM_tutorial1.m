% prepare workspace
clear all
close all
clc
format short

% pphysical parameters
tau_w=100;
tau_e=50;
Tw_inf=150;
Tw_inf_real=100;
Ta=20;

% numerical parameters
dt=60;
tend=600;
t=0:dt:tend;
method="Euler";
clip=0;

% analytical solution
Tw_analyt=Tw_inf+(Ta_Tw_inf)*exp(-t/tau_w);

imax=tend/dt;
T=zeros(size(t,2),2);

T(1,1)=Ta;
T(1,2)=Ta;

