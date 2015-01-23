angular.module('rsmev.controllers')
  .controller 'adminController', ['$scope', 'sharedService', 'adminService', ($scope, sharedService, adminService) ->
	  $scope.title = sharedService.get() + adminService.get()
	]
