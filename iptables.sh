#!/bin/bash

echo "content-type: text/html"
echo
echo "
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Iptables</title>
</head>
<body>
	<h4> Regra IPTABLE </h4>
	<form method="get">
		<h5>Local da regra</h5>
		<select name="indice" id="indice">
			<option>-i</option>
			<option>-a</option>
		</select>
		<!-- entrada -->
		<h5>Selecione a ação</h5>
		<select multiple name="action">
    		<option>IMPUT</option>
    		<option>OUTPUT</option>
    		<option>FORWARD</option>
   		</select>
   		<!-- protocolo -->
   		<h5>Selecione o protocolo </h5>
   		<select multiple name="protocol" id="protocol">
    		<option>udp</option>
    		<option>tcp</option>
   		</select>
		<!-- IP -->
		<h5>Informe o ip xxx.xxx.xxx.xxx/xx</h5>
   		<input type="text" name="ip" id="ip"> </input>
   		<!-- site -->
   		<h5>Informe o host de destino</h5>
   		<input type="text" name="host" id="host"> </input>
   		<!-- comentario da regra -->
   		<h5>Comentario da regra</h5>
   		<input type="text" name="comentario" id="comentario"> </input>
   		<!-- Regra -->
   		<select name="rule" id="rule">
       		<option value="DROP">DROP</option>
        	<option value="ACCEPT">ACCEPT</option>
       		<option value="REJECT">REJECT</option>
    	</select>

    	<button type="submit">Gerar Comando</button>

	</form>
	<br>
	<br>"

echo "$QUERY_STRING" | awk -F "&" '{print $3}' | awk -F "=" '{print $2}' | sed 's/%2F/\//'
echo "<br>"
indice=$(echo $QUERY_STRING | awk -F "&" '{print $1}' | awk -F "=" '{print $2}')
action=$(echo $QUERY_STRING | awk -F "&" '{print $1}' | awk -F "=" '{print $2}')
protocol=$(echo $QUERY_STRING | awk -F "&" '{print $2}' | awk -F "=" '{print $2}')
ip=$(echo $QUERY_STRING | awk -F    "&" '{print $3}' | awk -F "=" '{print $2}' | sed 's/%2F/\//')
host=$(echo $QUERY_STRING | awk -F "&" '{print $4}' | awk -F "=" '{print $2}')
comentario=$(echo $QUERY_STRING | awk -F "&" '{print $1}' | awk -F "=" '{print $2}')
rule=$(echo $QUERY_STRING | awk -F "&" '{print $5}' | awk -F "=" '{print $2}')

echo "iptables $indice $action -p $protocol -s $ip -d $host -j $comentario $rule"


 echo "
</body>
</html>
"