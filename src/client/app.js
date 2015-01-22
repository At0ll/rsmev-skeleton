angular.module('rsmev')
    .config(function ($routeProvider) {
        $routeProvider
            .when('/client', {
                templateUrl: 'pages/client.html',
                controller: 'clientController'
            })
            .otherwise({ redirectTo: '/' });
    });