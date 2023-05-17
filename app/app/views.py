from django.http import HttpResponse

def index(request):
    res = f'Request: {request.META}'
    return HttpResponse(res)
