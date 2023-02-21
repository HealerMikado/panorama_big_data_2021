import csv
import gzip
import logging
import os
from typing import Dict, List


import dotenv
import boto3
import requests
from botocore.exceptions import NoCredentialsError
from lxml import html

# Load var located in .env file
dotenv.load_dotenv()

# s3 client to upload all the files
__S3 = boto3.resource(
    's3'
    , aws_access_key_id=os.getenv('AWS_ACCESS_KEY')
    , aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'))



__BUCKET_AWS = os.getenv('BUCKET_NAME')
__FOLDER_AWS = os.getenv('FOLDER_NAME')

def upload_to_aws(local_file, s3_file=None):
    try:
        __S3.Bucket(__BUCKET_AWS).upload_file(local_file, __FOLDER_AWS+s3_file, ExtraArgs ={'ACL': 'public-read'})
        logging.info("Upload Successful")
        return True
    except FileNotFoundError:
        logging.error("The file was not found")
        return False
    except NoCredentialsError:
        logging.error("Credentials not available")
        return False

def delete_all_files():
    bucket = __S3.Bucket(__BUCKET_AWS)
    bucket.objects.filter(Prefix=__FOLDER_AWS).delete()


def dowload_from_url(url :str, file_name : str) -> None:
    """Dowload the file behind the url and write it in local FS

    :param url: the url of the file
    :type url: str
    """
    logging.info(f'Download the file behind {url}')
    headers = get_headers()
    r = requests.get(url,headers=headers, allow_redirects=True)
    open(f'out/{file_name}', 'wb').write(r.content)

def add_city_column(file_name:str, city:str) -> None :
    with gzip.open(f'out/temp_{file_name}', 'rt', encoding="utf-8", newline="") as file_in:
        reader = csv.reader(file_in, quotechar='"')
        with gzip.open(f'out/{file_name}', 'wt', encoding="utf-8", newline="") as file_out:
            writer = csv.writer(file_out, quotechar='"', lineterminator='\n')
            header = next(reader)
            header.append("city")
            writer.writerow(header)
            for row in reader :
                row.append(city)
                writer.writerow(row)




def get_headers() -> Dict:
    # MS edge header. Just to look like a normal user
    user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246'

    # Request headers
    headers = {'User-Agent': user_agent}

    return headers



def get_all_urls(page_url : str, display_link: str, cities:str = None) -> List[str]:
    """Get all the urls of a link with a specific text

    :param page: page_url the specific page
    :type page: str
    :param display_link: the display text of the link
    :type display_link: str
    :param cities : a array of city name
    :type cities : array of str
    """
    if cities is None :
        cities = []

    headers = get_headers()
    # Runing the request
    page = requests.get(page_url, headers=headers)
    # Transform the page in HTML tree
    tree = html.fromstring(page.content)
    links  = []
    # Permet d'aller chercher la liste des lien via une requête Xpath
    if len(cities)==0:
         links.append(tree.xpath(f'.//a[text()="{display_link}"]'))
    else:
        for city in cities :
            table = tree.xpath(f'.//table[contains(@class, \'{city}\')]')[0]
            links.extend(table.xpath(f'.//a[text()="{display_link}"]'))
   
    return links, cities

def tranform_url_to_file_name(url : str) -> str:
    url = url.replace("http://data.insideairbnb.com", "data-insideairbnb")
    url = url.replace("/", "-")
    return url


if __name__ == "__main__":
    logging.basicConfig(filename='scrapper.log', level=logging.INFO)
    logging.info("******   Start scrapping   ******")
    logging.info("Cleaning folder")
    #delete_all_files()

    logging.info("Scrapping airbnb page")


    cities =["barcelona", "brussels", "new-york-city", "riga", "rome", "barcelona", "salem-or"]
    #cities = ["lisbon", "paris", "beijing", "geneva", "istanbul", "mexico-city", "puglia", "seattle", "washington-dc"]
    #cities = ["istanbul"]

    links, cities = get_all_urls("http://insideairbnb.com/get-the-data.html", "listings.csv.gz", cities)
    link_city =zip (links, cities)
    # DL file + upload to S3 + delete file
    for link in link_city:
        file_name = tranform_url_to_file_name(link[0].attrib['href'])
        dowload_from_url(
            link[0].attrib['href']
            ,f"temp_{file_name}" )
        add_city_column(file_name=file_name, city=link[1] )
        #upload_to_aws(f'out/{file_name}', file_name)
        #os.remove(f'out/{file_name}')

    logging.info("******   End scrapping   ******")
