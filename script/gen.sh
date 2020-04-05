#!/bin/bash
adirScript="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo 'adirScript="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"'
echo 'cd ${adirScript}'

$HOME/bin/quote_heredoc.sh "$adirScript/installdc.sh" "installdc.sh" EO1F
$HOME/bin/quote_heredoc.sh "$adirScript/docker-compose.yml" "docker-compose.yml" EO2F
$HOME/bin/quote_heredoc.sh "$adirScript/dockercompose.sh" "dockercompose.sh" EO3F
$HOME/bin/quote_heredoc.sh "$adirScript/gen_self_sign.sh" "gen_self_sign.sh" EO4F
$HOME/bin/quote_heredoc.sh "$adirScript/installall.sh" "installall.sh" EO5F
$HOME/bin/quote_heredoc.sh "$adirScript/run.sh" "run.sh" EO6F
echo 'bash ${adirScript}/run.sh'
