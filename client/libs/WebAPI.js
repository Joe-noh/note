//import fetch from 'fetch'

class WebAPI {
  static login(name, password) {
    return fetch("/api/login", {
      method: "post",
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        session: {name, password}
      })
    });
  }

  logout() {
    localStorage.removeItem("token");
    this.onChange(false);
  }

  getToken() {
    return localStorage.token;
  }

  setToken(token) {
    localStorage.token = token;
  }

  isLoggedIn() {
    return !!this.getToken();
  }

  onChange() {}
}

export default WebAPI;
