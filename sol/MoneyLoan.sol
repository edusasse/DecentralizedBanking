pragma solidity ^0.4.18;

import './DecentralizedBankingToken.sol';
import './SafeMath.sol';

contract MoneyLoan is DecentralizedBankingToken {
    
    using SafeMath for uint256;
    
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
        mapping(address => uint256) balanceFromInvestors;
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
    
    mapping(address => ClientNode) mapOfClients;
    address[] public arrayOfClientsAccts;
    
    mapping(address => MoneylenderNode) mapOfMoneylenders;
    address[] public arrayOfMoneylendersAccts;
    
    mapping(address => InvestorNode) mapOfInvestors;
    address[] public arrayOfInvestorsAccts;
    
    mapping(address => AssuranceNode) mapOfAssurances;
    address[] public arrayOfAssurancesAccts;
    
    function transferToInvestorNode(address _to, uint256 _value) returns (bool success) { 
        require(
            balances[msg.sender] >= _value 
            && _value > 0
            && mapOfInvestors[msg.sender].person.immutableAddress != address(0)
            && mapOfMoneylenders[_to].person.immutableAddress != address(0)
            && !mapOfMoneylenders[_to].isClosedForNewInvestors); 
        
        // Creates an investor found to register the inflow of funds
        InvestorFund memory investorFund = InvestorFund(mapOfInvestors[msg.sender],_to,_value,0,true);
        investorFund.investorNode = mapOfInvestors[msg.sender];
        investorFund.holdingFundsNode = _to;
        investorFund.foundsInTokens = _value;
        // TODO: convert using Oracle
        investorFund.foundsInFiduciaryCurrency = 0;
        if (mapOfMoneylenders[_to].isPreDefinedInterest){
            investorFund.isPreDefinedInterest = true;
            // investorFund.preDefinedInterest = mapOfMoneylenders[_to].preDefinedInterest
        }
        
        balances[msg.sender] = balances[msg.sender].sub(_value); 
        // Adds new funds to MoneylenderNode
        mapOfMoneylenders[_to].mapOfInvestorFunds[msg.sender].push(investorFund);
        // FIXME
        mapOfMoneylenders[_to].balanceFromInvestors = mapOfMoneylenders[_to].balanceFromInvestors.add(_value);
        
        return true; 
    }
    
}