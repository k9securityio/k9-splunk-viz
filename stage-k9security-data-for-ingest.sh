#!/usr/bin/env bash
set -e
src_dir="${HOME}/tmp/k9security-inbox/reports/aws"
pushd "$src_dir"

stage_dir="${HOME}/tmp/splunk-inputs/k9security"

src_files=$(find . -mtime -7d -name '*.csv' | sed 's|./||')
splunk_input_dir='/var/local/splunk-inputs/k9security'

echo "staging k9security files in ${stage_dir}"
mkdir -p "${stage_dir}"
for src_file in $src_files; do
  dest_file=$(echo "$src_file" | sed 's|/|_|g')
  echo "src_file: ${src_file} dest_file: ${dest_file}"
  cp "${src_file}" "${stage_dir}/${dest_file}"
done;

popd

splunk_container_name="splunk-integration-splunk-1"

docker container exec --user root "${splunk_container_name}" mkdir -p "${splunk_input_dir}"

echo "copying staged files to ${splunk_input_dir}"
docker cp "${stage_dir}/" "${splunk_container_name}:${splunk_input_dir}"
echo "done ;)"