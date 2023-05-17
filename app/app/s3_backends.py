"""
Custom storage backends for S3.
"""
from storages.backends.s3boto3 import S3Boto3Storage


class StaticS3Storage(S3Boto3Storage):
    location = "static"
    default_acl = "public-read"


class MediaS3Storage(S3Boto3Storage):
    location = "media"
    default_acl = "public-read"
