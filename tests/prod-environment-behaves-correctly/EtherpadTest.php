<?php

require_once 'traits/assertHttp.php';

class EtherpadTest extends PHPUnit_Framework_TestCase {
	use assertHttp;

	public function testEtherpadIsLive () {
		$this->assertHttpResponseCode(200, 'http://pad.nasqueron.org', 'Etherpad looks down.');
		$this->assertHttpResponseCode(200, 'https://pad.nasqueron.org/', "Etherpad HTTPS issue.");
		$this->assertHttpResponseCode(200, 'http://pad.wolfplex.be', "Etherpad doesn't reply to pad.wolfplex.be vhost.");
		$this->assertHttpResponseCode(404, 'http://pad.nasqueron.org/notexisting', 'A 404 code were expected for a not existing Etherpad page.');
		$this->assertHttpResponseCode(200, 'http://pad.nasqueron.org/metrics', "ep_ether-o-meter plugin doesn't seem installed.");
	}

	public function testWolfplexApiWorks () {
		//Reported by philectro - 09:42 < philectro> hey tous les pad ont disparu :o

		$url = "http://www.wolfplex.be/pad/";
		$this->assertHttpResponseCode(200, $url);

		$stringOnlyAvailableWhenApiWorks = '<li><a href="/pad/';
		$currentContent = file_get_contents($url);
		$this->assertContains($stringOnlyAvailableWhenApiWorks, $currentContent, "On Ysul, /home/wolfplex.org/logs/api.log could help. But more probably, you reinstalled the Etherpad container without restoring the API key. Move the former APIKEY.txt file to /opt/etherpad-lite or, if lost, update Wolfplex API credentials with the new API key.");
	}
}
