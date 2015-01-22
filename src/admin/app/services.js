angular.module('rsmev.services')
    .factory('adminService', [function () {
        return {
            get: function () {
                return "Admin";
            }
        };
    }]);