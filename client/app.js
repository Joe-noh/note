import React from 'react'
import {Router, Route, IndexRoute} from 'react-router'

import App from './components/App'
import PageIndex from './components/PageIndex'

React.render(
  (
    <Router>
      <Route path="/" component={App}>
        <IndexRoute component={PageIndex} />
      </Route>
    </Router>
  ),
  document.getElementById("root")
);
