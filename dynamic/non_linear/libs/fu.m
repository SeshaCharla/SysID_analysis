function u_w = fu(u_p)
    % Function for u_p to u_w
    p = get_staticID_parms();
    a = p.a_fu;
    b = p.b_fu;
    u_w = a * u_p + b;
end

