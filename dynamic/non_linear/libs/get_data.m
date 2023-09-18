function [chirp, sq] = get_data(data_path, fs, tf_ch, tf_sq)
    chirp = struct;
    sq = struct;
    %% For chirp wave
    omega = readmatrix(data_path.chirp + "/omega_chirp.csv");
    omega = omega(1:fs*tf_ch);
    u_p = readmatrix(data_path.chirp + "/u_chirp.csv");
    u_p = u_p(1:fs*tf_ch);
    omega_despiked = despike(despike(despike(omega, 50), 50), 50);
    %omega_filtered = lowpass(omega_despiked, fl, fs);
    chirp.omega = omega_despiked;
    chirp.uw = fu(u_p);
    %% For square wave
    omega = readmatrix(data_path.sq + "/omega_sq.csv");
    omega = omega(1:fs*tf_sq);
    u_p = readmatrix(data_path.sq + "/u_sq.csv");
    u_p = u_p(1:fs*tf_sq);
    omega_despiked = despike(despike(despike(omega, 50), 50), 50);
    sq.omega = omega_despiked;
    sq.uw = fu(u_p);

end