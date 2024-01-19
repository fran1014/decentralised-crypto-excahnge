pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Token.sol";

contract Exchange{
  address public feeAccount;
  uint256 public feePercent;
  mapping(address => mapping(address => uint256)) public tokens;
  mapping(uint256 => _Order ) public orders;
  uint256 public orderCount;
  mapping (uint256 => bool) public orderCancelled; //true or false (boolean/bool)
  mapping(uint256 => bool) public orderFilled;

  //Orders mapping


  event Deposit(
    address token,
    address user,
    uint256 amount,
    uint256 balance);

  event Withdraw(
    address token,
    address user,
    uint256 amount,
    uint256 balance
  );

  event Cancel(
    uint256 id,
    address user,
    address tokenGet,
    uint256 amountGet,
    address tokenGive,
    uint256 amountGive,
    uint256 timestamp

  );

  event Trade(
    uint256 id,
    address user,
    address tokenGet,
    uint256 amountGet,
    address tokenGive,
    uint256 amountGive,
    address creator,
    uint256 timestamp


  );


  event Order(
    uint256 id,
    address user,
    address tokenGet,
    uint256 amountGet,
    address tokenGive,
    uint256 amountGive,
    uint256 timestamp
  );

  //A way to model the order
  struct _Order {
      //Atributes of an order
      uint256 id; //Unique Identifier for order
      address user; //User who made order
      address tokenGet; //Address of the token they receive 
      uint256 amountGet; //Amount they receive
      address tokenGive; //Address of token they give 
      uint256 amountGive; //Amount they give
      uint256 timestamp; //When order was created
  }

  constructor (address _feeAccount, uint256 _feePercent){
    feeAccount = _feeAccount; 
    feePercent = _feePercent;
  }

  //Deposit & withdrawn token
  function depositToken(address _token, uint256 _amount) public{
    //Transfer tokens to exchange
    require(Token(_token).transferFrom(msg.sender, address(this), _amount));
    //Update balance 
    tokens[_token][msg.sender] = tokens[_token][msg.sender] + _amount;
    //Emit an event
    emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
  }

  function withdrawToken(address _token, uint256 _amount) public {
    // Ensure user has enough tokens to withdraw
    require(tokens[_token][msg.sender] >= _amount);

     //Transfer tokens to user
     Token(_token).transfer(msg.sender, _amount);
    //Update user balance 
     tokens[_token][msg.sender] = tokens[_token][msg.sender] - _amount;

    //Emit event
    emit Withdraw (_token, msg.sender, _amount, tokens[_token][msg.sender]);
    }




  //Check balances 
  function balanceOf(address _token, address _user)
  public
  view
  returns(uint256){
    return tokens [_token][_user];
  }

  //------------------
//Make and cancel orders



function makeOrder(
 address _tokenGet,
 uint256 _amountGet,
 address _tokenGive,
 uint256 _amountGive)
 public{
//Token Give (the token they want to spend) - which token and how much?
//token Get (the token they want to receive) - which token and how much?

//Require token balance 
require(balanceOf(_tokenGive, msg.sender) >= _amountGive );

//Instantiate a new Order
orderCount++ ;
orders[orderCount]= _Order(
  orderCount,//id
  msg.sender, //user
  _tokenGet, //tokenGet
  _amountGet, //amountGet
  _tokenGive, //tokenGive
  _amountGive, //amountGive
  block.timestamp //timestamp
  );

  //Emit event 
  emit Order(
    orderCount,
    msg.sender,
    _tokenGet,
    _amountGet,
    _tokenGive,
    _amountGive,
    block.timestamp
  );
}

function cancelOrder(uint256 _id) public{
  //Fecthing the order
  _Order storage _order =  orders[_id];

   //Ensure the caller if the function if the owner of the order
  require(address(_order.user) == msg.sender);

  //Order must exist 
  require(_order.id == _id);

  //Cancel the order
  orderCancelled[_id] = true;

 

  //Emit event
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

//--------------
//Executing orders

function fillOrder(uint256 _id) public{
  //1.Must be valid orderid
  require(_id > 0 && _id <= orderCount, "Order does not exist");
  //2.Order can´t be filled 
  require(!orderFilled[_id]);
  //3.Order can´t be cancelled
  require(!orderCancelled[_id]);


  //Fetch Order
  _Order storage _order = orders[_id];
  //Swaping tokens (Trading)
  _trade(
    _order.id,
    _order.user, 
    _order.tokenGet,
    _order.amountGet,
    _order.tokenGive,
    _order.amountGive
     );

  //Mark order as filled
  orderFilled[_order.id] = true;

  
}

function _trade(
  uint256 _orderId,
  address _user,
  address _tokenGet,
  uint256 _amountGet,
  address _tokenGive,
  uint256 _amountGive
   ) internal{

    //Fee is paid by the user who filled the order (msg.sender)
    //Fee is deducted from _accountGet
    uint256 _feeAmount = (_amountGet * feePercent)/100;

    
    //Execute trade 
    //msg.sender is the user who filled the order, while _user is who created the order
    tokens[_tokenGet][msg.sender] = 
    tokens[_tokenGet][msg.sender] -
     (_amountGet + _feeAmount);

    tokens[_tokenGet][_user] = tokens[_tokenGet][_user] + _amountGet;

    //ChargeFees
    tokens[_tokenGet][feeAccount] = 
    tokens[_tokenGet][feeAccount] +
     _feeAmount;

     tokens[_tokenGive][_user] =  tokens[_tokenGet][_user] - _amountGive;
     tokens[_tokenGive][msg.sender] =
     tokens[_tokenGive][msg.sender] +
      _amountGive;

      //Emit trade event
      emit Trade(
        _orderId,
        msg.sender,
        _tokenGet,
        _amountGet,
        _tokenGive,
        _amountGive,
        _user,
        block.timestamp
      );

   }

}


