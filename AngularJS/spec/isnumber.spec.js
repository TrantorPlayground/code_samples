(function() {
    'use strict';
    describe('Directive - Numbers only', function() {
        var $scope, form;
        beforeEach(module('app'));
        beforeEach(inject(function($compile, $rootScope) {
            $scope = $rootScope;
            var element = angular.element(
                '<form name="form">' +
                '<input ng-model="model.somenum" name="somenum" numbers-only />' +
                '</form>'
            );
            $scope.model = { somenum: null }
            $compile(element)($scope);
            form = $scope.form;
        }));

        describe('integer', function() {
            it('should pass with integer', function() {
                form.somenum.$setViewValue('1');
                $scope.$digest();
                expect($scope.model.somenum).toEqual('1');
                expect(form.somenum.$valid).toBe(true);
            });
            it('should not pass with string', function() {
                form.somenum.$setViewValue('test');
                $scope.$digest();
                expect($scope.model.somenum).toBeUndefined();
                expect(form.somenum.$valid).toBe(false);
            });
        });
    });
})();
