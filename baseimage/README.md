# Baseimage Introduction
This directory contains the infrastructure for creating a new baseimage used for the development environment.  The resulting image is published to atlas.hashicorp.com for consumption by developers.

The purpose of this baseimage is to act as a bridge between a raw ubuntu/trust64 configuration and the customizations required for openchain development.  Some of the FOSS components that need to be added to Ubuntu do not have convenient native packages.  Therefore, they are built from source.  However, the build process is generally expensive (often taking in excess of 30 minutes) so it is fairly inefficient to perform these operations every time a developer wishes to 'vagrant up' a new environment.

Therefore, the expensive FOSS components are built into this baseimage once and subsequently cached on the public atlas server so that developers may simply consume the objects without requiring a local build cycle.

# Intended Audience
This is only intended for release managers curating the base image on atlas.  Typical developers may safely ignore this directory completely.

Anyone wishing to customize their development image is encouraged to do so via the vagrant infrastructure in the root directory of this project.

## Exceptions

If a component is found to be both broadly applicable and expensive to build with every "vagrant up", it may be a candidate for inclusion in a future baseimage.

# Usage

* "make" will generate a new .box resource in the CWD, suitable for submission to atlas.
* "make install" will also install the .box into the local vagrant environment, making it suitable to local testing.
