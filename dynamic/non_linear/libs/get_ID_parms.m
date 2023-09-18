function p = get_ID_parms()
    %% Identified parameters from static experiments
    p = struct;
    % Force stuff
    p.C_T = 7.2581 * 10^(-6);
    p.C_D = 3.6088 * 10^(-8);   
    p.M_f = 1.3135 * 10^(-3);
    % Input definition
    p.a_fu = 0.06962415;
    p.b_fu = -64.32664328;
    % Small perutrbation results
    p.b_m = 0;
    p.J = 3.2238 * 10^(-6);
end