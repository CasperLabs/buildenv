#!/bin/bash
set -ex
git clone https://github.com/CasperLabs/CasperLabs.git
cd CasperLabs
sbt update
cd execution-engine
make setup
~/.cargo/bin/cargo fetch
cd ../..
rm -rf CasperLabs
