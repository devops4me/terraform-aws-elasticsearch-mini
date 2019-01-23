
### ######################### ###
### [[module]] es_domain_mini ###
### ######################### ###

module es_domain_mini
{
    source          = ".."

    in_private_ids       = "${ module.vpc-network.out_public_subnet_ids }"
    in_security_group_id = "${ module.security-group.out_security_group_id }"

    in_ecosystem_name     = "${ var.in_ecosystem_name }"
    in_tag_timestamp      = "${ module.resource-tags.out_tag_timestamp }"
    in_tag_description    = "${ module.resource-tags.out_tag_description }"
}


### ---> ##################### <--- ### || < ####### > || ###
### ---> --------------------- <--- ### || < ------- > || ###
### ---> Network Layer Modules <--- ### || < Layer N > || ###
### ---> --------------------- <--- ### || < ------- > || ###
### ---> ##################### <--- ### || < ####### > || ###

/*
 | --
 | -- This module creates a VPC and then allocates subnets in a round robin manner
 | -- to each availability zone. For example if 8 subnets are required in a region
 | -- that has 3 availability zones - 2 zones will hold 3 subnets and the 3rd two.
 | --
 | -- Whenever and wherever public subnets are specified, this module knows to create
 | -- an internet gateway and a route out to the net.
 | --
*/
module vpc-network
{
    source                 = "github.com/devops4me/terraform-aws-vpc-network"

    in_vpc_cidr            = "10.77.0.0/16"
    in_num_public_subnets  = 2
    in_num_private_subnets = 0

    in_ecosystem_name     = "${ var.in_ecosystem_name }"
    in_tag_timestamp      = "${ module.resource-tags.out_tag_timestamp }"
    in_tag_description    = "${ module.resource-tags.out_tag_description }"
}


/*
 | --
 | -- I have used network flow logs in conjunction with the RabbitMQ
 | -- bench test tool (perf-test) to pinpoint the exact set of security
 | -- group rules that are neither overly permissive nor restrictive.
 | --
 | --    https://www.rabbitmq.com/clustering.html
 | --
 | -- The above URL makes the case for the ports required for RabbitMQ
 | -- to cluster correctly.
 | --
*/
module security-group
{
    source     = "github.com/devops4me/terraform-aws-security-group"
    in_ingress = [ "http", "https" ]
    in_vpc_id  = "${ module.vpc-network.out_vpc_id }"

    in_ecosystem_name     = "${ var.in_ecosystem_name }"
    in_tag_timestamp      = "${ module.resource-tags.out_tag_timestamp }"
    in_tag_description    = "${ module.resource-tags.out_tag_description }"
}


### ################################ ###
### [[module]] net_interfaces_module ###
### ################################ ###

module net_interfaces_module
{
    source      = "github.com/devops4me/terraform-network-interface-addresses"

    in_owner_id = "${ module.es_domain_mini.out_owner_id }"
    in_vpc_id   = "${ module.vpc-network.out_vpc_id }"

    ## if u remov this (unused) things may fail. Is it a workaround re : dependency (is owner ID not enough? Kill or document
    ## if u remov this (unused) things may fail. Is it a workaround re : dependency (is owner ID not enough? Kill or document
    ## if u remov this (unused) things may fail. Is it a workaround re : dependency (is owner ID not enough? Kill or document
    ## if u remov this (unused) things may fail. Is it a workaround re : dependency (is owner ID not enough? Kill or document
    ## if u remov this (unused) things may fail. Is it a workaround re : dependency (is owner ID not enough? Kill or document
    ## if u remov this (unused) things may fail. Is it a workaround re : dependency (is owner ID not enough? Kill or document
    ## if u remov this (unused) things may fail. Is it a workaround re : dependency (is owner ID not enough? Kill or document
    ## if u remov this (unused) things may fail. Is it a workaround re : dependency (is owner ID not enough? Kill or document
    in_dependency_holder = "${ module.es_domain_mini.out_kibana_endpoint }"
}


### ####################### ###
### [[module]] applb_module ###
### ####################### ###

/*
module load_balancer_module
{
    source              = "load.balancer"

    in_vpc_id           = "${ module.vpc-network.out_vpc_id }"
    in_subnet_ids       = [ "${ module.vpc-network.out_public_subnet_ids }" ]
    in_s_group_ids      = [ "${ module.security-group.out_security_group_id }" ]
    in_ip_addresses     = "${ module.net_interfaces_module.out_ip_addresses }"
    in_ip_address_count = "4"

    in_ecosystem_id = "legacy-eco-id"
    in_history_note = "Legacy eco-system history note."
}
*/


/*
 | --
 | -- The "http" load balancer front end listener exists for us
 | -- human beings to access the kibana web interface.
 | --
 | --   http://<kibana-load-balancer-dns-name>/_plugin/kibana
 | --
 | -- This lightweight setup sidesteps the browser's attempts to
 | -- warn us of invalid certificates.
 | --
 | -- This layer 7 load balancer is slower than its layer 4 cousin
 | -- which is fine as it only services human engineers.
 | --
*/
module kibana-load-balancer
{
    source                = "github.com/devops4me/terraform-aws-load-balancer"

    in_vpc_id             = "${ module.vpc-network.out_vpc_id }"
    in_subnet_ids         = "${ module.vpc-network.out_public_subnet_ids }"
    in_security_group_ids = [ "${ module.security-group.out_security_group_id }" ]
    in_ip_addresses     = "${ module.net_interfaces_module.out_eni_addresses }"

#############    in_ip_address_count   = "${ var.in_initial_node_count }"
#############    in_ip_address_count   = "${ var.in_initial_node_count }"
#############    in_ip_address_count   = "${ var.in_initial_node_count }"
#############    in_ip_address_count   = "${ var.in_initial_node_count }"
#############    in_ip_address_count   = "${ var.in_initial_node_count }"
#############    in_ip_address_count   = "${ var.in_initial_node_count }"
    in_ip_address_count   ="4"            ############ ---->  "${ var.in_initial_node_count }"
    in_lb_class           = "application"
    in_is_internal        = false

    in_front_end          = [ "http" ]
    in_back_end           = [ "https" ]

    in_ecosystem_name     = "${ var.in_ecosystem_name }"
    in_tag_timestamp      = "${ module.resource-tags.out_tag_timestamp }"
    in_tag_description    = "${ module.resource-tags.out_tag_description }"
}


/*
 | --
 | -- Remember the AWS resource tags! Using this module, every
 | -- infrastructure component is tagged to tell you 5 things.
 | --
 | --   a) who (which IAM user) created the component
 | --   b) which eco-system instance is this component a part of
 | --   c) when (timestamp) was this component created
 | --   d) where (in which AWS region) was this component created
 | --   e) which eco-system class is this component a part of
 | --
*/
module resource-tags
{
    source = "github.com/devops4me/terraform-aws-resource-tags"
}


### ######################### ###
### [[module]] route53_module ###
### ######################### ###
/*
module route53_dns_module
{
    source = "route53.dns"

    in_load_balancer_arn  = "${module.traffic_module.out_load_balancer_arn}"
    in_hosted_zone_id     = "${var.ssl.cert.id}" ##### USE environment to set this hosted zone id
    in_domain_url         = "${var.ssl.cert.id}" ##### USE environment to set this domain url
    in_ssl_cert_id        = "${var.ssl.cert.id}" ##### USE environment to set this cert id

    in_ecosystem_id = "${ module.ecosystem_id_module.ecosystem_id }"
    in_history_note = "${ module.ecosystem_id_module.history_note }"
}
*/

### ########################## ###
### [[module]] esdomain_module ###
### ########################## ###

/*
module esdomain_custom_heavyduty_module
{
    source = "esdomain"

    in_security_group_ids  = [ "${module.security-group.out_security_group_id}" ]
    in_private_ids = "${module.vpc-network.out_private_subnet_ids}"

    in_is_lightweight = false

    in_es_version   = "${var.es_settings["es.elastic.version"]}"
    in_worker_type  = "${var.es_settings["es.ec2.worker.type"]}"
    in_master_type  = "${var.es_settings["es.ec2.master.type"]}"
    in_worker_count = "${var.es_settings["es.ec2.worker.count"]}"
    in_master_count = "${var.es_settings["es.ec2.master.count"]}"
    in_zone_aware   = "${var.es_settings["es.zone.awareness"]}"
    in_volume_size  = "${var.es_settings["es.ebs.volume.size"]}"
    in_kms_key_ref  = "${var.es_settings["es.kms.key.ref"]}"
    in_snaphot_hour = "${var.es_settings["es.snaphot.hour"]}"


    in_ecosystem_id = "${ module.ecosystem_id_module.ecosystem_id }"
    in_history_note = "${ module.ecosystem_id_module.history_note }"
}
*/


################ ########################################################################################## ########
################ As this is the root module - variables can only originate from files and the command line. ########
################ ########################################################################################## ########

### ##################################### ###
### [[es.ecosys.auto.tfvars]] es_settings ###
### ##################################### ###

/*
variable "es_settings"
{
    type = "map"
}
*/



/*
 | --
 | -- Six cluster nodes are a good fit for regions with 3 availability zones
 | -- as failures in two zones will robustly see 2 nodes servicing the queue's
 | -- producers and consumers.
 | --
 | -- Even with the auto-scaling solution you should look to maintain a minimum
 | -- of 6 nodes and upscale in multiples of 3 capped at 60 nodes.
 | --
 | -- If you have an eye on costs then consider downgrading the instance type
 | -- rather than the number of instances.
 | --
*/
variable in_initial_node_count
{
    description = "The number of nodes that this cluster will be brought up with."
    default = 6
}


/*
 | --
 | -- You can override this variable and pass in a more appropriate
 | -- name for the eco-system (or subsystem) being engineered.
 | --
*/
variable in_ecosystem_name
{
    description = "The name of this ecosystem which by default is rabbitmq-cluster."
    default = "elasticsearch"
}
