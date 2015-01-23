angular.module('rsmev.services').factory 'adminService',
	[() ->
		get = () ->
			"Admin"
		return {
			get: get
		}
	]
