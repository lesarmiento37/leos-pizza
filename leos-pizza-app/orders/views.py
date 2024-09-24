from django.shortcuts import render, redirect
from .forms import OrderForm
from .models import Order

def place_order(request):
    if request.method == 'POST':
        form = OrderForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('orders_table')
    else:
        form = OrderForm()
    return render(request, 'place_order.html', {'form': form})

# Orders Table View
def orders_table(request):
    orders = Order.objects.all()
    return render(request, 'orders_table.html', {'orders': orders})
