import ftplib
import os

from ftplib import FTP

#out_folder = "isd-lite"
out_folder = "isd"
try:
    os.mkdir(f"{out_folder}")
except OSError as error:
    print(error)

with FTP('ftp.ncdc.noaa.gov') as ftp :
    ftp.login()

    #ftp.cwd('pub/data/noaa/isd-lite')
    ftp.cwd('pub/data/noaa')

    start_year = 1943
    end_year = 1970
    max_file = 1000
    for year in range(start_year, end_year+1):
        files =ftp.nlst(str(year))
        print(files)
        i=0
        try :
            os.mkdir(f"{out_folder}/{year}")
        except OSError as error:
            print(error)

        while i< min(len(files), max_file):
            with open(f"{out_folder}/{files[i]}", 'wb') as fp:
                res = ftp.retrbinary('RETR ' + files[i], fp.write)
                if not res.startswith('226 Transfer complete'):  
                    print('Download failed')
                    if os.path.isfile(files[i]):
                        os.remove(files[i])          
            i+=1
