import React from 'react'
import {History} from 'react-router'

import auth from '../libs/auth'

export default React.createClass({
  mixins: [History],

  handleOnSubmit(e) {
    e.preventDefault();

    let name = this.refs.nameInput.getDOMNode().value;
    let pass = this.refs.passwordInput.getDOMNode().value;

    auth.login(name, pass, (loggedIn) => {
      var {location} = this.props;

      if (location.state && location.state.nextPathname) {
        this.history.replaceState(null, location.state.nextPathname);
      } else {
        this.history.replaceState(null, '/');
      }
    });
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
