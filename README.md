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

