#!/usr/bin/env bash
set -e
systemctl enable nomad.service
systemctl start nomad.service