from django.shortcuts import render, redirect
from .forms import OrderForm
from .models import Order
from django.contrib.auth.decorators import user_passes_test

def place_order(request):
    if request.method == 'POST':
        form = OrderForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('orders_table') 
    else:
        form = OrderForm()
    return render(request, 'place_order.html', {'form': form})

def is_admin(user):
    return user.is_superuser

@user_passes_test(is_admin)
def orders_table(request):
    orders = Order.objects.all()
    return render(request, 'orders_table.html', {'orders': orders})


