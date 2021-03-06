
/*
 | --
 | -- This resource porovisions an ElasticSearch cluster service with the requested
 | -- number of nodes and returns a service endpoint to us.
 | --
*/
resource aws_elasticsearch_domain mini {

    domain_name           = "${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"
    elasticsearch_version = var.in_es_version

    cluster_config {

        instance_type            = var.in_worker_type
    	instance_count           = var.in_worker_count
    	dedicated_master_enabled = false
    	zone_awareness_enabled   = false
    }

    vpc_options {

        security_group_ids  = [ var.in_security_group_id ]
        subnet_ids          = [ element( var.in_subnet_ids, 0 ) ]
    }

/*
    access_policies = data.aws_iam_policy_document.es-cloud-iam-policy.json
*/

    ebs_options {
        ebs_enabled = true
        volume_size = var.in_volume_size
        volume_type = "gp2"
    }

    advanced_options = {
        "rest.action.multi.allow_explicit_index" = "true"
    }

    tags = merge( local.elasticsearch_tags, var.in_mandated_tags )

}



/*
 | --
 | -- As this module evolves, a feature will be added to optionally pass in
 | -- the desired policy statements thus overriding this most commonly used
 | -- access policy.
 | --
*/
resource aws_elasticsearch_domain_policy access {

  domain_name = aws_elasticsearch_domain.mini.domain_name
  access_policies = data.template_file.es_policy_stmts.rendered

}



/*
 | --
 | -- This JSON file embodies the access policies for an elasticsearch
 | -- instance that gives or denies access to the resource.
 | --
*/
data template_file es_policy_stmts {
    template = file( "${path.module}/elasticsearch-access.json" )
    vars = {
        elasticsearch_domain_name = aws_elasticsearch_domain.mini.arn
    }

}



/*
 | --
 | -- Allow the ElasticSearch cluster management service to bring up ec2 instance
 | -- nodes and perform some other necessary activities.
 | --
data aws_iam_policy_document es-cloud-iam-policy {

    statement {

        effect = "Allow"
        principals {
            type = "AWS"
            identifiers = ["*"]
        }
        actions = ["es:*"]
        resources = [
            "arn:aws:es:${data.aws_region.with.name}:${data.aws_caller_identity.with.account_id}:domain/${var.in_ecosystem_name}/*"
        ]
    }
}
*/



locals {

    elasticsearch_tags = {
        Name  = "es-${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"
        Desc  = "This elasticsearch cluster for the ${ var.in_ecosystem_name } ${ var.in_tag_description }"
    }

}


### ############################ ###
### [[data]] aws_caller_identity ###
### ############################ ###

/*
data aws_caller_identity with {
}
*/

### ################### ###
### [[data]] aws_region ###
### ################### ###

/*
data aws_region with {
}
*/
