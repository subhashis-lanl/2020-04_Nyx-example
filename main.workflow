workflow "ECP-Artifacts_002" {
resolves = "generate param study scripts"
}

action "install dependencies" {
  uses = "sh"
  args = "./sbang.sh setup/install-deps.sh"
}

action "generate param study scripts" {
  needs = "install dependencies"
  uses = "sh"
  runs = "param_study/generate_scripts.py"
  args = []
}

