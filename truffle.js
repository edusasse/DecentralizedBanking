module.exports = {
	networks: {
		development: {
			host: "localhost",
			port: 8545,
			network_id: "*",
			gas: 4600000
		}
	},
	rpc: {
		host: "localhost",
		gas: 4712388,
		port: 8545
	},
	solc: {
		optimizer: {
			enabled: true,
			runs: 200
		}
	},
};
