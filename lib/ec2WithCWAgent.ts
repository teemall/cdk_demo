import * as ec2 from 'aws-cdk-lib/aws-ec2';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { readFileSync } from 'fs';

export class EC2WithCWAgent extends Construct {
    constructor(scope: Construct, id: string, vpc: ec2.Vpc, webserverRole: iam.Role, webserverSG: ec2.SecurityGroup){
        super(scope, id)
        const ec2InstanceWithCWAgent = new ec2.Instance(this, id, {
              vpc,
              vpcSubnets: {
                subnetType: ec2.SubnetType.PUBLIC,
              },
              role: webserverRole,
              securityGroup: webserverSG,
              instanceType: ec2.InstanceType.of(
                ec2.InstanceClass.BURSTABLE2,
                ec2.InstanceSize.MICRO,
              ),
              machineImage: new ec2.AmazonLinuxImage({
                generation: ec2.AmazonLinuxGeneration.AMAZON_LINUX_2,
              })
            });
        const userDataScriptWith = readFileSync('./lib/user-data.sh', 'utf8');
        ec2InstanceWithCWAgent.addUserData(userDataScriptWith);
    }
}