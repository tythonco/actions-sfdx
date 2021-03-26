#!/bin/sh

set -eu

command=${COMMAND:-validate}
auth_file_key=${AUTH_FILE_KEY:-NotSet}
enc_auth_file=${ENC_AUTH_FILE:-sfdx_auth_url.txt.enc}
run_tests=${RUN_TESTS:-NotSet}
scratch_def_file=${SCRATCH_DEF_FILE:-config/project-scratch-def.json}
test_level=${TEST_LEVEL:-NoTestRun}

if { [ "${command}" = "deploy" ] || [ "${command}" = "test-scratch" ] || [ "${command}" = "validate" ]; } && [ "${auth_file_key}" = "NotSet" ];
then
	echo "ERROR: Please specify auth file decryption key with auth_file_key argument"
	exit 1
fi

if [ "${command}" = "deploy" ]
then
  cmd="${command} -a ${auth_file_key} -e ${enc_auth_file} -r ${run_tests} -t ${test_level}"
elif [ "${command}" = "test-scratch" ]
then
  cmd="${command} -a ${auth_file_key} -e ${enc_auth_file} -s ${scratch_def_file}"
elif [ "${command}" = "validate" ]
then
  cmd="${command} -a ${auth_file_key} -e ${enc_auth_file}"
else
  cmd="${command}"
fi

eval "${cmd}"