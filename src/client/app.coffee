angular.module('rsmev')
  .config(($routeProvider) ->
    $routeProvider
      .when '/client',
        templateUrl: 'pages/client.html',
        controller: 'clientController'
      .otherwise({ redirectTo: '/' })
  )