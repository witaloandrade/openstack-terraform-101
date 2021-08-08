@ECHO OFF
SET /P _tenant_name= Informe seu CD. Ex. CD123456 :
::@ECHO CD INFOMADO "%_tenant_name%"
SET /P _user_name= Informe seu usuario OpenStack:
::@ECHO USUARIO INFOMADO "%_user_name%"
SET /P _password= Insira sua senha:
::@ECHO  " Configurando variaveis"
set TF_VAR_tenant_name=%_tenant_name%
set TF_VAR_user_name=%_user_name%
set TF_VAR_password="%_password%"
@ECHO OFF