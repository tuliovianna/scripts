#!/bin/bash

read POST

REGRA=$(echo $POST | cut -d '&' -f 1 | cut -d '=' -f 2)
PROTOCOLO=$(echo $POST | cut -d '&' -f 2 | cut -d '=' -f 2)
ACAO=$(echo $POST | cut -d '&' -f 3 | cut -d '=' -f 2)

echo 'Content-type: text/html'
echo

echo -e 

 ' <html>

<body>'

echo "<pre>iptables -I ${REGRA} -p ${PROTOCOLO} -s 192.168.0.10/32 -d www.uol.com.br -j ${ACAO}</pre>"
echo "<pre>$(iptables -L)</pre>"

echo -e '
<form method='POST'>
	iptables -I 
	<select name="regra">
	<option value="INPUT">INPUT</option>
	<option value="OUTPUT">OUTPUT</option>
	<option value="FORWARD">FORWARD</option>
	</select>
	-p 
	<select name="protocolo">
    	<option value="tcp">tcp</option>
    	<option value="udp">udp</option>
	</select>
	-s 192.168.0.10/32 -d www.uol.com.br -j
	<select name="acao">
	<option value="DROP">DROP</option>
	<option value="ACCEPT">ACCEPT</option>
	<option value="REJECT">REJECT</option>
	</select>

<br><br>
<input type="submit" name="submit">

</form>

</body>

</html>

'
