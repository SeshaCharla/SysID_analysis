function idf_data = gen_idfdata(Gc, fs, N)
    f_max = 30;
    freqs = logspace(log10(0.1*2*pi), log10(f_max*2*pi), 1000);
    for i=1:N
        [mag, phase] = bode(Gc{i}, freqs);
        idf_data{i} = idfrd(mag.*exp(1j*phase*pi/180),freqs, 1/fs);
    end
end