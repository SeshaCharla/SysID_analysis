function sys_compare(expt, sim, fig_name)
    % compare plots
    figure()
    compare(expt, sim);
    grid on;
    legend("Expt.", "Sim.",'Location','best')
    save_fig(gcf, fig_name+"_validation");

end