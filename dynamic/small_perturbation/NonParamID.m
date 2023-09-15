%% Main Code
clear; clc; close all;
%%
get_dir;
expt_details;
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
legend_2 = ", " + "u_nom = "+string(u_nom);
legend(legend_1 + legend_2','Location','best')
save_fig(gcf, "BodePlots");
hold off

%% Estimates of transfer functions
%%Estimation Options
 Options = tfestOptions;
 Options.InitialCondition = 'zero';
 Options.EnforceStability = true;
 Options.WeightingFilter = [0.1*2*pi, 30*2*pi];
 Options.InitializeMethod = 'all';

 np = 1;
 nz = 0;
 num = arrayfun(@(x)NaN(1,x), nz+1,'UniformOutput',false);
 den = arrayfun(@(x)[1, NaN(1,x)],np,'UniformOutput',false);

 % Prepare input/output delay
 iodValue = 0;
 iodFree = true;
 iodMin = 0;
 iodMax = 0.04;
 sysinit = idtf(num, den, 0);
 iod = sysinit.Structure.ioDelay;
 iod.Value = iodValue;
 iod.Free = iodFree;
 iod.Maximum = iodMax;
 iod.Minimum = iodMin;
 sysinit.Structure.ioDelay = iod;
 %% Perform estimation using "sysinit" as template
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
    %showConfidence(t_f{i}, 3);
end
grid on
legend_1 = "ETFE"+string(1:N);
legend_2 = ", " + "u_nom = "+string(u_nom);
legend(legend_1 + legend_2','Location','best')
saveas(gcf,'BodePlots_tfest','epsc')
saveas(gcf,'BodePlots_tfest','png')
hold off
%% Comparing the results
for i=1:N
    figure()
    compare(idf_data{i}, tf_est{i});
    legend(["Data", "tfest"+string(i)+", u_nom = "+string(u_nom(i))],'Location','best')
    saveas(gcf,'Comparepolot_'+string(expt(i)),'epsc')
    saveas(gcf,'Comparepolot_'+string(expt(i)),'png')
end
%% parameters
p = {};
figure()
hold on
for i=1:N
    p{i} = getpvec(tf_est{i});
end
legend(legend_1 + legend_2','Location','best')
hold off
% forms || k/(s+w_c) | K/(tau s + 1) ||
k = [];
K = [];
w_c = [];
tau = [];
for i=1:N
    k(i) = p{i}(1);
    w_c(i) = p{i}(2);
    tau(i) = 1/w_c(i);
    K(i) = k(i)/w_c(i);
end
parms = {k, w_c, tau, K};
%% Parameter plots
lab = ["k", "\omega_c", "\tau", "K"];
lab_ = ["kw", "omega_c", "tau", "Kt"];
for i=1:4
    figure()
    plot((rpm_nom), parms{i}, "-x")
    xlabel('rpm_{nom}');
    ylabel(lab(i))
    grid on
    saveas(gcf,'Parameteter_'+lab_(i),'epsc')
    saveas(gcf,'Parameteter_'+lab_(i),'png')
    legend('expt.', "fit: K = V_{in}*g'_w(u_{nom})")
end
%%
