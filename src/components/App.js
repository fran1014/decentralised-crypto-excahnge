import { useEffect } from 'react';
import { ethers } from 'ethers';
import TOKEN_ABI from '../abis/Token.json';
import '../App.css';

function App() {
  const loadBlockChainData = async () => {
    const accounts = await window.ethereum.request({
      method: 'eth_requestAccounts',
    });
    console.log(accounts[0]);

    //Connect ethers to Blockchain
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const { chainId } = await provider.getNetwork();
    console.log(chainId);

    //Token Smart Contract
    const token = new ethers.Contract(
      '0x5FbDB2315678afecb367f032d93F642f64180aa3',
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
