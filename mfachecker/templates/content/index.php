
<ul>
<?php
$keys = array_keys($_);
foreach ( $keys as $k) {
	?>
	<li>
		<?php p($k);?>
	</li>
	<?php if (is_array($_[$k])) {?>
		<ul>
		<?php foreach ($_[$k] as $v) ?>
			<li> <?php p($v)?> </li>
		</ul>
	<?php
	}
}?>
</ul>
<h1>Hello world</h1>
