import boto3
from awscli.customizations.emr.constants import EC2

from create_volume import get_or_create_volume
from security_group import get_or_create_security_group
from settings import machine_image, instance_type, key_name

ec2 = boto3.resource('ec2')


def create_instance():
    security_group = get_or_create_security_group()
    volume = get_or_create_volume()

    print("Requesting new instance...")
    instances: EC2.Instance = ec2.create_instances(
        DryRun=False,
        ImageId=machine_image,
        InstanceType=instance_type,
        KeyName=key_name,
        MaxCount=1,
        MinCount=1,
        TagSpecifications=[
            {
                'ResourceType': 'instance',
                'Tags': [{'Key': 'name', 'Value': 'montagu-barman'}]
            }
        ],
        SecurityGroupIds=[security_group.id],
        UserData=get_startup_script()
    )
    instance = instances[0]

    print("Waiting for instance to be running...")
    instance.wait_until_running()

    print("Attaching EBS volume...")
    instance.attach_volume(
        Device="/dev/sdf",
        VolumeId=volume.id
    )

    return instances[0]


def get_startup_script():
    with open('./bin/startup.sh', 'r') as f:
        code = f.read()
    return code
