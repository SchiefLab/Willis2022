aws emr create-cluster \\
--os-release-label 2.0.20220606.1 \\
--applications Name=JupyterEnterpriseGateway Name=Spark Name=Hadoop Name=JupyterHub \\
--ec2-attributes \\ 
'{
    "KeyName": "EMR",
    "InstanceProfile": "EMR_EC2_DefaultRole",
    "SubnetId": "subnet-xxxx", 
    "EmrManagedSlaveSecurityGroup": "sg-xxx",
    "EmrManagedMasterSecurityGroup": "sg-xxxx"
}' \\
--release-label emr-6.7.0 \\
--log-uri 's3n://aws-logs-XXXXXXXXXX-us-west-2/elasticmapreduce/' \\
--instance-groups '[
    {
        "InstanceCount": 1,
        "BidPrice": "OnDemandPrice",
        "EbsConfiguration": {
            "EbsBlockDeviceConfigs": [
                {
                    "VolumeSpecification": {
                        "SizeInGB": 32,
                        "VolumeType": "gp2"
                    },
                    "VolumesPerInstance": 2
                }
            ]
        },
        "InstanceGroupType": "MASTER",
        "InstanceType": "m5.xlarge",
        "Name": "Master - 1"
    },
    {
        "InstanceCount": 5,
        "BidPrice": "OnDemandPrice",
        "EbsConfiguration": {
            "EbsBlockDeviceConfigs": [
                {
                    "VolumeSpecification": {
                        "SizeInGB": 32,
                        "VolumeType": "gp2"
                    },
                    "VolumesPerInstance": 2
                }
            ]
        },
        "InstanceGroupType": "CORE",
        "InstanceType": "m5.xlarge",
        "Name": "Core - 2"
    }
]'
--auto-scaling-role EMR_AutoScaling_DefaultRole \\
--bootstrap-actions '[{"Path":"s3://oasdatabase/python-modules.sh","Name":"Custom action"}]' \\
--ebs-root-volume-size 100 \\
--service-role EMR_DefaultRole \\
--enable-debugging \\
--auto-termination-policy '{"IdleTimeout":3600}' \\
--name 'EMR-6.7.0' \\
--scale-down-behavior TERMINATE_AT_TASK_COMPLETION \\
--region us-west-2
