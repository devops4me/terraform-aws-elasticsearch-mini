
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
    	dedicated_master_enabled = var.in_use_dedicated_masters
    	zone_awareness_enabled   = var.in_zone_aware
    }

    vpc_options {

        security_group_ids  = [ var.in_security_group_id ]
        subnet_ids          = var.in_private_ids
    }

    access_policies = data.aws_iam_policy_document.es-cloud-iam-policy.json

    ebs_options {
        ebs_enabled = true
        volume_size = var.in_volume_size
        volume_type = "gp2"
    }

    advanced_options = {
        "rest.action.multi.allow_explicit_index" = "true"
    }

    tags = {
        Name  = "${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"
        Class = var.in_ecosystem_name
        Desc  = "This mini elasticsearch domain ${ var.in_tag_description }"
    }

}


/*
 | --
 | -- Allow the ElasticSearch cluster management service to bring up ec2 instance
 | -- nodes and perform some other necessary activities.
 | --
*/
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


### ############################ ###
### [[data]] aws_caller_identity ###
### ############################ ###

data aws_caller_identity with {
}


### ################### ###
### [[data]] aws_region ###
### ################### ###

data aws_region with {
}
