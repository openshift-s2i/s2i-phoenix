Phoenix Docker images
=====================

This repository contains the source for building various versions of
Phoenix applications as a reproducible Docker image using
[source-to-image](https://github.com/openshift/source-to-image).
The resulting image can be run using [Docker](http://www.docker.com).

For more information about using this image with OpenShift, please see the
official [OpenShift
Documentation](https://docs.openshift.org/latest/architecture/core_concepts/builds_and_image_streams.html#source-build).

Versions
--------
Elixir versions currently provided are:
* 1.7.2

Erlang versions currently provided are:
* 21.0

Nodejs versions currently provided are:
* 8.11.2

CentOS versions currently supported are:
* CentOS7

Openshift Usage
---------------
To build a Phoenix image:

1. Clone this repo and enter into the directory
  ```
  git clone git@github.com:openshift-s2i/s2i-phoenix.git
  cd s2i-phoenix
  ```

1. Install the example image stream configuration into openshift
  ```
  oc create -f imagestream.json
  ```

1. Create the application
  1. WebUI - Navigate to the project, click 'Add to Project' and search for
     the new builder image, select it and populate the fields to create your
     application
  1. Command Line -
    ```
    oc new-app --image-stream=phoenix --code http://github.com/jtslear/phoenix-example.git
    ```

Local Usage
-----------
To build the Phoenix Builder image:

* This image is available on DockerHub. To download it run:

```
$ docker pull primemodule/phoenix-builder
```

* To build a Phoenix builder image from scratch run:

```
$ git clone https://github.com/primemodule/s2i-phoenix.git
$ cd s2i-phoenix
$ make build VERSION=1.7
```

**If the `VERSION` parameter is ommitted, the build would occur for all versions
configured by this repo**

Test
----
This repository also provides the
[S2I](https://github.com/openshift/source-to-image) test framework,
which launches tests to check functionality of a simple Phoenix application built
on top of the s2i-phoenix image.

```
$ cd s2i-phoenix/1.7
$ docker build -t primemodule/phoenix-builder-candidate . # Test script requires this to be available locally
$ cd ..
$ make test
```
