package noprivileged

violations[{"msg": msg}] {
  c := input.spec.template.spec.containers[_]
  c.securityContext.privileged
  msg := sprintf("Container '%s' is set to run as privileged. This is unsafe.", [c.name])
}