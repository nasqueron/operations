<?php

require_once 'traits/assertHttp.php';

class DevCentralTest extends PHPUnit_Framework_TestCase {
	use assertHttp;

	public function testWebsiteIsUp () {
		$this->assertHttpResponseCode(200, 'https://devcentral.nasqueron.org', "DevCentral HTTPS issue.");
		$this->assertHttpResponseCode(500, 'https://phabricator-files-for-devcentral-nasqueron.spacetechnology.net', "DevCentral alternative domain should return a 500 error code for homepage. Check phabricator.base-uri isn't empty.");
	}

    public function testNginxRedirectsHttpToHttps () {
		$this->assertHttpResponseCode(301, 'http://devcentral.nasqueron.org', 'Nginx should redirect http to https with a 301 code.');
    }

	public function testAphlictIsUp () {
		$this->assertHttpResponseCode(405, 'http://dwellers.nasqueron.org:22281/', 'Aphlict server seems down, does aphlict container is launched in Docker engine?');
	}
}
