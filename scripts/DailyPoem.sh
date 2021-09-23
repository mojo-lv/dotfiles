#!/bin/bash
set -e
sleep 10

_daily_poem="$(curl 'https://v2.jinrishici.com/sentence' -H 'X-User-Token:sq4tG1719MalDdHkc4SGUcifOFG5cjrn')"
_daily_poem=${_daily_poem##*\{}
_daily_poem=${_daily_poem%%\}*}
#echo ${_daily_poem}

#原文
_poem_content=${_daily_poem##*content\":[\"}
_poem_content=${_poem_content//\",\"/}
_poem_content=${_poem_content//。/。\\n}
_poem_content=${_poem_content//？/？\\n}
_poem_content=${_poem_content//！/！\\n}
_poem_content=${_poem_content%%\"]*}
echo ${_poem_content}

if [ ${#_poem_content} -gt 20 ] && [ ${#_poem_content} -lt 200 ]; then
	echo -e ${_poem_content} > ~/.config/conky/poem/content

	#标题
	_poem_title=${_daily_poem##*title\":\"}
	echo ${_poem_title%%\"*} > ~/.config/conky/poem/title

	#朝代作者
	_poem_dynasty=${_daily_poem##*dynasty\":\"}
	_poem_author=${_daily_poem##*author\":\"}
	echo "${_poem_dynasty%%\"*}·${_poem_author%%\"*}" > ~/.config/conky/poem/author
	exit 0
fi
exit 1
