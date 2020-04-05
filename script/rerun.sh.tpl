#!/bin/bash
adirProj="$( cd "$( dirname "$${BASH_SOURCE[0]}" )" && cd .. && pwd )"

set -e

mkdir -p "$adirProj/out"
echo about to generate "$adirProj/out/genout.sh"
rm -f "$adirProj/out/genout.sh"
bash "$adirProj/script/gen.sh" > "$adirProj/out/genout.sh"
bash "$adirProj/script/gen.sh" | ssh -i ~/.ssh/id_gs_temp_2019-01b -l ${userEc2} ${hostEc2} "rm -f /tmp/genout && cat > /tmp/genout.sh"
ssh -i ~/.ssh/id_gs_temp_2019-01b -l ${userEc2} ${hostEc2} "sudo bash /tmp/genout.sh"
