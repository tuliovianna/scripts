#!/bin/bash

echo "content-type: text/html"
echo
echo
echo "
<html>
<head>
<meta charset='utf-8'>
<title>Controle de Usuarios</title>
</head>
<body>

<form>
  <fieldset>
  	Digite o usuário a ser encontrado:
  	<input type="text" name="pesquisa" placeholder="Buscar Usuário">
  	<input type="submit" value="Buscar">
  </fieldset>
</form>
"
pesquisa=$(echo $QUERY_STRING  | awk -F "=" '{print $2}')
check_pesquisa=$(echo $QUERY_STRING  | awk -F "=" '{print $2}' | wc -m)
if [[ $check_pesquisa > 1 ]]; then
  echo "<pre>$(cat /etc/passwd | grep $pesquisa)</pre>"
fi
echo "

<form>
  <fieldset>
 	Usuario a ser adicionado:
  	<input type="text" name="add" placeholder="Adicionar usuário">
  	<input type="submit" name="botao" value="Adicionar">
  </fieldset>

</form>

<form>
  <fieldset>
  	Remover Usuário:
  	<input type="text" name="remove" placeholder="Excluir usuário">
  	<input type="submit" name="botao" value="Deletar">
  </fieldset>
</form>
"

add=$(echo $QUERY_STRING | awk -F "&" '{print $1}' | awk -F "=" '{print $2}')
botao=$(echo $QUERY_STRING | awk -F "&" '{print $2}' | awk -F "=" '{print $2}')
remove=$(echo $QUERY_STRING | awk -F "&" '{print $3}' | awk -F "=" '{print $2}')

if [[ $botao = "Adicionar" ]]; then
  
  echo "<pre>$(sudo adduser $add --no-create-home --disabled-password --gecos "")</pre>"
  echo "<pre>$(cat /etc/passwd | grep ${add})</pre>"
  echo "<pre>$(cat /etc/group | grep ${group})</pre>"
fi


if [[ $botao = "Deletar" ]]; then


echo "<pre>$(sudo deluser $add)</pre>"

if [ $add == 0 ]
then
echo "O Comando xyz foi executado com sucesso" >> /usr/lib/cgi-bin/log.txt
fi


fi

echo "
</body>
</html>
"
