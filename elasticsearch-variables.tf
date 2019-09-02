
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
    default = "7.1"
}


### ########################### ###
### [[variable]] in_worker_type ###
### ########################### ###

variable in_worker_type {
    description = "The ec2 instance type to use for elasticsearch worker nodes."
    default = "m5.large.elasticsearch"
}


### ############################ ###
### [[variable]] in_worker_count ###
### ############################ ###

variable in_worker_count {
    description = "The (mandatorily even) ec2 elasticsearch worker node count so that half are deployed in each of the 2 zones."
    default = 2
}


### ########################### ###
### [[variable]] in_volume_size ###
### ########################### ###

variable in_volume_size {
    description = "The size of the EBS volume."
    default = 32
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

variable in_subnet_ids {
    description = "The list of subnets that the elasticsearch cluster nodes will inhabit."
    type = list
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


### ############################## ###
### [[variable]] in_mandated_tags ###
### ############################## ###

variable in_mandated_tags {

    description = "Optional tags unless your organization mandates that a set of given tags must be set."
    type        = map
    default     = { }
}


