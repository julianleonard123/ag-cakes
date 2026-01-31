# AG Cakes Website

A Hugo-based static website for AG Cakes, a bespoke celebration cake business based in Ballinasloe, Ireland.

## Overview

This website showcases custom celebration cakes including birthday, anniversary, and special occasion cakes. The site is built with Hugo and deployed to AWS using CloudFront and S3 for fast, reliable, and cost-effective hosting.

**Live Site**: https://ag-cakes.com/

## Tech Stack

- **Static Site Generator**: Hugo (v0.154+)
- **Infrastructure**: AWS CDK (TypeScript)
- **Hosting**: Amazon S3 + CloudFront CDN
- **Deployment**: Automated via shell scripts

## Project Structure

```
ag-cakes/
├── assets/          # Hugo assets for processing (CSS, JS)
├── cdk/             # AWS CDK infrastructure code
├── config/          # Hugo configuration files
├── content/         # Website content (Markdown)
├── layouts/         # Hugo layout templates
├── static/          # Static files (images, etc.)
├── hugo.toml        # Main Hugo config
├── deploy-content.sh         # Fast content deployment script
└── deploy-infrastructure.sh  # Full infrastructure deployment
```

## Local Development

### Prerequisites

- Hugo (extended version recommended)
- Go modules (for Hugo themes)

### Running Locally

```bash
# Start the development server
hugo server

# Site will be available at http://localhost:1313/
```

Hugo will automatically rebuild when you make changes to content or templates.

## Content Management

### Adding Images

1. Place images in `static/img/`
2. Reference them in content using `img/filename.jpg`

### Updating Pages

- **Home page**: `content/_index.md`
- **Contact page**: `content/contact.md`

## Deployment

### Quick Content Updates (30-60 seconds)

For text, image, or CSS changes:

```bash
./deploy-content.sh
```

This script:
1. Builds the Hugo site with minification
2. Syncs files to S3
3. Invalidates CloudFront cache

### Infrastructure Changes (2-5 minutes)

For CloudFront, S3, or IAM policy changes:

```bash
./deploy-infrastructure.sh
```

Use this when modifying `cdk/lib/cdk-stack.ts`.

## AWS Infrastructure

The site is deployed using AWS CDK with:

- **S3 Bucket**: Private bucket for site files
- **CloudFront**: Global CDN with HTTPS
- **Origin Access Control**: Secure CloudFront-to-S3 access

**Estimated Cost**: < $1/month for typical traffic

See [cdk/README.md](cdk/README.md) for detailed infrastructure documentation.

## Configuration

### AWS Profile

Both deployment scripts use the `julian` AWS profile. To change this, edit:
- `deploy-content.sh` (line 14)
- `deploy-infrastructure.sh` (line 18)

### Hugo Configuration

Main configuration is split across:
- `hugo.toml` - Base settings
- `config/_default/params.toml` - Theme parameters
- `config/_default/languages.en.toml` - Language-specific settings

## Development Workflow

1. Make changes to content or layouts
2. Test locally with `hugo server`
3. Deploy content with `./deploy-content.sh`
4. Changes appear on live site in 2-3 minutes

## License

Copyright © 2025 AG Cakes. All rights reserved.
