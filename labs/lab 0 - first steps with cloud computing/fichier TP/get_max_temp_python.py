import gzip
import os

def get_max_temp_per_year(directory="./ncdc_data"):

    for file in sorted(os.listdir(directory)): # Sans le trie les archives sont lues dans le désordre.
        process_file(directory, file)


def process_file(directory, file):
    with gzip.open(f'{directory}/{file}') as year:
        max_year = -9999
        for line in year:
            if not line[87:92]:
                continue
            current_temp = int(line[87:92])
            quality = line[92:93].decode("utf-8") 
            if current_temp < 9999 and quality in "01459" and current_temp > max_year :
                max_year = current_temp
        print (f"base year {file}.gz \t {max_year}")

if __name__ == "__main__":
    get_max_temp_per_year()