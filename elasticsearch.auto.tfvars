
### ########################### ###
### [[auto tfvars]] es_settings ###
### ########################### ###

es_settings
{
    "es.ec2.worker.type"    = "m3.medium.elasticsearch"
    "es.ec2.master.type"    = "m3.medium.elasticsearch"
    "es.ec2.worker.count"   = "6"
    "es.ec2.master.count"   = "3"
    "es.elastic.version"    = "6.3"

    "es.ebs.volume.size"    = "64"
    "es.dedicated.master"   = "true"
    "es.zone.awareness"     = "true"

    "es.encrypt.at.rest"    = "true"
    "es.kms.key.ref"         = ""

    "es.peering.vpc.id"     = ""
    "es.domain.root.url"    = ""

    "es.cm.ssl.cert.id"     = ""
    "es.snaphot.hour"       = "20"
}
