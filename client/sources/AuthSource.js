import WebAPI from '../libs/WebAPI'

let AuthSource = {
  login(name, password) {
    return WebAPI.login(name, password);
  }
}

export default AuthSource;
