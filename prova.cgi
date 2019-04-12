#!/bin/bash

read POST

echo 'Content-type: text/html'
echo

echo -e 

 ' <html>

<body>'

echo -e ' 
<form method='POST'>

Usuario: <input type="text" name="user">
<br>
<input type="submit" name="submit" value="Enviar">

</form>

</body>

</html>

'