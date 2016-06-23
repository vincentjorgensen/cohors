#!/bin/bash
set -e

NEW_USER=$1

PKI_DIR=easyrsa3/pki
CERTS_DIR=easyrsa3/pki/issued
KEYS_DIR=easyrsa3/pki/private

USER_CONFIG_WORKSPACE=user_config_workspace
USER_CONFIG_DIR=$USER_CONFIG_WORKSPACE/$NEW_USER
VISCOSITY_TEMPLATE_DIR=$USER_CONFIG_DIR/$NEW_USER.visc

rm -rf $USER_CONFIG_DIR

mkdir -p $VISCOSITY_TEMPLATE_DIR

VISCOSITY_CONFIG_DIR=$USER_CONFIG_DIR/viscosity

mkdir -p $VISCOSITY_CONFIG_DIR

cp $CERTS_DIR/$NEW_USER.crt $USER_CONFIG_DIR/
cp $CERTS_DIR/$NEW_USER.crt $VISCOSITY_TEMPLATE_DIR/cert.crt

cp $KEYS_DIR/$NEW_USER.key $USER_CONFIG_DIR/
cp $KEYS_DIR/$NEW_USER.key $VISCOSITY_TEMPLATE_DIR/key.key

cp $PKI_DIR/ca.crt $USER_CONFIG_DIR/
cp $PKI_DIR/ca.crt $VISCOSITY_TEMPLATE_DIR/ca.crt

###for VPC_NAME in {{{eu-west-1,ap-southeast-2}-prod,{us-east-1,us-west-2}-{prod,dev}}-edge,us-east-1-{prod,dev}-core}; do
for VPC_NAME in {us-west-2,us-east-1,eu-west-1,ap-southeast-1}-dev; do
    echo $VPC_NAME

    rm -rf $VISCOSITY_CONFIG_DIR/$VPC_NAME.visc
    cp -a $VISCOSITY_TEMPLATE_DIR $VISCOSITY_CONFIG_DIR/$VPC_NAME.visc

    cat > $VISCOSITY_CONFIG_DIR/$VPC_NAME.visc/config.conf <<CONFIG
#-- Config Auto Generated By Viscosity --#

#viscosity startonopen true
#viscosity dhcp true
#viscosity dnssupport true
#viscosity name $VPC_NAME
remote $VPC_NAME-vpn.spongecell.net 1194 udp
pull
tls-client
persist-key
ca ca.crt
nobind
persist-tun
cert cert.crt
#comp-lzo adaptive
dev tun
key key.key
resolv-retry infinite
CONFIG

done

rm -r $USER_CONFIG_DIR/$NEW_USER.visc

tar -cf $NEW_USER.tar --directory $USER_CONFIG_WORKSPACE $NEW_USER

rm -r $USER_CONFIG_WORKSPACE/$NEW_USER

echo created $NEW_USER.tar