<!DOCTYPE html>
<html>
<head>
	<title>Comparação Hash</title>
	<meta charset="utf-8">
</head>
<body>
	<fieldset>
	<form method="post" enctype="multipart/form-data">
		<hr>
		Digite o Hash a ser comparado:
		<input type="text" name="hash1" placeholder="Valor do Hash">
		<br>
		Selecione a ser comparado:
		<input type="file" name="hash2">
		<br>
		<br>
		<button type="submit"> Realizar comparação</button>
	</form>
	</fieldset>
<?php
  if (isset($_POST['hash1'])) {
  	
  	$hash1=$_POST['hash1'];

  	if (isset($_FILES['hash2']['tmp_name'])) {
  		$hash2 = md5_file($_FILES['hash2']['tmp_name']);

	  	if($hash1 == $hash2){
	    echo "Hash igual.";
		}
	  	else{
	    echo "Hash diferente.".md5_file($_FILES['hash2']['tmp_name']);
		}
  	}
  }
  
  
?>

</body>
</html>