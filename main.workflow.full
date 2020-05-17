workflow "ECP-Artifacts_002" {
resolves = "perform param study"
}

action "install dependencies" {
  uses = "sh"
  args = "./sbang.sh setup/install-deps.sh"
}

action "perform param study" {
  needs = "install dependencies"
  uses = "sh"
  runs = "param_study/perform_param_study.py"
  args = []
}

