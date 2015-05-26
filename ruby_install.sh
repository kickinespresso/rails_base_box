#!/usr/bin/env bash
echo "Install and configure ruby and gems"
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
echo "cd /vagrant" >> ~/.bash_profile
rbenv install 2.2.0
rbenv local 2.2.0
rbenv global 2.2.0
rbenv local 2.2.0
rbenv rehash
gem install bundler
gem install mailcatcher