variable "project_id" {
  type        = string
  description = "project id required"
}
variable "project_name" {
 type        = string
 description = "project name in which demo deploy"
}
variable "project_number" {
 type        = string
 description = "project number in which demo deploy"
}
variable "gcp_account_name" {
 description = "user performing the demo"
}
variable "org_id" {
 description = "Organization ID in which project created"
}
variable "cloud_composer_image_version" {
 description = "Version of Cloud Composer 2 image to use"
}
variable "spark_container_image_tag" {
 description = "Tag number to assign to container image"
}
variable "gcp_region" {
 description = "GCP region"
}
variable "gcp_zone" {
 description = "GCP zone"
}
variable "gcp_multi_region" {
 description = "GCP multi-region"
}
variable "bq_connector_jar_gcs_uri" {
 description = "BQ connector jar to use"
}
variable "cloud_scheduler_time_zone" {
 description = "Cloud Scheduler Time Zone e.g. America/Chicago"
}
variable "dataproc_runtime_version" {
 description = "Version of Dataproc Serverless Runtime"
}
