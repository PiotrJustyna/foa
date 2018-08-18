#!/bin/sh
rm -rf ../foa/feedback
mkdir ../foa/feedback
cd ../foa/
rebar3 edoc
rebar3 shell --apps foa