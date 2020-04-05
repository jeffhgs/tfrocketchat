#!/bin/bash
adirScript="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

adirState="/var/lib/installs"

bash "${adirScript}/install_reqs_and_run.sh" "$adirState" "$adirScript/installdc.sh" \
bash "${adirScript}/install_reqs_and_run.sh" "$adirState" "$adirScript/dockercompose.sh" \
bash "${adirScript}/install_reqs_and_run.sh" "$adirState" "$adirScript/gen_self_sign.sh" \
bash up.sh

