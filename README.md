# Decentralized Banking

    Check the [WHITEPAPER](WHITEPAPER.md) for more information.

# Stack

* Ethereum
* IPFS
* Truffle
* Testrpc

# Prepare enviroment

Install and execute Testrpc. 
´´´´
npm install -g ethereumjs-testrpc
testrpc
´´´´
You should run testrpc in a new terminal and leave it running while you develop.

Install Truffle.
´´´´
npm install -g truffle
´´´´

# Build

You should be able to compile the contracts by running truffle compile.
´´´´
truffle compile
´´´´

To deploy the contracts to the simulated network, you need to run truffle migrate:
´´´´
truffle migrate
´´´´
To run this migration again:
´´´´
truffle migrate --reset
´´´´

