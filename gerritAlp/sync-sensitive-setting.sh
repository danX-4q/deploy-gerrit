#!/bin/bash

SETTING_CONF="./sensitive.conf.example"

while getopts "f:" opt
do
	case $opt in
	f)
		SETTING_CONF="$OPTARG"
		;;
	\?)
		echo "Invalid option: -$OPTARG"
		;;
	esac
done

echo "using config file: $SETTING_CONF"

. $SETTING_CONF || { echo "$0 said: error when . $SETTING_CONF"; exit 1; }

function f__set_kv {
	local file="$1"
	local key="$2"
	local value="$3"

	sed -i -e 's#\('"$2"'[[:space:]]*=\)[^[:space:]]*$#\1'"$3"'#g' "$1"
}

function f__set_kv_wr {
        local file="$1"
	local bgn="$2"
	local end="$3"
        local key="$4"
        local value="$5"

	sed -i -e '/'"$2"'/,/'"$3"'/ s/\('"$4"'[[:space:]]*=[[:space:]]*\)[^[:space:]]*$/\1'"$5"'/g' "$1"
}

function f__db_passwd {
	f__set_kv docker-compose.yaml POSTGRES_PASSWORD "$DB_PASSWORD"
	f__set_kv_wr support-files--gerrit/gerrit.config.tmpl "[database]" "[index]" password "$DB_PASSWORD"
}

function f__ldap_admin_passwd {
	f__set_kv docker-compose.yaml LDAP_ADMIN_PASSWORD  "$LDAP_ADMIN_PASSWORD"
	f__set_kv_wr support-files--gerrit/gerrit.config.tmpl "[ldap]" "[sendemail]" password "$LDAP_ADMIN_PASSWORD"
}

function f__canonical_web_url {
	f__set_kv docker-compose.yaml CANONICAL_WEB_URL  "$CANONICAL_WEB_URL"
}

function f__smtp_info {
	f__set_kv_wr support-files--gerrit/gerrit.config.tmpl "[sendemail]" "[sshd]" smtpUser "$SMTP_USER"
	f__set_kv_wr support-files--gerrit/gerrit.config.tmpl "[sendemail]" "[sshd]" smtpPass "$SMTP_PASSWORD"
	f__set_kv_wr support-files--gerrit/gerrit.config.tmpl "[sendemail]" "[sshd]" from "$SMTP_FROM"
}


f__db_passwd
f__ldap_admin_passwd
f__canonical_web_url
f__smtp_info

echo "$0 said: over"

