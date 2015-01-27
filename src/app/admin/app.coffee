angular.module('rsmev', ['ngRoute', 'rsmev.controllers', 'rsmev.services', 'rsmev.directives', 'rsmev.widgets'])
.config(($routeProvider) ->
	$routeProvider
	 .when '/admin',
	  templateUrl: 'pages/admin.html',
	  controller: 'adminController'
	 .otherwise({ redirectTo: '/' })
)
