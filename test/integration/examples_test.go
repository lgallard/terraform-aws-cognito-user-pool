package integration

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/lgallard/terraform-aws-cognito-user-pool/test/helpers"
	"github.com/stretchr/testify/assert"
)

func TestSimpleExample(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: helpers.GetExamplePath("simple"),
		Vars: map[string]interface{}{
			"user_pool_name": helpers.GenerateUniqueUserPoolName(t, "simple"),
		},
		NoColor: true,
	}

	helpers.ApplyAndValidate(t, terraformOptions, func(t *testing.T, opts *terraform.Options) {
		// Validate outputs
		userPoolID := helpers.GetOutputAsString(t, opts, "id")
		assert.NotEmpty(t, userPoolID)
		
		userPoolName := helpers.GetOutputAsString(t, opts, "name")
		assert.Contains(t, userPoolName, "simple")
		
		userPoolArn := helpers.GetOutputAsString(t, opts, "arn")
		assert.Contains(t, userPoolArn, "arn:aws:cognito-idp")
		
		// Validate with AWS API
		client := helpers.GetCognitoClient(t, "us-east-1")
		userPool := helpers.ValidateUserPoolExists(t, client, userPoolID)
		
		assert.Equal(t, userPoolName, *userPool.Name)
		assert.Equal(t, "ESSENTIALS", *userPool.UserPoolTier)
	})
}

func TestCompleteExample(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: helpers.GetExamplePath("complete"),
		Vars: map[string]interface{}{
			"user_pool_name": helpers.GenerateUniqueUserPoolName(t, "complete"),
		},
		NoColor: true,
	}

	helpers.ApplyAndValidate(t, terraformOptions, func(t *testing.T, opts *terraform.Options) {
		// Validate user pool
		userPoolID := helpers.GetOutputAsString(t, opts, "id")
		assert.NotEmpty(t, userPoolID)
		
		client := helpers.GetCognitoClient(t, "us-east-1")
		userPool := helpers.ValidateUserPoolExists(t, client, userPoolID)
		
		// Validate complete example specific configurations
		assert.NotNil(t, userPool.Policies)
		assert.NotNil(t, userPool.Policies.PasswordPolicy)
		
		// Validate clients if they exist
		clientsOutput := helpers.GetOutputAsMap(t, opts, "clients")
		if len(clientsOutput) > 0 {
			for clientName, clientData := range clientsOutput {
				clientInfo := clientData.(map[string]interface{})
				clientID := clientInfo["id"].(string)
				
				client := helpers.ValidateUserPoolClient(t, helpers.GetCognitoClient(t, "us-east-1"), userPoolID, clientID)
				assert.Equal(t, clientName, *client.ClientName)
			}
		}
		
		// Validate domain if it exists
		domainOutput := helpers.GetOutputAsString(t, opts, "domain")
		if domainOutput != "" {
			helpers.ValidateUserPoolDomain(t, helpers.GetCognitoClient(t, "us-east-1"), domainOutput)
		}
	})
}

func TestEmailMFAExample(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: helpers.GetExamplePath("email_mfa"),
		Vars: map[string]interface{}{
			"user_pool_name": helpers.GenerateUniqueUserPoolName(t, "email-mfa"),
		},
		NoColor: true,
	}

	helpers.ApplyAndValidate(t, terraformOptions, func(t *testing.T, opts *terraform.Options) {
		userPoolID := helpers.GetOutputAsString(t, opts, "id")
		assert.NotEmpty(t, userPoolID)
		
		client := helpers.GetCognitoClient(t, "us-east-1")
		userPool := helpers.ValidateUserPoolExists(t, client, userPoolID)
		
		// Validate MFA configuration
		assert.NotNil(t, userPool.MfaConfiguration)
		// MFA should be configured (OPTIONAL or ON)
		mfaConfig := *userPool.MfaConfiguration
		assert.True(t, mfaConfig == "OPTIONAL" || mfaConfig == "ON", "MFA should be enabled")
		
		// Validate auto verified attributes include email
		if userPool.AutoVerifiedAttributes != nil {
			autoVerified := make([]string, len(userPool.AutoVerifiedAttributes))
			for i, attr := range userPool.AutoVerifiedAttributes {
				autoVerified[i] = *attr
			}
			assert.Contains(t, autoVerified, "email")
		}
	})
}

func TestSimpleExtendedExample(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: helpers.GetExamplePath("simple_extended"),
		Vars: map[string]interface{}{
			"user_pool_name": helpers.GenerateUniqueUserPoolName(t, "simple-extended"),
		},
		NoColor: true,
	}

	helpers.ApplyAndValidate(t, terraformOptions, func(t *testing.T, opts *terraform.Options) {
		userPoolID := helpers.GetOutputAsString(t, opts, "id")
		assert.NotEmpty(t, userPoolID)
		
		client := helpers.GetCognitoClient(t, "us-east-1")
		userPool := helpers.ValidateUserPoolExists(t, client, userPoolID)
		
		// Validate extended configurations
		assert.NotNil(t, userPool.Name)
		assert.Contains(t, *userPool.Name, "simple-extended")
		
		// Validate that it has more configuration than simple example
		// This could include password policies, MFA, etc.
		if userPool.Policies != nil && userPool.Policies.PasswordPolicy != nil {
			assert.NotNil(t, userPool.Policies.PasswordPolicy.MinimumLength)
		}
	})
}

func TestWithBrandingExample(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: helpers.GetExamplePath("with_branding"),
		Vars: map[string]interface{}{
			"user_pool_name": helpers.GenerateUniqueUserPoolName(t, "with-branding"),
		},
		NoColor: true,
	}

	helpers.ApplyAndValidate(t, terraformOptions, func(t *testing.T, opts *terraform.Options) {
		userPoolID := helpers.GetOutputAsString(t, opts, "id")
		assert.NotEmpty(t, userPoolID)
		
		client := helpers.GetCognitoClient(t, "us-east-1")
		userPool := helpers.ValidateUserPoolExists(t, client, userPoolID)
		
		// Validate branding specific configurations
		assert.NotNil(t, userPool.Name)
		assert.Contains(t, *userPool.Name, "with-branding")
		
		// Check if managed login branding output exists
		managedLoginBrandingOutput := helpers.GetOutputAsString(t, opts, "managed_login_branding")
		if managedLoginBrandingOutput != "" {
			assert.NotEmpty(t, managedLoginBrandingOutput)
		}
		
		// Check if UI customization output exists
		uiCustomizationOutput := helpers.GetOutputAsString(t, opts, "ui_customization")
		if uiCustomizationOutput != "" {
			assert.NotEmpty(t, uiCustomizationOutput)
		}
	})
}

func TestAllExamplesResourceDestruction(t *testing.T) {
	t.Parallel()

	examples := []string{"simple", "complete", "email_mfa", "simple_extended", "with_branding"}
	
	for _, example := range examples {
		example := example
		t.Run("Destroy_"+example, func(t *testing.T) {
			t.Parallel()
			
			terraformOptions := &terraform.Options{
				TerraformDir: helpers.GetExamplePath(example),
				Vars: map[string]interface{}{
					"user_pool_name": helpers.GenerateUniqueUserPoolName(t, example+"-destroy"),
				},
				NoColor: true,
			}
			
			// Apply first
			terraform.InitAndApply(t, terraformOptions)
			
			// Get user pool ID before destroy
			userPoolID := helpers.GetOutputAsString(t, terraformOptions, "id")
			
			// Destroy
			terraform.Destroy(t, terraformOptions)
			
			// Validate destruction
			client := helpers.GetCognitoClient(t, "us-east-1")
			helpers.ValidateUserPoolDestroyed(t, client, userPoolID)
		})
	}
}