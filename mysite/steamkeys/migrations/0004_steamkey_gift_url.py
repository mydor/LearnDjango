# Generated by Django 2.0.9 on 2019-01-02 19:22

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('steamkeys', '0003_auto_20190102_1318'),
    ]

    operations = [
        migrations.AddField(
            model_name='steamkey',
            name='gift_url',
            field=models.URLField(blank=True, null=True),
        ),
    ]
