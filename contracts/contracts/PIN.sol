// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PIN is IERC20 {
    //add burn function

    event WhiteListed(address indexed member);

    event BlackListed(address indexed member);

    uint public totalSupply;
    mapping (address => uint) private _balances;
    mapping (address => mapping (address => uint)) public allowance;
    string public constant name =  "PINNACLE COOPERATIVES";
    string public constant symbol= "PIN";
    uint256 public price = 1e18;
    mapping (address => bool) whitelist;
    address public manager;

    modifier onlyManager() {
        require(msg.sender == manager);
        _;
    }

    constructor(address _builder, uint _initialSupply) {
        _mint(_builder, _initialSupply);
        manager = _builder;
    }
     
/**
 * @dev returns the current token balance of the provided account
 * @param account is the account whose balance is enquired
 */
    function balanceOf(address account) external view returns (uint256) {
        return _balances[account]; 
    }
/**
 * @dev function to transfer tokens, returns bool indicating success or failure of thr transactions
 * @param recepient is the reciever of the transferred tokens
 * @param amount is the no. of tokens transferred
 */
    function transfer(address recepient, uint amount) external returns (bool){
       address sender = msg.sender;
       _transfer(sender, recepient, amount);
        return true;
    }
    /**
     * @dev approve is to approve spender to spend amount tokens on behalf of owner
     * @param spender to be approved
     * @param amount the amount of tokens to be approved for spending on behalf of the owner
     */
    function approve(address spender, uint amount) external returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;
    }
    
    /**
     * @dev to transfer tokens on behalf of owner
     * @param sender is the account whose tokens are being transferred

     */

    function transferFrom(address sender, address recepient, uint amount) external returns(bool) {
        address spender = msg.sender; // @var spender is the account approved to perform transaction on behalf of the spender.
        _spendAllowance(sender, spender, amount);
        _transfer(sender, recepient, amount);
        return true;
    }

    /**
     * @dev to mint tokens by calling _mint function
     * @param _to is the address to recieve minted tokens
     * @param amount is the no. of tokens to be minted!
     */

    function mint(address _to, uint256 amount) public onlyManager {
        _mint(_to, amount);
    }


    /**
     * @dev to burn the tokens
     * @param amount is the no. of tokens to be burnt
     */

    function burn(uint256 amount) public returns(bool) {
        address owner = msg.sender;
        _burn(owner, amount);
        return true;
    }

    /**
     * @dev to perform delegated burning of the tokens
     * @param owner is the account whose tokens are to be burnt
     * @param amount is the no. of tokens to be burnt
     */

    function burnFrom(address owner, uint256 amount) external returns(bool) {
        _spendAllowance(owner, msg.sender, amount);
        _burn(owner, amount);
        return true;
    }
    
    /**
     * @dev to add members to the whitleist
     * @param member is the account to be added to the whitelist
     */

    function addToWhitelist(address member) external onlyManager {
        whitelist[member] = true;
        emit WhiteListed(member);
    }

    /**
     * @dev to remove from the whitelist
     * @param member is the account to be removed
     */
    function removeFromWhitelist(address member) public onlyManager{
        whitelist[member] = false;
        emit BlackListed(member);
    }

    /**
     * @dev internal function to mint tokens to address.
     * @param _to is the account recieving tokens
     * @param _amount is the no. of token minted to @param _to
     */
    function _mint(address _to, uint256 _amount) internal {
        _balances[_to] += _amount;
        totalSupply += _amount;
        emit Transfer(address(0), msg.sender, _amount);
    }

    /**
     * @dev to transfer tokens from caller account to another
     * @param recepient is the address recieving tokensis the t
     * @param amount is the number of tokens being transferred.
     */
    function _transfer(address sender,address recepient, uint amount) internal {
        require(sender != address(0), "Invalid sender address");
        require(recepient != address(0), "Invalid receiver address");

        uint _fromBalance = _balances[sender];

        require(_fromBalance >= amount, "Not enough sender balance");
        unchecked {
            _balances[sender] = _fromBalance - amount;
        }
        
        _balances[recepient] += amount;

        emit Transfer(msg.sender, recepient, amount);
    }

    /**
     * @dev function to approve @param spender to spend on behalf of the owner(caller)
     * @param owner is the account whose tokens are getting approved to be spent
     * @param spender is the account approved to spend the tokens
     * @param amount is the no. of tokens approved to be spent
     */

    function _approve(address owner, address spender, uint amount) internal {
        require(owner != address(0), "Invalid owner address");
        require(spender != address(0), "invalid spender address");

        allowance[owner][spender] = amount;
        emit Approval(msg.sender, spender, amount);
    }

    /**
     * @dev checks and performs necessary operation before the delegated tokens are spent
     * @param owner is the account holding tokens
     * @param spender is tyhe account spending tokens
     * @param amount  is the amount of tokens to be spnt in the transaction
     */
    function _spendAllowance(address owner, address spender, uint amount) internal virtual {
        uint allowanceAmount = allowance[owner][spender];
        require(allowanceAmount >= amount, "Not allowed");
        unchecked {
            _approve(owner, spender, allowanceAmount - amount);
        }
    }

    /**
     * @dev to burn the tokens
     * @param owner is the account whose tokens are to be burnt
     * @param amount is the number of tokens to be burnt
     */

    function _burn(address owner, uint256 amount) internal {
        require(_balances[owner] >= amount, "Not enough balance");
        totalSupply -= amount;
        _balances[owner] -= amount;

        emit Transfer(msg.sender, address(0), amount);
    }
}