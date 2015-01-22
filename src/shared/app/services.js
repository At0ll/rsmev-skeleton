angular.module('rsmev.services', [])
    .factory('sharedService', [function () {
        return {
            get: function () {
                return "Hello ";
            }
        };
    }]);