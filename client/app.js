import React from 'react'
import {Router, Route, IndexRoute} from 'react-router'

import App from './components/App'
import Login from './components/Login'
import PageIndex from './components/PageIndex'

import history from './libs/history'
import auth from './libs/auth'

let requireLogin = (nextState, replaceState) => {
  if (!auth.isLoggedIn()) {
    replaceState({nextPathname: nextState.location.pathname}, '/login');
  }
}

React.render(
  <Router history={history}>
    <Route path="/" component={App}>
      <Route path="login" component={Login} />
      <IndexRoute component={PageIndex} onEnter={requireLogin} />
    </Route>
  </Router>,
  document.getElementById("root")
);
