#! /usr/bin/env bash

transform_current=$(wlr-randr --json | jq -r '.[] | select(.name == "LVDS-1") | .transform')
transform_new="normal"
[[ "$transform_current" = "normal" ]] && transform_new="90"

wlr-randr --output LVDS-1 --transform "$transform_new"
exit $?
