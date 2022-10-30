#!/bin/bash

# Usage prompt
usage="Usage: $0 [-d <dir path to archive>] [-n <self-extracting archive name>]"

# Read input args
while getopts d:n: flag
do
    case "${flag}" in
        d) dir_path=${OPTARG};;
        n) name=${OPTARG};;
		*) echo "$usage" >&2; exit 1;;
    esac
done

# Validate input args
if [ ! "${dir_path}" ] || [ ! "${name}" ]; then
	if [ ! "${dir_path}" ]; then
		echo "Missing -d arg" >&2
	fi
	if [ ! "${name}" ]; then
		echo "Missing -n arg" >&2
	fi
    echo "$usage" >&2
    exit 1
fi

# Generate self-extracting arch script
script="${name}.sh"
# Write script
cat > ${script} << EOF
#!/bin/sh

# Usage prompt
usage="Usage: \$0 (-o <output path>)"

# Read input args
while getopts o: flag
do
    case "\${flag}" in
        o) output_path=\${OPTARG};;
		*) echo "\$usage" >&2; exit 1;;
    esac
done

# Initalize missing output_path
if [ ! "\${output_path}" ]
then
	unzip_command="tar zxf -"
else
	mkdir \${output_path}
	unzip_command="tar zxf - -C \${output_path}"
fi

# Unzip
sed -e '1,/^DATA_SECTION$/d' ${script} | base64 -d | \${unzip_command}
exit

DATA_SECTION
EOF

# Inejct arch to script
tar -czf - ${dir_path} | base64 >> ${script}

# Grant execution rule
chmod +x ${script}