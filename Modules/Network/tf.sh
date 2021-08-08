#!/usr/bin/env bash
echo "Informe seu usuario OpenStack: "
read -r OS_USERNAME_INPUT
export TF_VAR_user_name=$OS_USERNAME_INPUT

echo "Informe seu CD. Ex. CD123456 "
read -r OS_TENANT_INPUT
export TF_VAR_tenant_name=$OS_TENANT_INPUT

echo "Insira sua senha: "
read -sr OS_PASSWORD_INPUT
export TF_VAR_password=$OS_PASSWORD_INPUT

