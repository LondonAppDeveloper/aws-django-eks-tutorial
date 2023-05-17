from django.forms import ModelForm

from publish.models import Post


class PostForm(ModelForm):
    class Meta:
        model = Post
        fields = ['title', 'author_name', 'content', 'image']
