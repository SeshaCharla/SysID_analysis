import numpy as np
from scipy.optimize import lsq_linear
import matplotlib.pyplot as plt
import read_data as rd


# The code is for estimating the C_T and C_D of the propeller
# from the static with prop data using the force measurements and the RPM


if __name__ == "__main__":
    # Loading p_steps_data -----------------------------------------------------
    dir = "../../../StaticData/WithProp_PWM_in/p_steps_data"
    f_50 = 100
    f_esc = 1
    omega_50 = np.loadtxt(dir+"/omega.csv")
    F_50 = np.loadtxt(dir+"/Fx.csv")
    M_50 = np.loadtxt(dir+"/Mx.csv")
    data_50 = rd.read_ESC_file(dir + "/ESC_data.csv")
    u_50 = 1125 + np.loadtxt(dir+"/u.csv")
    rpm_50 = np.array(data_50[' Speed'])
    esc_omega_50 = rpm_50*2*np.pi/60
    esc_throttle_50 = np.array(data_50['Thrott'])
    # Loading p_steps_data_fine ------------------------------------------------
    dir = dir + "_fine"
    f_10 = 100
    f_esc = 1
    omega_10 = np.loadtxt(dir+"/omega_static.csv")
    F_10 = np.loadtxt(dir+"/Fx.csv")
    M_10 = np.loadtxt(dir+"/Mx.csv")
    data_10 = rd.read_ESC_file(dir + "/ESC_data_fine.csv")
    rpm_10 = np.array(data_50[' Speed'])
    esc_omega_10 = rpm_50*2*np.pi/60
