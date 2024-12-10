#!/bin/sh

# make progress followable
#set -x

# package name and version  this works on
PACKAGE_NAME="TextWrap-Gedit-Plugin-0.2.1"

# download file url
PACKAGE_DOWNLOAD_URL="http://hartmann-it-design.de/gedit/TextWrap/"${PACKAGE_NAME}.tar.gz




# change current directory to home directory
cd ~

# download archive if it not exists yet
if [ ! -f ${PACKAGE_NAME}.tar.gz ]; then
	wget=$(which wget)
	if [ -x ${wget} ]; then
		echo "downloading ${PACKAGE_DOWNLOAD_URL} ..."
		${wget} "${PACKAGE_DOWNLOAD_URL}" 2>/dev/null
		if [ $? != 0 ]; then
			echo 1>&2 "error: download plugin archive failed for unknown reason - sorry. must quit"
			exit
		fi
	else
		echo 1>&2 "error: no plugin archive found and failed to download because command 'wget' not found. must quit"
		exit
	fi
fi


# extract the downloaded archive if exists or download it
echo "extracting plugin package ${PACKAGE_NAME} ..."
tar -xf ${PACKAGE_NAME}.tar.gz

# change into archive directory and copy files to gedit plugin directory
echo "installing plugin ..."
cd ${PACKAGE_NAME}
test -d ~/.gnome2/gedit/plugins || mkdir -p ~/.gnome2/gedit/plugins
cp TextWrap.py TextWrap.gedit-plugin ~/.gnome2/gedit/plugins/
cd

echo "activating plugin ..."
# activate TextWrap if not already in the list of activated plugins
if [ -x $(which gconftool) ]; then
	gconftool --get /apps/gedit-2/plugins/active-plugins | grep "TextWrap" >/dev/null || ( OLDVALUE=$(gconftool --get /apps/gedit-2/plugins/active-plugins); NEWVALUE=$(echo $OLDVALUE | sed 's/\[/\[TextWrap,/'); gconftool --set --type=list --list-type=string /apps/gedit-2/plugins/active-plugins $NEWVALUE )
fi

# TODO: this shall end with a dialog confirming success or failure by testing existence of files

