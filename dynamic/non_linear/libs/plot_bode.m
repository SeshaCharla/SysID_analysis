function plot_bode(Gc, N, nom, file_name)
    % Plot the bode plots
    b_opts = bodeoptions('cstprefs');
    b_opts.Grid = 'on';
    b_opts.XLimMode= 'manual';
    b_opts.XLim = {[0.1, 200]};
    h = {};
    figure();
    hold on;
    for i=1:N
        h{i} = bodeplot(Gc{i}, b_opts);
    end
    set(gcf, "units", "inches", "position", [3, 3, 10, 6])
    grid on
    legend_nom ="($u\_0$, $\omega\_0$) = ("+string(round(nom.u, 2))+", "+string(round(nom.omega, 2))+")";
    legend(legend_nom,'Location','best','Interpreter','Latex')
    save_fig(gcf, file_name);
    hold off
end