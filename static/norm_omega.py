import numpy as np


a = 22.6
b = -51

def gw(u_p):
    """The non-linear input transformation function"""
    return a*np.log(u_p - 1110) + b

def dgw(u_p):
    """ Derivative"""
    return a/(u_p - 1110)
