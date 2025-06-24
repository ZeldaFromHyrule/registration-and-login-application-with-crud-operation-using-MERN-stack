# MERN App Deployment on Azure with Terraform, Docker, and GitHub Actions

## Table of Contents
- [Project Overview](#project-overview)
- [Prerequisites](#prerequisites)
- [Repository Structure](#repository-structure)
- [Configuration](#configuration)
- [Terraform Deployment](#terraform-deployment)
- [Docker & Azure Container Registry (ACR)](#docker--azure-container-registry-acr)
- [GitHub Actions Workflow](#github-actions-workflow)
- [Environment Variables & Secrets](#environment-variables--secrets)
- [Updating & Redeployment](#updating--redeployment)
- [Cleaning Up](#cleaning-up)

## Project Overview
This repository demonstrates how to deploy a MERN (MongoDB, Express, React, Node.js) application to Azure using:
1. **Terraform** for infrastructure as code (Resource Group, ACR, Web Apps).
2. **Docker** to containerize frontend and backend services.
3. **GitHub Actions** to automate building, pushing Docker images to ACR, and deploying updates to Azure Web Apps.

## Prerequisites
- An **Azure** subscription.
- **Terraform** v1.** installed.
- **Azure CLI**.
- **Docker** installed and running.
- A **GitHub** repository with this code.
- GitHub **Secrets**:
  - `AZURE_CREDENTIALS`
  - `ACR_USERNAME`
  - `ACR_PASSWORD`
  - `MONGO_URI`

## Repository Structure
```
├── backend/                 # Node.js/Express backend
├── frontend/                # React frontend
├── main.tf                  # Terraform configuration
├── variables.tf             # Terraform variables definitions
├── terraform.tfvars         # Terraform variable values
└── .github/
    └── workflows/
        └── build-and-deploy.yml  # GitHub Actions workflow
```

## Configuration
1. **Terraform Variables**: Edit `variables.tf` and `terraform.tfvars` for:
   - `resource_group_name`
   - `location`
   - `acr_name`
   - `container_app_env_name`

2. **Terraform Backend** (optional): Configure remote state if needed.

## Terraform Deployment
```bash
# Initialize Terraform
terraform init

# Review changes
terraform plan

# Apply infrastructure
terraform apply
```
This creates:
- Resource Group
- Azure Container Registry (ACR)
- User-assigned Managed Identity
- Role assignments for ACR push/pull
- App Service Plan (Linux)
- Two Linux Web Apps: backend and frontend with managed identity

## Docker & Azure Container Registry (ACR)
- Backend and frontend Dockerfiles live in `backend/` and `frontend/`.
- Images are tagged with a timestamp and pushed to ACR.

## GitHub Actions Workflow
Located at `.github/workflows/build-and-deploy.yml`, the workflow:
1. Checks out code.
2. Logs into Azure and ACR.
3. Builds Docker images for backend and frontend.
4. Pushes images to ACR.
5. Updates Azure Web Apps to use new images and restarts them.
6. Configures CORS and app settings.

Trigger manually via "Run workflow" in GitHub.

## Environment Variables & Secrets
- `AZURE_CREDENTIALS`: Azure service principal JSON.
- `ACR_USERNAME` & `ACR_PASSWORD`: ACR admin credentials.
- `MONGO_URI`: MongoDB connection string.
- `TIMESTAMP`: Auto-generated build tag in workflow.

## Updating & Redeployment
To apply code or container updates:
1. Push commits to the repository.
2. Manually trigger or configure workflow triggers (e.g., on `main` push).
3. Workflow rebuilds images, pushes to ACR, and updates web apps.

## Cleaning Up
To destroy all resources:
```bash
terraform destroy
```
