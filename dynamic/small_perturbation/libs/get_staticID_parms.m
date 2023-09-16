function p = get_staticID_parms()
    %% Identified parameters from static experiments
    p = struct;
    % Force stuff
    p.C_T = 7.2581 * 10^(-6);
    p.C_D = 3.6088 * 10^(-8);   
    p.M_f = 1.3135 * 10^(-3);
    % Input definition
    p.a_fu = 0.06962415;
    p.b_fu = -64.32664328;
end