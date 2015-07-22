<?php

trait assertHttp {
	/**
	 * Asserts the HTTP response code of an URL matches the expected code
	 *
	 * @param int $expectedCode the expected HTTP response code
	 * @param string $url the URL to check
	 * @param string $comment the comment to output if the test fails [facultative]
	 */
	private function assertHttpResponseCode ($expectedCode, $url, $comment = '') {
		$actualCode = $this->getHttpResponseCode($url);
		return $this->assertEquals($expectedCode, $actualCode, $comment);
	}

	/**
	 * Gets the HTTP response code of the specified URL
	 *
	 * @param string $url
	 * @return int the HTTP response code
	 */
	private function getHttpResponseCode ($url) {
		$ch = curl_init($url);
		curl_setopt($ch, CURLOPT_USERAGENT, "Nasqueron-Ops-Tests");
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_exec($ch);
		$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
		curl_close($ch);
		return $code;
	}
}
