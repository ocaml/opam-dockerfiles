# OPAM for ubuntu-12.04 with local switch of OCaml 4.04.1+flambda
# Autogenerated by OCaml-Dockerfile scripts
FROM ocaml/ocaml:ubuntu-12.04
LABEL distro_style="apt" distro="ubuntu" distro_long="ubuntu-12.04" arch="x86_64" ocaml_version="4.04.1+flambda" opam_version="1.2" operatingsystem="linux"
RUN apt-get -y update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install aspcud && \
  git clone -b 1.2 git://github.com/ocaml/opam /tmp/opam && \
  sh -c "cd /tmp/opam && make cold && make install && echo Not installing OPAM2 wrappers && rm -rf /tmp/opam" && \
  echo 'opam ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/opam && \
  chmod 440 /etc/sudoers.d/opam && \
  chown root:root /etc/sudoers.d/opam && \
  adduser --disabled-password --gecos '' opam && \
  passwd -l opam && \
  chown -R opam:opam /home/opam
USER opam
ENV HOME /home/opam
WORKDIR /home/opam
RUN mkdir .ssh && \
  chmod 700 .ssh && \
  git config --global user.email "docker@example.com" && \
  git config --global user.name "Docker CI" && \
  sudo -u opam sh -c "git clone -b master git://github.com/ocaml/opam-repository" && \
  sudo -u opam sh -c "opam init -a -y --comp 4.04.1+flambda /home/opam/opam-repository" && \
  sudo -u opam sh -c "opam install -y depext travis-opam"
ENTRYPOINT [ "opam", "config", "exec", "--" ]
CMD [ "bash" ]