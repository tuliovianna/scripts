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
    <title>Iptables</title>
    <style>
        .margin{
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
<h1>IPTABLES</h1>
<form method="get">

    <div class="margin">
        <label for="parametro">Parâmetro:</label>
        <select name="parametro" id="parametro">
            <option value='-I'>-I</option>
            <option value='-A'>-A</option>
        </select>
    </div>

    <div class="margin">
        <label for="regra">Regra:</label>
        <select name="regra" id="regra">
            <option value="INPUT">INPUT</option>
            <option value="OUTPUT">OUTPUT</option>
            <option value="FORWARD">FORWARD</option>
        </select>
    </div>

    <div class="margin">
        <label for="protocolo">Protocolo:</label>
        <select name="protocolo" id="protocolo">
            <option value="tcp">TCP</option>
            <option value="udp">UDP</option>
        </select>
    </div>

    <div class="margin">
        <label for="ip">IP:</label>
        <input type="text" name="ip" id="ip">
    </div>

    <div class="margin">
        <label for="site">Site:</label>
        <input type="text" name="site" id="site">
    </div>

    <div class="margin">
        <label for="comentario">Comentário:</label>
        <input type="text" name="comentario" id="comentario">
    </div>

    <div class="margin">
        <label for="acao">Ação:</label>
        <select name="acao" id="acao">
            <option value="DROP">DROP</option>
            <option value="ACCEPT">ACCEPT</option>
            <option value="REJECT">REJECT</option>
        </select>
    </div>

    <input type="submit" value="Gerar" name="botao">
    <input type="submit" value="Submeter" name="botao">
    <input type="submit" value="Flush" name="botao">

    <a href=$SCRIPT>
        <button type="button" >Limpar</button>
    </a>
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
      echo "<pre>Nenhuma existe nenhuma regra pra apagar</pre>"
    else
      echo "<pre>Todas as regras foram apagadas</pre>"
      echo "<pre>$(sudo iptables -F)</pre>"
    fi

  else

    if [[ $CHECK_QUERY_STRING -gt 87 ]]; then

      if [[ $BOTAO = "Gerar" ]]; then
        SAIDA=$(echo "Comando gerado: sudo iptables $PARAMETRO $REGRA -p $PROTOCOLO -s $IP -d $SITE -m comment --comment \"$COMENTARIO\" -j $ACAO")
        echo "<pre>$SAIDA</pre>"
      fi
      if [[ $BOTAO = "Submeter" ]]; then
        SAIDA=$(echo "Comando submetido: sudo iptables $PARAMETRO $REGRA -p $PROTOCOLO -s $IP -d $SITE -m comment --comment \"$COMENTARIO\" -j $ACAO")
        echo "<pre>$SAIDA</pre>"
        echo "<pre>$(sudo iptables $PARAMETRO $REGRA -p $PROTOCOLO -s $IP -d $SITE -m comment --comment \"$COMENTARIO\" -j $ACAO)</pre>"
      fi
    else
      echo "<pre>Preencha todos os campos.</pre>"
    fi

  fi

fi

echo "
<br>
<hr>
<h1>LISTAR IPTABLES</h1>
<form method="get">

    <div class="margin">
        <label for="chain">Chain:</label>
        <select name="chain" id="chain">
            <option value="ALL">ALL</option>
            <option value="INPUT">INPUT</option>
            <option value="OUTPUT">OUTPUT</option>
            <option value="FORWARD">FORWARD</option>
        </select>
    </div>

    <button type="submit">Mostrar</button>

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
