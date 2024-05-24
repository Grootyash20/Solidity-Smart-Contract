// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface ERC20Token {
    function totalSupply() external view returns(uint);
    function balanceOf(address tokenOwner) external view returns(uint balance);
    function transfer(address to, uint tokens) external returns(bool success);

    function allowance(address tokenOwner, address spender) external view returns(uint remaining);
    function approve(address spender, uint tokens) external returns(bool success);
    function transferFrom(address from, address to, uint tokens) external returns(bool success);

    event Transfer(address from, address  to, uint tokens);
    event Approval(address tokenOwner, address spender, uint tokens);
}

contract Hub is ERC20Token {
    string public name = "HubCoin";
    string public symbol = "HUB";
    uint8 public decimals = 0; 
    uint public override totalSupply;
    address public founder;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    
    constructor() {
        totalSupply = 1000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner) external view override returns(uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) external override returns(bool success) {
        require(balances[msg.sender] >= tokens, "Insufficient balance");
        balances[to] += tokens;
        balances[msg.sender] -= tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) external view override returns(uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) external override returns(bool success) {
        require(balances[msg.sender] >= tokens, "Insufficient balance");
        require(tokens > 0, "Tokens amount must be greater than 0");
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) external override returns(bool success) {
        require(allowed[from][msg.sender] >= tokens, "Allowance exceeded");
        require(balances[from] >= tokens, "Insufficient balance");
        balances[to] += tokens;
        balances[from] -= tokens;
        allowed[from][msg.sender] -= tokens;
        emit Transfer(from, to, tokens);
        return true;
    }
}
