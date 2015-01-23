angular.module('rsmev').config(($routeProvider) ->
	$routeProvider
	 .when '/admin',
	  templateUrl: 'pages/admin.html',
	  controller: 'adminController'
	 .otherwise({ redirectTo: '/' })
)
