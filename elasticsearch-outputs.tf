
####### ############################################### ########
######## Outputs for the Terraform [[esdomain]] module. ########
######## ############################################## ########


### ################################ ###
### [[output]] out_elasticsearch_url ###
### ################################ ###

output out_elasticsearch_url {
    description = "The elasticsearch domain endpoint for constructing its url."
    value       = aws_elasticsearch_domain.mini.endpoint
}
