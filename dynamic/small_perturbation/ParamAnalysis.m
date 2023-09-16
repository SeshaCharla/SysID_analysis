%% Main Code for parameter analysis
clear; close all; clc;
addpath("libs\");
%% Getting the data
dirs = get_dir;
[fs, expt, N, input_period, Vin] = expt_details();
[u, omega] = get_data(dirs.sos, N, expt);               % Get the data
fl = 30;
[del_u, del_omega, nom] = gen_perturb_data(u, omega, N, fl, fs); 
p_tf = read_parms(N);
%% Voltage and Gain
figure()
hold on;
plot(nom.u, p_tf.K, "+-")
plot_var(gca, nom.u, p_tf.K, p_tf.sig_K, 1, N)
plot(nom.u, Vin, "o-")
xlabel('$u_{\omega_0}$', 'Interpreter','latex');
ylabel('$K = V_{in}$', 'Interpreter','latex');
hold off
grid on;
legend('K', '','V_{in}', 'Location','best')
save_fig(gca, "K-Vin")
%% Omega and J, b_m estimation
% $\omega_m = (1/J) (b_m + 2 C_D \omega_0)$
% Creating the non-negative least-squares problem
p = get_staticID_parms();
d = p_tf.omega;
C = [ones([N, 1]), nom.omega];
sol = lsqnonneg(C, d');
bm_Jinv = sol(1);
CD2_Jinv = sol(2);
J = 2*p.C_D/CD2_Jinv;    % Kg. m^2
b_m = bm_Jinv*J;
fwc = @(omega) (1/J)*(b_m + 2*p.C_D*omega);
%% Plots
figure()
hold on;
plot(nom.omega, p_tf.omega);
plot_var(gca, nom.omega, p_tf.omega, p_tf.sig_omega, 1, N);
plot(nom.omega, fwc(nom.omega));
xlabel('$\omega_0$', 'Interpreter','latex');
ylabel('$\omega_m$', 'Interpreter', 'latex');
hold off;
grid on;
legend('Data: $\omega_m$','','Fit: $\omega_m = \frac{1}{J} (b_m + 2 C_D \omega_0)$','Location','best','Interpreter','Latex')
save_fig(gca, "omega_fit");