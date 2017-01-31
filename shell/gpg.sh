function reshadow() {
	local keydir="$(gpgconf --list-dirs homedir)/private-keys-v1.d"
	if [ -d "${keydir}" ]; then
		for key in $(find ${keydir} -name \*.key); do
			if [ "$(head -c 24 $key | tail -c 20)" = "shadowed-private-key" ]; then
				rm -f "$key"
			fi
		done
		gpg --card-status &> /dev/null
		echo "Done"
	else
		echo "GPG keydir not found" >&2
		return 1
	fi
}

if [ !"$SSH_CONNECTION" ] && [ "$SSH_TTY" != $(tty) ]; then
	# Set GPG TTY
	export GPG_TTY=$(tty)

	# Refresh gpg-agent tty in case user switches into an X session
	gpg-connect-agent updatestartuptty /bye >/dev/null

	# Set SSH to use gpg-agent
	unset SSH_AGENT_PID
	if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
		export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
		if [ ! -e "$SSH_AUTH_SOCK" ]; then
			export SSH_AUTH_SOCK="$(gpgconf --list-dirs | grep homedir | cut -d: -f2)/S.gpg-agent.ssh"
		fi
	fi
fi
