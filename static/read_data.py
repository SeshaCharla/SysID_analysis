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


if __name__=="__main__":
    a = 10
