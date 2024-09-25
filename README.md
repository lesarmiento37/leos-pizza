
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

By following these steps, you have set up an automated pipeline using AWS CodeBuild to deploy the Leo's Pizza web application to Amazon EKS. Terraform is used to manage the infrastructure, ensuring that the CodeBuild project is correctly configured.

### Verify the Application Deployment

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

# Cluster Autoscaler and HPA Configuration for Leo's Pizza App

## 1. Install Cluster Autoscaler on EKS

The Cluster Autoscaler automatically adjusts the number of nodes in your EKS cluster based on the demands of your applications. Follow these steps to install and configure it:

### Step 1.1: Create an IAM Policy for the Cluster Autoscaler

Create an IAM policy that grants the Cluster Autoscaler permissions to interact with EC2 Auto Scaling groups. Save the following policy as `cluster_autoscaler_policy.json`:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*"
        }
    ]
}
```

### Step 1.2: Create the IAM Policy in AWS

Run the following command to create the policy:

```bash
aws iam create-policy --policy-name EKSClusterAutoscalerPolicy --policy-document file://cluster_autoscaler_policy.json
```

### Step 1.3: Create the Service Account and Attach IAM Role

Use `eksctl` to create a Kubernetes service account for the Cluster Autoscaler and attach the IAM policy:

```bash
eksctl create iamserviceaccount   --name cluster-autoscaler   --namespace kube-system   --cluster <cluster-name>   --attach-policy-arn arn:aws:iam::<account-id>:policy/EKSClusterAutoscalerPolicy   --approve   --override-existing-serviceaccounts
```

Replace `<cluster-name>` and `<account-id>` with your EKS cluster name and AWS account ID.

### Step 1.4: Deploy the Cluster Autoscaler

Use Helm to deploy the Cluster Autoscaler:

```bash
helm install cluster-autoscaler autoscaler/cluster-autoscaler   --namespace kube-system   --set autoDiscovery.clusterName=<cluster-name>   --set awsRegion=<region>   --set rbac.create=true   --set serviceAccount.name=cluster-autoscaler
```

Verify the Cluster Autoscaler is running by checking the logs:

```bash
kubectl logs -f deployment/cluster-autoscaler -n kube-system
```

## 2. Install the Metrics Server

The Metrics Server is required for the Horizontal Pod Autoscaler (HPA) to retrieve CPU and memory metrics. Install it using the following command:

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Verify the Metrics Server is running:

```bash
kubectl get deployment metrics-server -n kube-system
```

## 3. Configure Resource Limits for Leo's Pizza App

To enable the HPA to scale based on CPU utilization, you must define resource requests and limits for the Leo's Pizza app. Update the `deployment.yaml` with CPU requests and limits:

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
        image: your-docker-image:latest
        ports:
        - containerPort: 8000
        resources:
          requests:
            cpu: "100m"  # Request 100 millicores (0.1 CPU)
          limits:
            cpu: "500m"  # Limit to 500 millicores (0.5 CPU)
```

Apply the updated deployment:

```bash
kubectl apply -f deployment.yaml
```

## 4. Set Up Horizontal Pod Autoscaler (HPA)

Now, configure the HPA to scale the Leo's Pizza app based on CPU utilization.

### Step 4.1: Create the HPA YAML File

```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: leos-pizza-hpa
  namespace: pizza  # Make sure this matches your namespace
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: leos-pizza-deployment
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 50  # Target 50% CPU utilization
```

Save this file as `pizza-hpa.yml` and apply it using:

```bash
kubectl apply -f pizza-hpa.yml
```

### Step 4.2: Verify the HPA

Check the status of the HPA to ensure it’s functioning correctly:

```bash
kubectl get hpa -n pizza
```

You should see the `TARGETS` field populated with the CPU utilization of the pods. If metrics are missing, ensure the Metrics Server is properly installed.

![image](https://github.com/user-attachments/assets/4b00b337-a503-4b76-a3e1-9ed2e2f363a2)


## 5. Testing and Monitoring

### Step 5.1: Generate Load

To test the HPA, generate some CPU load on the app (e.g., by running CPU-heavy processes or sending multiple requests).
```bash
kubectl exec -it <pod-name> -n <namespace> -- /bin/sh -c "while true; do :; done"
```
After applied a significant load to the Leo's Pizza app by simulating a high number of HTTP requests to the application. As a result, the CPU usage increased, and the Horizontal Pod Autoscaler (HPA) scaled the number of replicas to handle the load.

Result:
As the load increased, the HPA dynamically scaled the number of replicas to handle the additional CPU demand. Here’s what we observed:

Initially, the number of pods was set to the default minimum of 1 replicas.
As the load increased and CPU usage exceeded 50%, the HPA started to incrementally scale up the pods.
The autoscaler continued scaling up the pods until it reached the maximum configured limit of 10 replicas.

The number of replicas has changed.


![image](https://github.com/user-attachments/assets/7227544a-5204-4d2a-84a4-5d647a3c22d0)
The hpa metrics:


![image](https://github.com/user-attachments/assets/8f7b88e9-20b0-41a3-9d31-04d2be6d8ef3)


After the workload-generating tasks were stopped, it is evident that the HPA returns to its initial charge of a pod. 


![image](https://github.com/user-attachments/assets/93ab5a00-6a10-40a6-878f-d0b9475a0f1a)


### Step 5.2: Monitor Scaling

Monitor the scaling of the pods using the following command:

```bash
kubectl get pods -w -n pizza
```

Watch how the HPA scales the number of replicas based on CPU usage.

## Conclusion

Following this guide, you should be able to deploy the Leo's Pizza web application on AWS EKS successfully. This setup provides a scalable environment suitable for production usage.

For further customization or additional features, refer to the official Django and Kubernetes documentation.
 