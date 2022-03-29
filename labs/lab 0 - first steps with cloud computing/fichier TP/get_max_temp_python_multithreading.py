import gzip
import os
import concurrent.futures
from itertools import repeat

def read_file(directory,file):
    print(f"thread {file}")
    with gzip.open(f'{directory}/{file}') as year:
        max_year = -9999
        for line in year:
            current_temp = int(line[87:92])
            quality = line[92:93].decode("utf-8") 
            if current_temp < 9999 and quality in "01459" and current_temp > max_year :
                max_year = current_temp
        print (f"base year {file}.gz \t {max_year}")


def get_max_temp_per_year(nb_worker, directory="./ncdc_data"):
    with concurrent.futures.ProcessPoolExecutor(max_workers=nb_worker) as executor:
        executor.map(read_file, repeat(directory), sorted(os.listdir(directory)))

if __name__ == "__main__":
    get_max_temp_per_year(os.cpu_count())