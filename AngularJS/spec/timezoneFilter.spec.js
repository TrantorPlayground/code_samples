(function () {
    'use strict';
    describe('Filter - Time zone Filter', function () {
        var timezoneFilter;
        beforeEach(function () {
            module('app');
            inject(function ($filter) {
                timezoneFilter = $filter('timezoneFilter');
            })
        });

        it('should return an empty string for empty input', function () {
            expect(timezoneFilter(null)).toEqual('');
        });

        it('should be equal', function () {
            expect(timezoneFilter('2016-12-13T09:13:39.000Z', 'MM/dd/yyyy h:mm a')).toEqual('12/13/2016 2:43 PM');
        });
    });
})();
