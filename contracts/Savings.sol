pragma solidity 0.8.0;

import "./IBank.sol";

contract Savings is IBank{

    mapping (address => Account) Account_user;

    function deposit(uint256 amount) external payable override returns (bool){
        
        require(amount > 0, "Debes depositar un monto mayor a 0");
        require(msg.value > 0 ether, "Debes depositar un monto mayor a 0");        
        Account_user[msg.sender]=Account(amount,block.number); //Asignacion a una wallet del monto depositado y el numero del bloque actual


        emit Deposit(msg.sender,amount);
        return true;
    }
    function withdraw(uint256 amount) external override returns (uint256){}
    function getBalance() external view override returns (uint256){}



}