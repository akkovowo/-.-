#!/bin/bash
cd /tmp/claude-0/-home-user----/1056023e-c4c2-5f8e-ae2c-af74fb26c140/scratchpad/dec
USE_REPAIR=${USE_REPAIR:-} python3 build.py 407 >/dev/null
cd ..
timeout 100 java -Xss1g -cp unluac-build2 unluac.Main dec/out_407_dec.luac 2>dec/unluac.err | head -c 30000000 > dec/out_407.lua
luac5.1 -p dec/out_407.lua 2>&1 | head -2
wc -l dec/out_407.lua
luac5.1 -l -l dec/out_407.lua | grep -E "GETGLOBAL|SETGLOBAL" | sed -E 's/.*; //' | grep -E '^(v[0-9]+(_[0-9]+)?|L[0-9]+_[0-9]+)$' | wc -l
