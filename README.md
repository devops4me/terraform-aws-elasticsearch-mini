
# aws elasticsearch


# AWS ElasticSearch Stack | Create Use Case

## How to Create a New ELK eco module

Before creating the elasticsearch stack run through this check list.

- (recreate) RENAME
    - directory to new elk.xxxxx module
    - INI file to new elk.xxxxx.ini
    - Ruby file to new elk.xxxxx.rb
    - Ruby class within .rb to ElkLab
    - command string to ... create elk.xxxxx
    
- Go to reusable.templates/terraform and create an aws.elk.xxxx.tf
- Go to plugin elk.xxx.ini and change inventory line to aws.elk.xxxx.tf
- BUG - there has to be something in runnables otherwise inventory does not get pulled in? - BUG

- check the local elk.stack.ini for any changes
   - check the root domain and its hosted zone ID match (in Route53)
   - why is root domain duplicated in server section?
   - in fact do we even need the server section - look into it wit a view to erasing the duplication
- within known-hosts.ini add elk.stack.host workstation/eco-system connector line
- within known-hosts.ini check the host AWS credentials and also the secrets folders
- within known-hosts.ini check the server section especially the root domain
- make sure the aws.iam.credentials INI file contains the correct IAM programmatic user keys
          - elk.stack.aws.credentials.ini
          - elk.lab.aws.credentials.ini
          - elk.prod.aws.credentials.ini
          - elk.dev.aws.credentials.ini

- Do a GIT ADD
     - git add plugin.modules/elk.xxx
     - git add reusable.templates/terraform/aws.elk.xxxx.tf

- Do a git commit -am "New eco-system environment module added."


## The Create Command

From the plugin.execute directory.

```bash
ruby eco.do.rb create -w elk.stack --debug
```

The logging endpoint looks like this.
```
https://search-log-elk-stack-18190-1859-045-gg2dwdc453f4upjbv5rvdcy5hu.eu-west-1.es.amazonaws.com/log-elk-stack-18190-1859-045
```

https://vpc-log-elk-stack-18210-2205-b7ayb46qj7v7gcaidfiiewyt7y.eu-west-1.es.amazonaws.com/

curl -XPUT https://vpc-log-elk-stack-18210-2205-b7ayb46qj7v7gcaidfiiewyt7y.eu-west-1.es.amazonaws.com/vpc-log-elk-stack-18210-2205/movie/1 -d '{"director": "Burton, Tim", "genre": ["Comedy","Sci-Fi"], "year": 1996, "actor": ["Jack Nicholson","Pierce Brosnan","Sarah Jessica Parker"], "title": "Mars Attacks!"}' -H 'Content-Type: application/json'


elasticsearch-901041531-1248838227.eu-west-2.elb.amazonaws.com
http://elasticsearch-901041531-1248838227.eu-west-2.elb.amazonaws.com

curl -XPUT https://elasticsearch-901041531-1248838227.eu-west-2.elb.amazonaws.com/movie/1 -d '{"director": "Burton, Tim", "genre": ["Comedy","Sci-Fi"], "year": 1996, "actor": ["Jack Nicholson","Pierce Brosnan","Sarah Jessica Parker"], "title": "Mars Attacks!"}' -H 'Content-Type: application/json'


curl -XPUT https://vpc-log-elk-stack-18210-2205-b7ayb46qj7v7gcaidfiiewyt7y.eu-west-1.es.amazonaws.com/movie/1 -d '{"director": "Burton, Tim", "genre": ["Comedy","Sci-Fi"], "year": 1996, "actor": ["Jack Nicholson","Pierce Brosnan","Sarah Jessica Parker"], "title": "Mars Attacks!"}' -H 'Content-Type: application/json'

https://search-log-elk-stack-18205-1708-zxohmsei7b6f4kcvgjxqvyjfe4.eu-west-1.es.amazonaws.com/

curl -XPUT https://search-log-elk-stack-18205-1708-zxohmsei7b6f4kcvgjxqvyjfe4.eu-west-1.es.amazonaws.com/log-elk-stack-18205-1708/movie/1 -d '{"director": "Burton, Tim", "genre": ["Comedy","Sci-Fi"], "year": 1996, "actor": ["Jack Nicholson","Pierce Brosnan","Sarah Jessica Parker"], "title": "Mars Attacks!"}' -H 'Content-Type: application/json'

### Creating an Index

curl -XPUT https://search-log-elk-stack-18190-1859-045-gg2dwdc453f4upjbv5rvdcy5hu.eu-west-1.es.amazonaws.com/log-elk-stack-18190-1859-045/movie/1 -d '{"director": "Burton, Tim", "genre": ["Comedy","Sci-Fi"], "year": 1996, "actor": ["Jack Nicholson","Pierce Brosnan","Sarah Jessica Parker"], "title": "Mars Attacks!"}' -H 'Content-Type: application/json'

The reply JSON string is this.

```json
{"_index":"log-elk-stack-18190-1859-045","_type":"movie","_id":"1","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":0,"_primary_term":1}
```

## Allow Account Users

This JSON policy allows users of the AWS account to access the elasticsearch domain.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "12345678901234"
        ]
      },
      "Action": [
        "es:*"
      ],
      "Resource": "arn:aws:es:eu-west-1:12345678901234:domain/log-elk-stack-18190-1859-045/*"
    }
  ]
}
```

## Allow Access from Specifif IP Addresses

This JSON policy allows users coming in from the listed IP Addresses to access the elasticsearch domain.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "es:*"
      ],
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": [
            "52.58.168.166",
            "52.58.168.167"
          ]
        }
      },
      "Resource": "arn:aws:es:eu-west-1:12345678901234:domain/log-elk-stack-18190-1859-045/*"
    }
  ]
}
```

arn:aws:es:eu-west-1:12345678901234:domain/log-elk-stack-18204-1514



curl -XPOST elasticsearch_domain_endpoint/_bulk --data-binary @bulk_movies.json -H 'Content-Type: application/json'

curl -XPOST https://search-log-elk-stack-18190-1859-045-gg2dwdc453f4upjbv5rvdcy5hu.eu-west-1.es.amazonaws.com/log-elk-stack-18190-1859-045/_bulk --data-binary @bulk-movies-db.json -H 'Content-Type: application/json'


curl -XPUT https://search-log-elk-stack-18190-1859-045-gg2dwdc453f4upjbv5rvdcy5hu.eu-west-1.es.amazonaws.com/log-elk-stack-18190-1859-045/movie/1 -d '{"director": "Burton, Tim", "genre": ["Comedy","Sci-Fi"], "year": 1996, "actor": ["Jack Nicholson","Pierce Brosnan","Sarah Jessica Parker"], "title": "Mars Attacks!"}' -H 'Content-Type: application/json'




https://vpc-log-elk-stack-18211-0524-jpcdvafdhav7ak2iig42ilgpuq.eu-west-1.es.amazonaws.com/

curl -XPUT https://vpc-log-elk-stack-18211-0524-jpcdvafdhav7ak2iig42ilgpuq.eu-west-1.es.amazonaws.com/vpc-log-elk-stack-18211-0524/movie/1 -d '{"director": "Burton, Tim", "genre": ["Comedy","Sci-Fi"], "year": 1996, "actor": ["Jack Nicholson","Pierce Brosnan","Sarah Jessica Parker"], "title": "Mars Attacks!"}' -H 'Content-Type: application/json'


https://vpc-log-elk-stack-18211-0823-buehk2igpe5cerzyl7gdc7bn7a.eu-west-1.es.amazonaws.com/

curl -XPUT https://vpc-log-elk-stack-18211-0823-buehk2igpe5cerzyl7gdc7bn7a.eu-west-1.es.amazonaws.com/vpc-log-elk-stack-18211-0823/movie/1 -d '{"director": "Burton, Tim", "genre": ["Comedy","Sci-Fi"], "year": 1996, "actor": ["Jack Nicholson","Pierce Brosnan","Sarah Jessica Parker"], "title": "Mars Attacks!"}' -H 'Content-Type: application/json'




cd ../Downloads/ssh.keys/library.ssh.access.keys
ssh ubuntu@build-business-websites.co.uk -i aws.bbw.private.key-converted.pem




https://vpc-log-elk-stack-18211-1207-vnr3dx3nql6uxdaeg5p2uf5sw4.eu-west-1.es.amazonaws.com

curl -XPUT https://vpc-log-elk-stack-18211-1207-vnr3dx3nql6uxdaeg5p2uf5sw4.eu-west-1.es.amazonaws.com/vpc-log-elk-stack-18211-1207/movie/1 -d '{"director": "Burton, Tim", "genre": ["Comedy","Sci-Fi"], "year": 1996, "actor": ["Jack Nicholson","Pierce Brosnan","Sarah Jessica Parker"], "title": "Mars Attacks!"}' -H 'Content-Type: application/json'


https:///

curl -XPUT https://vpc-log-elk-stack-18211-1310-mpc4dfvyqgtkdaw7zmhl2gthtm.eu-west-1.es.amazonaws.com/vpc-log-elk-stack-18211-1310/movie/1 -d '{"director": "Burton, Tim", "genre": ["Comedy","Sci-Fi"], "year": 1996, "actor": ["Jack Nicholson","Pierce Brosnan","Sarah Jessica Parker"], "title": "Mars Attacks!"}' -H 'Content-Type: application/json'





VPC ID       ~> vpc-a9f0d4c2    | vpc-lab-es-18211-1403
Subnet ID    ~> subnet-1c151b77 | subnet-lab-es-18211-1403
Security Grp ~> sg-8642c8ea     | acl.lab.es.18211.1403.054.thinkpad.io
CIDR Block   ~>10.255.0.0/16
VPC Endpoint ~> https://vpc-log-lab-es-18211-1403-skne24b7wsfzugmxn5hyfy7lwi.eu-central-1.es.amazonaws.com/
Kibana Url   ~> https://vpc-log-lab-es-18211-1403-skne24b7wsfzugmxn5hyfy7lwi.eu-central-1.es.amazonaws.com/_plugin/kibana/



curl -XPUT https://vpc-log-lab-es-18211-1403-skne24b7wsfzugmxn5hyfy7lwi.eu-central-1.es.amazonaws.com/vpc-log-lab-es-18211-1403/movie/1 -d '{"director": "Burton, Tim", "genre": ["Comedy","Sci-Fi"], "year": 1996, "actor": ["Jack Nicholson","Pierce Brosnan","Sarah Jessica Parker"], "title": "Mars Attacks!"}' -H 'Content-Type: application/json'

