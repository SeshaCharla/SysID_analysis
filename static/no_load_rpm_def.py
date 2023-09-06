import numpy as np
from scipy.optimize import curve_fit    # Curve_fit
import matplotlib.pyplot as plt
import read_data as rd

def g_w(u_p, a, b):
    """The non-linear input transformation function"""
    return a*np.log(u_p - 1110) + b

def d_g_w(u_p, a):
    """ Derivative"""
    return a/(u_p - 1110)

# Reading no-prop data

dir = "../../StaticData/NoProp/p_steps_data"
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
uw_50 = omega_50/V_50

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
uw_10 = omega_10/V_10


# Combining data
u_p = np.concatenate([u_10, u_50])
u_w = np.concatenate([uw_10, uw_50])


# Fitting a curve
popt, pcov = curve_fit(g_w, u_p, u_w)

gw = lambda u_p: g_w(u_p, popt[0], popt[1])

up = np.linspace(min(u_p), max(u_p), 100)
uw = gw(up)

# ------------------------------------------------------------------------------
# Goodness of fit
R = 1 - (np.sum((u_w - gw(u_p))**2)/(np.sum((u_w-np.mean(u_w))**2)))
# ------------------------------------------------------------------------------

# Plots

plt.figure(1)
plt.scatter(u_p, u_w, marker="+", label='Expt. Data')
plt.plot(up, uw, color="C1", label=r'$u_w = a \ln (u_p - 1110) + b$')
plt.ylabel(r'Normalized no-load angular velocity ($u_\omega$)')
plt.xlabel(r'PWM input ($u_p$ $\mu/s$)')
plt.grid()
plt.legend()
plt.text(1300, 40, r'$a = {} \qquad b = {}$'.format(np.round(popt[0],4), np.round(popt[1],4)))
plt.text(1400, 30, r'$R^2 = {}$'.format(np.round(R,2)))
plt.savefig("figs/no-load_rpm.eps", bbox_inches='tight')


#===============================================================================
# Validating the derivative

up_sorted = np.sort(u_p)
d_uw = np.diff(np.sort(u_w))
d_up = np.diff(up_sorted)
d_gw = d_uw/d_up

dgw = lambda u_p: d_g_w(u_p, popt[0])

# ------------------------------------------------------------------------------
# Goodness of fit
R_D = 1 - (np.sum((d_gw - dgw(up_sorted[1:]))**2)/(np.sum((d_gw-np.mean(d_gw))**2)))
# ------------------------------------------------------------------------------



# Plots

plt.figure(2)
plt.scatter(up_sorted[1:], d_gw, marker="+", label='Diff. Expt. Data')
plt.plot(up_sorted[1:], dgw(up_sorted[1:]), color="C1", label=r'$\frac{du_w}{d u_p} = \frac{a}{(u_p - 1110)}$')
plt.ylabel(r'Derivative of ($u_\omega$)')
plt.xlabel(r'PWM input ($u_p$ $\mu/s$)')
plt.grid()
plt.legend()
plt.text(1500, 0.6, r'$R^2 = {}$'.format(np.round(R_D,2)))
plt.savefig("figs/no-load_rpm_derivative.eps", bbox_inches='tight')














plt.show()
