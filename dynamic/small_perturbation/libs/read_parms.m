function tf_parm = read_parms(N)
    load("libs\tf_parms.mat", "pvec", "dpvec");
    tf_parm = struct;
    for i = 1:N
        tf_parm.k(i) = pvec{i}(1);
        tf_parm.sig_k(i) = dpvec{i}(1);
        tf_parm.omega(i) = pvec{i}(2);
        tf_parm.sig_omega(i) = dpvec{i}(2);
        tf_parm.tau(i) = 1/tf_parm.omega(i);
        tf_parm.sig_tau(i) = tf_parm.sig_omega(i)/(tf_parm.omega(i)^2);
        tf_parm.K(i) = tf_parm.k(i)/tf_parm.omega(i);
        % Variance of static gain calculation
        w = tf_parm.omega(i);
        sk = tf_parm.sig_k(i);
        sw = tf_parm.sig_omega(i);
        k = tf_parm.k(i);
        tf_parm.sig_K(i) = (1/w) * sqrt((sk^2) + (k^2/w^2)*(sw^2) + (2*k/w)*sk*sw);
    end
end