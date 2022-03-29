cimport cython
import gzip
import os

def get_max_temp_per_year(str directory):
    cdef str file

    for file in sorted(os.listdir(directory)): # Sans le trie les archives sont lues dans le désordre.
        process_file(directory, file)

@cython.boundscheck(False)
cdef void process_file(str directory, str file):
    cdef char* line 
    cdef int current_temp
    cdef str quality
    cdef int max_year = -9999
    with gzip.open(f'{directory}/{file}') as gzipfile:
        max_year = -9999
        for line in gzipfile:
            if not line : break
            if not line[87:92]:
                continue
            current_temp = int(line[87:92])
            quality = line[92:93].decode("utf-8") 
            if current_temp < 9999 and quality in "01459" and current_temp > max_year :
                max_year = current_temp
        print (f"base year {file}.gz \t {max_year}")
