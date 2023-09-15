function [del_u, del_omega, nom] = gen_perturb_data(u, omega, N)
    % Creating perturbation data
    nom = struct;
    nom.u = zeros(N, 1);
    nom.omega = zeros(N, 1);
    del_u = {};
    del_rpm = {};
    for i=1:N
        nom.u(i, 1) = mean((u{i}));
        nom.omega(i, 1) = mean(omega{i});
        del_omega{i} = omega{i} - nom.omega(i, 1);
        del_u{i} = u{i} - nom.u(i, 1);
    end
end