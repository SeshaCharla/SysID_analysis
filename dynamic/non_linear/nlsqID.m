%% Main Code
clear; close all; clc;
addpath("libs\");
%% Getting the data
dirs = get_dir;
[fs, Vin] = expt_details();
fl = 30;
[ch, sq] = get_data(get_dir(), fl, fs);     % Get the data
C_D = get_staticID_parms().C_D;
M_f = get_staticID_parms().M_f;
%% Using Chirp data to identify parameters
% theta = [J, (J f_s - b_m), \delta v, V_{in} b_m, V_{in}^2 (1 + \delta v)]
% b = C_D
% A = [-f_s \omega[k+1] & \omega[k] & -M_f & u_\omega[k] & C_D u_\omega[k]^2]
b = C_D * ch.omega(1:end-1).^2;
A1 = -fs*ch.omega(2:end);
A2 = ch.omega(1:end-1);
A3 = -M_f*ones(size(ch.omega(1:end-1)));
A4 = ch.uw(1:end-1);
A5 = C_D * ch.uw(1:end-1).^2;
A = [A1, A2, A3, A4, A5];
lb = [0,-Inf,-1, 0, 0];
ub = [Inf, Inf, 1, Inf, Inf];
%x = lsqlin(C,d,A,b,Aeq,beq,lb,ub)
sol = lsqlin(A, b, [], [], [], [], [], []);
%%