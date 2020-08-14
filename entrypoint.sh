#!/bin/sh

DEBUG=1

log_debug () {
    if [[ $DEBUG ]]; then
        echo " [DEBUG] $@"
    fi
}

log_info () {
    echo " [INFO] $@"
}

log_error () {
    echo " [ERROR] $1" 1>&2
    exit 1
}

dirpath="$1"
pds4_version="$2"
release="$3"
verbose="$4"

# Check valid dirpath is specified
if [ -z "$dirpath" ]; then
    log_error "Valid directory path must be specified (dirpath)."
fi

if [ ! -z "$verbose" ] && [ "$verbose" == "true" ]; then
    DEBUG=0
fi

# Get Latest LDDTool and Validate Versions
lddtool_version=$(curl --silent "https://api.github.com/repos/NASA-PDS/pds4-information-model/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/v//')

# Get Latest IM Version
im_version=$(curl --silent "https://raw.githubusercontent.com/NASA-PDS/pds4-information-model/v${lddtool_version}/model-ontology/src/ontology/Data/config.properties" | grep 'infoModelVersionId' | awk -F= '{print $NF}')

# Convert IM Version
$(python -c "
import string
import os
alphadict = dict(zip(range(10), range(10)))
for x, y in enumerate(string.ascii_uppercase, 10):
  alphadict[x] = str(y)
print(''.join(str(alphadict[int(val)]) for val in '$im_version'.split('.')))
")
im_version_alpha=$(echo $alpha_version)

# Download and Unpack LDDTool
wget --directory-prefix=/tmp https://github.com/NASA-PDS/pds4-information-model/releases/download/v${lddtool_version}/lddtool-${lddtool_version}-bin.tar.gz
tar -xf /tmp/lddtool-${lddtool_version}-bin.tar.gz -C /tmp/
echo $GITHUB_WORKSPACE

# Generate Dictionaries
log_info " Cleanup development versions if they exist"
rm -fr $(dirname $dirpath)
mkdir -p $dirname
cd $dirname

log_info "Generate dictionaries"
dependencies_dir=$GITHUB_WORKSPACE/src/dependencies
if [ -d "$dependencies_dir" ]; then
  files="$dependencies_dir/*/src/*IngestLDD*.xml $GITHUB_WORKSPACE/src/*IngestLDD*.xml"
else
  files="$GITHUB_WORKSPACE/src/*IngestLDD*.xml"
fi

log_info "Generating dictionaries for $files"
/tmp/lddtool-$lddtool_version/bin/lddtool -plJn $files

exit $?
