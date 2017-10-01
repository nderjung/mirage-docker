# MirageOS Toolchain Container

This is a containerised version of [MirageOS](https://github.com/mirage/mirage).
It enables quick instantiation of the mirage environment and the ability to use
the mirage cli interface in any ad-hoc manner.

At present the container is built on `[centos7](https://hub.docker.com/_/centos/)`,
opam `1.2.2` and OCaml `4.03.0`.  In addition to the `mirage` toolchain it also
contains `mirage-xen` so as to be optimised for this virtualisation environment.

## Basic usage

To build a Mirage project, you can use the container to run `mirage configure`,
mounting your working directory to `/opam/app` like so:

    docker run --rm -it $(pwd):/opam/app \
        a1exanderjung/mirage-toolchain \
        mirage configure

## Future development

[ ] Provide docker tags for all major OCaml versions
[ ] Develop a kvm-based container
