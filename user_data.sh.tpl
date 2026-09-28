#!/bin/bash
# Bootstraps a fresh Amazon Linux 2023 instance:
#  1. base packages + any extras from var.packages
#  2. Docker, enabled at boot
#  3. CloudWatch Agent, enabled at boot
#  4. whatever application bootstrap you supplied via var.app_user_data
set -euxo pipefail

dnf update -y
dnf install -y docker amazon-cloudwatch-agent
%{ for pkg in packages ~}
dnf install -y ${pkg}
%{ endfor ~}

systemctl enable --now docker
usermod -aG docker ec2-user

# Minimal CloudWatch Agent config: ship system logs so you have something to
# look at from day one. Extend /opt/aws/amazon-cloudwatch-agent/etc/config.json
# to add custom metrics or log files as your application needs grow.
cat > /opt/aws/amazon-cloudwatch-agent/etc/config.json <<'CWAGENT'
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "/ec2/${name}/system",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
CWAGENT

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json -s

# --- Application bootstrap (from var.app_user_data) -----------------------
${app_user_data}
