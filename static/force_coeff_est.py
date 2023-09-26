import numpy as np
from scipy.optimize import nnls     # non-negative least-squares
import matplotlib.pyplot as plt
import lib as rd


# The code is for estimating the C_T and C_D of the propeller
# from the static with prop data using the force measurements and the RPM

# Getting the necessary data
# ------------------------------------------------------------------------------
# Loading p_steps_data -----------------------------------------------------
dir = "../../StaticData/WithProp_PWM_in/p_steps_data"
f_50 = 100
dt_50 = 10
front_offset_50 = 600
aft_offset_50 = 100
omega_data_50 = np.loadtxt(dir+"/omega.csv")
F_data_50 = np.loadtxt(dir+"/Fx.csv")
M_data_50 = -np.loadtxt(dir+"/Mx.csv")
# u_data_50 = 1125 + np.loadtxt(dir + "/u.csv")
# u_50 = rd.get_static_means(u_data_50, f_50, dt_50, front_offset_50, aft_offset_50)
# u_10[0] = 1125
# u_10[-2] = 1875
omega_50 = rd.get_static_means(omega_data_50, f_50, dt_50, front_offset_50, aft_offset_50)[:-1]
F_50 = rd.get_static_means(F_data_50, f_50, dt_50, front_offset_50, aft_offset_50)[:-1]
M_50 = rd.get_static_means(M_data_50, f_50, dt_50, front_offset_50, aft_offset_50)[:-1]

# Loading p_steps_data_fine ------------------------------------------------
# good range = [1:-21]
dir = dir + "_fine"
f_10 = 100
dt_10 = 10
front_offset_10 = 600
aft_offset_10 = 100
omega_data_10 = np.loadtxt(dir+"/omega_static.csv")
F_data_10 = np.loadtxt(dir+"/Fx.csv")
M_data_10 = -np.loadtxt(dir+"/Mx.csv")
u_data_10 = np.loadtxt(dir+"/u_static.csv")
u_10 = rd.get_static_means(u_data_10, f_10, dt_10, front_offset_10, aft_offset_10)[1:-21]
# u_10[0] = 1110
# u_10[-21] = 1890
omega_10 = rd.get_static_means(omega_data_10, f_10, dt_10, front_offset_10, aft_offset_10)[1:-21]
F_10 = rd.get_static_means(F_data_10, f_10, dt_10, front_offset_10, aft_offset_10)[1:-21]
M_10 = rd.get_static_means(M_data_10, f_10, dt_10, front_offset_10, aft_offset_10)[1:-21]
# ------------------------------------------------------------------------------

# Combining data and putting in least-squares form
# M[38] Spike due to flutter or something
omega = np.concatenate([omega_10, omega_50])
omega = np.delete(omega, 38)
A_F = np.matrix(omega**2).T
A_M = np.matrix(np.concatenate([[np.ones([len(omega),])], [omega], [omega**2]])).T
F = np.concatenate([F_10, F_50])
M = np.concatenate([M_10, M_50])
F = np.delete(F, 38)
M = np.delete(M, 38)
#-------------------------------------------------------------------------------

# Solving for the force coefficients

# C_T
sol_T = nnls(A_F, F)
C_T = sol_T[0][0]
sigma_2_CT = rd.calc_COV(A_F, F, sol_T[0]);
sigma_CT = np.sqrt(sigma_2_CT[0, 0]);

# M_f, b, C_D
sol_D = nnls(A_M, M)
C_D = sol_D[0][2]
b_f = sol_D[0][1]
M_f = sol_D[0][0]
cov_CD = rd.calc_COV(A_M, M, sol_D[0])
[lds, ld_vec] = np.linalg.eig(cov_CD)
sig_bf = np.sqrt(lds[1])
sig_Mf = np.sqrt(lds[0])
sig_CD = np.sqrt(lds[2])


# ------------------------------------------------------------------------------
# Goodness of fit
R_T = 1 - (np.sum((F - C_T*omega**2)**2)/(np.sum((F-np.mean(F))**2)))
R_D = 1 - (np.sum((M - ((C_D*omega**2) + (b_f * omega) + M_f))**2)/np.sum((M - np.mean(M))**2))
# ------------------------------------------------------------------------------

# Plots
w = np.linspace(min(omega), max(omega), 100)
F_T = C_T * w**2
M_D = C_D * w**2 + b_f * w + M_f

plt.figure(1)
plt.scatter(omega, F, marker="+", label='Expt. Data')
plt.plot(w, F_T, color="C1", label=r'$F_T = C_T \omega^2$')
plt.ylabel(r'Thrust $(N)$')
plt.xlabel(r'$\omega$ $(rad/s)$')
plt.grid()
plt.legend()
plt.text(200, 6, r'$C_T = {}$'.format(C_T))
plt.text(200, 5, r'$R^2 = {}$'.format(np.round(R_T,2)))
plt.savefig("figs/Thrust_curve.eps", bbox_inches='tight')

plt.figure(2)
plt.scatter(omega, M, marker="+", label='Expt. Data')
plt.plot(w, M_D, color="C1", label=r'$M = C_D \omega^2 + b_f \omega + M_f$')
plt.ylabel(r'Drag Moment $(N.m)$')
plt.xlabel(r'$\omega$ $(rad/s)$')
plt.grid()
plt.legend()
plt.text(200, 0.045, r'$C_D = {}$'.format(C_D))
plt.text(200, 0.04, r'$b_f = {}$'.format(b_f))
plt.text(200, 0.035, r'$M_f = {}$'.format(M_f))
plt.text(200, 0.025, r'$R^2 = {}$'.format(np.round(R_D,2)))
plt.savefig("figs/Drag_curve.eps", bbox_inches='tight')

plt.show()
