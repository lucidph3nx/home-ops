#!/bin/bash
# create group
sudo groupadd ben
# create user
sudo useradd -m -s /bin/bash -g ben ben

# permissions etc
sudo cp -pr /home/vagrant/.ssh /home/ben/
sudo chown -R ben:ben /home/ben
sudo echo "%ben ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ben

# add public key from github for user to auth keys
curl https://github.com/lucidph3nx.keys | sudo tee -a /home/ben/.ssh/authorized_keys
