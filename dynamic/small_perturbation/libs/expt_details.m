function [fs, expt, N, input_period] = expt_details()
    fs = 250;           % Hz
    expt = 1250:50:1750;
    N = length(expt);
    input_period = 10;  %seconds
end