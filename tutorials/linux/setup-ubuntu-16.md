# Introduction

This document serves as tutorial to setup my Ubuntu server. It contains highly
cargo culted documentation found on the Internet but this is a configuration
working for me and not having to find the same tutorials on the net over and
over I've decided to keep it in here.

This may be converted into a Puppet definition sometime in the future if I get
around to looking deeper into Puppet.


# Install dotfiles

Source: https://github.com/perdian/dotfiles

    sudo apt-get --yes install dialog realpath git zsh python nano
    cd ~
    git clone https://github.com/perdian/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    ./environments/bootstrap.py root
    chsh -s $(which zsh)


# Configure LDAP Server

Source: https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-openldap-and-phpldapadmin-on-an-ubuntu-14-04-server

    sudo apt-get --yes install slapd ldap-utils
    sudo dpkg-reconfigure slapd


# Install phpldapadmin

    sudo apt-get --yes install phpldapadmin

Edit Configuration file:

    sudo nano /etc/phpldapadmin/config.php

Edit:

    $servers->setValue('server','host','server_domain_name_or_IP');
    ...
    $servers->setValue('server','base',array('dc=test,dc=com'));
    ...
    $servers->setValue('login','bind_id','cn=admin,dc=test,dc=com');


# Import LDAP content

Source: http://stackoverflow.com/questions/792563/how-do-i-clone-an-openldap-database

    ldapadd -Wx -D "cn=admin,dc=perdian,dc=de" -H ldap://127.0.0.1 -f ldap-dump.ldif

# Manage LDAP content

Source: http://www.techrepublic.com/article/how-to-populate-an-ldap-server-with-users-and-groups-via-phpldapadmin/

    sudo apt-get -y install libnss-ldap libpam-ldap ldap-utils 

# Authenticate SSH via LDAP

Source: https://www.server-world.info/en/note?os=Ubuntu_16.04&p=openldap&f=3