(function () {
    angular
        .module('fleetComm')
        .directive('dateTimePicker', dateTimePicker);

    function dateTimePicker() {
        return {
            require: 'ngModel',
            restrict: 'AE',
            scope: {
                ngModel: '=',
                maxdate: '=',
                mindate: '=',
                datevalue: '='
            },
            link: function (scope, elem, attrs, ngModelCtrl) {
                elem.datetimepicker({
                    minDate: moment().add(-1, 'minutes'),
                    useCurrent: false,
                    defaultDate: scope.ngModel,
                    widgetPositioning: {
                        horizontal: 'auto',
                        vertical: 'bottom'
                    },
                    disabledDates: [moment().add(-1, 'days')]
                });

                if (!angular.isUndefined(scope.maxdate)) {
                    elem.on("dp.change", function (e) {
                        ngModelCtrl.$setViewValue(e.date);
                        scope.$apply();
                    });
                }

                if (!angular.isUndefined(scope.mindate)) {
                    elem.on("dp.change", function (e) {
                        angular.element("#" + scope.mindate).data("DateTimePicker").minDate(e.date);
                        ngModelCtrl.$setViewValue(e.date);
                        var dateEnd = moment(e.date).add(1, 'hours').format("MM/DD/YYYY h:mm A");
                        angular.element("#" + scope.mindate + ' input').val(dateEnd);
                        scope.$apply();
                    });
                }
            }
        };
    }
})();
