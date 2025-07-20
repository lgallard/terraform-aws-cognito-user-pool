package unit

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/lgallard/terraform-aws-cognito-user-pool/test/helpers"
	"github.com/stretchr/testify/assert"
)

func TestUserPoolTierValidation(t *testing.T) {
	t.Parallel()

	testCases := []struct {
		name        string
		userPoolTier string
		shouldFail  bool
	}{
		{
			name:        "ValidTierLite",
			userPoolTier: "LITE",
			shouldFail:  false,
		},
		{
			name:        "ValidTierEssentials",
			userPoolTier: "ESSENTIALS",
			shouldFail:  false,
		},
		{
			name:        "ValidTierPlus",
			userPoolTier: "PLUS",
			shouldFail:  false,
		},
		{
			name:        "InvalidTierLowercase",
			userPoolTier: "lite",
			shouldFail:  true,
		},
		{
			name:        "InvalidTierBasic",
			userPoolTier: "BASIC",
			shouldFail:  true,
		},
		{
			name:        "InvalidTierEmpty",
			userPoolTier: "",
			shouldFail:  true,
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
					"user_pool_tier": tc.userPoolTier,
					"enabled":        false, // Don't create resources for validation tests
				},
				NoColor: true,
			}

			if tc.shouldFail {
				_, err := terraform.InitAndPlanE(t, terraformOptions)
				assert.Error(t, err, "Expected validation error for user_pool_tier: %s", tc.userPoolTier)
			} else {
				_, err := terraform.InitAndPlanE(t, terraformOptions)
				assert.NoError(t, err, "Unexpected validation error for user_pool_tier: %s", tc.userPoolTier)
			}
		})
	}
}

func TestRequiredVariables(t *testing.T) {
	t.Parallel()

	testCases := []struct {
		name       string
		vars       map[string]interface{}
		shouldFail bool
	}{
		{
			name: "ValidMinimalConfig",
			vars: map[string]interface{}{
				"user_pool_name": "test-pool",
				"enabled":        false,
			},
			shouldFail: false,
		},
		{
			name: "MissingUserPoolName",
			vars: map[string]interface{}{
				"enabled": false,
			},
			shouldFail: true,
		},
	}

	for _, tc := range testCases {
		tc := tc
		t.Run(tc.name, func(t *testing.T) {
			t.Parallel()

			terraformOptions := &terraform.Options{
				TerraformDir: helpers.GetModulePath(),
				Vars:         tc.vars,
				NoColor:      true,
			}

			if tc.shouldFail {
				_, err := terraform.InitAndPlanE(t, terraformOptions)
				assert.Error(t, err, "Expected validation error for missing required variables")
			} else {
				_, err := terraform.InitAndPlanE(t, terraformOptions)
				assert.NoError(t, err, "Unexpected validation error for valid configuration")
			}
		})
	}
}

func TestPasswordPolicyValidation(t *testing.T) {
	t.Parallel()

	testCases := []struct {
		name           string
		passwordPolicy map[string]interface{}
		shouldFail     bool
	}{
		{
			name: "ValidPasswordPolicy",
			passwordPolicy: map[string]interface{}{
				"minimum_length":    8,
				"require_lowercase": true,
				"require_numbers":   true,
				"require_symbols":   true,
				"require_uppercase": true,
			},
			shouldFail: false,
		},
		{
			name: "ValidMinimumLength",
			passwordPolicy: map[string]interface{}{
				"minimum_length":    6,
				"require_lowercase": false,
				"require_numbers":   false,
				"require_symbols":   false,
				"require_uppercase": false,
			},
			shouldFail: false,
		},
		{
			name: "ValidMaximumLength",
			passwordPolicy: map[string]interface{}{
				"minimum_length":    99,
				"require_lowercase": false,
				"require_numbers":   false,
				"require_symbols":   false,
				"require_uppercase": false,
			},
			shouldFail: false,
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
					"password_policy": tc.passwordPolicy,
					"enabled":         false,
				},
				NoColor: true,
			}

			if tc.shouldFail {
				_, err := terraform.InitAndPlanE(t, terraformOptions)
				assert.Error(t, err, "Expected validation error for password policy")
			} else {
				_, err := terraform.InitAndPlanE(t, terraformOptions)
				assert.NoError(t, err, "Unexpected validation error for password policy")
			}
		})
	}
}

func TestEnabledFlagValidation(t *testing.T) {
	t.Parallel()

	testCases := []struct {
		name    string
		enabled interface{}
		valid   bool
	}{
		{
			name:    "EnabledTrue",
			enabled: true,
			valid:   true,
		},
		{
			name:    "EnabledFalse",
			enabled: false,
			valid:   true,
		},
		{
			name:    "EnabledString",
			enabled: "true",
			valid:   false,
		},
		{
			name:    "EnabledNumber",
			enabled: 1,
			valid:   false,
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
					"enabled":        tc.enabled,
				},
				NoColor: true,
			}

			_, err := terraform.InitAndPlanE(t, terraformOptions)
			
			if tc.valid {
				assert.NoError(t, err, "Unexpected validation error for enabled flag")
			} else {
				assert.Error(t, err, "Expected validation error for invalid enabled flag type")
			}
		})
	}
}