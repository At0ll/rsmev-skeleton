angular.module('rsmev.services')
  .factory 'clientService', [() ->
    get = () -> "Bro"
    return {
      get: get
    }
  ]