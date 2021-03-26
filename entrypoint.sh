#!/bin/sh

set -eu

action=${ACTION:-validate}
enc_auth_file=${ENC_AUTH_FILE:-sfdx_auth_url.txt.enc}
run_tests=${RUN_TESTS:-NotSet}
scratch_def_file=${SCRATCH_DEF_FILE:-config/project-scratch-def.json}
test_level=${TEST_LEVEL:-NoTestRun}
cmd="${action} -e ${enc_auth_file} -r ${run_tests} -s ${scratch_def_file} -t ${test_level}"

eval $cmd