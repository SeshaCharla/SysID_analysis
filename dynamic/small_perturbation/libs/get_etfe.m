function Gc = get_etfe(id_data, N)
    M = 250;
    f_max = 30;
    freqs = logspace(log10(0.1*2*pi), log10(f_max*2*pi), 1000);
    seg_size = 1000;
    Gc = {};
    for i=1:N
        Gc{i} = spa(id_data{i}, M, freqs, seg_size);
    end
end