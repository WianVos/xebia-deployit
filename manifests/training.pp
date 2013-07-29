class deployit::training{

	file{'training zip file': 
	source => "puppet:///modules/deployit/training",
	recurse => true,
	path => '/var/tmp/training'
	}

}
