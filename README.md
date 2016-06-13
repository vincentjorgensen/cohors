# Cohors
AWS infrastructure as code. 

## Columns
stuff goes here

## VPCs
A column exists inside a single VPC. The second octet must be unique to the
VPC.

| Datacenter     | Prod Second Octet | Dev Second Octet |
| -------------- |:-----------------:|:----------------:|
| us-west-2      | 0                 | 100              |
| us-west-1      | 4                 | 104              |
| us-east-1      | 8                 | 108              |
| eu-west-1      | 12                | 112              |
| eu-central-1   | 16                | 116              |
| ap-southeast-1 | 20                | 120              |
| ap-southeast-2 | 24                | 124              |

## Subnets 
A column exists inside a single VPC. The second octet must be unique to the
column for a deployment. The following table shows the production VPC in
us-west-2.

|         | Cidr          | Minimum    | Maximum      | Broadcast    | Hosts |
| ------- | ------------- | ---------- | ------------ | ------------ | ----- |
| VPC     | 10.0.0.0/16   | 10.0.0.1   | 10.0.255.254 | 10.0.255.255 | 65534 |
| 1PuS    | 10.0.0.0/18   | 10.0.0.1   | 10.0.63.254  | 10.0.63.255  | 16382 |
| 2PuS    | 10.0.64.0/18  | 10.0.64.1  | 10.0.127.254 | 10.0.127.255 | 16382 |
| 1PrS    | 10.0.128.0/19 | 10.0.128.1 | 10.0.159.254 | 10.0.159.255 | 8190  |
| 2PrS    | 10.0.160.0/19 | 10.0.160.1 | 10.0.191.254 | 10.0.191.255 | 8190  |
| 1PrRDSS | 10.0.192.0/19 | 10.0.192.1 | 10.0.223.254 | 10.0.223.255 | 8190  |
| 1PrRDSS | 10.0.224.0/19 | 10.0.192.1 | 10.0.255.254 | 10.0.255.255 | 8190  |

## VPNs
VPNs are also by second octet and there is one per column. To determine the
second octet for a column, add 1 to the VPC second octet. For example, the VPN
second octet for us-west-2 is 1.

## Consul
stuff goes here
