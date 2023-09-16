function sys_compare(data1, data2, N, nom, expt)
    for i=1:N
        figure()
        compare(data1{i}, data2{i});
        grid on;
        legend(["Data: (u_0, \omega_0) = ("+string(round(nom.u(i), 2))+", "+string(round(nom.omega(i), 2))+")", "tfest"],'Location','best')
        save_fig(gcf, 'freq_ComparePlot_'+string(expt(i)));
    end
end