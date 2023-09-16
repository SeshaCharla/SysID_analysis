function [fs, expt, N, input_period, Vin] = expt_details()
    fs = 250;           % Hz
    expt = 1250:50:1750;
    N = length(expt);
    input_period = 10;  %seconds
    Vin =  [15.64
            15.64
            15.64
            15.59111111
            16.06
            16.018
            15.88436364
            15.83854545
            15.71254545
            15.53759259
            15.37163636];
end