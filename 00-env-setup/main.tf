/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/******************************************
Local variables declaration
 *****************************************/

locals {
project_id                  = "${var.project_id}"
project_nbr                 = "${var.project_number}"
admin_upn_fqn               = "${var.gcp_account_name}"
location                    = "us-central1"
zone                        = "us-central1-a"
umsa                        = "s8s-lab-sa"
umsa_fqn                    = "${local.umsa}@${local.project_id}.iam.gserviceaccount.com"
s8s_spark_bucket            = "s8s-spark-bucket-${local.project_nbr}"
s8s_spark_bucket_fqn        = "gs://s8s-spark-${local.project_nbr}"
s8s_spark_sphs_nm           = "s8s-sphs-${local.project_nbr}"
s8s_spark_sphs_bucket       = "s8s-sphs-${local.project_nbr}"
s8s_spark_sphs_bucket_fqn   = "gs://s8s-sphs-${local.project_nbr}"
vpc_nm                      = "s8s-vpc-${local.project_nbr}"
spark_subnet_nm             = "spark-snet"
spark_subnet_cidr           = "10.0.0.0/16"
psa_ip_length               = 16
s8s_data_bucket             = "s8s_data_bucket-${local.project_nbr}"
s8s_code_bucket             = "s8s_code_bucket-${local.project_nbr}"
s8s_notebook_bucket         = "s8s_notebook_bucket-${local.project_nbr}"
s8s_model_bucket            = "s8s_model_bucket-${local.project_nbr}"
s8s_metrics_bucket          = "s8s_metrics_bucket-${local.project_nbr}"
s8s_artifact_repository_nm  = "s8s-spark-${local.project_nbr}"
bq_datamart_ds              = "customer_churn_ds"
umnb_server_machine_type    = "e2-medium"
umnb_server_nm              = "s8s-spark-ml-pipelines-nb-server"
mnb_server_machine_type     = "n1-standard-4"
mnb_server_nm               = "s8s-spark-ml-interactive-nb-server"
CC_GMSA_FQN                 = "service-${local.project_nbr}@cloudcomposer-accounts.iam.gserviceaccount.com"
GCE_GMSA_FQN                = "${local.project_nbr}-compute@developer.gserviceaccount.com"
CLOUD_COMPOSER2_IMG_VERSION = "${var.cloud_composer_image_version}"
SPARK_CONTAINER_IMG_VERSION = "${var.container_image_version}"
}

/******************************************
1. Update organization policies in parallel
 *****************************************/
resource "google_project_organization_policy" "orgPolicyUpdate_disableSerialPortLogging" {
  project     = var.project_id
  constraint = "compute.disableSerialPortLogging"
  boolean_policy {
    enforced = false
  }
}

resource "google_project_organization_policy" "orgPolicyUpdate_requireOsLogin" {
  project     = var.project_id
  constraint = "compute.requireOsLogin"
  boolean_policy {
    enforced = false
  }
}

resource "google_project_organization_policy" "orgPolicyUpdate_requireShieldedVm" {
  project     = var.project_id
  constraint = "compute.requireShieldedVm"
  boolean_policy {
    enforced = false
  }
}

resource "google_project_organization_policy" "orgPolicyUpdate_vmCanIpForward" {
  project     = var.project_id
  constraint = "compute.vmCanIpForward"
  list_policy {
    allow {
      all = true
    }
  }
}

resource "google_project_organization_policy" "orgPolicyUpdate_vmExternalIpAccess" {
  project     = var.project_id
  constraint = "compute.vmExternalIpAccess"
  list_policy {
    allow {
      all = true
    }
  }
}

resource "google_project_organization_policy" "orgPolicyUpdate_restrictVpcPeering" {
  project     = var.project_id
  constraint = "compute.restrictVpcPeering"
  list_policy {
    allow {
      all = true
    }
  }
}

/*******************************************
Introducing sleep to minimize errors from
dependencies having not completed
********************************************/
resource "time_sleep" "sleep_after_org_policy_updates" {
  create_duration = "120s"
  depends_on = [
    google_project_organization_policy.orgPolicyUpdate_disableSerialPortLogging,
    google_project_organization_policy.orgPolicyUpdate_requireOsLogin,
    google_project_organization_policy.orgPolicyUpdate_requireShieldedVm,
    google_project_organization_policy.orgPolicyUpdate_vmCanIpForward,
    google_project_organization_policy.orgPolicyUpdate_vmExternalIpAccess,
    google_project_organization_policy.orgPolicyUpdate_restrictVpcPeering
  ]
}

/******************************************
2. Enable Google APIs in parallel
 *****************************************/

resource "google_project_service" "enable_orgpolicy_google_apis" {
  project = var.project_id
  service = "orgpolicy.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    time_sleep.sleep_after_org_policy_updates
  ]
}

resource "google_project_service" "enable_compute_google_apis" {
  project = var.project_id
  service = "compute.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    time_sleep.sleep_after_org_policy_updates
  ]
}

resource "google_project_service" "enable_container_google_apis" {
  project = var.project_id
  service = "container.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    time_sleep.sleep_after_org_policy_updates
  ]
}

resource "google_project_service" "enable_containerregistry_google_apis" {
  project = var.project_id
  service = "containerregistry.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    time_sleep.sleep_after_org_policy_updates
  ]
}

resource "google_project_service" "enable_dataproc_google_apis" {
  project = var.project_id
  service = "dataproc.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    time_sleep.sleep_after_org_policy_updates
  ]
}

resource "google_project_service" "enable_bigquery_google_apis" {
  project = var.project_id
  service = "bigquery.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    time_sleep.sleep_after_org_policy_updates
  ]
}

resource "google_project_service" "enable_storage_google_apis" {
  project = var.project_id
  service = "storage.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    time_sleep.sleep_after_org_policy_updates
  ]
}

resource "google_project_service" "enable_notebooks_google_apis" {
  project = var.project_id
  service = "notebooks.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    time_sleep.sleep_after_org_policy_updates
  ]
}

resource "google_project_service" "enable_aiplatform_google_apis" {
  project = var.project_id
  service = "aiplatform.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    time_sleep.sleep_after_org_policy_updates
  ]
}

resource "google_project_service" "enable_logging_google_apis" {
  project = var.project_id
  service = "logging.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    time_sleep.sleep_after_org_policy_updates
  ]
}

resource "google_project_service" "enable_monitoring_google_apis" {
  project = var.project_id
  service = "monitoring.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    time_sleep.sleep_after_org_policy_updates
  ]
}
resource "google_project_service" "enable_servicenetworking_google_apis" {
  project = var.project_id
  service = "servicenetworking.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    time_sleep.sleep_after_org_policy_updates
  ]
}

resource "google_project_service" "enable_cloudbuild_google_apis" {
  project = var.project_id
  service = "cloudbuild.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    time_sleep.sleep_after_org_policy_updates
  ]
}

resource "google_project_service" "enable_artifactregistry_google_apis" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    time_sleep.sleep_after_org_policy_updates
  ]
}

resource "google_project_service" "enable_cloudresourcemanager_google_apis" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    time_sleep.sleep_after_org_policy_updates
  ]
}

resource "google_project_service" "enable_composer_google_apis" {
  project = var.project_id
  service = "composer.googleapis.com"
  disable_dependent_services = true
}

/*******************************************
Introducing sleep to minimize errors from
dependencies having not completed
********************************************/
resource "time_sleep" "sleep_after_api_enabling" {
  create_duration = "180s"
  depends_on = [
    google_project_service.enable_orgpolicy_google_apis,
    google_project_service.enable_compute_google_apis,
    google_project_service.enable_container_google_apis,
    google_project_service.enable_containerregistry_google_apis,
    google_project_service.enable_dataproc_google_apis,
    google_project_service.enable_bigquery_google_apis,
    google_project_service.enable_storage_google_apis,
    google_project_service.enable_servicenetworking_google_apis,
    google_project_service.enable_aiplatform_google_apis,
    google_project_service.enable_notebooks_google_apis,
    google_project_service.enable_cloudbuild_google_apis,
    google_project_service.enable_artifactregistry_google_apis,
    google_project_service.enable_cloudresourcemanager_google_apis,
    google_project_service.enable_composer_google_apis
  ]
}

/******************************************
3. Create User Managed Service Account 
 *****************************************/
module "umsa_creation" {
  source     = "terraform-google-modules/service-accounts/google"
  project_id = local.project_id
  names      = ["${local.umsa}"]
  display_name = "User Managed Service Account"
  description  = "User Managed Service Account for Serverless Spark"
   depends_on = [time_sleep.sleep_after_api_enabling]
}

/******************************************
4a. Grant IAM roles to User Managed Service Account
 *****************************************/

module "umsa_role_grants" {
  source                  = "terraform-google-modules/iam/google//modules/member_iam"
  service_account_address = "${local.umsa_fqn}"
  prefix                  = "serviceAccount"
  project_id              = local.project_id
  project_roles = [
    
    "roles/iam.serviceAccountUser",
    "roles/iam.serviceAccountTokenCreator",
    "roles/storage.objectAdmin",
    "roles/storage.admin",
    "roles/metastore.admin",
    "roles/metastore.editor",
    "roles/dataproc.worker",
    "roles/bigquery.dataEditor",
    "roles/bigquery.admin",
    "roles/dataproc.editor",
    "roles/artifactregistry.writer",
    "roles/logging.logWriter",
    "roles/cloudbuild.builds.editor",
    "roles/aiplatform.admin",
    "roles/aiplatform.viewer",
    "roles/aiplatform.user",
    "roles/viewer",
    "roles/composer.worker",
    "roles/composer.admin"
  ]
  depends_on = [
    module.umsa_creation
  ]
}

# IAM role grants to Google Managed Service Account for Cloud Composer 2
module "gmsa_role_grants_cc" {
  source                  = "terraform-google-modules/iam/google//modules/member_iam"
  service_account_address = "${local.CC_GMSA_FQN}"
  prefix                  = "serviceAccount"
  project_id              = local.project_id
  project_roles = [
    
    "roles/composer.ServiceAgentV2Ext",
  ]
  depends_on = [
    module.umsa_role_grants
  ]
}

# IAM role grants to Google Managed Service Account for Compute Engine (for Cloud Composer 2 to download images)
module "gmsa_role_grants_gce" {
  source                  = "terraform-google-modules/iam/google//modules/member_iam"
  service_account_address = "${local.GCE_GMSA_FQN}"
  prefix                  = "serviceAccount"
  project_id              = local.project_id
  project_roles = [
    
    "roles/editor",
  ]
  depends_on = [
    module.umsa_role_grants
  ]
}


/******************************************************
5. Grant Service Account Impersonation privilege to yourself/Admin User
 ******************************************************/

module "umsa_impersonate_privs_to_admin" {
  source  = "terraform-google-modules/iam/google//modules/service_accounts_iam/"
  service_accounts = ["${local.umsa_fqn}"]
  project          = local.project_id
  mode             = "additive"
  bindings = {
    "roles/iam.serviceAccountUser" = [
      "user:${local.admin_upn_fqn}"
    ],
    "roles/iam.serviceAccountTokenCreator" = [
      "user:${local.admin_upn_fqn}"
    ]

  }
  depends_on = [
    module.umsa_creation
  ]
}

/******************************************************
6. Grant IAM roles to Admin User/yourself
 ******************************************************/

module "administrator_role_grants" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  projects = ["${local.project_id}"]
  mode     = "additive"

  bindings = {
    "roles/storage.admin" = [
      "user:${local.admin_upn_fqn}",
    ]
    "roles/metastore.admin" = [

      "user:${local.admin_upn_fqn}",
    ]
    "roles/dataproc.admin" = [
      "user:${local.admin_upn_fqn}",
    ]
    "roles/bigquery.admin" = [
      "user:${local.admin_upn_fqn}",
    ]
    "roles/bigquery.user" = [
      "user:${local.admin_upn_fqn}",
    ]
    "roles/bigquery.dataEditor" = [
      "user:${local.admin_upn_fqn}",
    ]
    "roles/bigquery.jobUser" = [
      "user:${local.admin_upn_fqn}",
    ]
    "roles/composer.environmentAndStorageObjectViewer" = [
      "user:${local.admin_upn_fqn}",
    ]
    "roles/iam.serviceAccountUser" = [
      "user:${local.admin_upn_fqn}",
    ]
    "roles/iam.serviceAccountTokenCreator" = [
      "user:${local.admin_upn_fqn}",
    ]
    "roles/composer.admin" = [
      "user:${local.admin_upn_fqn}",
    ]
    "roles/aiplatform.user" = [
      "user:${local.admin_upn_fqn}",
    ]
     "roles/aiplatform.admin" = [
      "user:${local.admin_upn_fqn}",
    ]
     "roles/compute.networkAdmin" = [
      "user:${local.admin_upn_fqn}",
    ]
  }
  depends_on = [
    module.umsa_role_grants,
    module.umsa_impersonate_privs_to_admin
  ]
  }

/*******************************************
Introducing sleep to minimize errors from
dependencies having not completed
********************************************/
resource "time_sleep" "sleep_after_identities_permissions" {
  create_duration = "120s"
  depends_on = [
    module.umsa_creation,
    module.umsa_role_grants,
    module.umsa_impersonate_privs_to_admin,
    module.administrator_role_grants,
    module.gmsa_role_grants_cc,
    module.gmsa_role_grants_gce
  ]
}

/************************************************************************
7. Create VPC network, subnet & reserved static IP creation
 ***********************************************************************/
module "vpc_creation" {
  source                                 = "terraform-google-modules/network/google"
  project_id                             = local.project_id
  network_name                           = local.vpc_nm
  routing_mode                           = "REGIONAL"

  subnets = [
    {
      subnet_name           = "${local.spark_subnet_nm}"
      subnet_ip             = "${local.spark_subnet_cidr}"
      subnet_region         = "${local.location}"
      subnet_range          = local.spark_subnet_cidr
      subnet_private_access = true
    }
  ]
  depends_on = [
    time_sleep.sleep_after_identities_permissions
  ]
}

resource "google_compute_global_address" "reserved_ip_for_psa_creation" { 
  provider      = google-beta
  name          = "private-service-access-ip"
  purpose       = "VPC_PEERING"
  network       =  "projects/${local.project_id}/global/networks/s8s-vpc-${local.project_nbr}"
  address_type  = "INTERNAL"
  prefix_length = local.psa_ip_length
  
  depends_on = [
    module.vpc_creation
  ]
}

resource "google_service_networking_connection" "private_connection_with_service_networking" {
  network                 =  "projects/${local.project_id}/global/networks/s8s-vpc-${local.project_nbr}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.reserved_ip_for_psa_creation.name]

  depends_on = [
    module.vpc_creation,
    google_compute_global_address.reserved_ip_for_psa_creation
  ]
}

/******************************************
8. Create Firewall rules 
 *****************************************/

resource "google_compute_firewall" "allow_intra_snet_ingress_to_any" {
  project   = local.project_id 
  name      = "allow-intra-snet-ingress-to-any"
  network   = local.vpc_nm
  direction = "INGRESS"
  source_ranges = [local.spark_subnet_cidr]
  allow {
    protocol = "all"
  }
  description        = "Creates firewall rule to allow ingress from within Spark subnet on all ports, all protocols"
  depends_on = [
    module.vpc_creation, 
    module.administrator_role_grants
  ]
}

/*******************************************
Introducing sleep to minimize errors from
dependencies having not completed
********************************************/
resource "time_sleep" "sleep_after_network_and_firewall_creation" {
  create_duration = "120s"
  depends_on = [
    module.vpc_creation,
    google_compute_firewall.allow_intra_snet_ingress_to_any
  ]
}

/******************************************
9. Create Storage bucket 
 *****************************************/

resource "google_storage_bucket" "s8s_spark_bucket_creation" {
  project                           = local.project_id 
  name                              = local.s8s_spark_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
  depends_on = [
      time_sleep.sleep_after_network_and_firewall_creation
  ]
}

resource "google_storage_bucket" "s8s_spark_sphs_bucket_creation" {
  project                           = local.project_id 
  name                              = local.s8s_spark_sphs_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
  depends_on = [
      time_sleep.sleep_after_network_and_firewall_creation
  ]
}

resource "google_storage_bucket" "s8s_data_bucket_creation" {
  project                           = local.project_id 
  name                              = local.s8s_data_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
  depends_on = [
      time_sleep.sleep_after_network_and_firewall_creation
  ]
}

resource "google_storage_bucket" "s8s_code_bucket_creation" {
  project                           = local.project_id 
  name                              = local.s8s_code_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
  depends_on = [
      time_sleep.sleep_after_network_and_firewall_creation
  ]
}

resource "google_storage_bucket" "s8s_notebook_bucket_creation" {
  project                           = local.project_id 
  name                              = local.s8s_notebook_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
  depends_on = [
      time_sleep.sleep_after_network_and_firewall_creation
  ]
}

resource "google_storage_bucket" "s8s_model_bucket_creation" {
  project                           = local.project_id 
  name                              = local.s8s_model_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
  depends_on = [
      time_sleep.sleep_after_network_and_firewall_creation
  ]
}

resource "google_storage_bucket" "s8s_metrics_bucket_creation" {
  project                           = local.project_id 
  name                              = local.s8s_metrics_bucket
  location                          = local.location
  uniform_bucket_level_access       = true
  force_destroy                     = true
  depends_on = [
      time_sleep.sleep_after_network_and_firewall_creation
  ]
}

/*******************************************
Introducing sleep to minimize errors from
dependencies having not completed
********************************************/

resource "time_sleep" "sleep_after_bucket_creation" {
  create_duration = "60s"
  depends_on = [
    google_storage_bucket.s8s_data_bucket_creation,
    google_storage_bucket.s8s_code_bucket_creation,
    google_storage_bucket.s8s_notebook_bucket_creation,
    google_storage_bucket.s8s_spark_sphs_bucket_creation,
    google_storage_bucket.s8s_spark_bucket_creation,
    google_storage_bucket.s8s_model_bucket_creation,
    google_storage_bucket.s8s_metrics_bucket_creation,
  ]
}

/******************************************
10. Post startup scripts for notebook instances
 *****************************************/

resource "null_resource" "umnbs_post_startup_bash_creation" {
    provisioner "local-exec" {
        command = "sed -i s/PROJECT_NBR/${local.project_nbr}/g ../02-scripts/bash/umnbs-exec-post-startup.sh"
    }
}

resource "null_resource" "mnbs_post_startup_bash_creation" {
    provisioner "local-exec" {
        command = "sed -i s/PROJECT_NBR/${local.project_nbr}/g ../02-scripts/bash/mnbs-exec-post-startup.sh"
    }
}

/******************************************
11. Copy of datasets, scripts and notebooks to buckets
 *****************************************/

resource "google_storage_bucket_object" "datasets_upload_to_gcs" {
  for_each = fileset("../01-datasets/", "*")
  source = "../01-datasets/${each.value}"
  name = "${each.value}"
  bucket = "${local.s8s_data_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation
  ]
}

resource "google_storage_bucket_object" "pyspark_scripts_dir_upload_to_gcs" {
  for_each = fileset("../02-scripts/", "*")
  source = "../02-scripts/${each.value}"
  name = "${each.value}"
  bucket = "${local.s8s_code_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation
  ]
}

resource "google_storage_bucket_object" "pyspark_scripts_upload_to_gcs" {
  for_each = fileset("../02-scripts/pyspark/", "*")
  source = "../02-scripts/pyspark/${each.value}"
  name = "pyspark/${each.value}"
  bucket = "${local.s8s_code_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation,
    google_storage_bucket_object.pyspark_scripts_dir_upload_to_gcs
  ]
}

resource "google_storage_bucket_object" "notebooks_dir_create_in_gcs" {
  for_each = fileset("../03-notebooks/", "*")
  source = "../03-notebooks/${each.value}"
  name = "03-notebooks/${each.value}"
  bucket = "${local.s8s_notebook_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation
  ]
}

resource "google_storage_bucket_object" "notebooks_pyspark_upload_to_gcs" {
  for_each = fileset("../03-notebooks/pyspark/", "*")
  source = "../03-notebooks/pyspark/${each.value}"
  name = "pyspark/${each.value}"
  bucket = "${local.s8s_notebook_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation,
    google_storage_bucket_object.notebooks_dir_create_in_gcs
  ]
}

resource "google_storage_bucket_object" "notebooks_vai_pipelines_upload_to_gcs" {
  for_each = fileset("../03-notebooks/vai-pipelines/", "*")
  source = "../03-notebooks/vai-pipelines/${each.value}"
  name = "vai-pipelines/${each.value}"
  bucket = "${local.s8s_notebook_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation,
    google_storage_bucket_object.notebooks_dir_create_in_gcs
  ]
}

resource "google_storage_bucket_object" "bash_dir_create_in_gcs" {
  for_each = fileset("../02-scripts/", "*")
  source = "../02-scripts/${each.value}"
  name = "${each.value}"
  bucket = "${local.s8s_code_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation,
    null_resource.umnbs_post_startup_bash_creation,
    null_resource.mnbs_post_startup_bash_creation,
    time_sleep.sleep_after_bucket_creation
  ]
}

resource "google_storage_bucket_object" "bash_scripts_upload_to_gcs" {
  for_each = fileset("../02-scripts/bash/", "*")
  source = "../02-scripts/bash/${each.value}"
  name = "bash/${each.value}"
  bucket = "${local.s8s_code_bucket}"
  depends_on = [
    time_sleep.sleep_after_bucket_creation,
    null_resource.umnbs_post_startup_bash_creation,
    null_resource.mnbs_post_startup_bash_creation
  ]
}

/*******************************************
Introducing sleep to minimize errors from
dependencies having not completed
********************************************/

resource "time_sleep" "sleep_after_network_and_storage_steps" {
  create_duration = "120s"
  depends_on = [
      time_sleep.sleep_after_network_and_firewall_creation,
      time_sleep.sleep_after_bucket_creation,
      google_storage_bucket_object.notebooks_vai_pipelines_upload_to_gcs,
      google_storage_bucket_object.notebooks_pyspark_upload_to_gcs,
      google_storage_bucket_object.pyspark_scripts_upload_to_gcs
  ]
}

/******************************************
12a. PHS creation
******************************************/

resource "google_dataproc_cluster" "sphs_creation" {
  project  = local.project_id 
  provider = google-beta
  name     = local.s8s_spark_sphs_nm
  region   = local.location

  cluster_config {
    
    endpoint_config {
        enable_http_port_access = true
    }

    staging_bucket = local.s8s_spark_bucket
    
    # Override or set some custom properties
    software_config {
      image_version = "2.0"
      override_properties = {
        "dataproc:dataproc.allow.zero.workers"=true
        "dataproc:job.history.to-gcs.enabled"=true
        "spark:spark.history.fs.logDirectory"="${local.s8s_spark_sphs_bucket_fqn}/*/spark-job-history"
        "mapred:mapreduce.jobhistory.read-only.dir-pattern"="${local.s8s_spark_sphs_bucket_fqn}/*/mapreduce-job-history/done"
      }      
    }
    gce_cluster_config {
      subnetwork =  "projects/${local.project_id}/regions/${local.location}/subnetworks/${local.spark_subnet_nm}" 
      service_account = local.umsa_fqn
      service_account_scopes = [
        "cloud-platform"
      ]
    }
  }
  depends_on = [
    module.administrator_role_grants,
    module.vpc_creation,
    time_sleep.sleep_after_network_and_storage_steps
  ]  
}

/******************************************
12b. BigQuery dataset creation
******************************************/

resource "google_bigquery_dataset" "bq_dataset_creation" {
  dataset_id                  = local.bq_datamart_ds
  location                    = "US"
}


/******************************************************************
12c. Vertex AI Workbench - User Managed Notebook Server Creation
******************************************************************/

resource "google_notebooks_instance" "umnb_server_creation" {
  project  = local.project_id 
  name = local.umnb_server_nm
  location = local.zone
  machine_type = "e2-medium"

  service_account = local.umsa_fqn
  network = "projects/${local.project_id}/global/networks/s8s-vpc-${local.project_nbr}"
  subnet = "projects/${local.project_id}/regions/${local.location}/subnetworks/${local.spark_subnet_nm}"
  post_startup_script = "gs://${local.s8s_code_bucket}/bash/umnbs-exec-post-startup.sh" 

  vm_image {
    project      = "deeplearning-platform-release"
    image_family = "common-cpu"
  }
  depends_on = [
    module.administrator_role_grants,
    module.vpc_creation,
    time_sleep.sleep_after_network_and_storage_steps,
    google_storage_bucket_object.bash_scripts_upload_to_gcs,
    google_storage_bucket_object.notebooks_vai_pipelines_upload_to_gcs
  ]  
}

/******************************************************************
12d. Vertex AI Workbench - Managed Notebook Server Creation
******************************************************************/

resource "google_notebooks_runtime" "mnb_server_creation" {
  project              = local.project_id
  provider             = google-beta
  name                 = local.mnb_server_nm
  location             = local.location

  access_config {
    access_type        = "SERVICE_ACCOUNT"
    runtime_owner      = local.umsa_fqn
  }

  software_config {
    post_startup_script = "gs://${local.s8s_code_bucket}/bash/mnbs-exec-post-startup.sh"
    post_startup_script_behavior = "DOWNLOAD_AND_RUN_EVERY_START"
  }

  virtual_machine {
    virtual_machine_config {
      machine_type     = local.mnb_server_machine_type
      network = "projects/${local.project_id}/global/networks/s8s-vpc-${local.project_nbr}"
      subnet = "projects/${local.project_id}/regions/${local.location}/subnetworks/${local.spark_subnet_nm}" 

      data_disk {
        initialize_params {
          disk_size_gb = "100"
          disk_type    = "PD_STANDARD"
        }
      }
      container_images {
        repository = "gcr.io/deeplearning-platform-release/base-cpu"
        tag = "latest"
      }
    }
  }
  depends_on = [
    module.administrator_role_grants,
    module.vpc_creation,
    google_compute_global_address.reserved_ip_for_psa_creation,
    google_service_networking_connection.private_connection_with_service_networking,
    time_sleep.sleep_after_network_and_storage_steps,
    google_storage_bucket_object.bash_scripts_upload_to_gcs,
    google_storage_bucket_object.notebooks_pyspark_upload_to_gcs
  ]  
}

/********************************************************
12e. Artifact registry for serverless Spark images
********************************************************/

resource "google_artifact_registry_repository" "artifact_registry_creation" {
    location          = local.location
    repository_id     = local.s8s_artifact_repository_nm
    description       = "Artifact repository"
    format            = "DOCKER"
    depends_on = [
        module.administrator_role_grants,
        module.vpc_creation,
        google_project_service.enable_artifactregistry_google_apis,
        time_sleep.sleep_after_network_and_storage_steps
    ]  
}

/********************************************************
13. Create Docker Container image
********************************************************/

resource "null_resource" "custom_container_image_creation" {
    provisioner "local-exec" {

        command = "/bin/bash ../02-scripts/bash/build-container-image.sh ${local.SPARK_CONTAINER_IMG_VERSION}"
    }
    depends_on = [
        module.administrator_role_grants,
        module.vpc_creation,
        google_project_service.enable_artifactregistry_google_apis,
        time_sleep.sleep_after_network_and_storage_steps,
        google_artifact_registry_repository.artifact_registry_creation
    ]  
}

/********************************************************
14. Create Composer Environment
********************************************************/
resource "google_composer_environment" "cloud_composer_env_creation" {
  name   = "${local.project_id}-cc2"
  region = local.location
  provider = google-beta
  config {

    software_config {
      image_version = local.CLOUD_COMPOSER2_IMG_VERSION 
      env_variables = {
        AIRFLOW_VAR_CODE_BUCKET = "${local.s8s_code_bucket}"
        AIRFLOW_VAR_PHS = "${local.s8s_spark_sphs_nm}"
        AIRFLOW_VAR_PROJECT_ID = "${local.project_id}"
        AIRFLOW_VAR_REGION = "${local.location}"
        AIRFLOW_VAR_SUBNET = "${local.spark_subnet_nm}"
        AIRFLOW_VAR_BQ_DATASET = "${local.bq_datamart_ds}"
        AIRFLOW_VAR_UMSA = "${local.umsa}"
      }
    }

    node_config {
      network    = local.vpc_nm
      subnetwork = local.spark_subnet_nm
      service_account = local.umsa_fqn
    }
  }

  depends_on = [
    time_sleep.sleep_after_phs_creation
  ] 

  timeouts {
    create = "75m"
  } 
}

/*******************************************
Introducing sleep to minimize errors from
dependencies having not completed
********************************************/
resource "time_sleep" "sleep_after_composer_creation" {
  create_duration = "180s"
  depends_on = [
      google_composer_environment.cloud_composer_env_creation
  ]
}


/*******************************************
Introducing sleep to minimize errors from
dependencies having not completed
********************************************/

resource "time_sleep" "sleep_after_phs_creation" {
  create_duration = "180s"
  depends_on = [
      google_dataproc_cluster.sphs_creation,
      google_notebooks_instance.umnb_server_creation,
      google_artifact_registry_repository.artifact_registry_creation

  ]
}

/******************************************
12. Output important variables needed for the demo
******************************************/

output "PROJECT_ID" {
  value = local.project_id
}

output "PROJECT_NBR" {
  value = local.project_nbr
}

output "LOCATION" {
  value = local.location
}

output "VPC_NM" {
  value = local.vpc_nm
}

output "SPARK_SERVERLESS_SUBNET" {
  value = local.spark_subnet_nm
}

output "PERSISTENT_HISTORY_SERVER_NM" {
  value = local.s8s_spark_sphs_nm
}

output "UMSA_FQN" {
  value = local.umsa_fqn
}

output "DATA_BUCKET" {
  value = local.s8s_data_bucket
}

output "CODE_BUCKET" {
  value = local.s8s_code_bucket
}

output "NOTEBOOK_BUCKET" {
  value = local.s8s_notebook_bucket
}

output "USER_MANAGED_umnb_server_nm" {
  value = local.umnb_server_nm
}

/******************************************
DONE
******************************************/