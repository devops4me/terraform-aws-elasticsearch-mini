
####### ############################################### ########
######## Outputs for the Terraform [[esdomain]] module. ########
######## ############################################## ########


### ########################## ###
### [[output]] out_es_endpoint ###
### ########################## ###

output out_es_endpoint {
    description = "The elasticsearch domain endpoint for constructing its url."
    value       = aws_elasticsearch_domain.mini.endpoint
}


### ####################### ###
### [[output]] out_owner_id ###
### ####################### ###

/*
output out_owner_id {
    description = "The ID set by AWS of the owner of the AWS ElasticSearch cluster."
    value       = "${local.es_owner_id}"
}
*/

### ############################## ###
### [[output]] out_kibana_endpoint ###
### ############################## ###

/*
output out_kibana_endpoint {
    description = "The elasticsearch domain kibana endpoint without the https scheme."
    value       = "${aws_elasticsearch_domain.mini.kibana_endpoint}"
}
*/

