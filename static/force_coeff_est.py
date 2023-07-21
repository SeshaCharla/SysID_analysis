from scipy.optimize import lsq_linear
import matplotlib.pyplot as plt

# Loading data -----------------------------------------------------------------
V_in = 16.15
dir = "../../../StaticData/WithProp_PWM_in/p_steps_data"
omega_50 = np.loadtxt(dir+"/omega.csv")
F_50 = np.loadtxt(dir+"/Fx.csv")
M_50 = np.loadtxt(dir+"/Mx.csv")
omega_10 = np.loadtxt(dir+"_fine/omega_static.csv")
F_10 = np.loadtxt(dir+"_fine/Fx.csv")
M_10 = np.loadtxt(dir+"_fine/Mx.csv")

# Creating required vectores ---------------------------------------------------
Omega = np.concatenate([omega_10, omega_50])
Omega_2 = np.concatenate([omega_10**2, omega_50**2])
F = np.concatenate([F_10, F_50])
M = np.concatenate([M_10, M_50])

# Thrust coefficient estimation-------------------------------------------------
C_T = lsq_linear(np.matrix(Omega_2).T, F) #, bounds=(0, np.Inf))
