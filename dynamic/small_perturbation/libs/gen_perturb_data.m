function [del_u, del_omega, nom] = gen_perturb_data(u, omega, N, fl, fs)
    % Creating perturbation data
    nom = struct;
    nom.u = zeros(N, 1);
    nom.omega = zeros(N, 1);
    del_u = {};
    del_rpm = {};
    for i=1:N
        nom.u(i, 1) = mean((u{i}));
        nom.omega(i, 1) = mean(omega{i});
        del_omega_uf = omega{i} - nom.omega(i, 1);
        del_omega{i} = lowpass(del_omega_uf, fl, fs);
        del_u{i} = u{i} - nom.u(i, 1);
    end
end