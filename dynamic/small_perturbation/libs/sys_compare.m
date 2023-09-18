function sys_compare(data1, data2, N, nom, expt, name)
    for i=1:N
        figure()
        compare(data1{i}, data2{i});
        grid on;
        legend(["Data: (u_0, \omega_0) = ("+string(round(nom.u(i), 2))+", "+string(round(nom.omega(i), 2))+")", "tfest"],'Location','best')
        save_fig(gcf, name+string(expt(i)));
    end
end