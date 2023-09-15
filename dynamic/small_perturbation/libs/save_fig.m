function save_fig(fig, file_name)
    saveas(fig,"./figs/"+file_name,'epsc');
    saveas(fig,"./figs/"+file_name,'png');
end