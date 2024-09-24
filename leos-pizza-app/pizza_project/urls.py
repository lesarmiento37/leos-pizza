"""
URL configuration for pizza_project project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.urls import path, include
from orders.views import place_order, orders_table
from django.contrib import admin

urlpatterns = [
    path('admin/', admin.site.urls),  # Admin page
    path('', place_order, name='place_order'),  # Home page for placing orders
    path('orders/', place_order, name='place_order'),  
    path('orders-table/', orders_table, name='orders_table'),  
    path('accounts/', include('django.contrib.auth.urls')),  
]
