import os
import django
from django.contrib.auth.models import User

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'pizza_project.settings')  
django.setup()

# Admin credentials
ADMIN_USERNAME = os.getenv('DJANGO_SUPERUSER_USERNAME', 'leonardo')
ADMIN_PASSWORD = os.getenv('DJANGO_SUPERUSER_PASSWORD', 'leo123')
ADMIN_EMAIL = os.getenv('DJANGO_SUPERUSER_EMAIL', 'leonardo@example.com')

# Create admin user if not exists
if not User.objects.filter(username=ADMIN_USERNAME).exists():
    User.objects.create_superuser(ADMIN_USERNAME, ADMIN_EMAIL, ADMIN_PASSWORD)
    print(f"Superuser '{ADMIN_USERNAME}' created successfully.")
else:
    print(f"Superuser '{ADMIN_USERNAME}' already exists.")
