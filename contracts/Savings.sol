// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "./IBank.sol";

contract Savings is IBank{

    address  payable contrato;
    address owner;

    constructor () {
        contrato =payable(address(this));
        owner = msg.sender;
    }
    
    uint256 public percent = 3; //3%
    uint256 count_blocks = 100; //Total de bloques para interes del 3%

    mapping (address => Account) Account_user; //Asingnacion de usuario por wallet

    function deposit(uint256 amount) external payable override returns (bool){
        
        require(amount > 0, "Debes depositar un monto mayor a 0");
        require(msg.value > 0 ether, "Debes depositar un monto mayor a 0");     

        Account_user[msg.sender]=Account(amount * 1 ether + Account_user[msg.sender].deposit,block.number); //Asignacion a una wallet del monto depositado y el numero del bloque actual
        contrato.transfer(amount * 1 ether);

        emit Deposit(msg.sender,amount);
        return true;
    }
    function withdraw(uint256 amount) external override returns (uint256){
        uint256 balanceUser = Account_user[msg.sender].deposit;
        require(amount >=0,"Debes retirar un monto de valor positivo");
        require(amount <= balanceUser, "Debes retirar un valor menor a tu balance"); //Validacion del retiro, monto hasta el deposito realizado + intereses
        if(amount ==0){
            amount=balanceUser;
        }
        Account_user[msg.sender].deposit = balanceUser-amount; //Actualizacion del saldo del usuario
        payable(msg.sender).transfer(amount * 1 ether);

        emit Withdraw(msg.sender, amount);
        return balanceUser;
    }
    function getBalance() external view override returns (uint256){        
        uint256 balanceUser = Account_user[msg.sender].deposit;
        balanceUser += InterstAccrued(); // Actualizacion del deposito + intereses
        return balanceUser;
    }

     function InterstAccrued() private view returns(uint256){
        uint256 blocks =(block.number - Account_user[msg.sender].lastInterestBlock); //Calculo del total de bloques transcurridos
        uint256 rate = blocks*(percent*10**16)/count_blocks; //Calculo de la tasa de interes hasta el bloque actual
        uint256 interstTotal = (Account_user[msg.sender].deposit / 1 ether)*rate; //Calculo del total de intereses obtenidos hasta el bloque actual

        return interstTotal;

        
    }
    function AddEth () public payable {}


}