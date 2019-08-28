
####### ########################################################## ########
######## Data sources for the Terraform [[es.domain.mini]] module. ########
####### ########################################################## ########

####### ################################################# ########
######## Variables for the Terraform [[esdomain]] module. ########
######## ################################################ ########


### ########################## ###
### [[variable]] in_es_version ###
### ########################## ###

variable in_es_version {
    description = "The required version of elasticsearch."
    default = "6.3"
}


### ########################### ###
### [[variable]] in_worker_type ###
### ########################### ###

variable in_worker_type {
    description = "The ec2 instance type to use for elasticsearch worker nodes."
    default = "t2.small.elasticsearch"
}


### ########################### ###
### [[variable]] in_master_type ###
### ########################### ###

variable in_master_type {
    description = "The ec2 instance type to use for elasticsearch master nodes."
    default = "t2.small.elasticsearch"
}


### ############################ ###
### [[variable]] in_worker_count ###
### ############################ ###

variable in_worker_count {
    description = "The (mandatorily even) ec2 elasticsearch worker node count so that half are deployed in each of the 2 zones."
    default = "4"
}


### ############################ ###
### [[variable]] in_master_count ###
### ############################ ###

variable in_master_count {
    description = "The (mandatorily even) ec2 elasticsearch master node count so that half are deployed in each of the 2 zones."
    default = "2"
}


### ##################################### ###
### [[variable]] in_use_dedicated_masters ###
### ##################################### ###

variable in_use_dedicated_masters {
    description = "True means that dedicated master nodes will be used."
    default = "false"
}


### ########################## ###
### [[variable]] in_zone_aware ###
### ########################## ###

variable in_zone_aware {
    description = "Use the (maximum) two availability zones instead of just one."
    default = "true"
}


### ########################### ###
### [[variable]] in_volume_size ###
### ########################### ###

variable in_volume_size {
    description = "The size of the EBS volume."
    default = "16"
}


### ########################### ###
### [[variable]] in_kms_key_ref ###
### ########################### ###

variable in_kms_key_ref {
    description = "The reference part of the KMS key arn for encrypting data at rest."
    default = ""
}


### ############################ ###
### [[variable]] in_snaphot_hour ###
### ############################ ###

variable in_snaphot_hour {
    description = "What hour of the day should AWS take the daily elasticsearch volume snapshot."
    default = "22"
}


### ################################## ###
### [[variable]] in_security_group_ids ###
### ################################## ###

variable in_security_group_id {
    description = "The security group that constrains traffic going in and coming out of elasticsearch."
}


### ########################## ###
### [[variable]] in_subnet_ids ###
### ########################## ###

variable in_private_ids {
    type = "list"
}


### ################# ###
### in_ecosystem_name ###
### ################# ###

variable in_ecosystem_name {
    description = "Creational stamp binding all infrastructure components created on behalf of this ecosystem instance."
}


### ################ ###
### in_tag_timestamp ###
### ################ ###

variable in_tag_timestamp {
    description = "A timestamp for resource tags in the format ymmdd-hhmm like 80911-1435"
}


### ################## ###
### in_tag_description ###
### ################## ###

variable in_tag_description {
    description = "Ubiquitous note detailing who, when, where and why for every infrastructure component."
}
