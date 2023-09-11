import numpy as np


def read_ESC_file(esc_file):
    """ Reads the ESC file and returns the dictionary with all the data"""
    data = dict()
    with open(esc_file, 'r') as f:
        split_str = ['']
        while split_str[0] != "Throttle":
            line = f.readline()
            split_str = line.split(" ")
        split_str  = line.split(',')
        for key in split_str:
            data[key[0:6]] = []
        keys = list(data.keys())
        f.readline()
        while True:
            line = f.readline()
            if line == '':
                break
            else:
                stuff = line[:-1].split(',')
                for i in range(len(keys)):
                    data[keys[i]].append(float(stuff[i]))
    return data


def get_static_means(data = np.array([]), f = 100, dt = 10, front_offset = 600, aft_offset = 100):
    """Returns an array of means for the given data"""
    n = len(data)
    t = n/f
    n_mean = int(t/dt)
    mean_data = [np.mean(data[(i*(dt*f) + front_offset): (i+1)*(dt*f) - aft_offset]) for i in range(n_mean)]
    return mean_data


def calc_R(y, y_hat):
    return 1 - (np.sum((y - y_hat)**2)/(np.sum((y-np.mean(y))**2)))


def get_static_uVomega(dir):
    """Read the data files and get u, V and \omega data"""
    # dir = "../../StaticData/WithProp_PWM_in/p_steps_data"
    f_50 = 100
    dt_50 = 10
    front_offset_50 = 600
    aft_offset_50 = 100
    omega_data_50 = np.loadtxt(dir+"/omega.csv")
    u_data_50 = 1125 + np.loadtxt(dir + "/u.csv")
    u_50 = get_static_means(u_data_50, f_50, dt_50, front_offset_50, aft_offset_50)[1:-1]
    omega_50 = get_static_means(omega_data_50, f_50, dt_50, front_offset_50, aft_offset_50)[1:-1]
    esc_data_50 = read_ESC_file(dir + "/ESC_data.csv")
    V_50 = np.mean(esc_data_50[' Volta'])

    # fine
    dir = dir + "_fine"
    f_10 = 100
    dt_10 = 10
    front_offset_10 = 600
    aft_offset_10 = 100
    omega_data_10 = np.loadtxt(dir+"/omega_static.csv")
    u_data_10 = np.loadtxt(dir+"/u_static.csv")
    u_10 = get_static_means(u_data_10, f_10, dt_10, front_offset_10, aft_offset_10)[2:-21]
    # u_10[0] = 1110
    # u_10[-21] = 1890
    omega_10 = get_static_means(omega_data_10, f_10, dt_10, front_offset_10, aft_offset_10)[2:-21]
    esc_data_10 = read_ESC_file(dir + "/ESC_data_fine.csv")
    V_10 = np.mean(esc_data_10[' Volta'])

    # Combining data
    u_p = np.sort(np.concatenate([u_10, u_50]))
    omega = np.sort(np.concatenate([omega_10, omega_50]))
    V_hat = np.mean([V_10, V_50])

    return u_p, V_hat, omega






if __name__=="__main__":
    a = 10
