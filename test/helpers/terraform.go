package helpers

import (
	"fmt"
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TerraformTestCase represents a test case configuration
type TerraformTestCase struct {
	TestName    string
	ModulePath  string
	VarFiles    []string
	Vars        map[string]interface{}
	Region      string
	BackendVars map[string]interface{}
}

// GetTerraformOptions creates standard Terraform options for testing
func GetTerraformOptions(t *testing.T, testCase TerraformTestCase) *terraform.Options {
	terraformVars := make(map[string]interface{})
	
	// Add default vars
	for k, v := range GetDefaultVars(t, testCase.TestName) {
		terraformVars[k] = v
	}
	
	// Add test-specific vars
	for k, v := range testCase.Vars {
		terraformVars[k] = v
	}
	
	options := &terraform.Options{
		TerraformDir: testCase.ModulePath,
		Vars:         terraformVars,
		VarFiles:     testCase.VarFiles,
		NoColor:      true,
	}
	
	// Add backend configuration if provided
	if len(testCase.BackendVars) > 0 {
		options.BackendConfig = testCase.BackendVars
	}
	
	return options
}

// GetDefaultVars returns common variables used across tests
func GetDefaultVars(t *testing.T, testName string) map[string]interface{} {
	return map[string]interface{}{
		"user_pool_name": GenerateUniqueUserPoolName(t, testName),
		"tags":           GetDefaultTags(),
	}
}

// GetExamplePath returns the path to an example directory
func GetExamplePath(exampleName string) string {
	return filepath.Join("..", "..", "examples", exampleName)
}

// GetFixturePath returns the path to a test fixture
func GetFixturePath(fixtureName string) string {
	return filepath.Join("..", "fixtures", fixtureName)
}

// GetModulePath returns the path to the root module
func GetModulePath() string {
	return filepath.Join("..", "..")
}

// ApplyAndValidate applies Terraform and validates the output
func ApplyAndValidate(t *testing.T, terraformOptions *terraform.Options, validation func(*testing.T, *terraform.Options)) {
	defer terraform.Destroy(t, terraformOptions)
	
	terraform.InitAndApply(t, terraformOptions)
	
	if validation != nil {
		validation(t, terraformOptions)
	}
}

// PlanAndValidate runs terraform plan and validates the plan
func PlanAndValidate(t *testing.T, terraformOptions *terraform.Options, expectedResourceCount int) {
	terraform.Init(t, terraformOptions)
	
	planStruct := terraform.InitAndPlan(t, terraformOptions)
	
	resourceCount := terraform.GetResourceCount(t, planStruct)
	require.Equal(t, expectedResourceCount, resourceCount.Add, 
		fmt.Sprintf("Expected %d resources to be added, but got %d", expectedResourceCount, resourceCount.Add))
}

// GetOutputAsString gets a Terraform output as string
func GetOutputAsString(t *testing.T, terraformOptions *terraform.Options, outputName string) string {
	return terraform.Output(t, terraformOptions, outputName)
}

// GetOutputAsMap gets a Terraform output as map
func GetOutputAsMap(t *testing.T, terraformOptions *terraform.Options, outputName string) map[string]interface{} {
	return terraform.OutputMap(t, terraformOptions, outputName)
}