from django.contrib import admin
from .models import Order

@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ('pizza_type', 'comments', 'created_at')
    search_fields = ['pizza_type']

