# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt /app/

# Install the required dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project into the container
COPY . /app/

# Set environment variables to prevent .pyc files and enable buffer
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Run migrations
RUN python manage.py migrate

# Create a script to create a superuser
COPY create_admin.py /app/create_admin.py

# Run the admin creation script
RUN python manage.py shell < create_admin.py

# Collect static files
RUN python manage.py collectstatic --noinput

# Set default environment variables for the superuser
ENV DJANGO_SUPERUSER_USERNAME=leonardo
ENV DJANGO_SUPERUSER_PASSWORD=leo123
ENV DJANGO_SUPERUSER_EMAIL=leonardo@example.com


# Expose port 8000
EXPOSE 8000

# Run the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
