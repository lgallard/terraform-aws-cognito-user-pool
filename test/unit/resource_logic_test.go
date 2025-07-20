package unit

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/lgallard/terraform-aws-cognito-user-pool/test/helpers"
	"github.com/stretchr/testify/assert"
)

func TestConditionalResourceCreation(t *testing.T) {
	t.Parallel()

	testCases := []struct {
		name                 string
		enabled              bool
		ignoreSchemaChanges  bool
		expectedResourceCount int
	}{
		{
			name:                 "EnabledTrue",
			enabled:              true,
			ignoreSchemaChanges:  false,
			expectedResourceCount: 1, // aws_cognito_user_pool.pool
		},
		{
			name:                 "EnabledFalse",
			enabled:              false,
			ignoreSchemaChanges:  false,
			expectedResourceCount: 0,
		},
		{
			name:                 "EnabledTrueIgnoreSchemaChanges",
			enabled:              true,
			ignoreSchemaChanges:  true,
			expectedResourceCount: 0, // No resources when ignore_schema_changes is true
		},
	}

	for _, tc := range testCases {
		tc := tc
		t.Run(tc.name, func(t *testing.T) {
			t.Parallel()

			terraformOptions := &terraform.Options{
				TerraformDir: helpers.GetModulePath(),
				Vars: map[string]interface{}{
					"user_pool_name":        helpers.GenerateUniqueUserPoolName(t, tc.name),
					"enabled":               tc.enabled,
					"ignore_schema_changes": tc.ignoreSchemaChanges,
				},
				NoColor: true,
			}

			helpers.PlanAndValidate(t, terraformOptions, tc.expectedResourceCount)
		})
	}
}

func TestClientConfiguration(t *testing.T) {
	t.Parallel()

	testCases := []struct {
		name                  string
		clients               interface{}
		expectedClientCount   int
	}{
		{
			name:                "NoClients",
			clients:             map[string]interface{}{},
			expectedClientCount: 0,
		},
		{
			name: "SingleClient",
			clients: map[string]interface{}{
				"client1": map[string]interface{}{
					"name": "test-client-1",
				},
			},
			expectedClientCount: 1,
		},
		{
			name: "MultipleClients",
			clients: map[string]interface{}{
				"client1": map[string]interface{}{
					"name": "test-client-1",
				},
				"client2": map[string]interface{}{
					"name": "test-client-2",
				},
			},
			expectedClientCount: 2,
		},
	}

	for _, tc := range testCases {
		tc := tc
		t.Run(tc.name, func(t *testing.T) {
			t.Parallel()

			terraformOptions := &terraform.Options{
				TerraformDir: helpers.GetModulePath(),
				Vars: map[string]interface{}{
					"user_pool_name": helpers.GenerateUniqueUserPoolName(t, tc.name),
					"enabled":        true,
					"clients":        tc.clients,
				},
				NoColor: true,
			}

			terraform.Init(t, terraformOptions)
			planStruct := terraform.Plan(t, terraformOptions)
			
			resourceCount := terraform.GetResourceCount(t, planStruct)
			
			// Calculate expected total resources (1 user pool + clients)
			expectedTotal := 1 + tc.expectedClientCount
			assert.Equal(t, expectedTotal, resourceCount.Add, 
				"Expected %d total resources (1 user pool + %d clients)", expectedTotal, tc.expectedClientCount)
		})
	}
}

func TestDomainConfiguration(t *testing.T) {
	t.Parallel()

	testCases := []struct {
		name           string
		domain         interface{}
		shouldHaveDomain bool
	}{
		{
			name:             "NoDomain",
			domain:           nil,
			shouldHaveDomain: false,
		},
		{
			name:             "StringDomain",
			domain:           "test-domain",
			shouldHaveDomain: true,
		},
		{
			name: "ObjectDomain",
			domain: map[string]interface{}{
				"domain": "test-domain",
			},
			shouldHaveDomain: true,
		},
	}

	for _, tc := range testCases {
		tc := tc
		t.Run(tc.name, func(t *testing.T) {
			t.Parallel()

			terraformOptions := &terraform.Options{
				TerraformDir: helpers.GetModulePath(),
				Vars: map[string]interface{}{
					"user_pool_name": helpers.GenerateUniqueUserPoolName(t, tc.name),
					"enabled":        true,
					"domain":         tc.domain,
				},
				NoColor: true,
			}

			terraform.Init(t, terraformOptions)
			planStruct := terraform.Plan(t, terraformOptions)
			
			resourceCount := terraform.GetResourceCount(t, planStruct)
			
			expectedCount := 1 // user pool
			if tc.shouldHaveDomain {
				expectedCount++ // add domain resource
			}
			
			assert.Equal(t, expectedCount, resourceCount.Add, 
				"Expected %d resources for domain configuration", expectedCount)
		})
	}
}

func TestMFAConfiguration(t *testing.T) {
	t.Parallel()

	testCases := []struct {
		name              string
		mfaConfiguration  string
		expectedValid     bool
	}{
		{
			name:             "MFAOff",
			mfaConfiguration: "OFF",
			expectedValid:    true,
		},
		{
			name:             "MFAOptional",
			mfaConfiguration: "OPTIONAL",
			expectedValid:    true,
		},
		{
			name:             "MFAOn",
			mfaConfiguration: "ON",
			expectedValid:    true,
		},
		{
			name:             "MFAInvalid",
			mfaConfiguration: "INVALID",
			expectedValid:    false,
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
					"enabled":           false, // Don't create resources for validation
					"mfa_configuration": tc.mfaConfiguration,
				},
				NoColor: true,
			}

			_, err := terraform.InitAndPlanE(t, terraformOptions)
			
			if tc.expectedValid {
				assert.NoError(t, err, "Unexpected error for MFA configuration: %s", tc.mfaConfiguration)
			} else {
				assert.Error(t, err, "Expected error for invalid MFA configuration: %s", tc.mfaConfiguration)
			}
		})
	}
}