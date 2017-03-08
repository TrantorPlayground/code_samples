(function () {
    'use strict';

    angular
        .module('fleetComm')
        .controller('FleetController', FleetController);

    /** @ngInject */
    function FleetController($scope, SocketService, FleetService, $timeout, Color, Chatbox, $compile, $uibModal,
                             uiGmapGoogleMapApi, getAllDrivers, AppSettings, getRecentEvents, getRecentMessages) {
        var vm = this;
        vm.shortStatus = {};
        vm.page = 0;
        vm.empty = false;
        var allItems = [];
        vm.driverList = {};
        vm.size = 0;
        vm.location = [];
        vm.emptyEvents = false;
        vm.emptyMsgs = false;
        vm.driverList = getAllDrivers;
        vm.fleetEvents = getRecentEvents;

        //show default Map location
        uiGmapGoogleMapApi.then(function (maps) {
            vm.geocoder = new maps.Geocoder();
            vm.maploaded = true;
            vm.map = {center: {latitude: 39.7683333, longitude: -86.1580556}, zoom: 10, control: {}};
            vm.show1 = true;
            vm.windowOptions = {
                disableAutoPan: true,
                maxWidth: 200,
                zIndex: null,
                closeBoxMargin: "5px",
                closeBoxURL: "http://www.google.com/intl/en_us/mapfiles/close.gif",
                isHidden: false,
                pane: "floatPane",
                enableEventPropagation: false
            };
            for (var i = 0; i < vm.fleetEvents.length; i++) {
                var latlng = {
                    lat: parseFloat(vm.fleetEvents[i].location.latitude),
                    lng: parseFloat(vm.fleetEvents[i].location.longitude)
                };
                vm.fleetEvents[i].location.address = vm.getAddressFromLatLng(latlng, i);
            }
            $timeout(function () {
                vm.iconLoad(vm.driverList);
                var myBounds = new google.maps.LatLngBounds();
                for (var i = 0; i < vm.driverList.length; i++) {
                    try {
                        myBounds.extend(
                            new google.maps.LatLng(vm.driverList[i].location.latitude, vm.driverList[i].location.longitude)
                        );
                    } catch (e) {
                    }
                }
                google.maps.event.trigger(vm.map.control.getGMap(), "resize");
                vm.map.control.getGMap().fitBounds(myBounds);
            }, 1000)
        });

        //For reverse Geo-loaction
        vm.getAddressFromLatLng = function (latlng, index) {
            vm.geocoder.geocode({'location': latlng}, function (results, status) {
                if (status === google.maps.GeocoderStatus.OK) {
                    vm.fleetEvents[index].location.address = results[0].formatted_address;
                    $scope.$apply();
                }
            });
        }

        if (vm.fleetEvents.length === 0) {
            vm.emptyEvents = true;
        }

        vm.messages = getRecentMessages;
        if (vm.messages.length === 0) {
            vm.emptyMsgs = true;
        }

        for (var i = 0; i < vm.driverList.length; i++) {
            vm.driverList[i].driver.imgPrefix = AppSettings.imgUrl;
        }

        /*Calculate distance ETA*/
        vm.calculateDistance = function (driverData) {
            //calculate Durations and Distance
            angular.forEach(driverData, function (driver) {
                if (driver.nextStopLocation) {
                    $timeout(function () {
                        var distanceService = new google.maps.DistanceMatrixService();
                        var origins = [];
                        var dests = [];
                        var firstStopLat = driver.location.latitude;
                        var firstStopLng = driver.location.longitude;

                        origins.push(firstStopLat + ',' + firstStopLng);
                        dests.push(driver.nextStopLocation.latitude + ',' + driver.nextStopLocation.longitude);

                        distanceService.getDistanceMatrix({
                            origins: origins,
                            destinations: dests,
                            travelMode: google.maps.TravelMode.DRIVING,
                            unitSystem: google.maps.UnitSystem.IMPERIAL,
                            avoidHighways: false,
                            avoidTolls: false
                        }, function (response, status) {
                            if (status == google.maps.DistanceMatrixStatus.OK) {
                                var totalTime = 0,
                                    totalDistance = 0;
                                totalTime = response.rows[0].elements[0].duration.text;
                                totalDistance = response.rows[0].elements[0].distance.text;
                                driver.duration = totalTime;
                                driver.distance = totalDistance;
                            }
                        });
                    }, 1000)
                }
            })
        }

        /*Call method for first time to calculate distance for first page*/
        vm.calculateDistance(vm.driverList);

        //Load history events from API
        vm.loadMoreEvents = function () {
            vm.size = vm.size + 1;
            FleetService.getRecentEvents(vm.size).success(function (response) {
                var items = response.data;
                allItems = [];
                for (var i = 0; i < items.length; i++) {
                    if (items[i].trip.driver) {
                        items[i].driverId = items[i].trip.driver.id;
                        var latlng = {
                            lat: parseFloat(items[i].location.latitude),
                            lng: parseFloat(items[i].location.longitude)
                        };
                        items[i].location.address = vm.getAddressFromLatLng(latlng, i)
                        allItems.push(items[i]);
                    }
                }
                vm.fleetEvents.push.apply(vm.fleetEvents, allItems);

                if (items.length === 0) {
                    vm.emptyEvents = true;
                }

            }).error(function () {

            });
        }

        //Load an event from API
        vm.viewEvent = function (event) {
            var modalInstance = $uibModal.open({
                animation: true,
                templateUrl: 'app/popups/docViewer/docViewer.html',
                controller: 'DocViewerController',
                controllerAs: 'dv',
                size: 'lg',
                resolve: {
                    documents: function (DocViewerService) {
                        return DocViewerService.getAllDocuments(event);
                    }
                }
            });
        }

        //Clear an event
        vm.clearEvent = function (tripId) {
            vm.fleetEvents = _.reject(vm.fleetEvents, function (event) {
                return event.trip.id == tripId;
            });
        }

        //Load next page of events
        vm.loadMoreMessages = function () {
            vm.size = vm.size + 1;
            FleetService.getRecentMessages(vm.size).success(function (response) {
                var messagesList = [];
                var items = response.data;
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
                    messagesList.push(messageItem);
                }
                //vm.messages.messages = messagesList
                vm.messages.push.apply(vm.messages, messagesList);
                if (items.length === 0) {
                    vm.emptyMsgs = true;
                }

            }).error(function () {

            });
        }

        //Clear a message
        vm.clearMessage = function (message) {
            vm.messages = _.reject(vm.messages, function (msg) {
                return msg.driverId == message.driverId;
            });
        }

        //Select a driver
        vm.selectDriver = function (driverData) {
            driverData.options = {animation: 1}; //or 1
            $timeout(function () {
                driverData.options = {animation: 0}; //or 1
            }, 1000)
        }

        //Show driver icon depending upon his/her initials
        vm.iconLoad = function (driverList) {
            angular.forEach(driverList, function (driverData) {
                var css;
                if (driverData.driver.status === 'available') {
                    css = Color.rgbToCSS(93, 183, 93, 50);
                } else if (driverData.driver.status === 'not-available') {
                    css = Color.rgbToCSS(217, 84, 79, 50);
                } else if (driverData.driver.status === 'on-trip') {
                    css = Color.rgbToCSS(0, 129, 187, 50);
                } else if (driverData.driver.status === 'inactive') {
                    css = Color.rgbToCSS(154, 154, 154, 50);
                }
                driverData.driver.icon = {
                    path: 'M 0,0 C -2,-20 -10,-22 -10,-30 A 10,10 0 1,1 10,-30 C 10,-22 2,-20 0,0 z M -2,-30 a 2,2 0 1,1 4,0 2,2 0 1,1 -4,0',
                    strokeColor: 'white',
                    fillColor: css,
                    fillOpacity: 1,
                    scale: 1,
                    strokeWeight: 2
                };

            })
        }

        //Show chat box
        vm.showChatBox = function (msg) {
            Chatbox.register_popup(msg.driverId);
            var chatbox = angular.element("<chat-box-window  boxid='" + msg.driverId + "' boxname='" + msg.firstName +
                "' firstname='" + msg.firstName + "' lastname='" + msg.lastName + "' ></chat-box-window>");
            $compile(chatbox)($scope, function (cloned, scope) {
                angular.element(document.body).append(cloned);
                $timeout(function () {
                    Chatbox.popups.unshift(msg.driverId);
                    Chatbox.calculate_popups();
                }, 200);
            });

        }

        //Search for drivers
        vm.searchDrivers = function () {
            vm.page = 0;
            vm.empty = false;
            if (vm.shortStatus == null || vm.shortStatus.status === undefined) {
                vm.shortStatus = {};
                vm.shortStatus.status = "all";
            }
            FleetService.searchDrivers(vm.shortStatus.status, vm.searchDriverName).success(function (response) {
                vm.driverList = response.data;
                for (var i = 0; i < vm.driverList.length; i++) {
                    vm.driverList[i].driver.imgPrefix = AppSettings.imgUrl;
                }
                vm.iconLoad(vm.driverList);
                vm.calculateDistance(vm.driverList);
            }).error(function () {

            });
        }

        //load more drivers
        vm.loadMoreDrivers = function () {
            if (vm.shortStatus == null || vm.shortStatus.status === undefined) {
                vm.shortStatus = {};
                vm.shortStatus.status = "all";
            }
            vm.page = vm.page + 1;
            FleetService.loadMoreDrivers(vm.shortStatus.status, vm.searchDriverName, vm.page).success(function (response) {
                vm.driverList.push.apply(vm.driverList, response.data);
                vm.iconLoad(vm.driverList);
                for (var i = 0; i < vm.driverList.length; i++) {
                    vm.driverList[i].driver.imgPrefix = AppSettings.imgUrl;
                }
                if (response.data.length === 0) {
                    vm.empty = true;

                } else if (response.data.length > 0) {
                    var newListofDriver = {};
                    newListofDriver = response.data;
                    vm.calculateDistance(newListofDriver);
                }

            }).error(function () {

            });
        }

        //Load socket stream for realtime events
        vm.driverDataStream = SocketService.getDriversStream();
        vm.driverDataStream.onMessage(function (message) {
            var message = JSON.parse(message.data);
            if (message.currentLocation) {
                var driverId = message.driver.id;
                angular.forEach(vm.driverList, function (driverData) {
                    if (driverData.driver.id == driverId) {
                        driverData.location = driverData.location || {};
                        driverData.location.latitude = message.currentLocation.latitude;
                        driverData.location.longitude = message.currentLocation.longitude;
                        driverData.location.address = message.currentLocation.address;
                        driverData.moving = true;
                        $timeout(function () {
                            driverData.moving = false;
                        }, 5000)
                    }
                })
            }
        });

        //All driver status
        $scope.userStatus = [
            {name: 'Unavailable', status: 'not-available'},
            {name: 'Available', status: 'available'},
            {name: 'In Transit', status: 'on-trip'},
            {name: 'Inactive', status: 'inactive'}
        ];
    }
})();
