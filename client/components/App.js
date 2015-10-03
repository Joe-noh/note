import React from 'react'
import auth from '../libs/auth'

export default class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      loggedIn: auth.isLoggedIn()
    }
  }

  render() {
    return (
      <div>
        <div>App</div>
        <div>{this.props.children}</div>
      </div>
    );
  }
}
