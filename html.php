<?php

function text(string $str): string {
	return str_replace(['<', '>', '"', '&'], ['&lt;', '&gt;', '&quot;', '&amp;'], $str);
}

function node(string $tag, string ...$nodes): string {
	$t = implode('', $nodes);
	return "<$tag>$t</$tag>";
}

function tnode(string $tag, string $t): string {
	$t = text($t);
	return "<$tag>$t</$tag>";
}

function attributes(array $attr): string {
	$a = '';
	foreach ($attr as $key => $val) {
		$a .= ' ' . $key;
		if ($val != '') {
			$a .= "=\"" . text($val) . "\"";
		}
	}
	return $a;
}

function anode(string $tag, array $attr = [], string ...$nodes): string {
	$a = attributes($attr);
	$t = implode('', $nodes);
	return "<$tag$a>$t</$tag>";
}

function inode(string $tag, array $attr = []): string {
	$a = attributes($attr);
	return "<$tag$a>";
}

function nodes(string ...$nodes): string {
	return implode('', $nodes);
}


function milliseconds() {
	$mt = explode(' ', microtime());
	return intval( $mt[1] * 1E3 ) + intval( round( $mt[0] * 1E3 ) );
}
$start = milliseconds();
$html = '';
for ($i=0; $i<100_000; $i++) {
	$html = nodes(
		inode('!doctype', ['html'=>'']),
		anode('html', ['lang'=>'en'], nodes(
			node('head',
				inode('meta', ['charset'=>'utf-8']),
				tnode('title', 'Test'),
			),
			node('body',
				anode('div', ['class'=>'alert alert-danger'], text('Test')),
				tnode("span", 'Abc & def'),
			),
		)),
	);
}
$end = milliseconds();
$ms = $end-$start;
echo $html."\n";
echo "PHP: ${ms}ms\n";
