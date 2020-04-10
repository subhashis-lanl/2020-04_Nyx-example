
workflow "ECP-Artifacts_002" {
  resolves = "postprocess"
}

action "install dependencies" {
  uses = "sh"
  args = "./sbang.sh setup/install-deps.sh"
}

action "execute" {
  needs = "install dependencies"
  uses = "sh"
  args = "./sbang.sh run/run.sh"
}

action "check job completion" {
  needs = "execute"
  uses = "sh"
  args = "./sbang.sh run/wait_for_completion.sh"
}

action "postprocess" {
  needs = "check job completion"
  uses = "sh"
  args = "./sbang.sh postprocess/postprocess.sh"
}
