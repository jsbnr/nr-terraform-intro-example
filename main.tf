# Define the alert policy resource
# More details: https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/alert_policy

resource "newrelic_alert_policy" "DemoPolicy" {
  name = "My Demo Policy"
  incident_preference = "PER_POLICY" # PER_POLICY is default
}


# Define a notification channel resource
# More details: https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/alert_channel

resource "newrelic_alert_channel" "DemoChannel" {
  name = "My Demo Channel"
  type = "email"

  config {
    recipients              = "jbuchanan@newrelic.com" # Use the email address on your New Relic account
    include_json_attachment = "1"
  }
}


# Subscribe alert policy to notification channel(s)
# More details: https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/alert_policy_channel

resource "newrelic_alert_policy_channel" "ChannelSubs" {
  policy_id  = newrelic_alert_policy.DemoPolicy.id
  channel_ids = [
    newrelic_alert_channel.DemoChannel.id
  ]
}

# Call our module to set the conditions
# More details regarding modules here: https://www.terraform.io/docs/modules/index.html

module "HostConditions" {
  source = "./modules/HostConditions"
  #source = "git::https://github.com/username/repo.git" #you can also specify a module from Git etc
  policyId = newrelic_alert_policy.DemoPolicy.id
  cpu_critical = 88
  cpu_warning = 78 
  diskPercent = 68
}


# -------------------
# Example of importing data for an existing resource.
# In this case an alert policy resources called "Preexisting Policy"
# Create a policy in your own account add add its name here to run example


# # Import an existing policy resource
# # More details here: https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/data-sources/alert_policy

# data "newrelic_alert_policy" "ExistingPolicy" {
#   name = "Preexisting Policy"
# }

# module "HostConditions2" {
#   source = "./modules/HostConditions"
#   #source = "git::https://github.com/username/repo.git"
#   policyId = newrelic_alert_policy.DemoPolicy.id
#   cpu_critical = 87
#   cpu_warning = 77
#   diskPercent = 67
# }

# -------------------