function dirs = get_dir()
    dirs = struct;
    dirs.root = "../../../../Experiments/DynamicData/WithProp/SmallPerturbation";
    dirs.sos = dirs.root + "/Sum_of_sinusoids_PWM_input";
    dirs.chirp = dirs.root + "/chirp_PWM_input";
end