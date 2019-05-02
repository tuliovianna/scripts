#!/bin/bash

SCRIPT=$(echo $0 | awk -F "/cgi-bin/" '{print $2}')
N_QUERY_STRING=$(echo "$QUERY_STRING"  | grep -o "=" | wc -l)

echo "content-type: text/html"
echo
echo "
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Tarefa 2 - Iptables</title>
    
    </head>
<body>
<h4>Regras - iptables</h4>
<form method="get">
<fieldset>
           <label for="parametro">Index:</label>
        <select name="parametro" id="parametro">
            <option value='-I'>-I</option>
            <option value='-A'>-A</option>
        </select>

        <label for="regra">Chain:</label>
        <select name="regra" id="regra">
            <option value="INPUT">INPUT</option>
            <option value="OUTPUT">OUTPUT</option>
            <option value="FORWARD">FORWARD</option>
        </select>

        <label for="protocolo">Protocolo:</label>
        <select name="protocolo" id="protocolo">
            <option value="tcp">TCP</option>
            <option value="udp">UDP</option>
        </select>

        <label for="ip">Origem:</label>
        <input type="text" name="ip" id="ip">


        <label for="site">Destino:</label>
        <input type="text" name="site" id="site">


        <label for="comentario">Coment:</label>
        <input type="text" name="comentario" id="comentario">

        <label for="acao">Ação:</label>
        <select name="acao" id="acao">
            <option value="DROP">DROP</option>
            <option value="ACCEPT">ACCEPT</option>
            <option value="REJECT">REJECT</option>
        </select>

    <input type="submit" value="Gerar" name="botao">
    <input type="submit" value="Gravar" name="botao">
    <input type="submit" value="Flush" name="botao">

    <a href=$SCRIPT>
        <button type="button" >Limpar</button>
    </a>
</fieldset>
</form>
"

if [[ $N_QUERY_STRING = 8 ]]; then

  CHECK_QUERY_STRING=$(echo $QUERY_STRING | wc -m)

  PARAMETRO=$(echo $QUERY_STRING | awk -F "&" '{print $1}' | awk -F "=" '{print $2}')
  REGRA=$(echo $QUERY_STRING | awk -F "&" '{print $2}' | awk -F "=" '{print $2}')
  PROTOCOLO=$(echo $QUERY_STRING | awk -F "&" '{print $3}' | awk -F "=" '{print $2}')
  IP=$(echo $QUERY_STRING | awk -F "&" '{print $4}' | awk -F "=" '{print $2}' | sed 's/%2F/\//')
  SITE=$(echo $QUERY_STRING | awk -F "&" '{print $5}' | awk -F "=" '{print $2}')
  COMENTARIO=$(echo $QUERY_STRING | awk -F "&" '{print $6}' | awk -F "=" '{print $2}')
  ACAO=$(echo $QUERY_STRING | awk -F "&" '{print $7}' | awk -F "=" '{print $2}')
  BOTAO=$(echo $QUERY_STRING | awk -F "&" '{print $8}' | awk -F "=" '{print $2}')

  if [[ $BOTAO = "Flush" ]]; then
    N_CHECK_FLUSH=$(sudo iptables -L | wc -l)
    if [[ $N_CHECK_FLUSH -eq 8 ]]; then
      echo "<pre>Iptables sem nenhuma regra.</pre>"
    else
      echo "<pre>Regras foram apagadas.</pre>"
      echo "<pre>$(sudo iptables -F)</pre>"
    fi

  else

    if [[ $CHECK_QUERY_STRING -gt 87 ]]; then

      if [[ $BOTAO = "Gerar" ]]; then
	
        SAIDA=$(echo "Regra gerada: sudo iptables $PARAMETRO $REGRA -p $PROTOCOLO -s $IP -d $SITE -m comment --comment \"$COMENTARIO\" -j $ACAO")
        echo "<pre>$SAIDA</pre>"
      fi
      if [[ $BOTAO = "Gravar" ]]; then
        SAIDA=$(echo "Regra gravada: sudo iptables $PARAMETRO $REGRA -p $PROTOCOLO -s $IP -d $SITE -m comment --comment \"$COMENTARIO\" -j $ACAO")
        echo "<pre>$SAIDA</pre>"
        echo "<pre>$(sudo iptables $PARAMETRO $REGRA -p $PROTOCOLO -s $IP -d $SITE -m comment --comment \"$COMENTARIO\" -j $ACAO)</pre>"
      fi
    else
      echo "<pre>Para criar a regra todos os campos devem ser preenchidos.</pre>"
    fi

  fi

fi

echo "
<br>
<h4>Listar Regras</h4>
<form method="get">
<fieldset>
        <label for="chain">Chain:</label>
        <select name="chain" id="chain">
            <option value="ALL">ALL</option>
            <option value="INPUT">INPUT</option>
            <option value="OUTPUT">OUTPUT</option>
            <option value="FORWARD">FORWARD</option>
        </select>

    <button type="submit">Exibir</button>
</fieldset>
</form>
"

if [[ $N_QUERY_STRING = 1 ]]; then
  CHAIN=$(echo "$QUERY_STRING" | awk -F "=" '{print $2}')
  if [[ $CHAIN = "ALL" ]]; then
    COMANDO="iptables -L -nv --line-numbers"
    echo "<pre>Comando: $COMANDO</pre>"

    SAIDA=$(sudo iptables -L -nv --line-numbers)
    echo "<pre>$SAIDA</pre>"
  else
    COMANDO="sudo iptables -L $CHAIN -nv --line-numbers"
    echo "<pre>Comando: $COMANDO</pre>"

    SAIDA=$(sudo iptables -L $CHAIN -nv --line-numbers)
    echo "<pre>$SAIDA</pre>"
  fi
fi

    echo "
  </body>
</html>
"
