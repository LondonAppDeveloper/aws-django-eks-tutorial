from django.urls import path
from publish import views


urlpatterns = [
    path('', views.index, name='index'),
    path('post/<int:post_id>/', views.view_post, name='view-post')
]
