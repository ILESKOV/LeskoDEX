// SPDX-License-Identifier: MIT
/// @title A contract for DECENTRALIZED EXCHANGE
/// @author LESKOV
/// @notice This exchange allow as to:
                                      // Deposit & Withdraw Funds
                                      // Manage Orders
                                      // Handle Trades - Charge fees
pragma solidity ^0.8.13;

import "./Token.sol";

/**
 * @title A contract for LeskoDEX.
 * NOTE: The contract of DEX with a decentralized orderbook and a custom ERC-20 token.
 */
contract Exchange{


/// @dev STATE VARIABLES are here
  address public feeAccount; // the acccount that receives exchange fees
  uint256 public feePercent; // the fee percentage
  address constant ETHER = address(0); //allows as to store Ether in tokens mapping with blank address
/// @dev MAPPINGS are here
  //Tracks of the number of individual tokens of each user
  mapping(address => mapping(address => uint256))public tokens;
  //A way to store the orders
  mapping(uint256 => _Order)public orders;
  uint256 public orderCount;
  //A way to store cancel orders
  mapping(uint256 => bool)public orderCancelled;
  //A way to store filled orders
  mapping(uint256 => bool)public orderFilled;
// SPDX-License-Identifier: MIT
/// @title A contract for DECENTRALIZED EXCHANGE
/// @author LESKOV
/// @notice This exchange allow as to:
// Deposit & Withdraw Funds
// Manage Orders
// Handle Trades - Charge fees
pragma solidity ^0.8.13;

import "./Token.sol";

/**
 * @title A contract for LeskoDEX.
 * NOTE: The contract of DEX with a decentralized orderbook and a custom ERC-20 token.
 */
contract Exchange {
    /// @dev STATE VARIABLES are here
    address public feeAccount; // the acccount that receives exchange fees
    uint256 public feePercent; // the fee percentage
    address constant ETHER = address(0); //allows as to store Ether in tokens mapping with blank address
    /// @dev MAPPINGS are here
    //Tracks of the number of individual tokens of each user
    mapping(address => mapping(address => uint256)) public tokens;
    //A way to store the orders
    mapping(uint256 => _Order) public orders;
    uint256 public orderCount;
    //A way to store cancel orders
    mapping(uint256 => bool) public orderCancelled;
    //A way to store filled orders
    mapping(uint256 => bool) public orderFilled;
    /// @dev EVENTS are here
    /**
     * @dev Emitted when the user deposits the tokens to the exchange.
     * @param token address of the deposited token.
     * @param user address of the user that deposited tokens.
     * @param amount amount of deposited tokens.
     * @param balance the exchange balance of these user tokens after deposit.
     */
    event Deposit(address token, address user, uint256 amount, uint256 balance);
    /**
     * @dev Emitted when the user withdraws the tokens from the exchange.
     * @param token the address of the token to be withdrawn.
     * @param user address of the user to whom funds are withdrawn.
     * @param amount amount of withdrawn tokens.
     * @param balance the exchange balance of these user tokens after withdrawn.
     */
    event Withdraw(address token, address user, uint256 amount, uint256 balance);
    /**
     * @dev Emitted when the user create an order.
     * @param id order count id.
     * @param user address of the user that create this order.
     * @param tokenGet the address of the token that the user wants to get.
     * @param amountGet the amount of `tokenGet` token user wants to get.
     * @param tokenGive the address of the token that the user wants to give.
     * @param amountGive the amount of `tokenGive` token user wants to give.
     * @param timestamp time of order creation.
     */
    event Order(
        uint256 id,
        address user,
        address tokenGet,
        uint256 amountGet,
        address tokenGive,
        uint256 amountGive,
        uint256 timestamp
    );
    /**
     * @dev Emitted when the user cancel an order.
     * @param id id of the cancelled order.
     * @param user address of the user that cancelled this order.
     * @param tokenGet the address of the token that the user wanted to get previously.
     * @param amountGet the amount of `tokenGet` token user wanted to get previously.
     * @param tokenGive the address of the token that the user wanted to give previously.
     * @param amountGive the amount of `tokenGive` token user wanted to give previously.
     * @param timestamp time of order cancelling.
     */
    event Cancel(
        uint256 id,
        address user,
        address tokenGet,
        uint256 amountGet,
        address tokenGive,
        uint256 amountGive,
        uint256 timestamp
    );
    /**
     * @dev Emitted when the trade happened.
     * @param id id of the filled order.
     * @param user address of the user that create this order.
     * @param tokenGet the address of the token that user received.
     * @param amountGet the amount of `tokenGet` token user received.
     * @param tokenGive the address of the token that the user gived.
     * @param amountGive the amount of `tokenGive` token user gived.
     * @param userFill address of the user that maked this deal with `user`.
     * @param timestamp time of the transaction.
     */
    event Trade(
        uint256 id,
        address user,
        address tokenGet,
        uint256 amountGet,
        address tokenGive,
        uint256 amountGive,
        address userFill,
        uint256 timestamp
    );

    /// @dev A way to model the order
    struct _Order {
        uint256 id;
        address user;
        address tokenGet;
        uint256 amountGet;
        address tokenGive;
        uint256 amountGive;
        uint256 timestamp;
    }

    /// @notice Initialisation of feeAccount and feePercent of exchange
    constructor(address _feeAccount, uint256 _feePercent) {
        feeAccount = _feeAccount;
        feePercent = _feePercent;
    }

    /// @dev Fallback: reverts if Ether is sent to this smart contract by mistake
    fallback() external payable {}

    receive() external payable {}

    /// @notice Function for deposit only Ether to exchange
    function depositEther() public payable {
        // Manage deposit - update balance
        tokens[ETHER][msg.sender] = tokens[ETHER][msg.sender] + (msg.value);
        emit Deposit(ETHER, msg.sender, msg.value, tokens[ETHER][msg.sender]);
    }

    /// @notice Function for withdraw only Ether from exchange
    function withdrawEther(uint256 _amount) public {
        require(tokens[ETHER][msg.sender] >= _amount);
        tokens[ETHER][msg.sender] = tokens[ETHER][msg.sender] - (_amount);
        payable(msg.sender).transfer(_amount);
        emit Withdraw(ETHER, msg.sender, _amount, tokens[ETHER][msg.sender]);
    }

    /// @notice Function for deposit only erc-20 tokens to exchange
    function depositToken(address _token, uint256 _amount) public {
        //Don't allow ETHER deposits
        require(_token != ETHER);
        // Send tokens to this contract
        require(Token(_token).transferFrom(msg.sender, address(this), _amount));
        // Manage deposit - update balance
        tokens[_token][msg.sender] = tokens[_token][msg.sender] + (_amount);
        // Emit event
        emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
    }

    /// @notice Function for withdraw only erc-20 tokens from exchange
    function withdrawToken(address _token, uint256 _amount) public {
        require(_token != ETHER);
        require(tokens[_token][msg.sender] >= _amount);
        tokens[_token][msg.sender] = tokens[_token][msg.sender] - (_amount);
        require(Token(_token).transfer(msg.sender, _amount));
        emit Withdraw(_token, msg.sender, _amount, tokens[_token][msg.sender]);
    }

    /// @notice Function for keep track balance of individual token of individual user
    function balanceOf(address _token, address _user) public view returns (uint256) {
        return tokens[_token][_user];
    }

    /// @notice Function adds order to storage
    function makeOrder(
        address _tokenGet,
        uint256 _amountGet,
        address _tokenGive,
        uint256 _amountGive
    ) public {
        orderCount = orderCount + (1);
        orders[orderCount] = _Order(
            orderCount,
            msg.sender,
            _tokenGet,
            _amountGet,
            _tokenGive,
            _amountGive,
            block.timestamp
        );
        emit Order(orderCount, msg.sender, _tokenGet, _amountGet, _tokenGive, _amountGive, block.timestamp);
    }

    /// @notice Function allows user to cancell the order
    function cancelOrder(uint256 _id) public {
        _Order storage _order = orders[_id]; //Fetch the order
        require(address(_order.user) == msg.sender); //Must be "my order"
        require(_order.id == _id); //The order must exist
        orderCancelled[_id] = true;
        emit Cancel(
            _order.id,
            msg.sender,
            _order.tokenGet,
            _order.amountGet,
            _order.tokenGive,
            _order.amountGive,
            block.timestamp
        );
    }

    /// @notice Function allows another users to fill orders
    function fillOrder(uint256 _id) public {
        //Require exist id and low than total orderCount
        require(_id > 0 && _id <= orderCount);
        //Require order not to be filled yet
        require(!orderFilled[_id]);
        //Require order not to be cancelled yet
        require(!orderCancelled[_id]);
        _Order storage _order = orders[_id]; //Fetch the order
        _trade(_order.id, _order.user, _order.tokenGet, _order.amountGet, _order.tokenGive, _order.amountGive);
        //Mark order as filled
        orderFilled[_order.id] = true;
    }

    /// @notice Function of trade with charging fees from users
    function _trade(
        uint256 _orderId,
        address _user,
        address _tokenGet,
        uint256 _amountGet,
        address _tokenGive,
        uint256 _amountGive
    ) internal {
        //Fee paid by the user that fills the order, a.k.a msg.sender.
        //Fee deducted from _amountGet
        uint256 _feeAmount = (_amountGet * (feePercent)) / (100);

        //Execute trade
        tokens[_tokenGet][msg.sender] = tokens[_tokenGet][msg.sender] - (_amountGet + (_feeAmount));
        tokens[_tokenGet][_user] = tokens[_tokenGet][_user] + (_amountGet);
        tokens[_tokenGet][feeAccount] = tokens[_tokenGet][feeAccount] + (_feeAmount);
        tokens[_tokenGive][_user] = tokens[_tokenGive][_user] - (_amountGive);
        tokens[_tokenGive][msg.sender] = tokens[_tokenGive][msg.sender] + (_amountGive);

        emit Trade(_orderId, _user, _tokenGet, _amountGet, _tokenGive, _amountGive, msg.sender, block.timestamp);
    }
}
