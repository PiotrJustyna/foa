#!/bin/sh
curl -o -H "Content-Type: application/json" -X POST "http://localhost:3000/feedback" -d "{key1:value1, key2:value2}" 