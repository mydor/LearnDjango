from django.db import models

from django.utils import timezone

# Create your models here.

class SteamKey(models.Model):
    name = models.CharField(max_length=200)
    purchase_date = models.DateField('date purchased')
    bundle_name = models.CharField(max_length=200)
    bundle_url = models.URLField()
    given_to = models.CharField(max_length=200, blank=True, null=True)
    given_date = models.DateField(blank=True, null=True)
    gift_url = models.URLField(blank=True, null=True)
    #created = models.DateTimeField(auto_now_add=True, editable=False)
    #modified = models.DateTimeField(auto_now=True, editable=False)
    created = models.DateTimeField(default=timezone.now)
    modified = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return self.name

    @property
    def isAvailable(self):
        return False if self.given_date else True
