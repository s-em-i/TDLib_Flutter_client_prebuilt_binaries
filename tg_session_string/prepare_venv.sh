#!/usr/bin/env bash

in_venv() {
    python3 - << 'EOF'
import sys

def get_base_prefix_compat():
    """Get base/real prefix, or sys.prefix if there is none."""
    return (
        getattr(sys, "base_prefix", None)
        or getattr(sys, "real_prefix", None)
        or sys.prefix
    )

if sys.prefix != get_base_prefix_compat(): 
	print('true')
else:
	print('false')
EOF
}

if ! $(in_venv); then
	if [ ! -d .venv ]; then
		python3 -m venv .venv
		export FRESHVENV=1
	fi
	source .venv/bin/activate
	"${0}"
	exec /usr/bin/env bash -i
fi

python3 --version

if [ ! -z $FRESHVENV ]; then
	pip install Telethon==1.41.2
fi
