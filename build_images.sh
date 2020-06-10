#!/usr/bin/env bash
docker image build . -f Dockerfile -t amsaravi/textograph-server -t 192.168.1.10:5000/textograph-server --no-cache