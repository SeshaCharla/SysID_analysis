%% Main Code
clear; close all; clc;
addpath("libs\");
%% Getting the data
dirs = get_dir;
[fs, expt, N, input_period] = expt_details();
[u, omega] = get_data(dirs.sos, N, expt);               % Get the data
%% Creating perturbation data
[del_u, del_omega, nom] = gen_perturb_data(u, omega, N);
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
plot_bode(tf_est, N, nom, "BodePlot_tfest");
%% Comparing the results
idf_data = gen_idfdata(Gc, fs, N);
for i=1:N
    figure()
    compare(idf_data{i}, tf_est{i});
    legend(["Data: (u_0, \omega_0) = ("+string(round(nom.u(i), 2))+", "+string(round(nom.omega(i), 2))+")", "tfest"],'Location','best')
    save_fig(gcf, 'Comparepolot_'+string(expt(i)));
end
