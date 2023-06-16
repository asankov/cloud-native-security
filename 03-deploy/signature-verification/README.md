# Signature Verification

Signing and verifying the signatures of your artifacts is an important step in the Cloud Native Security Lifecycle.

Doing this allows you to verify that your artifacts have not been tampered with.

The signing and verification happen in different stages.

## Signing

The signing is done in the **Distrubite phase**, for example your CI pipeline, where you are building the articats.

In this example, we are going to use [Cosign](https://github.com/sigstore/cosign) for that job.

First, we need to login to the container registry in which we are holding the image we want to sign:

```shell
docker login -u $USERNAME -p $PASSWORD $REGISTRY
```

Then, assuming we already have a private key we can sign the container image with the Cosign CLI:

```shell
cosign sign --key $COSIGN_KEY -y $IMAGE_REPO
```

`$COSIGN_KEY` is the file that holds our private key.
The way we store and use this key is the most important thing in this pipeline.
If our private key is compromised the whole process is useless, because any attacked can sign whatever they want and that would be trusted.

When signing via the `cosign sign` command Cosign will automatically push the signature to the container registry, so that we can later pull it and verify it.

## Verification

The verificaiton is done in the next phase - **Deploy**.
We want the verification to be done as closely to the actual deploy as possible.
Ideally that will happen in the orchestrator/platform we are using for deploying.

In the case of Kubernetes, that is easy, because we can use [Admission Validation Webhooks](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/).

First, we need to install the Validating Webhook.
We can do this via the Hel chart, provided by the Cosign team:

```shell
# create the cosign namespace
kubectl create namespace cosign-system
# install the Helm chart
helm install policy-controller -n cosign-system sigstore/policy-controller
```

Now, we need to create a `ClusterImagePolicy` resource that will tell Cosign which images to validate and how to do it.

There is a sample `ClusterImagePolicy` in [this file](./cluster-image-policy.yaml).

The `spec.images.glob="**"` tells Cosign to validate ALL images being deployed to the cluster.
The `spec.authorities[].key.data` is the public key with which they will be validated.
This public key is part of the public-private key pair used for the signature.
Public keys are safe to be shared and shown (in constrast with private key, which should be kept as hidden as possible).

After you have installed the Cosign validating webhook and the `ClusterImagePolicy` resource you can try to deploy signed and non-signed images.

If you try to deploy an image that is not signed, you will get an error similar to this, and deploying a signed image should be successful.
