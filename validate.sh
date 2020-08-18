log_info () {
    echo " [INFO] $@"
}

log_error () {
    echo " [ERROR] $1" 1>&2
    exit 1
}

datapath="$1"
schemas="$2"
schematrons="$3"
skip_content_validation="$4"
failure_expected="$5"

# Check valid datapath is specified
if [ -z "$datapath" ]; then
    log_error "Valid directory path must be specified (datapath)."
fi

if  [ ! -d "$datapath" ]; then
    log_error "Valid directory path must be specified. Datapath: $datapath"
fi

# Check datapath contains schemas / schematrons / labels to validate
if ! ls $datapath/*.xml 1> /dev/null 2>&1 ; then
    log_error "Invalid datapath. Must contain at least one of schema, schematron, and XML label"
fi

# Get latest validate version from Github
validate_version=$(curl --silent "https://api.github.com/repos/NASA-PDS/validate/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/v//')
log_info "Validate version: $validate_version"

# Download the latest version and unpack
if [ ! -f "/tmp/validate-${validate_version}-bin.tar.gz" ]; then
    wget -q --directory-prefix=/tmp https://github.com/NASA-PDS/validate/releases/download/${validate_version}/validate-${validate_version}-bin.tar.gz
    tar -xf /tmp/validate-${validate_version}-bin.tar.gz -C /tmp/
fi

# Add applicable Validate arguments per action options
args="-R pds4.label --skip-content-validation"
if [ -n "$schemas" ]; then
    args="$args -x $schemas"
fi

if [ -n "$schematrons" ]; then
    args="$args -S $schematrons"
fi

# Validate the data
/tmp/validate-${validate_version}/bin/validate -t $datapath/*_VALID.xml $args
valid_exitcode=$?

/tmp/validate-${validate_version}/bin/validate -t $datapath/*_FAIL.xml $args
fail_exitcode=$?

# Check for expected failure
if $fail_exitcode && [ "$failure_expected" == "true" ]; then
    echo "[FAIL] Validate expected to fail, but executed successfully."
    exit 1
fi

exit $valid_exitcode
