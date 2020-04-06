#!/bin/bash
adirProj="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
echo 'adirScript="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"'
echo 'cd ${adirScript}'

bash "${adirProj}/script/docker-compose.yml.sh" "${adirProj}/out/conf.json" "${adirProj}/out/docker-compose.yml"

${adirProj}/util/quote_heredoc.sh "${adirProj}/script/installdc.sh" "installdc.sh" EO1F
${adirProj}/util/quote_heredoc.sh "${adirProj}/out/docker-compose.yml" "docker-compose.yml" EO2F
${adirProj}/util/quote_heredoc.sh "${adirProj}/script/dockercompose.sh" "dockercompose.sh" EO3F
${adirProj}/util/quote_heredoc.sh "${adirProj}/script/gen_self_sign.sh" "gen_self_sign.sh" EO4F
${adirProj}/util/quote_heredoc.sh "${adirProj}/script/installall.sh" "installall.sh" EO5F
${adirProj}/util/quote_heredoc.sh "${adirProj}/script/up.sh" "up.sh" EO6F
${adirProj}/util/quote_heredoc.sh "${adirProj}/script/down.sh" "down.sh" EO6BF
${adirProj}/util/quote_heredoc.sh "${adirProj}/out/conf.json" "conf.json" EO7F
${adirProj}/util/quote_heredoc.sh "${adirProj}/util/install_reqs_and_run.sh" "install_reqs_and_run.sh" EO8F
${adirProj}/util/quote_heredoc.sh "${adirProj}/script/nginx.sh" "nginx.sh" EO9F

echo '(cd "${adirScript}" && bash ${adirScript}/installall.sh)'
