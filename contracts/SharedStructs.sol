pragma solidity ^0.4.18;

library SharedStructs {
    
    // Contract that will define a money loan
    struct Contract {
        ClientNode clientNode;
        MoneylenderNode moneylenderNode;
        uint24 amountInFiduciary;
        uint8 period;
        bytes32 ipfsContract;
        bool isContractSigned;
        // TODO: How to work with real numbers in solidity
        // ?ufixed? preDefinedInterest
    }
    
    // Client node
    struct ClientNode {
        Person person;
    }

    // Investor node
    struct InvestorNode {
        Person person;
        mapping(address => InvestorFund) mapOfInvestorFunds;
        address[] arrayOfInvestorFundsAccts;
    }
    
    // Investor 
    struct InvestorFund {
        InvestorNode investorNode;
        address holdingFundsNode;
        uint256 foundsInTokens;
        uint24 foundsInFiduciaryCurrency;
        bool isPreDefinedInterest;
        // TODO: How to work with real numbers in solidity
        // ?ufixed? preDefinedInterest
    }
    
    struct MoneylenderNode {
        Person person;
        uint256 balanceFromInvestors;
        mapping(address => InvestorFund[]) mapOfInvestorFunds;
        address[] arrayOfInvestorFundsAccts;
        // Moneylender can redefine his strategy, but InvestorFunds will always keep the original definition
        bool isPreDefinedInterest;
        // TODO: How to work with real numbers in solidity
        // ?ufixed? preDefinedInterest;
        // Portfolio for the Moneylender
        bytes32 ipfsHashPortfolio;
        bool isClosedForNewInvestors;
    }
    
    struct AssuranceNode {
        Person person;
        mapping(address => uint256) balanceFromInvestors;
        mapping(address => InvestorFund) mapOfInvestorFunds;
        address[] arrayOfInvestorFundsAccts;
        // Portfolio for the AssuranceNode
        bytes32 ipfsHashPortfolio;
    }
    
    struct Person {
        // imutable
        address immutableAddress;
        bytes32 immutableFirstName;
        bytes32 immutableLastName;
        uint16 immutableYearOfBirth;
        uint8 immutableMonthOfBirth;
        uint8 immutableDayOfBirth;
        // mutable
        bytes32 country;
        bytes32 city;
        bytes32 state;
        bytes32 defaultCurrency;
        bytes32 ipfsHashPhoto;
        bytes32 ipfsHashAdditionalInformation;
    }
    
}