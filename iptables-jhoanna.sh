#!/bin/bash

echo "content-type: text/html"
echo
echo "
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>Atividade 2</title>
</head>
<body>
	<h3>FORMULÁRIO - LIST BOX</h3>
	<form method="get">

	<select name="inicio">
			<option value="-I">-I</option>
			<option value="-A">-A</option>
	</select>

	<h5>REGRA</h5>
	<select name="regra">
			<option value="INPUT">INPUT</option>
			<option value="OUTPUT">OUTPUT</option>
			<option value="FORWARD">FORWARD</option>
	</select>

	<h5>PROTOCOLO</h5>
	<select name="protocolo">
			<option value="tcp">tcp</option>
			<option value="udp">udp</option>
	</select>

		<h5>IP</h5>
		<input type="text" name="ip">

		<h5>SITE</h5>
		<input type="text" name="site">

		<h5>COMMENT</h5>
		<input type="text" name="comment">

		<select name="acao">
				<option value="DROP">DROP</option>
				<option value="ACCEPT">ACCEPT</option>
				<option value="REJECT">REJECT</option>
		</select>

		<input type="submit" value="Gerar" name="funcbot">
  	<input type="submit" value="Submeter" name="funcbot">
  	<input type="submit" value="Flush" name="funcbot">

	</form>
	<br>
	<h5>FIM</h5>
"

INICIO=$(echo $QUERY_STRING | awk -F "&" '{print $1}' | awk -F "=" '{print $2}')
REGRA=$(echo $QUERY_STRING | awk -F "&" '{print $2}' | awk -F "=" '{print $2}')
PROTOCOLO=$(echo $QUERY_STRING | awk -F "&" '{print $3}' | awk -F "=" '{print $2}')
IP=$(echo $QUERY_STRING | awk -F "&" '{print $4}' | awk -F "=" '{print $2}' | sed 's/%2F/\//')
SITE=$(echo $QUERY_STRING | awk -F "&" '{print $5}' | awk -F "=" '{print $2}')
COMMENT=$(echo $QUERY_STRING | awk -F "&" '{print $6}' | awk -F "=" '{print $2}')
ACAO=$(echo $QUERY_STRING | awk -F "&" '{print $7}' | awk -F "=" '{print $2}')
FUNCBOT=$(echo $QUERY_STRING | awk -F "&" '{print $8}' | awk -F "=" '{print $2}')

if [[ $FUNCBOT = "Gerar" ]]; then
	FIM=$(echo "Gerando: sudo iptables $INICIO $REGRA -p $PROTOCOLO -s $IP -d $SITE -m comment --comment \"$COMMENT\" -j $ACAO")
	echo "<pre>$FIM</pre>"
fi
if [[ $FUNCBOT = "Submeter" ]]; then
	FIM=$(echo "Submetendo: sudo iptables $INICIO $REGRA -p $PROTOCOLO -s $IP -d $SITE -m comment --comment \"$COMMENT\" -j $ACAO")
	echo "<pre>$FIM</pre>"
	echo "<pre>$(sudo iptables $INICIO $REGRA -p $PROTOCOLO -s $IP -d $SITE -m comment --comment \"$COMMENT\" -j $ACAO)</pre>"
fi
if [[ $FUNCBOT = "Flush" ]]; then
	echo "<pre>Jhoanna</pre>"
	echo "<pre>$(sudo iptables -F)</pre>"
fi

echo "
<br>
<h3>FORMULÁRIO - LISTAR IPTABLES</h3>
<form method="get">
	<select name="chain" id="chain">
            <option value="ALL">ALL</option>
            <option value="INPUT">INPUT</option>
            <option value="OUTPUT">OUTPUT</option>
            <option value="FORWARD">FORWARD</option>
    </select>

    <button type="submit">Exibir</button>
</form>"

CHAIN=$(echo "$QUERY_STRING" | awk -F "=" '{print $2}')
if [[ $CHAIN = "ALL" ]]; then
	COMANDO="iptables -L -nv --line-numbers"
	echo "<pre>Comando: $COMANDO</pre>"

	FIM=$(sudo iptables -L -nv --line-numbers)
	echo "<pre>$FIM</pre>"
else
	COMANDO="sudo iptables -L $CHAIN -nv --line-numbers"
	echo "<pre>Comando: $COMANDO</pre>"

	FIM=$(sudo iptables -L $CHAIN -nv --line-numbers)
	echo "<pre>$FIM</pre>"
fi

    echo "
</body>
</html>
"
