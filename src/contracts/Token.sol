/// @title A contract for ERC-20 "" Token
/// @author ___SLON___
/// @notice The contract creates a token according to the ERC-20 standard
pragma solidity ^0.5.0;
//Safe Math is used here to avoid potential overflows and underflows
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Token{
  using SafeMath for uint;
/// @dev STATE VARIABLES are here
  string public name = "ESKO";
  string public symbol = "ESKO";
  uint256 public decimals = 18;
  uint256 public totalSupply;

/// @dev MAPPINGS are here
    //Track balances
    mapping(address => uint256)public balanceOf;
    //Tracks how many tokens exchange is allowed to expand
    mapping(address => mapping(address => uint256))public allowance;

/// @dev EVENTS are here
   event Transfer(address indexed from, address indexed to, uint256 value);
   event Approval(address indexed owner, address indexed spender, uint value);
/// @notice Supply is million tokens. Supply*(10**decimals)are in Wei
/// @notice Initialisation of totalSupply and giving all tokens to deployer
  constructor() public{
      totalSupply = 1000000 * (10 ** decimals);
      balanceOf[msg.sender] = totalSupply;
  }
/// @notice All functions below are built according to the ERC-20 standard
    function transfer(address _to, uint256 _value)public returns(bool success){
      require(balanceOf[msg.sender] >= _value);
      _transfer(msg.sender, _to, _value);
      return true;

    }
/// @notice This _transfer function is the same part of transfer and transferFrom functions 
   function _transfer(address _from, address _to, uint256 _value) internal{
      require(_to != address(0));
      balanceOf[_from] = balanceOf[_from].sub(_value);
      balanceOf[_to] = balanceOf[_to].add(_value);
      emit Transfer(_from, _to, _value);
   }


    function approve(address _spender, uint256 _value)public returns(bool success){
      require(_spender != address(0));
      allowance[msg.sender][_spender] = _value;
      emit Approval(msg.sender, _spender, _value);
      return true;
    }
  
  
  function transferFrom(address _from, address _to, uint256 _value)public returns(bool success){
      require(_value <= balanceOf[_from]);
      require(_value <= allowance[_from][msg.sender]);
      allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
      _transfer(_from, _to, _value);
      return true;
  }
}