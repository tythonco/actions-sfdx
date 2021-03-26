#!/bin/sh

set -eu

action=${ACTION:-validate}
auth_file_key=${ACTION:-NotSet}
enc_auth_file=${ENC_AUTH_FILE:-sfdx_auth_url.txt.enc}
run_tests=${RUN_TESTS:-NotSet}
scratch_def_file=${SCRATCH_DEF_FILE:-config/project-scratch-def.json}
test_level=${TEST_LEVEL:-NoTestRun}

if [ "${auth_file_key}" = "NotSet" ]
then
	echo "ERROR: Please specify auth file decryption key with auth_file_key argument"
	exit 1
fi

if [ "${action}" = "deploy" ]
then
  cmd="${action} -a ${auth_file_key} -e ${enc_auth_file} -r ${run_tests} -t ${test_level}"
elif [ "${action}" = "test" ]
then
  cmd="${action} -a ${auth_file_key} -e ${enc_auth_file} -s ${scratch_def_file}"
elif [ "${action}" = "validate" ]
then
  cmd="${action} -a ${auth_file_key} -e ${enc_auth_file}"
fi

eval $cmd