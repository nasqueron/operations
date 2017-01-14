#!/usr/bin/env php
<?php

///
/// Parse arguments
///

if ($argc < 2) {
	fwrite(STDERR, "Usage: $argv[0] $file\n");
	exit(1);
}

$file = $argv[1];

if (!file_exists($file)) {
	fwrite(STDERR, "File not found: $file\n");
	exit(2);
}

///
/// Reads file
///

function to_one_line ($string) {
	return str_replace(["\r", "\n"], "", trim($string));
}

function to_one_line_from_bind ($string) {
	$toReturn = "";
	foreach (explode('"', $string) as $fragment) {
		if (trim($fragment) !== "") {
			$toReturn .= $fragment;
		}
	}
	return $toReturn;
}

function get_dns_record ($content) {
	$record = to_one_line($content);
	if (!preg_match("/(.*)\._domainkey/", $record, $matches)) {
		throw new Exception("Can't parse file.");
	}
	$subdomain = $matches[0];

	if (!preg_match("/\s+IN\s+TXT\s+\((.*)\)/", $record, $matches)) {
		throw new Exception("Can't parse file.");
	}
	$value = to_one_line_from_bind($matches[1]);

	return "$subdomain TXT $value";
}

try {
	echo get_dns_record(file_get_contents($file)), "\n";
} catch (Exception $ex) {
	fwrite(STDERR, $ex->getMessage());
}
