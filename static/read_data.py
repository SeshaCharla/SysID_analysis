
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


if __name__=="__main__":
    dir = "../../StaticData/WithProp_PWM_in/p_steps_data_fine/"
    esc_file= dir + "ESC_data_fine.csv"
    data = read_ESC_file(esc_file)
