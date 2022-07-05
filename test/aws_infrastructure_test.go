package aws_infrastructure

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"testing"
	"time"

	"github.com/a8m/envsubst"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

type MainJson struct {
	Region        string     `json:"region"`
	Vpc           VpcJson    `json:"vpc"`
	Public        SubnetJson `json:"public"`
	Private       SubnetJson `json:"private"`
	AppLB         AppJson    `json:"alb"`
	GateLB        GateJson   `json:"glb"`
	Ecs           EcsJson    `json:"ecs"`
	Eks           EksJson    `json:"eks"`
	ExecutionRole IamJson    `json:"execution_role"`
	TaskRole      IamJson    `json:"task_role"`
	EksRole       IamJson    `json:"eks_role"`
}

type VpcJson struct {
	Name string `json:"name"`
	Cidr string `json:"cidr"`
}

type SubnetJson struct {
	Name             string `json:"name"`
	Cidr             string `json:"cidr"`
	AvailabilityZone string `json:"az"`
}

type AppJson struct {
	Name string `json:"name"`
}

type GateJson struct {
	Name string `json:"name"`
}

type EcsJson struct {
	Name string `json:"name"`
}

type EksJson struct {
	Name string `json:"name"`
}

// TODO: Add in checks for policies.
type IamJson struct {
	Name string `json:"name"`
}

var deployment_passed bool
var ExpectedJson MainJson

func init() {
	jsonFile, err := os.Open("./aws_infrastructure_testdata.json")
	if err != nil {
		fmt.Println(err)
	}
	byteVal, _ := ioutil.ReadAll(jsonFile)
	json.Unmarshal(byteVal, &ExpectedJson)
}
func TestAWSInfraInput(t *testing.T) {
	t.Parallel()

	directory, err := envsubst.String("../${ENVIRONMENT}")
	if err != nil {
		fmt.Println(err)
	}

	file, err := envsubst.String("input-${ENVIRONMENT}.tfvars")
	if err != nil {
		fmt.Println(err)
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: directory,
		VarFiles:     []string{file},
		NoColor:      true,
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	ActualJson := MainJson{
		Region: terraform.Output(t, terraformOptions, "region"),
		Vpc: VpcJson{
			Name: terraform.Output(t, terraformOptions, "vpc_name"),
			Cidr: terraform.Output(t, terraformOptions, "vpc_cidr"),
		},
		Public: SubnetJson{
			Name:             terraform.Output(t, terraformOptions, "public_one_name"),
			Cidr:             terraform.Output(t, terraformOptions, "public_one_cidr"),
			AvailabilityZone: terraform.Output(t, terraformOptions, "public_one_az"),
		},
		Private: SubnetJson{
			Name:             terraform.Output(t, terraformOptions, "private_two_name"),
			Cidr:             terraform.Output(t, terraformOptions, "private_two_cidr"),
			AvailabilityZone: terraform.Output(t, terraformOptions, "private_two_az"),
		},
		AppLB: AppJson{
			Name: terraform.Output(t, terraformOptions, "app_load_balancer_name"),
		},
		GateLB: GateJson{
			Name: terraform.Output(t, terraformOptions, "gateway_load_balancer_name"),
		},
		Ecs: EcsJson{
			Name: terraform.Output(t, terraformOptions, "ecs_name"),
		},
		Eks: EksJson{
			Name: terraform.Output(t, terraformOptions, "eks_name"),
		},
		ExecutionRole: IamJson{
			Name: terraform.Output(t, terraformOptions, "ecs_role_name"),
		},
		TaskRole: IamJson{
			Name: terraform.Output(t, terraformOptions, "task_role_name"),
		},
		EksRole: IamJson{
			Name: terraform.Output(t, terraformOptions, "eks_role_name"),
		},
	}

	if assert.Equal(t, ExpectedJson.Region, ActualJson.Region) {
		deployment_passed = true
		t.Logf("PASS: The expected region of the project, %v, matches the actual region of the project.", ExpectedJson.Region)
	} else {
		deployment_passed = false
		terraform.Destroy(t, terraformOptions)
		t.Fatalf("FAIL: Expected %v, but found %v", ExpectedJson.Region, ActualJson.Region)
	}

	if assert.Equal(t, ExpectedJson.AppLB, ActualJson.AppLB) {
		deployment_passed = true
		t.Logf("PASS: The expected App Load Balancer name, %v, matches the actual App Load Balancer name.", ExpectedJson.AppLB.Name)
	} else {
		deployment_passed = false
		terraform.Destroy(t, terraformOptions)
		t.Fatalf("FAIL: Expected %v, but found %v", ExpectedJson.AppLB.Name, ActualJson.AppLB.Name)
	}

	if assert.Equal(t, ExpectedJson.GateLB, ActualJson.GateLB) {
		deployment_passed = true
		t.Logf("PASS: The expected Gateway Load Balancer name, %v, matches the actual Gateway Load Balancer name.", ExpectedJson.GateLB.Name)
	} else {
		deployment_passed = false
		terraform.Destroy(t, terraformOptions)
		t.Fatalf("FAIL: Expected %v, but found %v.", ExpectedJson.GateLB.Name, ActualJson.GateLB.Name)
	}

	if assert.Equal(t, ExpectedJson.Eks, ActualJson.Eks) {
		deployment_passed = true
		t.Logf("PASS: The expected EKS cluster name, %v, matches the actual EKS cluster name.", ExpectedJson.Eks.Name)
	} else {
		deployment_passed = false
		terraform.Destroy(t, terraformOptions)
		t.Fatalf("FAIL: Expected %v, but found %v.", ExpectedJson.Eks.Name, ActualJson.Eks.Name)
	}

	if assert.Equal(t, ExpectedJson.Ecs, ActualJson.Ecs) {
		deployment_passed = true
		t.Logf("PASS: The expected ECS cluster name, %v, matches the actual ECS cluster name.", ExpectedJson.Ecs.Name)
	} else {
		deployment_passed = false
		terraform.Destroy(t, terraformOptions)
		t.Fatalf("FAIL: Expected %v, but found %v.", ExpectedJson.Ecs.Name, ActualJson.Ecs.Name)
	}

	if assert.Equal(t, ExpectedJson.ExecutionRole, ActualJson.ExecutionRole) {
		deployment_passed = true
		t.Logf("PASS: The expected ECS execution role name, %v, matches the actual ECS execution role name.", ExpectedJson.ExecutionRole.Name)
	} else {
		deployment_passed = false
		terraform.Destroy(t, terraformOptions)
		t.Fatalf("FAIL: Expected %v, but found %v.", ExpectedJson.ExecutionRole.Name, ActualJson.ExecutionRole.Name)
	}

	if assert.Equal(t, ExpectedJson.TaskRole, ActualJson.TaskRole) {
		deployment_passed = true
		t.Logf("PASS: The expected ECS task role name, %v, matches the actual ECS task role name.", ExpectedJson.TaskRole.Name)
	} else {
		deployment_passed = false
		terraform.Destroy(t, terraformOptions)
		t.Fatalf("FAIL: Expected %v, but found %v.", ExpectedJson.TaskRole.Name, ActualJson.TaskRole.Name)
	}

	if assert.Equal(t, ExpectedJson.EksRole, ActualJson.EksRole) {
		deployment_passed = true
		t.Logf("PASS: The expected EKS role name, %v, matches the actual EKS role name.", ExpectedJson.EksRole.Name)
	} else {
		deployment_passed = false
		terraform.Destroy(t, terraformOptions)
		t.Fatalf("FAIL: Expected %v, but found %v.", ExpectedJson.EksRole.Name, ActualJson.EksRole.Name)
	}

	if assert.Equal(t, ExpectedJson.Vpc, ActualJson.Vpc) {
		deployment_passed = true
		t.Logf("PASS: The expected name of the VPC, %v, matches the actual name of the VPC.", ExpectedJson.Vpc.Name)
		t.Logf("PASS: The expected CIDR block for the VPC, %v, matches the actual CIDR block for the VPC.", ExpectedJson.Vpc.Cidr)
	} else {
		deployment_passed = false
		terraform.Destroy(t, terraformOptions)
		t.Fatalf("FAIL: Expected %v, but found %v.", ExpectedJson.Vpc, ActualJson.Vpc)
	}

	if assert.Equal(t, ExpectedJson.Public, ActualJson.Public) {
		deployment_passed = true
		t.Logf("PASS: The expected name of the first public subnet, %v, matches the actual name of the first public subnet.", ExpectedJson.Public.Name)
		t.Logf("PASS: The expected CIDR block for the first public subnet, %v, matches the actual CIDR block for the first public subnet.", ExpectedJson.Public.Cidr)
		t.Logf("PASS: The expected availability zone for the first public subnet, %v, matches the actual availability zone for the first public subnet.", ExpectedJson.Public.AvailabilityZone)
	} else {
		deployment_passed = false
		terraform.Destroy(t, terraformOptions)
		t.Fatalf("FAIL: Expected %v, but found %v.", ExpectedJson.Public, ActualJson.Public)
	}

	if assert.Equal(t, ExpectedJson.Private, ActualJson.Private) {
		deployment_passed = true
		t.Logf("PASS: The expected name of the second private subnet, %v, matches the actual name of the second private subnet.", ExpectedJson.Private.Name)
		t.Logf("PASS: The expected CIDR block for the second private subnet, %v, matches the actual CIDR block for the second private subnet.", ExpectedJson.Private.Cidr)
		t.Logf("PASS: The expected availability zone for the second private subnet, %v, matches the actual availability zone for the second private subnet.", ExpectedJson.Private.AvailabilityZone)
	} else {
		deployment_passed = false
		terraform.Destroy(t, terraformOptions)
		t.Fatalf("FAIL: Expected %v, but found %v.", ExpectedJson.Private, ActualJson.Private)
	}

	time.Sleep(120 * time.Second)
	fmt.Println("Sleep Over...")
}
