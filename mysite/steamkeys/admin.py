from django.contrib import admin

from .models import SteamKey

# Register your models here.
class SteamKeyAdmin(admin.ModelAdmin):
    readonly_fields = ('id', 'created', 'modified')

admin.site.register(SteamKey, SteamKeyAdmin)

