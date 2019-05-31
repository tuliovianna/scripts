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
"
pesquisa=$(echo $QUERY_STRING  | awk -F "=" '{print $2}')
check_pesquisa=$(echo $QUERY_STRING  | awk -F "=" '{print $2}' | wc -m)
if [[ $check_pesquisa > 1 ]]; then
  echo "<pre>$(cat /etc/passwd | grep $pesquisa)</pre>"
fi
echo "

<form>
  <fieldset>
 	Processo a ser encontrado: <br> <br>
  	<input type="text" name="add" placeholder="Nome do Processo">
  	<input type="submit" name="botao" value="Buscar">
  </fieldset>

</form>

<form>
  <fieldset>
  	Processo a ser removido: <br> <br>
  	<input type="text" name="remove" placeholder="PID do Processo">
  	<input type="submit" name="botao" value="Deletar">
  </fieldset>
</form>
"

add=$(echo $QUERY_STRING | awk -F "&" '{print $1}' | awk -F "=" '{print $2}')
botao=$(echo $QUERY_STRING | awk -F "&" '{print $2}' | awk -F "=" '{print $2}')
remove=$(echo $QUERY_STRING | awk -F "&" '{print $3}' | awk -F "=" '{print $2}')
NOW=$(date)

if [[ $botao = "Buscar" ]]; then
  echo "<pre>$(ps aux | grep $add)</pre>"
  echo "<pre>$(sudo ./arquivo.sh "$(date +"%d/%m/%Y %H:%M:%S")" "$(sudo whoami)" "$add" "adicionado")</pre>"
  echo "<pre>$(cat /etc/passwd | grep ${add})</pre>"
  echo "<pre>$(cat /etc/group | grep ${group})</pre>"
fi

CHECK=$(grep -w "$add" /etc/passwd | wc -l)
if [[ $botao = "Deletar" ]]; then
      echo "<pre>$(sudo kill -9 $add)</pre>"
      echo "<pre>$(sudo ./arquivo.sh "$(date +"%d/%m/%Y %H:%M:%S")" "$(sudo whoami)" "$add" "excluido")</pre>"
      echo "<pre style="display: none;">$(sudo date '+Deletado em: %d/%m/%Y %H:%M:%S' | sudo tee -a /usr/lib/cgi-bin/vamos.txt)</pre> + $(sudo date |sudo tee -a /usr/lib/cgi-bin/vamos.txt)"
fi

echo "
</body>
</html>
"
