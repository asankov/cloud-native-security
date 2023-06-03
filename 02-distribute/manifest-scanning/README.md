# Manifest Scanning

This is a practical example of Manifest Scanning via [Open Policy Agent (OPA)](https://www.openpolicyagent.org/).

Manifest Scanning is the process of scanning our manifests (non-code artifacts, e.g. Kubernetes manifests, Terraform files, Dockerfiles, etc.) for misconfigurations, bad-practices, etc.

In this example we are going to verify that our Kubernetes Deployment don't have any containers that run as root.
This is a [security bad-practice](https://dev.to/techworld_with_nana/run-pod-with-root-privileges-41n9) and should be avoided unless strictly necessary.

The [`policy.rego`](./policy.rego) file contains the Rego policies, which OPA will use to verify our manifests.

[`deploy.yaml`](./deploy.yaml) contains a Kubernetes Deployment.

We can use the OPA CLI to validate the manifest file against the policy:

```shell
opa eval -i deploy.yaml -d policy.rego 'data.noprivileged.violations[_].msg' --fail-defined
```

The `--fail-defined` flag means that the command will fail (return a non-zero error code) if the policy check output any violations.

[This CI Job](https://gitlab.com/asankov/cloud-native-security/-/jobs/4345862664) is an example of a failed policy check.

[This CI Job](https://gitlab.com/asankov/cloud-native-security/-/jobs/4345954918) is an example of a successfull policy check.
