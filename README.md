
# Leo's Pizza Web Application Deployment Guide

This README provides detailed steps to deploy the Leo's Pizza web application using Django and AWS Elastic Kubernetes Service (EKS). The application allows users to place pizza orders and enables administrators to view the orders.

## Prerequisites

Before you start the deployment, ensure you have the following:

- **AWS Account**: Ensure you have administrative access.
- **AWS CLI**: Installed and configured with administrative credentials.
- **kubectl**: Configured to interact with your AWS account.
- **Docker**: Installed for creating the application image.
- **Python**: Version 3.x and Django installed for local setup and tests.
- **EKSCTL**: Tool for creating and managing Kubernetes clusters on AWS.

## Deployment Overview

1. [Setup the EKS Cluster](#1-setup-the-eks-cluster)
2. [Dockerize the Django Application](#2-dockerize-the-django-application)
3. [Deploy Django Application on Kubernetes](#3-deploy-django-application-on-kubernetes)
4. [Verify the Application Deployment](#4-verify-the-application-deployment)

## Detailed Steps

### 1. Setup the EKS Cluster

Create an Amazon EKS cluster where the application will be deployed, please take in account the file leonardo.tfvars to deploy the required cluster:

```bash
cd leos-pizza-tf-cluster
terraform init
terraform plan -var-file="leonardo.tfvars"
terraform apply -var-file="leonardo.tfvars" --auto-approve
```

### 2. Dockerize the Django Application

Package the Django application into a Docker container:

1. **Navigate to your project directory** where the Django project is located.

2. **Create a Dockerfile**:

   ```Dockerfile
        Use an official Python runtime as a parent image
        FROM python:3.9-slim
        WORKDIR /app
        COPY requirements.txt /app/
        RUN pip install --no-cache-dir -r requirements.txt
        COPY . /app/
        ENV PYTHONDONTWRITEBYTECODE 1
        ENV PYTHONUNBUFFERED 1
        RUN python manage.py migrate
        COPY create_admin.py /app/create_admin.py
        RUN python manage.py shell < create_admin.py
        RUN python manage.py collectstatic --noinput
        ENV DJANGO_SUPERUSER_USERNAME=leonardo
        ENV DJANGO_SUPERUSER_PASSWORD=leo123
        ENV DJANGO_SUPERUSER_EMAIL=leonardo@example.com
        EXPOSE 8000
        CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
   ```

## Overview of the Deployment Pipeline

1. **CodeBuild Setup**:
   - The buildspec.yaml defines the build pipeline.
   - CodeBuild will build the Docker image, push it to ECR, and deploy the application to EKS.

2. **Terraform Setup**:
   - Terraform is used to create the CodeBuild project and other AWS resources.
   
3. **Buildspec.yaml**:
   - The `buildspec.yaml` defines the stages of the build, including Docker image build, ECR push, and EKS deployment.

### 1. Trigger the Build

Once the CodeBuild project is created with Terraform and the `buildspec.yaml` file is in the repository, you can trigger the build:

1. Go to the AWS CodeBuild console.
2. Select the project created by Terraform (`leos-pizza-build`).
3. Start the build.

CodeBuild will pull the latest code from your repository, build the Docker image, push it to ECR, and deploy it to EKS.

### 2. Verify the Deployment

After the build is complete, check the status of your EKS deployment by running:

```bash
kubectl get svc leos-pizza-service
```

You should be able to access the application via the LoadBalancer’s external IP.

## Conclusion

By following these steps, you have set up an automated pipeline using AWS CodeBuild to deploy the Leo's Pizza web application to Amazon EKS. Terraform is used to manage the infrastructure, ensuring that the CodeBuild project is correctly configured.


### 3. Deploy Django Application on Kubernetes

Deploy your application using kubectl:

1. **Create a deployment.yaml file** for the Kubernetes deployment:

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: leos-pizza-deployment
   spec:
     replicas: 3
     selector:
       matchLabels:
         app: leos-pizza
     template:
       metadata:
         labels:
           app: leos-pizza
       spec:
         containers:
         - name: leos-pizza
           image: yourusername/leos-pizza-app:latest
           ports:
           - containerPort: 8000
   ```

2. **Deploy the application**:

   ```bash
   kubectl apply -f deployment.yaml
   ```

3. **Expose the application using a LoadBalancer**:

   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: leos-pizza-service
   spec:
     type: LoadBalancer
     ports:
       - port: 80
         targetPort: 8000
     selector:
       app: leos-pizza
   ```

   Apply the service configuration:

   ```bash
   kubectl apply -f service.yaml
   ```

### 4. Verify the Application Deployment

Check that the deployment is running and the service is exposed:

1. **Get the service details**:

   ```bash
   kubectl get svc leos-pizza-service
   ```

2. **Access the application** through the external IP or DNS name provided by the LoadBalancer.

## Troubleshooting

If you encounter issues during deployment, check the following:

- **Pod Status**: Ensure all pods are in `Running` state (`kubectl get pods`).
- **Logs**: Check logs for any application or deployment errors (`kubectl logs <pod_name>`).

## Conclusion

Following this guide, you should be able to deploy the Leo's Pizza web application on AWS EKS successfully. This setup provides a scalable environment suitable for production usage.

For further customization or additional features, refer to the official Django and Kubernetes documentation.
