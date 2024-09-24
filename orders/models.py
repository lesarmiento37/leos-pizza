from django.db import models

class Order(models.Model):
    PIZZA_CHOICES = [
        ('Margherita', 'Margherita'),
        ('Pepperoni', 'Pepperoni'),
        ('Vegetarian', 'Vegetarian'),
        ('Hawaiian', 'Hawaiian'),
        ('BBQ Chicken', 'BBQ Chicken'),
        ('Four Cheese', 'Four Cheese'),
        ('Mushroom', 'Mushroom'),
        ('Mexicana', 'Mexicana'),
        ('Buffalo Chicken', 'Buffalo Chicken'),
        ('Meat Lovers', 'Meat Lovers'),
        ('Supreme', 'Supreme'),
        ('Spinach and Feta', 'Spinach and Feta'),
        ('Cheeseburger Pizza', 'Cheeseburger Pizza'),
        ('Philly Cheesesteak', 'Philly Cheesesteak'),
        ('White Pizza', 'White Pizza'),
        ('Garlic Chicken', 'Garlic Chicken'),
        ('Taco Pizza', 'Taco Pizza'),
        ('Seafood Pizza', 'Seafood Pizza'),
        ('Sausage and Pepperoni', 'Sausage and Pepperoni'),
        ('BBQ Bacon', 'BBQ Bacon'),
    ]

    pizza_type = models.CharField(max_length=50, choices=PIZZA_CHOICES)
    comments = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.pizza_type} ({self.created_at})"
