import alt from '../libs/alt'
import AuthSource from '../sources/AuthSource'
import WebAPI from '../libs/WebAPI'

class AuthActions {
  requestLogin(name, password) {
    this.dispatch();

    AuthSource.login(name, password).then((res) => {
      this.actions.updateAuth(res);
    });
  }

  updateAuth(res) {
    this.dispatch(res);
  }
}

export default alt.createActions(AuthActions);
