// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PesagemContract {
    address public owner;
    address payable public fornecedor;
    address payable public usuario;
    uint256 public balance;

    struct ContratoPesagem {
        string date;
        string time;
        string tag;
        uint8 numLocomotives;
        uint8 numVagons;
        uint256 weight;
        bool isValidated;
    }

    ContratoPesagem[] public contratosPesagem;

    event PesagemRegistrada(uint256 index);
    event PesagemValidada(uint256 index);
    event PesagemAjustada(uint256 index);
    event SaldoTransferido(address indexed recipient, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Permission denied");
        _;
    }

    constructor() {
        owner = msg.sender;
        fornecedor = payable(0x93B080bB18A3B7f941aBD7e369367627B688F0b2);
        usuario = payable(0x978cC110CeD2575b3C9bA43eD41002B37CF4D846);
    }

    function deposit() external payable {
        balance += msg.value;
    }

    function registrarPesagem(
        string memory date,
        string memory time,
        string memory tag,
        uint8 numLocomotives,
        uint8 numVagons,
        uint256 weight
    ) external {
        require(msg.sender == owner, "Permission denied");
        ContratoPesagem memory novoContrato = ContratoPesagem(date, time, tag, numLocomotives, numVagons, weight, false);
        contratosPesagem.push(novoContrato);
        emit PesagemRegistrada(contratosPesagem.length - 1);
    }

    function informarValidacao(uint256 index, bool isValid) external onlyOwner {
        contratosPesagem[index].isValidated = isValid;
        emit PesagemValidada(index);
    }

    function ajustarPesagem(uint256 index) external onlyOwner {
        contratosPesagem[index].isValidated = false;
        emit PesagemAjustada(index);
    }

    function transferTo(string memory recipient) external onlyOwner {
        require(balance > 0, "Insufficient balance to transfer.");
        require(!contratosPesagem[contratosPesagem.length - 1].isValidated, "The last weighing must be validated.");

        address payable recipientAddress = (keccak256(abi.encodePacked(recipient)) == keccak256(abi.encodePacked("fornecedor"))) ? fornecedor : usuario;
        
        uint256 amountToTransfer = balance;
        balance = 0;

        recipientAddress.transfer(amountToTransfer);
        emit SaldoTransferido(recipientAddress, amountToTransfer);
    }

    function getContratoPesagem(uint256 index) external view returns (ContratoPesagem memory) {
        return contratosPesagem[index];
    }

    function getNumContratosPesagem() external view returns (uint256) {
        return contratosPesagem.length;
    }
}
