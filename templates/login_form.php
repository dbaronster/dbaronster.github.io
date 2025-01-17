<html>
<head>
<title><?=$CFG->appname?> Login</title>
<link rel="stylesheet" type="text/css" href="/css/chilehead.css">
</head>

<body bgcolor=#ffffff link=#0000ff vlink=#000099 alink=#ff0000>
<div class=h1><?=$CFG->appname?> Login Screen<hr size=1></div>

<div class="help-frame">
	<div class="help">

	<p>If you do not already have an account, please
	<a href="<?=$CFG->wwwroot?>users/signup.php">sign up for an account</a> now.

	<p>If you have an account but have forgotten your password,
	<a href="<?=$CFG->wwwroot?>users/forgot_password.php">click here</a> to recover
	your password.

	<p>If you have do not wish to login yet,
	<a href="<?=$CFG->wwwroot?>">click here</a> to return to the home page.

	</div>
</div>


<div class="form">

<!--td bgcolor=#f0f0f0-->
	<? if (! empty($errormsg)) { ?>
		<div class=warning align=center><? pv($errormsg) ?></div>
	<? } ?>

	<form name="entryform" method="post" action="<?=$CFG->wwwroot?>login.php">
	<table>
	<tr>
		<td class=label>Username:</td>
		<td><input type="text" name="username" size=20 value="<? pv($frm["username"]) ?>"></td>
	</tr>
	<tr>
		<td class=label>Password:</td>
		<td><input type="password" name="password" size=20></td>
	</tr>
	<tr>
		<td></td>
		<td><input type="submit" value="Login">
			<input type="button" value="Cancel" onClick="javascript: history.go(-1)">
			<p class=normal>
			  <a href="<?=$CFG->wwwroot?>users/signup.php">Sign up for an account</a>
			| <a href="<?=$CFG->wwwroot?>users/forgot_password.php">Forgot my password</a>
		</td>
	</table>
	</form>

</div>

</body>
</html>