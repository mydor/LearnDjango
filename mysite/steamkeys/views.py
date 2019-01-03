from django.core.paginator import Paginator
from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import render
from django.db.models.functions import Lower

from .models import SteamKey

page_sizes = [ "10", "25", "50", 'all' ]
numeric_fields = ('id',)

# Create your views here.

def listing(request):
    key_list = SteamKey.objects.all()
    order = request.GET.get('order', 'id')
    limit_get = request.GET.get('per_page', '10')
    page = request.GET.get('page')

    # Set our pagination limit
    limit = 999999999999999 if limit_get == 'all' else int(limit_get)

    # If order starts with -, we want a reverse sort
    reverse = True if order[0] == '-' else False

    # Get the field name we are trying to sort on
    field = order[1:] if reverse else order

    # If a non-numeric field, Lower case it for sorting
    sort = field if field in numeric_fields else Lower(field)

    # Get our sorted order
    key_list = key_list.order_by(sort)

    # flip it if we want a reverse sort
    if reverse:
        key_list = key_list.reverse()


    # Get our paginator factory
    paginator = Paginator(key_list, limit)

    # Get the display rows
    rows = paginator.get_page(page)

    return render(request, 'steam/index.html', {'rows': rows, 'page_sizes': page_sizes, 'per_page': limit_get, 'order': order})

