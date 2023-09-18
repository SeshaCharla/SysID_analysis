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
plot_var(gca, nom.u, p_tf.K, p_tf.sig_K, 2, N)
plot(nom.u, Vin, "o-")
xlabel('$u_{\omega_0}$', 'Interpreter','latex');
ylabel('$K = V_{in}(1 + \delta v)$', 'Interpreter','latex');
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
R = calc_R2(p_tf.omega, fwc(nom.omega));
figure()
hold on;
plot(nom.omega, p_tf.omega);
plot_var(gca, nom.omega, p_tf.omega, p_tf.sig_omega, 2, N);
plot(nom.omega, fwc(nom.omega));
xlabel('$\omega_0$', 'Interpreter','latex');
ylabel('$\omega_m$', 'Interpreter', 'latex');
text(400, 15, '$R^2 =$ '+string(round(R, 2)), 'Interpreter', 'latex');
text(400, 19, '$J =$ '+string(J),'Interpreter', 'latex');
text(400, 18, '$b_m =$ '+string(b_m),'Interpreter', 'latex');
text(400, 17, '$C_D =$ '+string(p.C_D),'Interpreter', 'latex');
hold off;
grid on;
legend('Data: $\omega_m$','','Fit: $\omega_m = \frac{1}{J} (b_m + 2 C_D \omega_0)$','Location','best','Interpreter','Latex')
save_fig(gca, "omega_fit");