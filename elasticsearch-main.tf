
### ################################## ###
### [[local]] module visible variables ###
### ################################## ###

locals
{
    es_owner_id = "amazon-elasticsearch"
}


### ##################################### ###
### [[resource]] aws_elasticsearch_domain ###
### ##################################### ###

resource aws_elasticsearch_domain mini
{
    domain_name           = "${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"
    elasticsearch_version = "${var.in_es_version}"

    cluster_config
    {
        instance_type            = "${var.in_worker_type}"
    	instance_count           = "${var.in_worker_count}"
    	dedicated_master_enabled = "${var.in_use_dedicated_masters}"
    	zone_awareness_enabled   = "${var.in_zone_aware}"
    }

    vpc_options
    {
        security_group_ids  = [ "${var.in_security_group_id}" ]
        subnet_ids          = [ "${var.in_private_ids}" ]
    }

    access_policies = "${data.aws_iam_policy_document.es-cloud-iam-policy.json}"

    ebs_options
    {
        ebs_enabled = true
        volume_size = "${var.in_volume_size}"
        volume_type = "gp2"
    }

    advanced_options
    {
        "rest.action.multi.allow_explicit_index" = "true"
    }

    tags
    {
        Name  = "${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"
        Class = "${ var.in_ecosystem_name }"
        Desc  = "This mini elasticsearch domain ${ var.in_tag_description }"
    }

}


### ################################ ###
### [[data]] aws_iam_policy_document ###
### ################################ ###

data aws_iam_policy_document es-cloud-iam-policy
{
    statement
    {
        effect = "Allow"
        principals
        {
            type = "AWS"
            identifiers = ["*"]
        }
        actions = ["es:*"]

        # ----> ##########################################################################
        # ----> ##########################################################################
        # ----> ##########################################################################
        # ----> #### I believe there could be two bugs below (definitely one).
        # ----> ####     [1] - the "cluster-" does not appear in the working famous 18236-1147 cluster below.
        # ----> ####     [2] - check that the aws_region.with.name gives eu-west-1 and not EU (Ireland) ...
        # ----> ##########################################################################
        # ----> ##########################################################################
        # ----> ##########################################################################
        resources = [
            "arn:aws:es:${data.aws_region.with.name}:${data.aws_caller_identity.with.account_id}:domain/${var.in_ecosystem_name}/*"
        ]
        # ----> ##########################################################################
        # ----> ##########################################################################
    }
}
