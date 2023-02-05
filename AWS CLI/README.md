### First task.

## Step 1 - Create VPC

# command:
```
aws ec2 create-vpc --cidr-block 10.0.0.0/16
```
# output:
```
{
    "Vpc": {
        "CidrBlock": "10.0.0.0/16",
        "DhcpOptionsId": "dopt-0a98df44ece05fac4",
        "State": "pending",
        "VpcId": "vpc-0552de9052ace532f",
        "OwnerId": "734507832483",
        "InstanceTenancy": "default",
        "Ipv6CidrBlockAssociationSet": [],
        "CidrBlockAssociationSet": [
            {
                "AssociationId": "vpc-cidr-assoc-0f54c24b93c6cd5ed",
                "CidrBlock": "10.0.0.0/16",
                "CidrBlockState": {
                    "State": "associated"
                }
            }
        ],
        "IsDefault": false
    }
}
```

# create tag:
```
aws ec2 create-tags --resources vpc-0552de9052ace532f --tags Key=Name,Value=hillel-vpc
```

## Step 2 - Create public and private subnets

# command for public:

```
aws ec2 create-subnet --vpc-id vpc-0552de9052ace532f --cidr-block 10.0.1.0/24
```

# output:
```
{
    "Subnet": {
        "AvailabilityZone": "us-east-1b",
        "AvailabilityZoneId": "use1-az4",
        "AvailableIpAddressCount": 251,
        "CidrBlock": "10.0.1.0/24",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "subnet-04413154f90d41daa",
        "VpcId": "vpc-0552de9052ace532f",
        "OwnerId": "734507832483",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "SubnetArn": "arn:aws:ec2:us-east-1:734507832483:subnet/subnet-04413154f90d41daa",
        "EnableDns64": false,
        "Ipv6Native": false,
        "PrivateDnsNameOptionsOnLaunch": {
            "HostnameType": "ip-name",
            "EnableResourceNameDnsARecord": false,
            "EnableResourceNameDnsAAAARecord": false
        }
    }
}
```

# create tag for public:
```
aws ec2 create-tags --resources subnet-04413154f90d41daa --tags Key=Name,Value=public
```

# command for private:

```
aws ec2 create-subnet --vpc-id vpc-0552de9052ace532f --cidr-block 10.0.2.0/24
```

#output:
```
{
    "Subnet": {
        "AvailabilityZone": "us-east-1b",
        "AvailabilityZoneId": "use1-az4",
        "AvailableIpAddressCount": 251,
        "CidrBlock": "10.0.2.0/24",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "subnet-00fe67de7b90d152f",
        "VpcId": "vpc-0552de9052ace532f",
        "OwnerId": "734507832483",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "SubnetArn": "arn:aws:ec2:us-east-1:734507832483:subnet/subnet-00fe67de7b90d152f",
        "EnableDns64": false,
        "Ipv6Native": false,
        "PrivateDnsNameOptionsOnLaunch": {
            "HostnameType": "ip-name",
            "EnableResourceNameDnsARecord": false,
            "EnableResourceNameDnsAAAARecord": false
        }
    }
}
```
# create tag for private:
```
aws ec2 create-tags --resources subnet-00fe67de7b90d152f --tags Key=Name,Value=private
```

## Step 3 - Create internet gateway for the VPC

# command:
```
aws ec2 create-internet-gateway
```
# output
```
{
    "InternetGateway": {
        "Attachments": [],
        "InternetGatewayId": "igw-0358b909e88eabd7c",
        "OwnerId": "734507832483",
        "Tags": []
    }
}
```

# create tag:
```
aws ec2 create-tags --resources igw-0358b909e88eabd7c --tags Key=Name,Value=igw-hillel
```

# attach igw to the VPC:
```
aws ec2 attach-internet-gateway --internet-gateway-id igw-0358b909e88eabd7c --vpc-id vpc-0552de9052ace532f
```

## Step 6 - Create a route table

# command:
```
aws ec2 create-route-table --vpc-id vpc-0552de9052ace532f
```
# output:
```
{
    "RouteTable": {
        "Associations": [],
        "PropagatingVgws": [],
        "RouteTableId": "rtb-0aabd3cf0d84433d2",
        "Routes": [
            {
                "DestinationCidrBlock": "10.0.0.0/16",
                "GatewayId": "local",
                "Origin": "CreateRouteTable",
                "State": "active"
            }
        ],
        "Tags": [],
        "VpcId": "vpc-0552de9052ace532f",
        "OwnerId": "734507832483"
    }
}
```
# create tag:
```
aws ec2 create-tags --resources rtb-0aabd3cf0d84433d2 --tags Key=Name,Value=Public
```

## Step 7 - Create routes

# command:
```
aws ec2 create-route --route-table-id rtb-0aabd3cf0d84433d2 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-0358b909e88eabd7c
```
# output:
```
{
    "Return": true
}
```
# associate route table to subnet:
```
aws ec2 associate-route-table --route-table-id rtb-0aabd3cf0d84433d2 --subnet-id subnet-04413154f90d41daa
```
# output:
```
{
    "AssociationId": "rtbassoc-0ee1962ed5f552594",
    "AssociationState": {
        "State": "associated"
    }
}
```


### Second task.
## Discribe the Cidr Block of all subnets with the name (tag) private in your VPC.
# command:
```
aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-0552de9052ace532f" "Name=tag:Name,Values=private" --query "Subnets[*].{Tag:Tags,ID:SubnetId,CIDR:CidrBlock}"
```
# output:
```
[
    {
        "Tag": [
            {
                "Key": "Name",
                "Value": "private"
            }
        ],
        "ID": "subnet-00fe67de7b90d152f",
        "CIDR": "10.0.2.0/24"
    }
]
```
