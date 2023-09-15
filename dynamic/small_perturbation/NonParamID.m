%% Main Code
clear; clc; close all;
addpath("libs\");
%% Getting the data
dirs = get_dir;
[fs, expt, N, input_period] = expt_details();
[u, omega] = get_data(dirs.sos, N, expt);   % Get the data
%% Creating perturbation data
u_nom = zeros(N, 1);
omega_nom = zeros(N, 1);
del_u = {};
del_rpm = {};
for i=1:N
    u_nom(i, 1) = mean((u{i}));
    omega_nom(i, 1) = mean(omega{i});
    del_omega{i} = omega{i} - omega_nom(i, 1);
    del_u{i} = u{i} - u_nom(i, 1);
end
%% Id_data
id_data = {};
for i = 1:N
    id_data{i} = iddata(del_omega{i}, del_u{i}, 1/fs, "Period", input_period);
end
%% Emperical Transfer function estimate
M = 250;
f_max = 30;
freqs = logspace(log10(0.1*2*pi), log10(f_max*2*pi), 1000);
seg_size = 1000;
Gc = {};
for i=1:N
    Gc{i} = spa(id_data{i},M, freqs, seg_size);
end
%% Bode plot and generating freqency response data
figure();
b_opts = bodeoptions('cstprefs');
b_opts.Grid = 'on';
b_opts.XLim = {[0 300]};
b_opts.XLimMode= 'manual';
hold on
h = {};
idf_data = {};
for i=1:N
    [mag, phase] = bode(Gc{i}, freqs);
    idf_data{i} = idfrd(mag.*exp(1j*phase*pi/180),freqs, 1/fs);
    h{i} = bodeplot(Gc{i}, b_opts);
    showConfidence(h{i}, 1);
end
grid on
legend_1 = "ETFE"+string(1:N);
legend_2 = ", " + "u_nom = "+string(round(u_nom,2));
legend(legend_1 + legend_2','Location','best')
save_fig(gcf, "BodePlots");
hold off

%% Estimates of transfer functions
% Perform estimation using "sysinit" as template
[Options, sysinit] = set_tfest_options();
tf_est = {};
for i=1:N
    tf_est{i} = tfest(id_data{i}, sysinit, Options);
end
% bode plots
t_f = {};
figure();
hold on;
for i=1:N
    t_f{i} = bodeplot(tf_est{i}, freqs, b_opts);
    showConfidence(t_f{i}, 1);
end
grid on
legend_1 = "ETFE"+string(1:N);
legend_2 = ", " + "u_nom = "+string(u_nom);
legend(legend_1 + legend_2','Location','best')
save_fig(gcf, "BodePlots_tfest");
hold off
%% Comparing the results
for i=1:N
    figure()
    compare(idf_data{i}, tf_est{i});
    legend(["Data", "tfest"+string(i)+", u_nom = "+string(u_nom(i))],'Location','best')
    save_fig(gcf, 'Comparepolot_'+string(expt(i)));
end
