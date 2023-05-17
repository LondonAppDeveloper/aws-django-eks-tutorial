from uuid import uuid4
import os

from django.db import models


def post_image_path(instance, filename):
    """
    Generate path for post image using UUID to ensure uniqueness.
    """
    ext = os.path.splitext(filename)[1]
    return os.path.join('posts', f'{uuid4()}{ext}')


class Post(models.Model):
    author_name = models.CharField(max_length=255)
    title = models.CharField(max_length=255)
    content = models.TextField()
    image = models.ImageField(upload_to=post_image_path)
