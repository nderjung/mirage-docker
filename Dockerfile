FROM centos:7

ENV WORKSPACE /app

RUN yum groupinstall -y 'Development Tools'
RUN yum install -y sudo git patch texinfo wget ocaml ocaml-camlp4-devel \
    ocaml-ocamldoc
RUN git clone -b 1.2 git://github.com/ocaml/opam /tmp/opam
RUN bash -c "cd /tmp/opam && make cold && make prefix=\"/usr\" install && rm -rf /tmp/opam"
RUN sed -i.bak '/LC_TIME LC_ALL LANGUAGE/aDefaults env_keep += "OPAMYES OPAMJOBS OPAMVERBOSE"' /etc/sudoers
RUN echo 'opam ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/opam
RUN chmod 440 /etc/sudoers.d/opam && chown root:root /etc/sudoers.d/opam
RUN sed -i.bak 's/^Defaults.*requiretty//g' /etc/sudoers
RUN rm -Rfv $WORKSPACE && mkdir $WORKSPACE
RUN useradd -d $WORKSPACE -s /bin/bash opam
RUN chown -R opam:opam $WORKSPACE
RUN passwd -l opam
RUN su - opam -c 'opam init -y && opam switch 4.03.0 && eval `opam config env`'
RUN su - opam -c 'echo ". $WORKSPACE/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true" >> .bash_profile'
RUN su - opam -c 'opam install -y mirage mirage-xen'

VOLUME $WORKSPACE
WORKDIR $WORKSPACE

USER opam:opam
