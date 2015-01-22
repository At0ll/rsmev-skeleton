angular.module('rsmev.services')
    .factory('clientService', [function () {
        return {
            get: function () {
                return "Bro";
            }
        };
    }]);