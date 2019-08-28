
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
