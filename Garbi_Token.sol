pragma solidity ^0.4.25;

// ----------------------------------------------------------------------------
// Llibreria matemàtica
// ----------------------------------------------------------------------------
contract SafeMath {
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
}



// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/jackaubrey41/DEMOERC20/blob/master/INIGO%20TOKEN%20ERC20
// funcions a utilitzar en el nostre token
// ----------------------------------------------------------------------------
contract ERC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function transfer(address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


// ----------------------------------------------------------------------------
// Contract function to receive approval and execute function in one call
//
// Borrowed from MiniMeToken
// ----------------------------------------------------------------------------
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}


// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}


// ----------------------------------------------------------------------------
// Aqui cambiem el nom, simbol, decimals i les monedes totals creades
// ----------------------------------------------------------------------------
// Nombre del contrato a cambiar y deployar 
contract GARBI_TOKEN is ERC20Interface, Owned, SafeMath {
    string public symbol; 
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    address public manager;

    // ------------------------------------------------------------------------
    // Constructor
    // Aqui per implementar el nostre token hem d'introduir els parametres de simbol, nom, decimal i monedes totals creades
    // Utilitzem dos decimals ja que les monedes tindran el valor de l'euro que es de 2 decimals. 1 GRB val 1 euro
    //------------------------------------------------------------------------
   constructor() public {
        symbol = "GRB";
        name = "GARBI_TOKEN";
        decimals = 2;
        _totalSupply = 1000000;
        balances[msg.sender] = _totalSupply;
        manager = msg.sender; // el maneger será la cuenta que deploya el contrato no hace falta pasarlo como argumento
        
        emit Transfer(address(0), manager, _totalSupply);
    }


    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------
    function totalSupply() public view returns (uint) {
        return _totalSupply - balances[address(0)];
    }


    // ------------------------------------------------------------------------
    // Get the token balance for account tokenOwner
    // ------------------------------------------------------------------------
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }


    // ------------------------------------------------------------------------
    // Aquest codi explica el balanç de cada conta i com resta i suma depenent de la operació que hi hagi
    // ------------------------------------------------------------------------
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Don't accept ETH
    // ------------------------------------------------------------------------
    function () public payable {
        revert();
    }
}
