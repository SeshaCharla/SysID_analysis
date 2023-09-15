function [u_w, omega_despiked] = get_data(data_path, N, expt)
    for i=1:N
        omega{i} = readmatrix(data_path + "/u_omega/omega_"+string(expt(i))+".csv");
        omega_despiked{i} = despike(despike(despike(omega{i}, 50), 50), 50);
        u_p{i} = (readmatrix(data_path + "/u_omega/u_"+string(expt(i))+".csv"));
        u_w{i} = fu(u_p{i});
    end
end