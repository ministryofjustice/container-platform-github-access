locals {
  name = var.use_name_prefix ? "${var.name_prefix} ${var.name}" : var.name
}

resource "pagerduty_escalation_policy" "this" {
  name        = local.name
  description = var.description
  num_loops   = var.num_loops
  teams       = [var.team]

  dynamic "rule" {
    for_each = var.rules
    content {
      escalation_delay_in_minutes = rule.value.escalation_delay_in_minutes
      dynamic "target" {
        for_each = rule.value.targets
        content {
          type = target.value.type
          id   = target.value.id
        }
      }
    }
  }
}
