import React from 'react'
import {Router, Route, IndexRoute} from 'react-router'

import App from './components/App'
import Login from './components/Login'
import PageIndex from './components/PageIndex'

React.render(
  <Router>
    <Route path="/" component={App}>
      <Route path="login" component={Login} />
      <IndexRoute component={PageIndex} />
    </Route>
  </Router>,
  document.getElementById("root")
);
