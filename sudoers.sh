#!/bin/bash
grep -Po '^sudo.+:\K.*$' /etc/group
