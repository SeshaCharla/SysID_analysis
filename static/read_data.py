import numpy as np

# Loading data -----------------------------------------------------------------
V_in = 16.15
dir = "../../StaticData/WithProp_PWM_in/p_steps_data"
omega_50 = np.loadtxt(dir+"/omega.csv")
F_50 = np.loadtxt(dir+"/Fx.csv")
M_50 = np.loadtxt(dir+"/Mx.csv")
omega_10 = np.loadtxt(dir+"_fine/omega_static.csv")
F_10 = np.loadtxt(dir+"_fine/Fx.csv")
M_10 = np.loadtxt(dir+"_fine/Mx.csv")


