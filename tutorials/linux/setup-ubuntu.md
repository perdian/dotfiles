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


# Adjust plesk

    sudo a2dismod mpm_event
    sudo a2enmod mpm_prefork
    sudo /etc/init.d/apache2 restart


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


# Fix phpldapadmin user creation

Source: http://askubuntu.com/questions/692146/error-trying-to-get-a-non-existent-value-appearance-password-hash-in-ldap

    sudo nano /usr/share/phpldapadmin/lib/TemplateRender.php

Search line

    $default = $this->getServer()->getValue('appearance','password_hash');

and change it to

    $default = $this->getServer()->getValue('appearance','password_hash_custom');


# Import LDAP content

Source: http://stackoverflow.com/questions/792563/how-do-i-clone-an-openldap-database

    ldapadd -Wx -D "cn=admin,dc=perdian,dc=de" -H ldap://127.0.0.1 -f ldap-dump.ldif


# Authenticate SSH via LDAP

Source: https://www.ossramblings.com/Ubuntu-14.04-SSSD-and-OpenLDAP-Authentication
Source: http://askubuntu.com/questions/247763/why-is-my-sssd-conf-file-missing-after-installing-sssd

    sudo apt-get --yes install sssd libpam-sss libnss-sss libnss-ldap
    sudo cp /usr/share/doc/sssd-common/examples/sssd-example.conf /etc/sssd/sssd.conf
    sudo nano /etc/sssd/sssd.conf

Edit settings for local LDAP server.

Restart SSSD service

    sudo chmod 0600 /etc/sssd/sssd.conf
    sudo service sssd restart

Adjust PAM

    sudo nano /etc/pam.d/common-session

Add line

    session optional pam_mkhomedir.so skel = /etc/skel/ mask=0077