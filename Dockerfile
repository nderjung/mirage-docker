FROM centos:7

ENV WORKSPACE /opam/app

RUN yum groupinstall -y 'Development Tools'
RUN yum install -y sudo git patch texinfo wget ocaml ocaml-camlp4-devel \
    ocaml-ocamldoc
RUN git clone -b 1.2 git://github.com/ocaml/opam /tmp/opam
RUN bash -c "cd /tmp/opam && make cold && make prefix=\"/usr\" install && rm -rf /tmp/opam"
RUN sed -i.bak '/LC_TIME LC_ALL LANGUAGE/aDefaults env_keep += "OPAMYES OPAMJOBS OPAMVERBOSE"' /etc/sudoers
RUN echo 'opam ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/opam
RUN chmod 440 /etc/sudoers.d/opam && chown root:root /etc/sudoers.d/opam
RUN sed -i.bak 's/^Defaults.*requiretty//g' /etc/sudoers
RUN rm -Rfv /opam && mkdir /opam
RUN useradd -d /opam -s /bin/bash opam
RUN chown -R opam:opam /opam
RUN passwd -l opam
RUN su - opam -c 'opam init -y && opam switch 4.03.0'
RUN su - opam -c 'opam install -y mirage mirage-xen'

ADD .bashrc /opam
VOLUME $WORKSPACE
WORKDIR $WORKSPACE
SHELL ["/bin/bash", "-l", "-c"]
USER opam:opam
