# OPAM for alpine-3.6 with local switch of OCaml 4.04.2
# Autogenerated by OCaml-Dockerfile scripts
FROM ocaml/ocaml:alpine-3.6
LABEL distro_style="apk" distro="alpine" distro_long="alpine-3.6" arch="x86_64" ocaml_version="4.04.2" opam_version="1.2" operatingsystem="linux"
RUN apk update && apk upgrade && \
  apk add rsync xz opam && \
  apk update && apk upgrade && \
  apk add aspcud && \
  adduser -S opam && \
  echo 'opam ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/opam && \
  chmod 440 /etc/sudoers.d/opam && \
  chown root:root /etc/sudoers.d/opam && \
  sed -i.bak 's/^Defaults.*requiretty//g' /etc/sudoers
USER opam
WORKDIR /home/opam
RUN mkdir .ssh && \
  chmod 700 .ssh && \
  git config --global user.email "docker@example.com" && \
  git config --global user.name "Docker CI" && \
  sudo -u opam sh -c "git clone -b master git://github.com/ocaml/opam-repository" && \
  sudo -u opam sh -c "opam init -a -y --comp 4.04.2 /home/opam/opam-repository" && \
  sudo -u opam sh -c "opam install -y depext travis-opam"
ENTRYPOINT [ "opam", "config", "exec", "--" ]
CMD [ "sh" ]