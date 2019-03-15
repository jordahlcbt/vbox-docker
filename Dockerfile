#
#       Copyright 2019, CB Technologies, Inc., All rights reserved.
#
#   GPLv3 HEADER START
#
#       This file is part of vbox-docker.
#
#       vbox-docker is free software: you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation, either version 3 of the License, or
#       (at your option) any later version.
#
#       vbox-docker is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#
#       You should have received a copy of the GNU General Public License
#       along with vbox-docker.  If not, see <https://www.gnu.org/licenses/>.
#
#   GPLv3 HEADER END
#
#       Author: steve.jordahl@cbtechinc.com
#
#       Revisions:
#         1.0  15-Mar-2019
#

FROM ubuntu:18.04
LABEL maintainer "Steve Jordahl <steve.jordahl@cbtechinc.com>"

ENV DEBIAN_FRONTEND noninteractive

RUN buildDeps=' \
		ca-certificates \
		gnupg \
	' \
	&& set -x \
	&& mkdir -p /etc/xdg/QtProject \
	&& apt update && apt upgrade -y && apt install -y \
	curl \
	less \
	vim \
	net-tools \
	libvpx5 \
	kmod \
	$buildDeps --no-install-recommends \
	&& curl -sSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | apt-key add - \
	&& echo "deb http://download.virtualbox.org/virtualbox/debian bionic contrib" >> /etc/apt/sources.list.d/virtualbox.list \
	&& apt-get update && apt-get install -y \
	virtualbox-6.0 \
	--no-install-recommends \
	&& chmod 4711 /usr/lib/virtualbox/VirtualBox \
	&& VBoxVer=`dpkg -s virtualbox-6.0 | grep "^Version" | cut -d " " -f 2 | cut -d "-" -f 1` \
	&& curl --insecure https://download.virtualbox.org/virtualbox/$VBoxVer/Oracle_VM_VirtualBox_Extension_Pack-$VBoxVer.vbox-extpack --output /tmp/Oracle_VM_VirtualBox_Extension_Pack-$VBoxVer.vbox-extpack \
	&& mkdir -p /usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack/ \
	&& tar xzf /tmp/Oracle_VM_VirtualBox_Extension_Pack-6.0.4.vbox-extpack -C /usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack/ \
	&& chmod -R o-w /usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& rm -rf /var/lib/apt/lists/*

COPY container/* /usr/local/bin/

ENTRYPOINT	[ "/usr/local/bin/startvm" ]
