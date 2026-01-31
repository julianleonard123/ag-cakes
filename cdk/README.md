# AG Cakes - AWS CDK Infrastructure

This directory contains the AWS CDK infrastructure code for deploying the Hugo static site to AWS.

## Architecture

The CDK stack creates:

- **S3 Bucket**: Stores the static site files (not publicly accessible)
- **CloudFront Distribution**: CDN for global content delivery with HTTPS
- **Origin Access Control (OAC)**: Secure access from CloudFront to S3
- **Automatic Deployment**: Uploads site content and invalidates CloudFront cache

### Cost Optimization

The infrastructure is configured for minimal cost:

- CloudFront Price Class 100 (North America + Europe only)
- S3 with auto-delete enabled for dev (change for production)
- Automatic CloudFront cache invalidation on deployment
- Expected cost: **< $1/month** for typical small sites

## Prerequisites

1. **AWS Account** with credentials configured
2. **AWS CLI** installed and configured:
   ```bash
   aws configure
   ```
3. **Node.js** and npm installed
4. **AWS CDK** installed globally:
   ```bash
   npm install -g aws-cdk
   ```

## First Time Setup

### Bootstrap CDK (one-time per AWS account/region)

If this is your first time using CDK in this AWS account/region:

```bash
cdk bootstrap
```

This creates the necessary CDK staging resources in your AWS account.

## Deployment

### Option 1: Use the Deployment Script (Recommended)

From the project root:

```bash
./deploy-infrastructure.sh
```

This script will:
1. Build the Hugo site with `hugo --minify`
2. Deploy to AWS using CDK
3. Upload all files to S3
4. Invalidate CloudFront cache

### Option 2: Manual Deployment

```bash
# Build Hugo site (from project root)
hugo --minify

# Deploy CDK stack
cd cdk
cdk deploy
```

### First Deployment Note

The first deployment takes **10-15 minutes** because CloudFront distribution creation is slow. Subsequent deployments are much faster (1-3 minutes).

## Updating Your Site

After making changes to your Hugo content:

### Option 1: Quick Content Update Script (Recommended)

From project root:

```bash
./deploy-content.sh
```

This is much faster (30-60 seconds) and only updates content files.

### Option 2: Manual Update

```bash
hugo --minify
cd cdk
cdk deploy
```

The CDK BucketDeployment construct automatically:
- Syncs only changed files to S3
- Invalidates CloudFront cache for updated content
- Optimizes deployment speed

## CDK Commands

Useful CDK commands from the `cdk/` directory:

* `npm run build`   compile typescript to js
* `npm run watch`   watch for changes and compile
* `npm run test`    perform the jest unit tests
* `cdk diff`        see what changes will be deployed
* `cdk deploy`      deploy the stack
* `cdk synth`       view the synthesized CloudFormation template
* `cdk destroy`     destroy the stack (WARNING: deletes everything!)

## Stack Outputs

After deployment, the stack outputs important information:

- **BucketName**: The S3 bucket name
- **DistributionId**: CloudFront distribution ID
- **DistributionDomainName**: CloudFront domain name
- **WebsiteURL**: Your live website URL (https://...)

View outputs anytime:

```bash
aws cloudformation describe-stacks \
  --stack-name AgCakesStaticSite \
  --query 'Stacks[0].Outputs'
```

## Configuration

### Change Deployment Region

Edit `bin/cdk.ts` and modify the `env` property, or set environment variables:

```bash
export CDK_DEFAULT_REGION=us-west-2
cdk deploy
```

### Custom Site Path

If your Hugo build output is in a different location:

```bash
cdk deploy -c sitePath=/path/to/your/public
```

### Production Settings

For production, edit `lib/cdk-stack.ts` and change:

```typescript
// Change these for production:
removalPolicy: cdk.RemovalPolicy.RETAIN,  // Keep bucket on stack deletion
autoDeleteObjects: false,                 // Don't delete files on stack deletion
```

## Cleanup

To delete all AWS resources:

```bash
cdk destroy
```

**WARNING**: This permanently deletes:
- The S3 bucket and all site files
- The CloudFront distribution
- All configuration

## Troubleshooting

### CDK Deploy Fails

1. Check AWS credentials:
   ```bash
   aws sts get-caller-identity
   ```

2. Ensure CDK is bootstrapped:
   ```bash
   cdk bootstrap
   ```

3. Check for policy/permission issues in the error message

### Site Not Loading

1. Wait 10-15 minutes after first deployment for CloudFront propagation
2. Check the CloudFront URL from stack outputs
3. Verify files exist in S3 bucket
4. Check CloudFront distribution status in AWS Console

### Changes Not Appearing

1. CloudFront cache may need time to invalidate (5-10 minutes)
2. Try hard refresh in browser (Cmd+Shift+R or Ctrl+F5)
3. Check CloudFront invalidation status in AWS Console

### Cost Concerns

Monitor costs in AWS Billing Dashboard:

- S3: ~$0.023/GB/month storage
- CloudFront: Free tier includes 1TB transfer/month
- Requests: Usually negligible for small sites

Set up AWS Billing Alerts to get notified if costs exceed expected amounts.

## Learn More

- [AWS CDK Documentation](https://docs.aws.amazon.com/cdk/)
- [CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
