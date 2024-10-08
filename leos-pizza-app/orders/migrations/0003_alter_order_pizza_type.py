# Generated by Django 4.2.16 on 2024-09-24 04:52

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('orders', '0002_alter_order_pizza_type'),
    ]

    operations = [
        migrations.AlterField(
            model_name='order',
            name='pizza_type',
            field=models.CharField(choices=[('Margherita', 'Margherita'), ('Pepperoni', 'Pepperoni'), ('Vegetarian', 'Vegetarian'), ('Hawaiian', 'Hawaiian'), ('BBQ Chicken', 'BBQ Chicken'), ('Four Cheese', 'Four Cheese'), ('Mushroom', 'Mushroom'), ('Mexicana', 'Mexicana'), ('Buffalo Chicken', 'Buffalo Chicken'), ('Meat Lovers', 'Meat Lovers'), ('Supreme', 'Supreme'), ('Spinach and Feta', 'Spinach and Feta'), ('Cheeseburger Pizza', 'Cheeseburger Pizza'), ('Philly Cheesesteak', 'Philly Cheesesteak'), ('White Pizza', 'White Pizza'), ('Garlic Chicken', 'Garlic Chicken'), ('Taco Pizza', 'Taco Pizza'), ('Seafood Pizza', 'Seafood Pizza'), ('Sausage and Pepperoni', 'Sausage and Pepperoni'), ('BBQ Bacon', 'BBQ Bacon')], max_length=50),
        ),
    ]
