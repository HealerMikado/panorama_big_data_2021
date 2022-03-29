import os
from aws_file_writer import AwsFileWriter
import json
from reccord import Reccord
import gzip

import dotenv
import logging
from datetime import datetime
from date_time_encoder import DateTimeEncoder



if __name__ == "__main__":

    dotenv.load_dotenv()
    FILE_SIZE = 10000
    aws_file_writer = AwsFileWriter(os.getenv('AWS_ACCESS_KEY'), os.getenv('AWS_SECRET_ACCESS_KEY'))
    aws_file_writer.delete_all_files(os.getenv('BUCKET_NAME'))
    file_list=[]
    while True:
        file_name = f'iot{datetime.now().strftime("%Y%m%d-%H%M%S")}.jsonl.gz'
        file_path = f'output/{file_name}'
        file_list.append(file_name)
        logging.info(f'creating new file {file_path}')
        with gzip.open(file_path, mode="wt", encoding="utf8") as file:
            for i in range(FILE_SIZE):
                reccord = Reccord()
                file.write(json.dumps(vars(reccord), cls=DateTimeEncoder))
                file.write("\n")
                if not i % 10000:
                    logging.info(f'{i} iot writen')

        aws_file_writer.upload_to_aws(
            file_path, os.getenv('BUCKET_NAME'), f'{os.getenv("FOLDER_NAME")}/{file_name}')
        os.remove(file_path)
        if len(file_list) > 5 :
            file_to_delete = file_list.pop(0)
            aws_file_writer.delete_to_aws(os.getenv('BUCKET_NAME'), f'{os.getenv("FOLDER_NAME")}/{file_to_delete}')
