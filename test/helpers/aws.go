package helpers

import (
	"fmt"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/cognitoidentityprovider"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/stretchr/testify/require"
)

// GenerateUniqueUserPoolName generates a unique user pool name for testing
func GenerateUniqueUserPoolName(t *testing.T, testName string) string {
	uniqueID := strings.ToLower(random.UniqueId())
	return fmt.Sprintf("test-%s-%s", testName, uniqueID)
}

// GetCognitoClient returns a Cognito Identity Provider client for the specified region
func GetCognitoClient(t *testing.T, region string) *cognitoidentityprovider.CognitoIdentityProvider {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(region),
	})
	require.NoError(t, err)

	return cognitoidentityprovider.New(sess)
}

// ValidateUserPoolExists checks if a user pool exists and returns its details
func ValidateUserPoolExists(t *testing.T, client *cognitoidentityprovider.CognitoIdentityProvider, userPoolID string) *cognitoidentityprovider.UserPoolType {
	input := &cognitoidentityprovider.DescribeUserPoolInput{
		UserPoolId: aws.String(userPoolID),
	}

	result, err := client.DescribeUserPool(input)
	require.NoError(t, err)
	require.NotNil(t, result.UserPool)

	return result.UserPool
}

// ValidateUserPoolClient checks if a user pool client exists and returns its details
func ValidateUserPoolClient(t *testing.T, client *cognitoidentityprovider.CognitoIdentityProvider, userPoolID, clientID string) *cognitoidentityprovider.UserPoolClientType {
	input := &cognitoidentityprovider.DescribeUserPoolClientInput{
		UserPoolId: aws.String(userPoolID),
		ClientId:   aws.String(clientID),
	}

	result, err := client.DescribeUserPoolClient(input)
	require.NoError(t, err)
	require.NotNil(t, result.UserPoolClient)

	return result.UserPoolClient
}

// ValidateUserPoolDomain checks if a user pool domain exists
func ValidateUserPoolDomain(t *testing.T, client *cognitoidentityprovider.CognitoIdentityProvider, domain string) *cognitoidentityprovider.DomainDescriptionType {
	input := &cognitoidentityprovider.DescribeUserPoolDomainInput{
		Domain: aws.String(domain),
	}

	result, err := client.DescribeUserPoolDomain(input)
	require.NoError(t, err)
	require.NotNil(t, result.DomainDescription)

	return result.DomainDescription
}

// ValidateUserPoolDestroyed checks that a user pool has been properly destroyed
func ValidateUserPoolDestroyed(t *testing.T, client *cognitoidentityprovider.CognitoIdentityProvider, userPoolID string) {
	input := &cognitoidentityprovider.DescribeUserPoolInput{
		UserPoolId: aws.String(userPoolID),
	}

	_, err := client.DescribeUserPool(input)
	require.Error(t, err)
	require.Contains(t, err.Error(), "UserPoolNotFound")
}

// GetDefaultTags returns the default tags used for testing
func GetDefaultTags() map[string]interface{} {
	return map[string]interface{}{
		"Environment": "test",
		"Terraform":   "true",
		"Purpose":     "terratest",
	}
}

// GenerateTestEmailAddress generates a test email address
func GenerateTestEmailAddress(t *testing.T) string {
	uniqueID := strings.ToLower(random.UniqueId())
	return fmt.Sprintf("test-%s@example.com", uniqueID)
}
