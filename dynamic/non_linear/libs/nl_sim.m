function omega_vec = nl_sim(w0, t_vec, u_vec)
    % ODE Simulation
    N = length(t_vec);
    omega_vec = zeros(5, 1);
    omega_vec(1) = w0;
    for i=1:N-1
        ode_fun = @(t, w) nl_sys(t, w, u_vec(i));
        sol = ode45(ode_fun,[0, t_vec(i+1)-t_vec(i)], omega_vec(i));
        omega_vec(i+1) = deval(sol, t_vec(i+1)-t_vec(i));
    end
end