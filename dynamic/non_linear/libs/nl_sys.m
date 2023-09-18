function dw = nl_sys(t, w, u)
    p = get_ID_parms();
    Vin = expt_details().V_in;
    g_u = (Vin*p.b_m*u) + (Vin^2*p.C_D*u^2);
    f_w = (p.b_m*w) + (p.C_D * w^2);
    dw = (1/p.J)*(g_u - f_w);
end