# Generated by Django 2.0.9 on 2019-01-02 18:57

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='SteamKey',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=200)),
                ('purchase_date', models.DateField(verbose_name='date purchased')),
                ('bundle_name', models.CharField(max_length=200)),
                ('bundle_url', models.URLField()),
            ],
        ),
    ]
