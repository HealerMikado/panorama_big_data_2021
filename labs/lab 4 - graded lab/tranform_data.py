import json

from ish_parser import ish_parser, ish_report

import gzip
import os
import concurrent.futures
from itertools import repeat

out_folder = 'json2'
in_folder = 'isd'



def transform_data(year):

        print(f"process year {year}")
        files = os.listdir(f"{in_folder}/{year}")
        with gzip.open(f"{out_folder}/{year}.jsonl.gz", "wt") as fout:
            for file in files:
                try : 
                    print(f"{file}")
                    with gzip.open(f"{in_folder}/{year}/{file}", 'rb') as fin:
                        content = bytes.decode(fin.read())
                        wf = ish_parser()
                        wf.loads(content)
                        lines = []
                        for report in wf.get_observations():
                            lines.append(report.toJson())
                        fout.write("\n".join(lines))
                except UnicodeDecodeError as e:
                    print(f'le fichier {file} est en erreur')


def main():
    try:
        os.mkdir(f"{out_folder}")
    except OSError as error:
        print(error)

    years = os.listdir(in_folder)

    with concurrent.futures.ProcessPoolExecutor(max_workers=os.cpu_count()) as executor:
        executor.map(transform_data, range(1973, 1978))


if __name__ == "__main__":
    main()
