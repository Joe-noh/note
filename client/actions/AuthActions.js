import alt from '../libs/alt'
import WebAPI from '../libs/WebAPI'

class AuthActions {
  requestLogin(name, password) {
    let dispatcher = this;

    WebAPI.login(name, password).then((res) => {
      dispatcher.dispatch(res);
    });
  }
}

export default alt.createActions(AuthActions);
