import logo from '../assets/logo.png';

const Navbar = () => {
  return (
    <div className="exchange__header grid">
      <div className="exchange__header--brand flex">
        <img src={logo} className="logo" alt="Tokens logo"></img>
        <h1>Tokens Exchange</h1>
      </div>

      <div className="exchange__header--networks flex"></div>

      <div className="exchange__header--account flex"></div>
    </div>
  );
};

export default Navbar;
