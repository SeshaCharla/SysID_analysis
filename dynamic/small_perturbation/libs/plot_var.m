function plot_var(ax, x, y, var_y, n, N)
    fill(ax, reshape([x; flip(x)], [2*N, 1]), reshape([y+(n*var_y), flip(y-(n*var_y))], [2*N, 1]), ...
        [0 0.4470 0.7410], FaceAlpha=0.1, EdgeColor="none");
end