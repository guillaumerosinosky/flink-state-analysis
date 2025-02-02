#! /usr/bin/python3
from random import randint
import argparse
import pathlib
import getopt
import sys


def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "k:s:m:r:", ["data_dir=", "keys=", "key_matching=", "size=", 'row_size='])
    except getopt.GetoptError as err:
        # print help information and exit:
        print(err)  # will print something like "option -a not recognized"
        usage()
        sys.exit(2)

    tables = 2
    keys = 10
    key_matching = 0.5
    dataset_size = 1024 # In Megabytes
    row_size = 1024
    data_dir = "/home/donatien/GEPICIAD/resource-estimator/xp/sql_illustration/data/tables/"

    for o, a in opts:
        if o == "--data_dir":
            data_dir = a
        elif o in ("-k", "--keys"):
            keys = int(a)
        elif o in ("-m", "--key_matching"):
            key_matching = float(a)
        elif o in ("-s", "--size"):
            dataset_size = int(a)
        elif o in ("-r", "--row_size"):
            row_size = int(a)
        else:
            assert False, "unhandled option"

    pathlib.Path(data_dir).mkdir(exist_ok=True, parents=True)
    table_row = "{}|{}\n"
    size_per_table = dataset_size * 1048576  # in bytes
    rows_per_table = int(size_per_table / (row_size + 3)) # Row size + 3 bytes for key (1), separator (1) and EOL (1)
    open(data_dir + "table_1.dat", "w").write(''.join(table_row.format(i, 'A'*10) for i in range(keys)))
    with open(data_dir + "table_2.dat", "w") as fd:
        for i in range(dataset_size):
            print("",  end="\r")
            print("Writing {}/{}Mb".format(i+1, dataset_size), end=" ")
            fd.write(''.join(table_row.format(randint(0, int(keys / key_matching)), 'B'*(row_size)) for j in range(int(rows_per_table / dataset_size))))

if __name__ == "__main__":
    main()
