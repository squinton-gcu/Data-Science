#!/bin/bash

mkdir -p /var/log/image_test
chown shiny.shiny /var/log/image_test

exec shiny-server >> /var/log/image_test.log 2>&1