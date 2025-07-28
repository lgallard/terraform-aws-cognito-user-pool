# Cognito User Pool with Managed Login Branding Example

This example demonstrates how to create an AWS Cognito User Pool with managed login branding using the `awscc` provider.

## Features

- Cognito User Pool with hosted UI
- Managed login branding with custom assets
- Support for light/dark mode logos
- Custom background images and favicon
- JSON-based settings for colors and typography
- User pool client with OAuth flows

## Prerequisites

1. **AWS Account** with appropriate permissions
2. **Terraform** >= 1.3.0
3. **AWSCC Provider** configured (for managed login branding)
4. **Branding Assets** (logos, backgrounds, favicon)

## Provider Requirements

This example requires both the `aws` and `awscc` providers:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.95"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = ">= 1.0"
    }
  }
}
```

## Usage

1. **Prepare Assets**: Add your branding assets to the `assets/` directory:
   - `logo-light.png` - Logo for light mode
   - `logo-dark.png` - Logo for dark mode
   - `background.jpg` - Background image
   - `favicon.ico` - Favicon

2. **Configure Variables**: Update `terraform.tfvars` with your settings:
   ```hcl
   user_pool_name = "my-app-user-pool"
   domain_name    = "my-app-auth"  # Optional custom domain
   aws_region     = "us-east-1"
   ```

3. **Deploy**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Branding Configuration

The example includes comprehensive branding configuration:

### Assets
- **Form Logo**: Different logos for light/dark modes
- **Background**: Page background image
- **Favicon**: Browser tab icon

### Settings
- **Color Schemes**: Custom colors for light/dark themes
- **Typography**: Font family and sizing
- **Layout**: Border radius and spacing

### Asset Categories

Cognito supports various asset categories:

| Category | Description | Color Modes |
|----------|-------------|-------------|
| `FORM_LOGO` | Logo on login form | LIGHT, DARK, DYNAMIC |
| `PAGE_BACKGROUND` | Page background | LIGHT, DARK, DYNAMIC |
| `FAVICON_ICO` | Browser favicon | DYNAMIC |
| `PAGE_HEADER_LOGO` | Header logo | LIGHT, DARK, DYNAMIC |
| `PAGE_FOOTER_LOGO` | Footer logo | LIGHT, DARK, DYNAMIC |

## Outputs

The example provides several useful outputs:

- `user_pool_id` - The Cognito User Pool ID
- `hosted_ui_url` - The hosted UI login URL
- `managed_login_branding` - Complete branding configuration
- `managed_login_branding_ids` - Branding instance IDs

## Testing the Branding

After deployment, you can test the branding by:

1. Visit the hosted UI URL (from outputs)
2. Check the login page for your custom branding
3. Test both light and dark mode (browser settings)
4. Verify all assets load correctly

## Asset Requirements

- **File Size**: Maximum 2MB per asset
- **Formats**: PNG, JPG, JPEG, SVG, ICO
- **Encoding**: Base64 (handled automatically by `filebase64()`)

## Important Notes

- **Provider Requirement**: This feature requires the `awscc` provider
- **Regional Support**: Managed login branding is available in most AWS regions
- **Client Association**: Each branding configuration is linked to a specific app client
- **Cost**: Managed login branding may have associated costs

## Cleanup

To destroy the resources:

```bash
terraform destroy
```

## References

- [AWS Cognito Managed Login Branding](https://docs.aws.amazon.com/cognito/latest/developerguide/managed-login-brandingeditor.html)
- [AWSCC Provider Documentation](https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/cognito_managed_login_branding)

<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.95 |
| <a name="requirement_awscc"></a> [awscc](#requirement\_awscc) | >= 1.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_cognito_user_pool"></a> [aws\_cognito\_user\_pool](#module\_aws\_cognito\_user\_pool) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name for the hosted UI | `string` | `""` | no |
| <a name="input_enable_branding"></a> [enable\_branding](#input\_enable\_branding) | Whether to enable managed login branding | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource | `map(string)` | <pre>{<br/>  "Environment": "development",<br/>  "Project": "cognito-branding-example"<br/>}</pre> | no |
| <a name="input_user_pool_name"></a> [user\_pool\_name](#input\_user\_pool\_name) | The name of the user pool | `string` | `"example-pool-with-branding"` | no |
| <a name="input_user_pool_tier"></a> [user\_pool\_tier](#input\_user\_pool\_tier) | The tier of the user pool | `string` | `"ESSENTIALS"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_ids_map"></a> [client\_ids\_map](#output\_client\_ids\_map) | Map of user pool client IDs |
| <a name="output_hosted_ui_url"></a> [hosted\_ui\_url](#output\_hosted\_ui\_url) | The hosted UI URL |
| <a name="output_managed_login_branding_details"></a> [managed\_login\_branding\_details](#output\_managed\_login\_branding\_details) | The managed login branding details from the module |
| <a name="output_user_pool_arn"></a> [user\_pool\_arn](#output\_user\_pool\_arn) | The ARN of the user pool |
| <a name="output_user_pool_domain"></a> [user\_pool\_domain](#output\_user\_pool\_domain) | The domain of the user pool |
| <a name="output_user_pool_id"></a> [user\_pool\_id](#output\_user\_pool\_id) | The ID of the user pool |
<!-- END_TF_DOCS -->
