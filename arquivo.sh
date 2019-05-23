#!/bin/bash
DATA=$1
ACAO=$2
STATUS=$3
USUARIO=$4

sudo echo "Usuario $STATUS excluido em $DATA por $ACAO" >> log.txt  
