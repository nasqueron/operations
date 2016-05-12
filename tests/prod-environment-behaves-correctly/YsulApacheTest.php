<?php

require_once 'traits/assertHttp.php';

class YsulApacheTest extends PHPUnit_Framework_TestCase {
	use assertHttp;

	/**
	 * Apache server hostname to tet
	 */
	const SERVER = 'ysul.nasqueron.org';

	/**
	 * Apache port
	 */
	const PORT = 3200;

	/**
	 * Path to SuEXEC binary
	 */
	const SUEXEC = '/usr/local/sbin/suexec';

	public function testApacheIsLive () {
		$url = "http://" . self::SERVER . ":" . self::PORT . "/";
		$this->assertHttpResponseCode(200, $url, "Apache looks down.");
	}

	public function testSuEXECHasBeenInstalled () {
		// Reported by amj on T823, see also T508 and T517.

		if (gethostname() !== self::SERVER) {
			$this->markTestSkipped(
				"This test can only run on " . self::SERVER
			);
		};

		$this->assertTrue(
			file_exists(self::SUEXEC)
		);
	}
}
