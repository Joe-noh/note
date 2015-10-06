import alt from '../libs/alt'
import AuthActions from '../actions/AuthActions'
import AuthSource from '../sources/AuthSource'

class AuthStore {
  constructor() {
    this.loggedIn = false;

    this.bindListeners({
      handleRequestLogin: AuthActions.REQUEST_LOGIN,
      handleLoggedIn: AuthActions.UPDATE_AUTH
    });
  }

  handleRequestLogin(res) {
    console.log(res);
    console.log("I am handleRequestLogin");
  }

  handleLoggedIn(res) {
    console.log(res);
    this.loggedIn = true;
    console.log("I am handleLoggedIn");
  }
}

export default alt.createStore(AuthStore, "AuthStore");
