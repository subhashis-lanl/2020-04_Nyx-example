workflow "ECP-Artifacts_002" {
resolves = "perform param study scripts"
}

action "perform param study scripts" {
  uses = "sh"
  runs = "param_study/perform_param_study.py"
  args = []
}

