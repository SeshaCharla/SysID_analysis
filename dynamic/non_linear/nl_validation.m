clear; close all; clc;
addpath("libs\");
%% Getting the data
dirs = get_dir;
fs = expt_details().fs;
expt = struct;
expt.tf.ch = 5;
expt.tf.sq = 50;
[expt.ch, expt.sq] = get_data(get_dir(), fs, expt.tf.ch, expt.tf.sq);     % Get the data
expt.id.ch = iddata(expt.ch.omega, expt.ch.uw, 1/fs);
expt.id.sq = iddata(expt.sq.omega, expt.sq.uw, 1/fs);
%% Getting the simulation data
sim = struct;
sim.ch.uw = expt.ch.uw;
sim.ch.omega = nl_sim(expt.ch.omega(1), linspace(0,expt.tf.ch, fs*expt.tf.ch), sim.ch.uw);
sim.sq.uw = expt.sq.uw;
sim.sq.omega = nl_sim(expt.sq.omega(1), linspace(0,expt.tf.sq, fs*expt.tf.sq), sim.sq.uw);
sim.id.ch = iddata(sim.ch.omega, sim.ch.uw, 1/fs);
sim.id.sq = iddata(sim.sq.omega, sim.sq.uw, 1/fs);
%% Comparing plots
sys_compare(expt.id.ch, sim.id.ch, "chirp")
sys_compare(expt.id.sq, sim.id.sq, "square")