Phoenix Docker images
=====================

[![CircleCI](https://circleci.com/gh/jtslear/s2i-phoenix.svg?style=svg)](https://circleci.com/gh/jtslear/s2i-phoenix)

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
* 1.3.1


Erlang versions currently provided are:
* 18.3


Nodejs versions currently provided are:
* 6.3.0

CentOS versions currently supported are:
* CentOS7

Installation
---------------
To build a Phoenix image:
*  **CentOS based image**

    This image is available on DockerHub. To download it run:

    ```
    $ docker pull jtslear/phoenix-builder
    ```

    To build a Phoenix builder image from scratch run:

    ```
    $ git clone https://github.com/jtslear/s2i-phoenix.git
    $ cd s2i-phoenix
    $ docker build .
    ```

Test
---------------------
This repository also provides the
[S2I](https://github.com/openshift/source-to-image) test framework,
which launches tests to check functionality of a simple Phoenix application built
on top of the s2i-phoenix image.

Users can choose between testing a Ruby test application based on a RHEL or
CentOS image.

*  **CentOS based image**

    ```
    $ cd s2i-ruby
    $ docker build -t jtslear/phoenix-builder-candidate . # Test script requires this to be available locally
    $ ./test/run
    ```
