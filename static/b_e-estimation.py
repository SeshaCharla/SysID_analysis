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
omega_2 = omega**2
b = p.C_D * omega_2
A = np.matrix([(V_hat*u_w)-omega]).T

# Linear least-squares
lb = [0]
ub = [np.Inf]
sol = lsq_linear(A, b, bounds=(lb, ub))

#
b_e = sol.x[0]

# Validation

g_inv = lambda w: (1/(p.b_e*V_hat))*(p.b_e * w  + (p.C_D * w**2) + p.M_f)

# Plots

plt.figure(1)
plt.scatter(omega, u_w, marker="+", label='Expt. Data')
plt.plot(omega, g_inv(omega), color="C1", label=r'Model')
plt.ylabel(r'Normalized no-load angular velocity ($u_\omega$)')
plt.xlabel(r'$\omega$')
plt.grid()
plt.legend()
# plt.text(1300, 40, r'$a = {} \qquad b = {}$'.format(np.round(popt[0],4), np.round(popt[1],4)))
# plt.text(1400, 30, r'$R^2 = {}$'.format(np.round(R,2)))
plt.savefig("figs/gw_validation.eps", bbox_inches='tight')

plt.show()
