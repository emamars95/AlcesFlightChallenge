#!/bin/bash 

function phoronix-test() {
	sudo yum -y install php
	sudo yum -y install php-xml
	sudo yum -y install php-pecl-json
	git clone https://github.com/phoronix-test-suite/phoronix-test-suite.git
	cd phoronix-test-suite
	./phoronix-test-suite benchmark gromacs
}

phoronix-test
