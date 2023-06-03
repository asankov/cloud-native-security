# 02. Distribute

**The Distribute Phase** is the second phase defined in the **Cloud Native Security Lifecycle**.

This is the Phase where we have commited our changes to git, and are ready to **Distribute** them, e.g. build the artifacts, publish them to the place from which we are going to consumer they later, perform the checks on the artifacts, etc.

This phase includes things like:

- building artifacts (container images/binaries)
- signing artifacts
- scanning artifacts
- scanning manifests, etc.

For a practical example of scanning Kubernetes manifests via Open Policy Agent look [here](./manifest-scanning/).
