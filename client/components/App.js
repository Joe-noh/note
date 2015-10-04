import React from 'react'

import history from '../libs/history'
import auth from '../libs/auth'

export default class App extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div>
        <header>
          <h1>App</h1>
        </header>
        <div>{this.props.children}</div>
      </div>
    );
  }
}
