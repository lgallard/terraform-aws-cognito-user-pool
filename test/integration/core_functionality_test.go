package integration

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/lgallard/terraform-aws-cognito-user-pool/test/helpers"
	"github.com/stretchr/testify/assert"
)

func TestBasicUserPoolCreation(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: helpers.GetModulePath(),
		Vars: map[string]interface{}{
			"user_pool_name": helpers.GenerateUniqueUserPoolName(t, "basic"),
			"enabled":        true,
		},
		NoColor: true,
	}

	helpers.ApplyAndValidate(t, terraformOptions, func(t *testing.T, opts *terraform.Options) {
		userPoolID := helpers.GetOutputAsString(t, opts, "id")
		assert.NotEmpty(t, userPoolID)
		
		client := helpers.GetCognitoClient(t, "us-east-1")
		userPool := helpers.ValidateUserPoolExists(t, client, userPoolID)
		
		assert.NotNil(t, userPool.Name)
		// Note: UserPoolTier field not available in AWS SDK UserPoolType struct
	})
}

func TestUserPoolWithClients(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: helpers.GetModulePath(),
		Vars: map[string]interface{}{
			"user_pool_name": helpers.GenerateUniqueUserPoolName(t, "with-clients"),
			"enabled":        true,
			"clients": map[string]interface{}{
				"web_client": map[string]interface{}{
					"name": "web-client",
					"explicit_auth_flows": []string{
						"ALLOW_USER_SRP_AUTH",
						"ALLOW_REFRESH_TOKEN_AUTH",
					},
				},
				"mobile_client": map[string]interface{}{
					"name": "mobile-client",
					"explicit_auth_flows": []string{
						"ALLOW_USER_SRP_AUTH",
						"ALLOW_REFRESH_TOKEN_AUTH",
					},
				},
			},
		},
		NoColor: true,
	}

	helpers.ApplyAndValidate(t, terraformOptions, func(t *testing.T, opts *terraform.Options) {
		userPoolID := helpers.GetOutputAsString(t, opts, "id")
		assert.NotEmpty(t, userPoolID)
		
		client := helpers.GetCognitoClient(t, "us-east-1")
		userPool := helpers.ValidateUserPoolExists(t, client, userPoolID)
		assert.NotNil(t, userPool.Name)
		
		// Validate clients
		clientsOutput := helpers.GetOutputAsMap(t, opts, "clients")
		assert.Len(t, clientsOutput, 2)
		
		for clientName, clientData := range clientsOutput {
			clientInfo := clientData.(map[string]interface{})
			clientID := clientInfo["id"].(string)
			
			userPoolClient := helpers.ValidateUserPoolClient(t, client, userPoolID, clientID)
			assert.Equal(t, clientName, *userPoolClient.ClientName)
		}
	})
}

func TestUserPoolWithDomain(t *testing.T) {
	t.Parallel()

	domainName := helpers.GenerateUniqueUserPoolName(t, "domain")

	terraformOptions := &terraform.Options{
		TerraformDir: helpers.GetModulePath(),
		Vars: map[string]interface{}{
			"user_pool_name": helpers.GenerateUniqueUserPoolName(t, "with-domain"),
			"enabled":        true,
			"domain":         domainName,
		},
		NoColor: true,
	}

	helpers.ApplyAndValidate(t, terraformOptions, func(t *testing.T, opts *terraform.Options) {
		userPoolID := helpers.GetOutputAsString(t, opts, "id")
		assert.NotEmpty(t, userPoolID)
		
		domainOutput := helpers.GetOutputAsString(t, opts, "domain")
		assert.Equal(t, domainName, domainOutput)
		
		client := helpers.GetCognitoClient(t, "us-east-1")
		
		// Validate user pool
		userPool := helpers.ValidateUserPoolExists(t, client, userPoolID)
		assert.NotNil(t, userPool.Name)
		
		// Validate domain
		domain := helpers.ValidateUserPoolDomain(t, client, domainName)
		assert.Equal(t, userPoolID, *domain.UserPoolId)
		assert.Equal(t, domainName, *domain.Domain)
	})
}

func TestUserPoolWithPasswordPolicy(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: helpers.GetModulePath(),
		Vars: map[string]interface{}{
			"user_pool_name": helpers.GenerateUniqueUserPoolName(t, "password-policy"),
			"enabled":        true,
			"password_policy": map[string]interface{}{
				"minimum_length":    12,
				"require_lowercase": true,
				"require_numbers":   true,
				"require_symbols":   true,
				"require_uppercase": true,
			},
		},
		NoColor: true,
	}

	helpers.ApplyAndValidate(t, terraformOptions, func(t *testing.T, opts *terraform.Options) {
		userPoolID := helpers.GetOutputAsString(t, opts, "id")
		assert.NotEmpty(t, userPoolID)
		
		client := helpers.GetCognitoClient(t, "us-east-1")
		userPool := helpers.ValidateUserPoolExists(t, client, userPoolID)
		
		// Validate password policy
		assert.NotNil(t, userPool.Policies)
		assert.NotNil(t, userPool.Policies.PasswordPolicy)
		
		passwordPolicy := userPool.Policies.PasswordPolicy
		assert.Equal(t, int64(12), *passwordPolicy.MinimumLength)
		assert.True(t, *passwordPolicy.RequireLowercase)
		assert.True(t, *passwordPolicy.RequireNumbers)
		assert.True(t, *passwordPolicy.RequireSymbols)
		assert.True(t, *passwordPolicy.RequireUppercase)
	})
}

func TestUserPoolWithMFA(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: helpers.GetModulePath(),
		Vars: map[string]interface{}{
			"user_pool_name":    helpers.GenerateUniqueUserPoolName(t, "mfa"),
			"enabled":           true,
			"mfa_configuration": "OPTIONAL",
			"software_token_mfa_configuration": map[string]interface{}{
				"enabled": true,
			},
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
		assert.Equal(t, "OPTIONAL", *userPool.MfaConfiguration)
	})
}

func TestUserPoolWithUserGroups(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: helpers.GetModulePath(),
		Vars: map[string]interface{}{
			"user_pool_name": helpers.GenerateUniqueUserPoolName(t, "user-groups"),
			"enabled":        true,
			"user_groups": []map[string]interface{}{
				{
					"name":        "admin",
					"description": "Admin users",
					"precedence":  1,
				},
				{
					"name":        "users",
					"description": "Regular users",
					"precedence":  2,
				},
			},
		},
		NoColor: true,
	}

	helpers.ApplyAndValidate(t, terraformOptions, func(t *testing.T, opts *terraform.Options) {
		userPoolID := helpers.GetOutputAsString(t, opts, "id")
		assert.NotEmpty(t, userPoolID)
		
		client := helpers.GetCognitoClient(t, "us-east-1")
		userPool := helpers.ValidateUserPoolExists(t, client, userPoolID)
		assert.NotNil(t, userPool.Name)
		
		// Validate user groups output
		userGroupsOutput := helpers.GetOutputAsMap(t, opts, "user_groups")
		assert.Len(t, userGroupsOutput, 2)
		assert.Contains(t, userGroupsOutput, "admin")
		assert.Contains(t, userGroupsOutput, "users")
	})
}

func TestUserPoolDisabled(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: helpers.GetModulePath(),
		Vars: map[string]interface{}{
			"user_pool_name": helpers.GenerateUniqueUserPoolName(t, "disabled"),
			"enabled":        false,
		},
		NoColor: true,
	}

	terraform.Init(t, terraformOptions)
	planStruct := terraform.Plan(t, terraformOptions)
	
	resourceCount := terraform.GetResourceCount(t, planStruct)
	assert.Equal(t, 0, resourceCount.Add, "No resources should be created when enabled is false")
}