#!/usr/bin/env bash
# vim: set syntax=bash noexpandtab :

NEWDISPLAY=":4"

function doStartX {
	unset WAYLAND_DISPLAY
	icewm
}

function doCleanup {
	if [ "$XEPHYR_PID" ] && kill -0 "$XEPHYR_PID" 2>/dev/null; then
		kill "$XEPHYR_PID"
		wait "$XEPHYR_PID"
		XEPHYR_STATUS="$?"
	fi

	xauth remove "$NEWDISPLAY"

	if [ "$1" = exit ]; then
		exit "${XEPHYR_STATUS:-0}"
	fi
}

xauth add "$NEWDISPLAY" MIT-MAGIC-COOKIE-! "$(od -An -N16 -tx /dev/urandom | tr -d ' ')"

trap 'doCleanup; trap - INT; kill -INT "$$"' INT
trap 'doCleanup exit' EXIT HUP TERM QUIT

Xephyr -br -reset -terminate -screen 1280x800 -resizeable "$NEWDISPLAY" & XEPHYR_PID="$!"
sleep 2 && DISPLAY="$NEWDISPLAY" doStartX

wait "$XEPHYR_PID"
