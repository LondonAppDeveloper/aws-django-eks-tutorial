from django.shortcuts import render, redirect
from django.urls import reverse

from publish.forms import PostForm
from publish.models import Post


def index(request):
    """
    Show landing page and handle form to publish post.
    """
    posts = Post.objects.all()
    if request.method == 'POST':
        form = PostForm(request.POST, request.FILES)
        if form.is_valid():
            post = form.save()
            return redirect(reverse('view-post', args=[post.id]))
    else:
        form = PostForm()
    return render(
        request, 'publish/index.html', {'form': form, 'posts': posts}
    )


def view_post(request, post_id):
    """
    Show specific post.
    """
    post = Post.objects.get(id=post_id)
    return render(request, 'publish/post.html', {'post': post})
