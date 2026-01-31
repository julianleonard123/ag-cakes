#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import { CdkStack } from '../lib/cdk-stack';

const app = new cdk.App();

new CdkStack(app, 'AgCakesStaticSite', {
  /* Use the default account and region from AWS CLI configuration */
  env: {
    account: process.env.CDK_DEFAULT_ACCOUNT,
    region: process.env.CDK_DEFAULT_REGION
  },

  /* Path to Hugo build output - can be overridden via context */
  sitePath: app.node.tryGetContext('sitePath') || '../public',

  /* Optional: specify a custom domain name via context */
  // domainName: app.node.tryGetContext('domainName'),
});
