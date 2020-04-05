#!/bin/bash
adirProj="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
echo 'adirScript="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"'
echo 'cd ${adirScript}'

${adirProj}/util/quote_heredoc.sh "${adirProj}/script/installdc.sh" "installdc.sh" EO1F
${adirProj}/util/quote_heredoc.sh "${adirProj}/script/docker-compose.yml" "docker-compose.yml" EO2F
${adirProj}/util/quote_heredoc.sh "${adirProj}/script/dockercompose.sh" "dockercompose.sh" EO3F
${adirProj}/util/quote_heredoc.sh "${adirProj}/script/gen_self_sign.sh" "gen_self_sign.sh" EO4F
${adirProj}/util/quote_heredoc.sh "${adirProj}/script/installall.sh" "installall.sh" EO5F
${adirProj}/util/quote_heredoc.sh "${adirProj}/script/up.sh" "up.sh" EO6F
${adirProj}/util/quote_heredoc.sh "${adirProj}/out/conf.json" "conf.json" EO7F

echo '(cd "${adirScript}" && bash ${adirScript}/installall.sh)'
