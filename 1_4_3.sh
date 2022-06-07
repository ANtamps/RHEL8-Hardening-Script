#!/bin/bash

echo -e "[Service]\nExecStart=-/usr/lib/systemd/systemd-sulogin-shell rescue" > /etc/systemd/system/rescue.service.d/00-require-auth.conf
