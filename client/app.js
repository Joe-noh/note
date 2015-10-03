import React from 'react'
import {Router, Route, IndexRoute} from 'react-router'
import {createHistory} from 'history'

import App from './components/App'
import Login from './components/Login'
import PageIndex from './components/PageIndex'

import auth from './libs/auth'

let history = createHistory();

let requireLogin = (nextState, replaceState) => {
  if (!auth.isLoggedIn()) {
    replaceState({nextPathname: nextState.location.pathname}, '/login');
  }
}

React.render(
  (
    <Router history={history}>
      <Route path="/" component={App}>
        <Route path="login" component={Login} />
        <IndexRoute component={PageIndex} onEnter={requireLogin} />
      </Route>
    </Router>
  ),
  document.getElementById("root")
);
