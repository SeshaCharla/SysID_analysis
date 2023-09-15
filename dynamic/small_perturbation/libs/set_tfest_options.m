function [Options, sysinit] = set_tfest_options()
     %Estimation Options
     Options = tfestOptions;
     Options.InitialCondition = 'zero';
     Options.EnforceStability = true;
     Options.WeightingFilter = [0.1*2*pi, 30*2*pi];
     Options.InitializeMethod = 'all';
    
     np = 1;
     nz = 0;
     num = arrayfun(@(x)NaN(1,x), nz+1,'UniformOutput',false);
     den = arrayfun(@(x)[1, NaN(1,x)],np,'UniformOutput',false);
    
     % Prepare input/output delay
     iodValue = 0;
     iodFree = true;
     iodMin = 0;
     iodMax = 0.04;
     sysinit = idtf(num, den, 0);
     iod = sysinit.Structure.ioDelay;
     iod.Value = iodValue;
     iod.Free = iodFree;
     iod.Maximum = iodMax;
     iod.Minimum = iodMin;
     sysinit.Structure.ioDelay = iod;
end