import numpy as np
from scipy.optimize import curve_fit    # Curve_fit
import matplotlib.pyplot as plt
import lib

def g_w(u_p, a, b):
    """The non-linear input transformation function"""
    return a*(u_p) + b

def d_g_w(u_p, a, b):
    """ Derivative"""
    return 2*a*np.ones(np.shape(u_p))

# Reading prop data

dir = "../../StaticData/WithProp_PWM_in/p_steps_data"
u_p, V_hat, omega = lib.get_static_uVomega(dir)
u_w = omega/V_hat


# Fitting a curve
popt, pcov = curve_fit(g_w, u_p, u_w)

gw = lambda u_p: g_w(u_p, popt[0], popt[1])

up = np.linspace(min(u_p), max(u_p), 100)
uw = gw(up)

# ------------------------------------------------------------------------------
# Goodness of fit
R = lib.calc_R(u_w, gw(u_p))
# ------------------------------------------------------------------------------

# Plots

plt.figure(1)
plt.scatter(u_p, u_w, marker="+", label='Expt. Data')
plt.plot(up, uw, color="C1", label=r'$u_w = a u_p + b $')
plt.ylabel(r'Normalized no-load angular velocity ($u_\omega$)')
plt.xlabel(r'PWM input ($u_p$ $\mu/s$)')
plt.grid()
plt.legend()
plt.text(1400, 20, r'$a = {} \qquad b = {}$'.format(np.round(popt[0],8), np.round(popt[1],8)))
plt.text(1500, 30, r'$R^2 = {}$'.format(np.round(R,2)))
plt.savefig("figs/no-load_rpm.eps", bbox_inches='tight')

plt.show()
