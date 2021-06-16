import boto3
from botocore.exceptions import NoCredentialsError

class AwsFileWriter:
    def __init__(self,ACCESS_KEY:str,SECRET_KEY:str )-> None :
        self.__ACCESS_KEY = ACCESS_KEY
        self.__SECRET_KEY = SECRET_KEY


    def upload_to_aws(self,local_file, bucket, s3_file=None):
        s3 = boto3.client('s3', aws_access_key_id=self.__ACCESS_KEY,
                        aws_secret_access_key=self.__SECRET_KEY)

        try:
            s3.upload_file(local_file, bucket, s3_file, ExtraArgs={'ACL': 'public-read'})
            print("Upload Successful")
            return True
        except FileNotFoundError:
            print("The file was not found")
            return False
        except NoCredentialsError:
            print("Credentials not available")
            return False

 
    def delete_to_aws(self, bucket, s3_file=None):
        s3 = boto3.client('s3', aws_access_key_id=self.__ACCESS_KEY,
                        aws_secret_access_key=self.__SECRET_KEY)

        try:
            s3.delete_object(
                Bucket =bucket
                ,Key= s3_file)
            print("Delete Successful")
            return True
        except FileNotFoundError:
            print("The file was not found")
            return False
        except NoCredentialsError:
            print("Credentials not available")
            return False


    def delete_all_files(self,bucket):

        s3 = boto3.resource('s3', aws_access_key_id=self.__ACCESS_KEY,
                        aws_secret_access_key=self.__SECRET_KEY)
        bucket = s3.Bucket(bucket)
        bucket.objects.filter(Prefix="IoT/").delete()