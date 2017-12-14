# Decentralized Banking

Check the [WHITEPAPER](WHITEPAPER.md) for more information.

# Stack

* Ethereum
* IPFS
* Truffle
* Testrpc

# Prepare enviroment

Install and execute Testrpc. 
```bash
npm install -g ethereumjs-testrpc
testrpc --rpc
```
You should run testrpc in a new terminal and leave it running while you develop.

Install Truffle.
```bash
npm install -g truffle
```

# Build

You should be able to compile the contracts by running truffle compile.
```bash
truffle compile
```

To deploy the contracts to the simulated network, you need to run truffle migrate:
```bash
truffle migrate
```
To run this migration again:
```bash
truffle migrate --reset
```

To test the project:
```
truffle test
```