from django.shortcuts import render, redirect
from .forms import OrderForm
from .models import Order
from django.contrib.auth.decorators import user_passes_test

# Order Placement Form View (Accessible to all users)
def place_order(request):
    if request.method == 'POST':
        form = OrderForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('place_order')  # Redirect back to the form after placing the order
    else:
        form = OrderForm()
    return render(request, 'place_order.html', {'form': form})

# Helper function to check if the user is an admin
def is_admin(user):
    return user.is_superuser

# Orders Table View (Restricted to admins only)
@user_passes_test(is_admin)
def orders_table(request):
    orders = Order.objects.all()
    return render(request, 'orders_table.html', {'orders': orders})
