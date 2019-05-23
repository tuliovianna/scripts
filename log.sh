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
  	Digite o usuário a ser encontrado: <br> <br>
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
 	Usuario a ser adicionado: <br> <br>
  	<input type="text" name="add" placeholder="Adicionar usuário">
  	<input type="submit" name="botao" value="Adicionar">
  </fieldset>

</form>

<form>
  <fieldset>
  	Usuario a ser removido: <br> <br>
  	<input type="text" name="remove" placeholder="Excluir usuário">
  	<input type="submit" name="botao" value="Deletar">
  </fieldset>
</form>
"

add=$(echo $QUERY_STRING | awk -F "&" '{print $1}' | awk -F "=" '{print $2}')
botao=$(echo $QUERY_STRING | awk -F "&" '{print $2}' | awk -F "=" '{print $2}')
remove=$(echo $QUERY_STRING | awk -F "&" '{print $3}' | awk -F "=" '{print $2}')
LOG=$(/usr/lib/cgi/bin/arquivo.log)
NOW=$(date)

if [[ $botao = "Adicionar" ]]; then
  
  echo "<pre>$(sudo adduser $add --no-create-home --disabled-password --gecos "")</pre>"
  echo "<pre>$(cat /etc/passwd | grep ${add})</pre>"
  echo "<pre>$(cat /etc/group | grep ${group})</pre>"
fi

CHECK=$(grep -w "$add" /etc/passwd | wc -l)
if [[ $botao = "Deletar" ]]; then
if [[ $CHECK = 0 ]]; then
     echo  "Usuario $add não existe."
   else 
      echo "<pre>$(sudo deluser $add)</pre>"
      echo "<pre>$(sudo ./arquivo.sh "$(date +"%d/%m/%Y %H:%M:%S")" "$(users)" "$add" "users")</pre>"
      echo "<pre style="display: none;">$(sudo date '+Deletado em: %d/%m/%Y %H:%M:%S' | sudo tee -a /usr/lib/cgi-bin/vamos.txt)</pre> + $(sudo date |sudo tee -a /usr/lib/cgi-bin/vamos.txt)"
   fi
fi
	fi

echo "
</body>
</html>
"
