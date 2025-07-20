package integration

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/lgallard/terraform-aws-cognito-user-pool/test/helpers"
	"github.com/stretchr/testify/assert"
)

func TestMFASecurityConfigurations(t *testing.T) {
	t.Parallel()

	testCases := []struct {
		name             string
		mfaConfiguration string
		expectedMFA      string
	}{
		{
			name:             "MFAOptional",
			mfaConfiguration: "OPTIONAL",
			expectedMFA:      "OPTIONAL",
		},
		{
			name:             "MFARequired",
			mfaConfiguration: "ON",
			expectedMFA:      "ON",
		},
		{
			name:             "MFADisabled",
			mfaConfiguration: "OFF",
			expectedMFA:      "OFF",
		},
	}

	for _, tc := range testCases {
		tc := tc
		t.Run(tc.name, func(t *testing.T) {
			t.Parallel()

			terraformOptions := &terraform.Options{
				TerraformDir: helpers.GetModulePath(),
				Vars: map[string]interface{}{
					"user_pool_name":    helpers.GenerateUniqueUserPoolName(t, tc.name),
					"enabled":           true,
					"mfa_configuration": tc.mfaConfiguration,
					"software_token_mfa_configuration": map[string]interface{}{
						"enabled": true,
					},
				},
				NoColor: true,
			}

			helpers.ApplyAndValidate(t, terraformOptions, func(t *testing.T, opts *terraform.Options) {
				userPoolID := helpers.GetOutputAsString(t, opts, "id")
				
				client := helpers.GetCognitoClient(t, "us-east-1")
				userPool := helpers.ValidateUserPoolExists(t, client, userPoolID)
				
				assert.NotNil(t, userPool.MfaConfiguration)
				assert.Equal(t, tc.expectedMFA, *userPool.MfaConfiguration)
			})
		})
	}
}

func TestPasswordPolicySecurityRequirements(t *testing.T) {
	t.Parallel()

	testCases := []struct {
		name           string
		passwordPolicy map[string]interface{}
		description    string
	}{
		{
			name: "StrongPasswordPolicy",
			passwordPolicy: map[string]interface{}{
				"minimum_length":    16,
				"require_lowercase": true,
				"require_numbers":   true,
				"require_symbols":   true,
				"require_uppercase": true,
			},
			description: "Very strong password requirements",
		},
		{
			name: "ModeratePasswordPolicy",
			passwordPolicy: map[string]interface{}{
				"minimum_length":    8,
				"require_lowercase": true,
				"require_numbers":   true,
				"require_symbols":   false,
				"require_uppercase": true,
			},
			description: "Moderate password requirements",
		},
		{
			name: "MinimalPasswordPolicy",
			passwordPolicy: map[string]interface{}{
				"minimum_length":    6,
				"require_lowercase": false,
				"require_numbers":   false,
				"require_symbols":   false,
				"require_uppercase": false,
			},
			description: "Minimal password requirements",
		},
	}

	for _, tc := range testCases {
		tc := tc
		t.Run(tc.name, func(t *testing.T) {
			t.Parallel()

			terraformOptions := &terraform.Options{
				TerraformDir: helpers.GetModulePath(),
				Vars: map[string]interface{}{
					"user_pool_name":  helpers.GenerateUniqueUserPoolName(t, tc.name),
					"enabled":         true,
					"password_policy": tc.passwordPolicy,
				},
				NoColor: true,
			}

			helpers.ApplyAndValidate(t, terraformOptions, func(t *testing.T, opts *terraform.Options) {
				userPoolID := helpers.GetOutputAsString(t, opts, "id")
				
				client := helpers.GetCognitoClient(t, "us-east-1")
				userPool := helpers.ValidateUserPoolExists(t, client, userPoolID)
				
				assert.NotNil(t, userPool.Policies)
				assert.NotNil(t, userPool.Policies.PasswordPolicy)
				
				policy := userPool.Policies.PasswordPolicy
				expectedLength := int64(tc.passwordPolicy["minimum_length"].(int))
				assert.Equal(t, expectedLength, *policy.MinimumLength)
				
				assert.Equal(t, tc.passwordPolicy["require_lowercase"].(bool), *policy.RequireLowercase)
				assert.Equal(t, tc.passwordPolicy["require_numbers"].(bool), *policy.RequireNumbers)
				assert.Equal(t, tc.passwordPolicy["require_symbols"].(bool), *policy.RequireSymbols)
				assert.Equal(t, tc.passwordPolicy["require_uppercase"].(bool), *policy.RequireUppercase)
			})
		})
	}
}

func TestAccountTakeoverPrevention(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: helpers.GetModulePath(),
		Vars: map[string]interface{}{
			"user_pool_name": helpers.GenerateUniqueUserPoolName(t, "account-takeover"),
			"enabled":        true,
			"account_recovery_setting": map[string]interface{}{
				"recovery_mechanisms": []map[string]interface{}{
					{
						"name":     "verified_email",
						"priority": 1,
					},
					{
						"name":     "verified_phone_number",
						"priority": 2,
					},
				},
			},
		},
		NoColor: true,
	}

	helpers.ApplyAndValidate(t, terraformOptions, func(t *testing.T, opts *terraform.Options) {
		userPoolID := helpers.GetOutputAsString(t, opts, "id")
		
		client := helpers.GetCognitoClient(t, "us-east-1")
		userPool := helpers.ValidateUserPoolExists(t, client, userPoolID)
		
		// Validate account recovery settings
		if userPool.AccountRecoverySetting != nil {
			assert.NotNil(t, userPool.AccountRecoverySetting.RecoveryMechanisms)
			assert.NotEmpty(t, userPool.AccountRecoverySetting.RecoveryMechanisms)
		}
	})
}

func TestUserPoolSecurityAttributes(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: helpers.GetModulePath(),
		Vars: map[string]interface{}{
			"user_pool_name":          helpers.GenerateUniqueUserPoolName(t, "security-attrs"),
			"enabled":                 true,
			"auto_verified_attributes": []string{"email"},
			"username_attributes":      []string{"email"},
			"deletion_protection":      "ACTIVE",
		},
		NoColor: true,
	}

	helpers.ApplyAndValidate(t, terraformOptions, func(t *testing.T, opts *terraform.Options) {
		userPoolID := helpers.GetOutputAsString(t, opts, "id")
		
		client := helpers.GetCognitoClient(t, "us-east-1")
		userPool := helpers.ValidateUserPoolExists(t, client, userPoolID)
		
		// Validate auto verified attributes
		if userPool.AutoVerifiedAttributes != nil {
			autoVerified := make([]string, len(userPool.AutoVerifiedAttributes))
			for i, attr := range userPool.AutoVerifiedAttributes {
				autoVerified[i] = *attr
			}
			assert.Contains(t, autoVerified, "email")
		}
		
		// Validate username attributes
		if userPool.UsernameAttributes != nil {
			usernameAttrs := make([]string, len(userPool.UsernameAttributes))
			for i, attr := range userPool.UsernameAttributes {
				usernameAttrs[i] = *attr
			}
			assert.Contains(t, usernameAttrs, "email")
		}
		
		// Validate deletion protection
		assert.NotNil(t, userPool.DeletionProtection)
		assert.Equal(t, "ACTIVE", *userPool.DeletionProtection)
	})
}

func TestClientSecuritySettings(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: helpers.GetModulePath(),
		Vars: map[string]interface{}{
			"user_pool_name": helpers.GenerateUniqueUserPoolName(t, "client-security"),
			"enabled":        true,
			"clients": map[string]interface{}{
				"secure_client": map[string]interface{}{
					"name": "secure-client",
					"explicit_auth_flows": []string{
						"ALLOW_USER_SRP_AUTH",
						"ALLOW_REFRESH_TOKEN_AUTH",
					},
					"prevent_user_existence_errors": "ENABLED",
					"enable_token_revocation":       true,
					"enable_propagate_additional_user_context_data": true,
					"access_token_validity":  1,  // 1 hour
					"refresh_token_validity": 30, // 30 days
					"id_token_validity":      1,  // 1 hour
				},
			},
		},
		NoColor: true,
	}

	helpers.ApplyAndValidate(t, terraformOptions, func(t *testing.T, opts *terraform.Options) {
		userPoolID := helpers.GetOutputAsString(t, opts, "id")
		
		client := helpers.GetCognitoClient(t, "us-east-1")
		userPool := helpers.ValidateUserPoolExists(t, client, userPoolID)
		assert.NotNil(t, userPool.Name)
		
		// Validate client security settings
		clientsOutput := helpers.GetOutputAsMap(t, opts, "clients")
		assert.Contains(t, clientsOutput, "secure_client")
		
		clientData := clientsOutput["secure_client"].(map[string]interface{})
		clientID := clientData["id"].(string)
		
		userPoolClient := helpers.ValidateUserPoolClient(t, client, userPoolID, clientID)
		
		// Validate security settings
		assert.Equal(t, "ENABLED", *userPoolClient.PreventUserExistenceErrors)
		assert.True(t, *userPoolClient.EnableTokenRevocation)
		assert.True(t, *userPoolClient.EnablePropagateAdditionalUserContextData)
		
		// Validate token validity periods
		assert.Equal(t, int64(1), *userPoolClient.AccessTokenValidity)
		assert.Equal(t, int64(30), *userPoolClient.RefreshTokenValidity)
		assert.Equal(t, int64(1), *userPoolClient.IdTokenValidity)
	})
}

func TestAdvancedSecurityFeatures(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: helpers.GetModulePath(),
		Vars: map[string]interface{}{
			"user_pool_name": helpers.GenerateUniqueUserPoolName(t, "advanced-security"),
			"enabled":        true,
			"user_pool_add_ons": map[string]interface{}{
				"advanced_security_mode": "ENFORCED",
			},
			"device_configuration": map[string]interface{}{
				"challenge_required_on_new_device":      true,
				"device_only_remembered_on_user_prompt": true,
			},
		},
		NoColor: true,
	}

	helpers.ApplyAndValidate(t, terraformOptions, func(t *testing.T, opts *terraform.Options) {
		userPoolID := helpers.GetOutputAsString(t, opts, "id")
		
		client := helpers.GetCognitoClient(t, "us-east-1")
		userPool := helpers.ValidateUserPoolExists(t, client, userPoolID)
		
		// Validate advanced security mode
		if userPool.UserPoolAddOns != nil {
			assert.Equal(t, "ENFORCED", *userPool.UserPoolAddOns.AdvancedSecurityMode)
		}
		
		// Validate device configuration
		if userPool.DeviceConfiguration != nil {
			assert.True(t, *userPool.DeviceConfiguration.ChallengeRequiredOnNewDevice)
			assert.True(t, *userPool.DeviceConfiguration.DeviceOnlyRememberedOnUserPrompt)
		}
	})
}