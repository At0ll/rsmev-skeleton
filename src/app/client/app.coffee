angular.module('rsmev', ['ngRoute', 'rsmev.controllers', 'rsmev.services'])
.config(($routeProvider) ->
  $routeProvider
    .when '/client',
      templateUrl: 'pages/client.html',
      controller: 'clientController'
    .otherwise({ redirectTo: '/' })
)