# Initial setup steps to prepare infrastructure

# gcloud init to set up gcloud cli

export TF_USER=${USER}. # user account, replace if not current user name
export TF_VAR_BILLING_ACCOUNT=$(gcloud beta billing accounts list | awk 'NR==2' | cut -d " " -f1)
export TF_ADMIN=${TF_USER}-terraform-admin
# export PROJECT_NAME="Your project name"

# Create New Project
gcloud projects create ${PROJECT_NAME} \
  --set-as-default

# Link Project to Billing Account
gcloud beta billing projects link ${PROJECT_NAME} \
  --billing-account ${TF_VAR_BILLING_ACCOUNT}

# Set credentials configuration json
export TF_CREDS=keys/terraform-admin.json

# create service account in Terraform Admin Project
gcloud iam service-accounts create terraform \
  --display-name "Terraform Admin Account"

# download JSON credentials
gcloud iam service-accounts keys create ${TF_CREDS} \
  --iam-account terraform@${PROJECT_NAME}.iam.gserviceaccount.com

# grant service account permission to view Admin Project & Manage Cloud Storage
for ROLE in 'container.admin' 'iam.serviceAccountAdmin' 'compute.admin' 'storage.admin' 'iam.roleAdmin' 'resourcemanager.projectIamAdmin'; do
  gcloud projects add-iam-policy-binding ${PROJECT_NAME} \
    --member serviceAccount:terraform@${PROJECT_NAME}.iam.gserviceaccount.com \
    --role roles/${ROLE}
done

# Enable API for terraform
for API in 'cloudresourcemanager' 'cloudbilling' 'iam' 'compute'; do
  gcloud services enable "${API}.googleapis.com"
done

# Once the above is finished, setup the terraform workspace and init file to run terraform apply

