import numpy as np
from scipy.optimize import lsq_linear
import matplotlib.pyplot as plt
import read_data as rd

# The code is for estimating the C_T and C_D of the propeller
# from the static with prop data using the force measurements and the RPM

# Loading p_steps_data ---------------------------------------------------------
dir = "../../StaticData/WithProp_PWM_in/p_steps_data"
omega_50 = np.loadtxt(dir+"/omega.csv")
F_50 = np.loadtxt(dir+"/Fx.csv")
M_50 = np.loadtxt(dir+"/Mx.csv")
data_50 = rd.read_ESC_file(dir + "/ESC_data.csv")
rpm_50 = np.array(data_50[' Speed'])
esc_omega_50 = rpm_50*2*np.pi/60
