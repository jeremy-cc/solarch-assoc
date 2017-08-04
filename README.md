# Solutions Architech Associate
##### Exam notes

###### Documentation:

1. [AWS S3 FAQ](https://aws.amazon.com/s3/faqs/)
2. [AWS EC2 FAQ](https://aws.amazon.com/ec2/faqs/)
3. [AWS ELB Classic FAQ](https://aws.amazon.com/elasticloadbalancing/classicloadbalancer/faqs/)
  
        
========

##### General notes on AWS

###### Regions and AZs:

1. A region is a distinct geographical area that comprises multiple Availability Zones
2. An availability zone is an isolated data centre or cluster of data centres that hosts AWS services within a region.
   A region contains at least two availability zones.
3. an Edge logation is an access point for AWS services - this is generally hosted in major urban areas, and is used
   mainly by systems such as CloudFront
   
   
###### IAM
   
1.  IAM is global, not bound to a region.
2.  IAM comprises users, groups, roles and policies.  
3.  Users can have api access (access keys) or username + password access ( console login ) - a user cannot log in
    to the console with an access key
    
###### IAM Roles
1.  Role types:
    1. AWS Service roles - permit AWS services to call other services on your behalf
    2. AWS Service linked roles - used for bots for things like Alexa / Polly
    3. Roles for cross account - permit one account to call another account, either yours or 3rd party
    4. Roles for Identity Provider access - permit OpenID, Single sign on etc access to AWS account
  
    
###### S3 - read FAQ before exam.
    
1.  S3 is a global namespace.  Bucket names must be unique across S3, not just across your account.
2.  URL Format:  https://s3-<region>.amazonaws.com/<bucketname>
3.  Consistency model:
    1.  Read after write consistency for PUT (new objects) 
    2.  Eventual consistency for Overwrite or delete (has non-zero propagation time)
4.  Sorts lexographically - data will stored in the same physical area on S3 and can cause performance bottlenecks.
    Consider salting file names with a random prefix for distribution
5.  Subresources
    1.  ACL - fine-grained permissions - at bucket level or at object level
    2.  Torrent - supports BitTorrent protocol
6.  SLA 99.9% but built for 99.99% - 11 9's durability guarantee
7.  S3 - IA (Infrequently accessed) - much cheaper
    S3 - RR (Reduced redundancy) - 99.99% availability over a year
    S3 vs Glacier - Glacier much cheaper but takes 3 - 5 hours to access data
8.  Charged for storage, request counts, storage management, data transfer, transfer acceleration
9.  For CRR, versioning must be on in the source and target buckets.  CRR will only replicate NEW objects.
    Old objects will be replicated if they are updated, and their entire history will be replicated as well.
    Object deletes are replicated but Object VERSION deletes are NOT replicated.
10. Can secure either via bucket policy or via ACLs
11. Transfer acceleration - use Cloudfront Edge location to speed upload to backing S3 bucket.
    
###### CloudFront

1.  Edge location - point at which content will be cached 'locally'
2.  Origin - original source of data [EC2, ALB, S3, Route53]
3.  Distribution - CDN consisting of 2 - N Edge locations
4.  can read from and write to Edge locations - writes are cached for the object's TTL.  You can expire early but you
    will be charged.
5.  two types - Web & RTMP     
6.  TTLs must be set to match periodicity of content
7.  Use signed cookies or urls to enforce access control onto resources.
8.  15-20 mins to provision a distribution.
9.  Possile to customise HTTP responses; restrict or permit (white XOR blacklist) by geographical location;  
10. Can create an *invalidation* to prevent caching of specific media objects on edge locations - billable.

###### Encryption
    
1.  In transit
    SSL/TLS
2.  At rest
    1. Server-side
        1. S3 managed keys - AES256 : SSE-S3
        2. SSE with KMS managed keys : SSE-KMS - permissioned envelope key + audit trail
        3. SSE with customer-provided keys - customer manages keys - SSE-C
    2. Client-side
        1. Encrypt client side, upload encrypted data to S3

###### Storage Gateway

1. acts as a async gateway between on-premise systems and AWS storage infrastructure (S3 and potentially Gateway)
2. downloadable as a virtual machine image - install and associate with AWS account
3. GW types:
   1. File Gateway (NFS) - store flat files in S3.  Permissions, ownership etc are stored as S3 metadata.  Once they are
   in S3 they can be managed as usual in S3 - versioning, ACL, bucket policies etc.
   2. Volumes Gateway (iSCSI) - store block 
      1. Stored volumes - store entire volume on premise.  Snapshots are written to AWS - use case for e.g backups.
      2. Cached volumes - store frequently accessed items locally, but S3 is the main data store for infrequent access.
      
      Volumes Gatway devices are virtual hard drives which can be saved as EBS snapshots (deltas) on AWS.
   3. Tape Gateway - VTL, create tape images then sync to AWS
      
###### Snowball
1. Legacy app was Import/Export - clients shipped physical drives to AWS for import but managing this became uneconomical
and impractical at large scale
2. 3 Types
   1. Snowball - beer-crate sized storage device.  Tamper-resistant, encrypted at rest, erased by Amazon once migration is complete
   2. Snowball Edge - similar sized appliance but has compute capabilities as well as just storage.  Essentially a small mobile
      AWS Data center that can cluster.  Support Lambda functions. 
   3. Snowmobile - peta/exabyte scale mobile AWS datacenter on truck.     
             
        
========

##### AWS Compute
        
###### EC2 - Elastic Compute Cloud
        
1.  Instance types : On Demand, Reserved (typically cheaper), Spot (at spot market rate), Dedicated Host (can be paid for by the hour)
2.  Spot instances - if the instance is terminated by AWS you do not pay for a partial hour of usage; if you terminate it you will be charged for any hour the instance ran

        | instance type  | Optimised for         |
        |  C             | Computation           |
        |  D             | Storage - Warehousing |
        |  F             | FPGA                  |
        |  G             | Graphics Intens       |
        |  I             | I/O  - RDBMS,NOSQL    |
        |  M             | General Purpose       |
        |  P             | Graphics / GPU        |
        |  R             | Memory (app/db)       |
        |  X             | Memory (Spark/bigdata)|
        
3. AMIs can be EBS backed or Instance Store (Ephemeral Storage) backed.
   1.  You cannot attach additional IS volumes once an instance is running.
   2.  You can only Reboot or Terminate an EC2 backed by IS.  Rebooting an instance backed by IS will not result
      in data loss, but if the underlying Hypervisor fails you effectively lose your data.
   3.  Instance Store used to be the only backing store; EBS is a newer feature.
   4.  Instance Store volumes do not display in the AWS Console.  Hence Ephemeral.
   5.  EC2 root EBS volumes are created from EBS snaphots.  EC2 root IS volumes are created from an S3 Template.
      IS root volumes can therefore take MORE time to provision than EBS volumes.
   6.  Root volumes are deleted on termination by default but you can instruct AWS not to delete EBS.  No option
      to do so for IS.
   7. instance metadata is available at http://169.254.169.254      
   
###### EC2 Placement Groups
   
1.  Permit a group of EC2 instances to be grouped logically within an AZ; share low latency 10Gbps network
2.  Cannot span AZs
3.  Must be uniquely named within the Account
4.  Limited to optimised instances (Compute / GPU / Storage / Memory optimised)
5.  AWS recommend homogenous instances within a placement group
6.  Cannot merge placement groups
7.  Cannot move running instances into a placement group; all instances must be launched into the placement group

###### EFS (Elastic File System)

1.  Supports NFS v4
2.  Pay for usage, not preprovisioned size.
3.  Scales to PB, supports thousands of concurrent NFS connections
4.  Data is stored across AZ's
5.  Block-based storage as opposed to object based (e.g S3)
6.  Read-after-write consistency.
7.  Good solution for sharing a usable filesystem between instances - e.g. code for websites / applications?
   
###### EBS (Elastic Block Storage)
        
1. Create logical block devices and attach them to EC2 instances.  Great for keeping filesystem deltas where if
   an instance dies you need to keep the data (e.g. jenkins CI)
2. EBS are in an AZ and are automatically replicated.
3. Types:   
   1.  SSD (GP2) - 3 IOPS (io/s) per gigabyte.  Up to 10k iops and burst of 3k iops/s for volumes < 1 Gb, bootable
   2.  Provisioned IOPS (IO1) - use for > 10k iops, bootable
   3.  Throughput-optimised HDD (ST1) (Magnetic) - Big Data / Warehousing / Log processing.  Sequential data, cannot be boot volumes
   4.  Cold HDD (SC1) -  fileservers.  low cost / infrequently accessed - cannot be boot volumes
   5.  Magnetic (Standard) - lowest cost / gig , bootable
4. EBS can only bind to one instance at a time.  For multiple instance sharing you have to use EFS
5. Never, ever create a Raid 5 device on EBS.  Amazon strongly de-incentivises this.
6. Snapshots of encrypted volumes are encrypted.  Likewise volumes restored from encrypted snapshots are encrypted.
7. You can only share unencrypted snapshots since the encryption keys are bound to your AWS accounts.  
8. You cannot delete an EBS snapshot if it is used as the root volume of a registered AMI.
   
###### Security Groups
   
1. Changes take place immediately
2. Security group ingress rules are automatically mirrored to egress - unlike VPC. 
3. All traffic is blocked by default; you can only PERMIT traffic.  You cannot DENY specific traffic.
4. 1 SG can apply to an infinity of EC2 instances

###### ALB And Health Checks

1. ALBs work at the application layer, support path based routing, and are recommended for HTTP traffic. Classic load
   balancers work at application or transport level but cannot do path-based routing.
2. ALBS route via Target Groups; Classic LBs route directly to EC2 instances.   
3. EC2 instances monitored by an ELB are reported as InService or OutOfService.
4. Health checks are conducted by connecting to the instances within an ALB or CLB.
5. ELBs are always addressed by DNS name; no IPv4 address is published for them.

###### Cloudwatch

1. Free tier updates metrics every 5 minutes; Detailed monitoring has granularity of 1 minute but is not free.
2. Metrics are for any Cloudwatch-enabled service
3. Default metrics for an EC2 instance are always CPU,Disk,Network and Status related by default.
4. Cloudwatch Alarms - permit notification when metrics exceed preconfigured limits e.g. 80% cpu usage, min credit etc. 
5. Cloudwatch Events - permit async rule-based triggers in response to Cloudwatch events e.g calling a Lambda function.
6. Cloudwatch Logs - permit log analysis such as exception monitoring, httpd access logs etc.
 
###### Lambda

1. Serverless compute service that abstracts away all lower level systems and abstractions.
2. Can be triggered from events (e.g. Cloudwatch) or in response to HTTP requests (API Gateway)
3. Need CORS permission - Access-Control-Allow-Origin: * 
  
###### RDS
  
1. RDS: Two different types of backup strategies - automated backups and database snapshots
    1. Automated Backups
        1. Automated backups permit recovery to any day within the retention period (1-35 days, defaulting to 7 days)
        2. Automated backups store take a full daily snapshot + transaction logs for the day.
        3. When restoring, the most recent Automated Backup is chosen and restored, followed with TX logs for the day,
       permitting recovery up to the second.
        4. Automated backups are enabled by default, and are backed up to S3.  Free S3 storage equivalent to RDS instance size
        5. Backups are taken during a defined window; during which time I/O latency may increase and storage I/O may be suspended
        6. Automated Backups are deleted if you delete the source RDS instance
    2. DB Snapshots
        1. DB snapshots are manual
2. Restored Automated backups AND snapshots are always created as a NEW RDS INSTANCE with a new endpoint 
3. Encryption at reset is supported, but you cannot encrypt an existing database; you need to create a new encrypted
   instance and migrate your unencrypted data into the encrypted instance.  Once an RDS instance is encrypted, all
   automated backups, snapshots and read replicas are encrypted as well.
4. Multi-AZ - you can have an RDS as a syncronous replica of an existing RDS in a separate AZ; if your primary RDS 
   fails, but you are set up Multi AZ, AWS will automatically fail over to the backup RDS using the same domain name.
   This is a DR solution, not a SCALING solution.
5. Read replicas are async replicas of the primary DB which can be used to boost performance.  This is a SCALING solution
   not a DR Solution.
   1.  Require automatic backups to be enabled
   2.  Can have up to 5 read replicas on a RDS instance
   3.  Can have read replicas of read replicas but latency stacks up very quickly. 
   4.  Each read replica has its own DNS entry.  Read replicas cannot be chained in Multi-AZ.  You can create read
   replicas of a Multi-AZ source DB though.
   5.  Read replicas can be promoted to source databases, but this breaks replication.
6. RDS scaling requires manual intervention e.g stopping instance to resize it.   
   
###### DynamoDB
                           
1. Is a fast NoSQL DB service
2. Supports documents AND key/value pairs.  Good fit for Web / Mobile / Game / IoT
3. Stored on SSD, spread across 3 different facilities (not necessarily AZ's)  
4. Supports Eventually Consistent Reads (1s consistency), Strongly-consistent reads (returns all data which was successfully written prior to read)                           
5. Pricing by provisioned throughput capacity
    1. Write throughput, hourly fee per 10 units
    2. Read throughput, hourly fee per 50 units
    3. Storage costs
6.  Expensive for writes, cheap for reads.
7.  Push-button scaling; can scale reads + writes on the fly    
    
###### Red Shift
 
1. Modes
    1. Single Node
    2. Multi-node which comprised a Leader node (manages clients) and up to 128 compute nodes (manage calculations)
    3. Column-based - used for aggregate queries and statistics
2. Distributes queries and data across all available nodes
3. Pricing
    1. compute node usage - 1 unit per node per hour
    2. backup
    3. data transfer, within a vpc
4. Encryption in transit, encrypted at rest using AES-256, can manage keys through hardware or KMS
5. Single AZ
6. Can restore snapshots to a new AZ if there's an outage.
7. Can be used to reduce load on primary transactional dbs caused by management running OLAP reports etc.

###### Elasticache

1. Permits deployment, operation and scale in-memory caches in AWS
2. Engines
    1. Memcached
    2. Redis - supports Multi-AZ and Master/Slave replication
3. Elasticache is a good choice to help reduce latency between app and db by caching results of calcs if the database
    is read heavy
    
###### Aurora
    
1. Maintains 2 copies of DB per AZ, minimum of 3 AZs, minimum of 6 copies of data.
2. Designed to sustain loss of 2 copies without affecting write availability and 3 copies without affecting read
    availability
3. Storage is self-healing
4. Two types of replicas
   1. Aurora replicas (up to 15) - fail over automatically
   2. Mysql Read Replicas (up to 5) - will require intervention to fail over
   
    
 
========

###### Route 53

1. Route53 is a GLOBAL service
2. SOA record holds
    1. server that supplied zone data
    2. administrator contact details
3. A record translates a domain name to an ip address.  This means you cannot route to a ELB via Route53 as ELBs do not have
    ipv4 or ipv6 addresses, just an amazon DNS entry.  You need to use an A or AAAA ALIAS record to route to an ELB.
4. TTL - cache length of DNS entry on server or resolving client.  Defaults in most places to 2 days.
5. CNAME - can resolve one domain name to another.  CNAME cannot map to the zone apex e.g google.com.  CNAME could map
   www.google.com
6. ALIAS records are specific to AWS and are not a DNS standard.  ALIAS records can map to zone apexes, and map these
  most commonly to ELBs. ALIAS records update transparently when for e.g. a backing ELB changes internal dns name; this
  change is completely opaque to the outside world.
7. Routing policies for ALIAS records:
    1. Simple (default) - most commonly used for single resource (e.g. single webserver)
    2. Weighted
        1. permit routing of traffic by weight e.g 80% to one region and 20% to another region.  Could also be used for A/B
       testing for e.g.
        2. weighting is ON AVERAGE - on average over time x % will go to A and y % will go to B.  Max weight for route is 255, min 0.
    3. Latency
        1. Route based on lowest network atency for end user - create a latency resource record set in every region 
        that hosts your site.  R53 selects latency resource set with lowest latency.
    4. Failover
        1. Routing policy for active/passive failover
        2. R53 monitors health of primary site via a health check; if health check fails then R53 routes to the failover site.
        3. R53 Health check url cannot be the url of the ALIAS record; it must be the url of the ELB endpoint
    5. Geolocation
        1. permits traffic routing based on geographical location
        2. Geolocation can be done by Continent (e.g. Europe), by Country (e.g Germany) or by State in the case of the USA.
8. Route 53 is a fully fledged DNS system e.g it supports MX records        
    
###### VPC

1. VPC Creation
    1. Cannot create a CIDR block greater than /16 for a VPC
    2. When a VPC is created, a MAIN route table is created with it.
    3. When a VPC is created, a default security group is created for the VPC
    4. When a VPC is created, a default Network ACL is created for the VPC
2. Subnets are bound to a single AZ within a region. ACLs and Security Groups can span AZs.  Subnets are associated
   to the MAIN route table by default on creation.
3. 3 addresses are reserved by default in a subnet, not including .0 and .255 
   a.b.c.1 is reserved for the VPC router.  a.b.c.2 is reserved for DNS and a.b.c.3 is reserved for future use.
   .255 is broadcast, but broadcast isn't possible in VPC so this is simply reserved.
4. To connect a VPC to the internet you need to create an Internet Gateway.  Only one IG can be bound to a VPC.

###### NAT Instances and NAT Gateways

1. NAT-GReleased in 2016.  Old method was NAT instances.  NAT Gateways scale automatically, no need to patch or put in SG's - AWS manage everything.
2. NAT instances are provisioned from specific NAT Amis
3. EC2 instances have a default Source/Dest check which checks that traffic to them is either for or from them.  A NAT instance
needs to be able to route traffic so this setting needs to be disabled.
4. NAT Instances are configured as the targets of routing tables in much the same way as IG's are

5. NAT Gateway is always deployed into subnets which are or can face PUBLIC internet.  
6. NAT Gateway doesn't require a SG or disable of source/dest traffic check

                                       
    
    