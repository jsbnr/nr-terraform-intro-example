# Define the variables required by this module.
# We provide defaults where applicable.

variable "policyId" {}
variable "cpu_critical" { default=90 }
variable "cpu_warning" { default=80 }
variable "diskPercent" { default=60 }

# Specify our infra alert conditions
# More details: https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/infra_alert_condition

# Demo Condition 1
resource "newrelic_infra_alert_condition" "cpuhot" {
  policy_id = var.policyId

  name       = "CPU Hot"
  type       = "infra_metric"
  event      = "SystemSample"
  select     = "cpuPercent"
  comparison = "above"
  where      = "(hostname LIKE '%myhost%')"

  critical {
    duration      = 5
    value         = var.cpu_critical 
    time_function = "all"
  }

  warning {
    duration      = 5
    value         = var.cpu_warning
    time_function = "all"
  }
}

# Demo Condition 2
resource "newrelic_infra_alert_condition" "highDiskUsage" {
  policy_id = var.policyId

  name       = "High disk usage"
  type       = "infra_metric"
  event      = "StorageSample"
  select     = "diskUsedPercent"
  comparison = "above"
  where      = "(hostname LIKE '%myhost%')"
  critical {
    duration      = 25
    value         = var.diskPercent
    time_function = "all"
  }
}