#!/bin/sh
rm -rf ./feedback
mkdir feedback
rebar3 edoc
rebar3 shell --apps foa