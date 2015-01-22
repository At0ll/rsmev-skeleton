angular.module('rsmev.controllers')
    .controller('clientController', ['$scope', 'sharedService', 'clientService', function ($scope, sharedService, clientService) {
        $scope.title = sharedService.get() + clientService.get();
    }]);