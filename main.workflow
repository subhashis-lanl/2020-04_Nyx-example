
workflow "ECP-Artifacts_002" {
  resolves = "install dependencies"
}

action "install dependencies" {
  uses = "sh"
  args = "./sbang.sh setup/install-deps.sh"
}
