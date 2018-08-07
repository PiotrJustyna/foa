#!/bin/sh
rebar3 compile
rebar3 edoc
rebar3 shell --apps foa