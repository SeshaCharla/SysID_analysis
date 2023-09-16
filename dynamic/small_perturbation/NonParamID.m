%% Main Code
clear; close all; clc;
addpath("libs\");
%% Getting the data
dirs = get_dir;
[fs, expt, N, input_period] = expt_details();
[u, omega] = get_data(dirs.sos, N, expt);               % Get the data
%% Creating perturbation data
fl = 30;
[del_u, del_omega, nom] = gen_perturb_data(u, omega, N, fl, fs);
%% Id_data
id_data = {};
for i = 1:N
    id_data{i} = iddata(del_omega{i}, del_u{i}, 1/fs, "Period", input_period);
end
%% Emperical Transfer function estimate
Gc = get_etfe(id_data, N);
plot_bode(Gc, N, nom, "BodePlot")
%% Estimates of transfer functions
tf_est = get_tfests(id_data, N);
pvec = {};
dpvec = {};
tr_funcs = {};
% removing the time delays
for i = 1:N
    [pvec{i}, dpvec{i}] = getpvec(tf_est{i});
    tr_funcs{i} = tf(pvec{i}(1), [1, pvec{i}(2)]);
end
plot_bode(tr_funcs, N, nom, "BodePlot_tfest");
%% Comparing the results using frequency domain
idf_data = gen_idfdata(Gc, fs, N);
sys_compare(idf_data, tr_funcs, N, nom, expt);
%% Comparing results using time domain chirp data
tl = 20;
fl = 25;
[u_c, omega_c] = get_data(dirs.chirp, N, expt);
for i = 1:N     % using only the limited lenght of the data
    u_c{i} = u_c{i}(1:tl*fs);
    omega_c{i} = omega_c{i}(1:tl*fs);
end
[del_u_c, del_omega_c, nom_c] = gen_perturb_data(u_c, omega_c, N, fl, fs);
% Id_data_c
idc_data = {};
for i = 1:N
    idc_data_tr = iddata(del_omega_c{i}, del_u_c{i}, 1/fs);
    idc_data{i} = detrend(idc_data_tr,1);
end
% Comparing the results in time domain
sys_compare(idc_data, tr_funcs, N, nom, expt);