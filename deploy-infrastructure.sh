#!/bin/bash
#
# AG Cakes - Infrastructure Deployment
# ======================================
# Deploy infrastructure changes using AWS CDK (2-5 minutes)
#
# Use this when you modify:
# - CloudFront settings (caching, functions, etc.)
# - S3 bucket configuration
# - IAM policies
# - Any code in cdk/lib/cdk-stack.ts
#
# For regular content updates, use: ./deploy-content.sh
#

set -e

AWS_PROFILE="julian"
AWS_REGION="eu-west-1"

echo "🏗️  AG Cakes - Infrastructure Deployment"
echo "=========================================="
echo ""

# Build Hugo site first (CDK will deploy it)
echo "📦 Building Hugo site..."
rm -rf public
hugo --minify

if [ ! -d "public" ]; then
  echo "❌ Error: public directory not found after Hugo build"
  exit 1
fi

echo "✅ Hugo site built successfully"
echo ""

# Deploy with CDK
echo "☁️  Deploying infrastructure with CDK..."
echo "   This may take 2-5 minutes..."
echo ""

cd cdk
AWS_PROFILE=$AWS_PROFILE AWS_REGION=$AWS_REGION \
  npx cdk deploy --require-approval never

cd ..

echo ""
echo "✅ Infrastructure deployment complete!"
echo ""
echo "💡 Note: For regular content updates, use ./deploy-content.sh instead"
echo "   (much faster - only 30-60 seconds)"
echo ""
