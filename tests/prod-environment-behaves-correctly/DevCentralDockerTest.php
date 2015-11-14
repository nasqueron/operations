<?php

require_once 'utils/DockerContainer.php';

class DevCentralDockerTest extends PHPUnit_Framework_TestCase {
	private $container;

	const DOCKER_CONTAINER = 'devcentral';

	protected function setUp () {
		if (!getenv('DOCKER_ACCESS')) {
			$this->markTestSkipped("No access to Docker engine.");
		}

		$this->container = new DockerContainer(getenv('DOCKER_HOST'), self::DOCKER_CONTAINER);
	}

	public function testInitialized () {
		//TODO: test if .initialized file exists
		$this->markTestIncomplete("This test will have to be implemented after container update.");
	}

	public function testProcesses () {
		$processes = $this->container->exec("ps auxw");

		$expectedProcesses = [
			'nginx: master process',
			'nginx: worker process',
			'php-fpm: master process',
			'PhabricatorTaskmasterDaemon',
			'PhabricatorBot',
		];

		foreach ($expectedProcesses as $expectedProcess) {
			$this->assertContains($expectedProcess, $processes);
		}
	}
}
