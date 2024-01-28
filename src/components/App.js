import { useEffect } from 'react';
import { useDispatch } from 'react-redux';

import config from '../config.json';

import {
  loadProvider,
  loadNetwork,
  loadAccount,
  loadTokens,
  loadExchange,
} from '../store/interactions';

function App() {
  const dispatch = useDispatch();
  const loadBlockChainData = async () => {
    //Connect ethers to Blockchain
    const provider = loadProvider(dispatch);

    //Fetch current network´s chainId (e.g hardhat:31337 , kovan:42)
    const chainId = await loadNetwork(provider, dispatch);

    //Fetch current amoutn and balance from metamask
    await loadAccount(provider, dispatch);

    //Load token Smart Contract
    const Token = config[chainId].Token;
    const mETH = config[chainId].mETH;
    await loadTokens(
      provider,
      [Token.address, config[chainId].mETH.address],
      dispatch
    );

    // Load exchange contract
    const exchangeConfig = config[chainId].exchange;
    await loadExchange(provider, exchangeConfig.address, dispatch);
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
