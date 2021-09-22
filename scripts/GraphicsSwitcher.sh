#!/bin/bash

# 须设置当前用户执行prime-select不需要密码
if test -s /tmp/GeForce; then
        # 当前为NVIDIA
	sudo prime-select intel
else
        # 当前为intel
	sudo prime-select nvidia
fi
