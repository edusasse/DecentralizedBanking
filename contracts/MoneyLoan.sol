pragma solidity ^0.4.18;

import './SharedStructs.sol';
import './DecentralizedBankingToken.sol';
import './SafeMath.sol';

contract MoneyLoan is DecentralizedBankingToken {
    
    using SafeMath for uint256;
    
    mapping(address => SharedStructs.ClientNode) mapOfClients;
    address[] public arrayOfClientsAccts;
    
    mapping(address => SharedStructs.MoneylenderNode) mapOfMoneylenders;
    address[] public arrayOfMoneylendersAccts;
    
    mapping(address => SharedStructs.InvestorNode) mapOfInvestors;
    address[] public arrayOfInvestorsAccts;
    
    mapping(address => SharedStructs.AssuranceNode) mapOfAssurances;
    address[] public arrayOfAssurancesAccts;
    
    /**
     * Transfers the defined amount of tokens to the defined MoneylenderNode. The MoneylenderNode cannot access this tokens if not by a contract.
     */
    function transferToInvestorNode(address _to, uint256 _value) public returns (bool success) { 
        require(
            balances[msg.sender] >= _value 
            && _value > 0
            && mapOfInvestors[msg.sender].person.immutableAddress != address(0)
            && mapOfMoneylenders[_to].person.immutableAddress != address(0)
            && !mapOfMoneylenders[_to].isClosedForNewInvestors); 
        
        // Creates an investor found to register the inflow of funds
        SharedStructs.InvestorFund memory investorFund = SharedStructs.InvestorFund(mapOfInvestors[msg.sender],_to,_value,0,true);
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
        // Adds balance to investor
        mapOfMoneylenders[_to].balanceFromInvestors = mapOfMoneylenders[_to].balanceFromInvestors.add(_value);
        
        return true; 
    }
    
}