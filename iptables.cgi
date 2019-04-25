#!/bin/bash

read POST

#RESULT=$(echo $POST | cut -d '&' -f 1 | cut -d '=' -f 2)

echo 'Content-type: text/html'
echo

echo -e 

 ' <html>

<body>'

echo "<pre>$(cat /etc/passwd | grep ${RESULT})</pre>"

echo -e ' 
<form method='POST'>

iptables -I -p 
	<select multiple>
    	<option>tcp</option>
    	<option>udp</option>
	</select>  
	<select multiple>
    	<option>INPUT</option>
    	<option>OUTPUT</option>
    	<option>FORWARD</option>
	</select>  

	-s 192.168.1.10/32 -d www.uol.com.br -j 
	<select multiple>
    	<option>DROP</option>
    	<option>ACCEPT</option>
    	<option>REJECT</option>
	</select>   <br> 
<br>
<input type="submit" name="submit" value="Enviar">

</form>

</body>

</html>

'