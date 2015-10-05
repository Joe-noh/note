import alt from '../libs/alt'
import AuthActions from '../actions/AuthActions'

class AuthStore {
  constructor() {
    this.loggedIn = false;

    this.bindListeners({
      handleLogin: AuthActions.REQUEST_LOGIN
    });
  }

  handleLogin(res) {
    console.log(res);
    console.log("I am store");
  }
}

export default alt.createStore(AuthStore, "AuthStore");
