import request from 'superagent'

let Login = {
  login(name, password, callback) {
    if (this.getToken()) {
      callback(true);
      this.onChange(true);
      return;
    }

    request
    .post("/api/login")
    .send({session: {name, password}})
    .end((err, res) => {
      if (err) {
        callback(false);
        this.onChange(false);
      } else {
        this.setToken(res.body.token);
        callback(true);
        this.onChange(true);
      }
    });
  },

  logout() {
    localStorage.removeItem("token");
    this.onChange(false);
  },

  getToken() {
    return localStorage.token;
  },

  setToken(token) {
    localStorage.token = token;
  },

  isLoggedIn() {
    return !!this.getToken();
  },

  onChange() {}
}

export default Login;
