workflow "ECP-Artifacts_002" {
resolves = "generate param study scripts"
}

action "generate param study scripts" {
  uses = "sh"
  runs = "param_study/generate_scripts.py"
  args = []
}

