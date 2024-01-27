import { useEffect } from 'react';
import { useDispatch } from 'react-redux';
import { ethers } from 'ethers';
import config from '../config.json';
import TOKEN_ABI from '../abis/Token.json';

import { loadProvider, loadNetwork, loadAccount } from '../store/interactions';

function App() {
  const dispatch = useDispatch();
  const loadBlockChainData = async () => {
    const account = await loadAccount(dispatch);
    console.log(account);

    //Connect ethers to Blockchain
    const provider = loadProvider(dispatch);
    const chainId = await loadNetwork(provider, dispatch);

    //Token Smart Contract
    const token = new ethers.Contract(
      config[chainId].Token.address,
      TOKEN_ABI,
      provider
    );
    console.log(token.address);
    const symbol = await token.symbol();
    console.log(symbol);
  };

  useEffect(() => {
    loadBlockChainData();
  });

  return (
    <div>
      {/* Navbar */}

      <main className="exchange grid">
        <section className="exchange__section--left grid">
          {/* Markets */}

          {/* Balance */}

          {/* Order */}
        </section>
        <section className="exchange__section--right grid">
          {/* PriceChart */}

          {/* Transactions */}

          {/* Trades */}

          {/* OrderBook */}
        </section>
      </main>

      {/* Alert */}
    </div>
  );
}

export default App;
