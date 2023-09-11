import numpy as np
import matplotlib.pyplot as plt
import read_data as rd
import norm_omega as gw
from scipy.optimize import lsq_linear    # Constrained linear least squares
import parms as p

# Reading prop data

dir = "../../StaticData/WithProp_PWM_in/p_steps_data"
f_50 = 100
dt_50 = 10
front_offset_50 = 600
aft_offset_50 = 100
omega_data_50 = np.loadtxt(dir+"/omega.csv")
u_data_50 = 1125 + np.loadtxt(dir + "/u.csv")
u_50 = rd.get_static_means(u_data_50, f_50, dt_50, front_offset_50, aft_offset_50)[1:-1]
omega_50 = rd.get_static_means(omega_data_50, f_50, dt_50, front_offset_50, aft_offset_50)[1:-1]
esc_data_50 = rd.read_ESC_file(dir + "/ESC_data.csv")
V_50 = np.mean(esc_data_50[' Volta'])

# fine
dir = dir + "_fine"
f_10 = 100
dt_10 = 10
front_offset_10 = 600
aft_offset_10 = 100
omega_data_10 = np.loadtxt(dir+"/omega_static.csv")
u_data_10 = np.loadtxt(dir+"/u_static.csv")
u_10 = rd.get_static_means(u_data_10, f_10, dt_10, front_offset_10, aft_offset_10)[2:-21]
# u_10[0] = 1110
# u_10[-21] = 1890
omega_10 = rd.get_static_means(omega_data_10, f_10, dt_10, front_offset_10, aft_offset_10)[2:-21]
esc_data_10 = rd.read_ESC_file(dir + "/ESC_data_fine.csv")
V_10 = np.mean(esc_data_10[' Volta'])


# Combining data
u_p = np.sort(np.concatenate([u_10, u_50]))
omega = np.sort(np.concatenate([omega_10, omega_50]))
u_w = gw.gw(u_p)
V_hat = np.mean([V_10, V_50])


# Parameter estimation
b = u_w
A = np.matrix([u_p**2, u_p, np.ones(np.shape(u_p))]).T

# Linear least-squares
sol = lsq_linear(A, b)

#
# Plots

plt.figure(1)
plt.scatter(u_p, u_w, marker="+", label='Expt. Data')
# plt.plot(omega, g_inv(omega), color="C1", label=r'Model')
plt.ylabel(r'Normalized angular velocity ($u_\omega$)')
plt.xlabel(r'PWM input $u_p$')
plt.grid()
plt.legend()
# plt.text(1300, 40, r'$a = {} \qquad b = {}$'.format(np.round(popt[0],4), np.round(popt[1],4)))
# plt.text(1400, 30, r'$R^2 = {}$'.format(np.round(R,2)))
plt.savefig("figs/u_w.eps", bbox_inches='tight')

plt.show()
