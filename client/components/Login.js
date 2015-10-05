import React from 'react'
import AuthStore from '../stores/AuthStore'
import AuthActions from '../actions/AuthActions'

let Login = React.createClass({
  getInitialState() {
    return AuthStore.getState();
  },

  componentDidMount() {
    AuthStore.listen(this.onChange);
  },

  componentWillUnmount() {
    AuthStore.unlisten(this.onChange);
  },

  onChange(state) {
    this.setState(state);
  },

  handleOnSubmit(e) {
    e.preventDefault();

    let name = this.refs.nameInput.getDOMNode().value;
    let pass = this.refs.passwordInput.getDOMNode().value;

    AuthActions.requestLogin(name, pass);
  },

  render() {
    return (
      <form onSubmit={this.handleOnSubmit} >
        <input type="text" ref="nameInput" placeholder="name" />
        <input type="password" ref="passwordInput" placeholder="password" />
        <input type="submit" value="Login" />
      </form>
    );
  }
});

export default Login;
