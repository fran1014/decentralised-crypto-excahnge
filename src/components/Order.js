import { useState, useRef } from 'react';

const Order = () => {
  const [isBuy, setIsBuy] = useState(true);
  const [amount, setAmount] = useState(0);
  const [price, setPrice] = useState(0);

  const buyRef = useRef(null);
  const sellRef = useRef(null);

  const tabHandler = (e) => {
    if (e.target.className !== buyRef.current.className) {
      e.target.className = 'tab tab--active';
      buyRef.current.className = 'tab';
      setIsBuy(false);
    } else {
      e.target.className = 'tab tab--active';
      sellRef.current.className = 'tab';
      setIsBuy(true);
    }
  };

  const buyHandler = (e) => {};

  const sellHandler = (e) => {};

  return (
    <div className="component exchange__orders">
      <div className="component__header flex-between">
        <h2>New Order</h2>
        <div className="tabs">
          <button onClick={tabHandler} ref={buyRef} className="tab tab--active">
            Buy
          </button>
          <button onClick={tabHandler} ref={sellRef} className="tab">
            Sell
          </button>
        </div>
      </div>

      <form onSubmit={isBuy ? buyHandler : sellHandler}>
        <input
          type="text"
          id="amount"
          placeholder="0.0000"
          onChange={(e) => setAmount(e.target.value)}
        />

        <input
          type="text"
          id="price"
          placeholder="0.0000"
          onChange={(e) => setPrice(e.target.value)}
        />

        <button className="button button--filled" type="submit">
          {isBuy ? <span> Buy Order </span> : <span> Sell Order </span>}
        </button>
      </form>
    </div>
  );
};

export default Order;