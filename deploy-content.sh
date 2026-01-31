#!/bin/bash
#
# AG Cakes - Content Deployment
# ===============================
# Fast deployment for content updates (text, images, CSS changes)
# Uses S3 sync + CloudFront cache invalidation (30-60 seconds)
#

set -e

# Configuration
BUCKET_NAME="agcakesstaticsite-sitebucket397a1860-ouyfv3ooz0ny"
DISTRIBUTION_ID="E3NL32W60B8UJV"
AWS_PROFILE="julian"
AWS_REGION="eu-west-1"

echo "🔄 AG Cakes - Content Update"
echo "=============================="
echo ""

# Build Hugo site
echo "📦 Building Hugo site..."
rm -rf public
hugo --minify

if [ ! -d "public" ]; then
  echo "❌ Error: public directory not found after Hugo build"
  exit 1
fi

echo "✅ Hugo site built successfully"
echo ""

# Sync to S3
echo "☁️  Syncing files to S3..."
AWS_PROFILE=$AWS_PROFILE AWS_REGION=$AWS_REGION \
  aws s3 sync public/ s3://$BUCKET_NAME/ --delete

echo "✅ Files synced to S3"
echo ""

# Invalidate CloudFront cache
echo "🔄 Invalidating CloudFront cache..."
INVALIDATION_OUTPUT=$(AWS_PROFILE=$AWS_PROFILE \
  aws cloudfront create-invalidation \
  --distribution-id $DISTRIBUTION_ID \
  --paths "/*" \
  --output json)

INVALIDATION_ID=$(echo $INVALIDATION_OUTPUT | grep -o '"Id": "[^"]*"' | cut -d'"' -f4)

echo "✅ Cache invalidation created: $INVALIDATION_ID"
echo ""
echo "🎉 Content deployment complete!"
echo "🌐 Your site: https://ag-cakes.com/"
echo ""
echo "💡 Changes will appear in 2-3 minutes after cache clears"
echo "   Hard refresh your browser: Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows)"
echo ""
