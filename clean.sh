#!/bin/sh
rm -rf ./feedback
mkdir feedback
rebar3 compile
rebar3 edoc