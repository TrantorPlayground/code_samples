(function () {
    'use strict';

    angular
        .module('fleetComm')
        .service('FleetService', FleetService);

    /** @ngInject */
    function FleetService($http, AppSettings, $q) {
        var that = this;
        that.messagesList = [];
        that.allItems = [];
        var eventsUrl = AppSettings.url + 'trip/event/latest';
        var messagesUrl = AppSettings.url + 'message/latest';
        var getDriversUrl = AppSettings.url + 'driver/filter/all/0/10';

        this.getDrivers = function () {
            var dfd = $q.defer()
            $http.get(getDriversUrl).then(function (response) {
                dfd.resolve(response.data.data)
            }).catch(function () {
                dfd.reject({'status': "error"});
            });
            return dfd.promise;
        }

        this.getEvents = function () {
            var dfd = $q.defer()
            $http.get(eventsUrl + '/0/4').then(function (response) {
                that.allItems = [];
                var items = response.data.data;
                for (var i = 0; i < items.length; i++) {
                    if (items[i].trip.driver) {
                        items[i].driverId = items[i].trip.driver.id;
                        that.allItems.push(items[i]);
                    }
                }
                dfd.resolve(that.allItems)
            }).catch(function (response) {
                dfd.reject({'status': "error"});
            });
            return dfd.promise
        }

        this.getMessages = function () {
            var dfd = $q.defer()
            $http.get(messagesUrl + '/0/4').then(function (response) {
                var items = response.data.data;
                that.messagesList = [];
                for (var i = 0; i < items.length; i++) {
                    var messageItem = {
                        driverId: (items[i]).sender.id,
                        firstName: items[i].sender.firstName,
                        lastName: items[i].sender.lastName,
                        message: items[i].messageData.text,
                        time: items[i].sentTime
                    }
                    if (items[i].sender.imageUrl)
                        messageItem.imageUrl = items[i].sender.imageUrl;
                    that.messagesList.push(messageItem);
                }
                dfd.resolve(that.messagesList)

            }).catch(function (response) {
                dfd.reject({'status': "error"});
            });
            return dfd.promise
        }

        this.searchDrivers = function (status, name) {
            if (name === undefined || name === "") {
                var searchDriverUrl = AppSettings.url + 'driver/filter/' + status.toLowerCase() + '/0/10';
            } else {
                var searchDriverUrl = AppSettings.url + 'driver/filter/' + status.toLowerCase() + '/0/10?driverName=' + name;
            }
            return $http.get(searchDriverUrl);
        }

        this.loadMoreDrivers = function (status, name, size) {
            if (name === undefined || name === "") {
                var loadDriverUrl = AppSettings.url + 'driver/filter/' + status.toLowerCase() + '/' + size + '/10';
            } else {
                var loadDriverUrl = AppSettings.url + 'driver/filter/' + status.toLowerCase() + '/' + size +
                                        '/10?driverName=' + name;
            }
            return $http.get(loadDriverUrl)
        }

        this.getRecentEvents = function (page) {
            return $http.get(eventsUrl + '/' + page + '/4')
        }

        this.getRecentMessages = function (page) {
            return $http.get(messagesUrl + '/' + page + '/4')
        }
    }
})();
