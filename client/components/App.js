import React from 'react'

export default class App extends React.Component {
  render() {
    return (
      <div>
        <div>App</div>
        <div>{this.props.children}</div>
      </div>
    );
  }
}
