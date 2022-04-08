
<div style="width: 100%"
	<div class="center">
		<div class="container">
	<div class="row">
		<h2 style="color: <?php $_["isSamlAuthenticated"] ? p("green") :p( "red")?>">
			<?php $_["isSamlAuthenticated"] ? p("User is logged in with SAML IDP") :p( "User Is Logged in directly")?>
		</h2>
	</div>
	<?php if ($_["isSamlAuthenticated"]){?>
	<div class="row">
		<label for="username">Username:</label>
		<input readonly id ="username" type="text" value="<?php p($_["username"])?>">
	</div>
		<div class="row">
			<label for="display_name">Display name:</label>
			<input readonly id ="display_name" type="text" value="<?php p($_["displayName"])?>">
		</div>
		<div class="row">
			<input readonly id ="mfa_status" type="checkbox" <?php if($_["mfaVerified"]) p("checked")?>>
			<label for="mfa_status">MFA verified</label>
		</div>
	<?php } ?>
</div>
</div>
</div>
