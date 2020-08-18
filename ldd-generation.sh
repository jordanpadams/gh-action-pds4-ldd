#
# Script that generates PDS4 LDDs from an IngestLDD file
#

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

datapath="$1"
pds4_im_version="$2"

# Check valid datapath is specified
if [ -z "$datapath" ]; then
    log_error "Valid directory path must be specified (datapath)."
fi

# Get Latest LDDTool and Validate Versions
lddtool_version=$(curl --silent "https://api.github.com/repos/NASA-PDS/pds4-information-model/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/v//')

# Download and Unpack LDDTool
wget -q --directory-prefix=/tmp https://github.com/NASA-PDS/pds4-information-model/releases/download/${lddtool_version}/lddtool-${lddtool_version}-bin.tar.gz
tar -xf /tmp/lddtool-${lddtool_version}-bin.tar.gz -C /tmp/

# Generate Dictionaries
log_info " Cleanup development versions if they exist"
gha_dir=$(dirname $datapath)
parent_dir=$(dirname $gha_dir)
rm -fr $parent_dir
mkdir -p $datapath
cd $datapath

log_info "Generate dictionaries"
dependencies_dir=$GITHUB_WORKSPACE/src/dependencies
if ls $dependencies_dir/*/src/*IngestLDD*.xml 1> /dev/null 2>&1 ; then
  files="$dependencies_dir/*/src/*IngestLDD*.xml $GITHUB_WORKSPACE/src/*IngestLDD*.xml"
else
  files="$GITHUB_WORKSPACE/src/*IngestLDD*.xml"
fi

log_info "Generating dictionaries for $files"
/tmp/lddtool-$lddtool_version/bin/lddtool -plJn $files

exit $?
