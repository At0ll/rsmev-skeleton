describe('controllers', function(){
    beforeEach(module('rsmev'));
    describe('admin controller', function(){
        var scope;
        beforeEach(inject(function($rootScope, $controller){
            scope = $rootScope.$new();
            $controller('adminController', {
                $scope: scope
            });
        }));
        it('should contain initial text', function(){
            expect(scope.title).toBe('Hello Admin');
        });
    });
});