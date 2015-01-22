angular.module('rsmev')
    .config(function ($routeProvider) {
        $routeProvider
            .when('/admin', {
                templateUrl: 'pages/admin.html',
                controller: 'adminController'
            })
            .otherwise({ redirectTo: '/' });
    });