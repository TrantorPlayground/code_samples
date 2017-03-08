(function() {
    'use strict';

    angular
        .module('fleetComm')
        .config(routerConfig);

    /** @ngInject */
    function routerConfig($stateProvider, $urlRouterProvider) {
        $stateProvider
            .state('login', {
                url: '/login',
                templateUrl: 'app/login/login.html',
                controller: 'LoginController',
                controllerAs: 'login',
                ncyBreadcrumb: {
                    label: 'Login'
                }
            })
            .state('home', {
                url: '/home',
                templateUrl: 'app/main/main.html',
                controller: 'MainController',
                controllerAs: 'main',
                ncyBreadcrumb: {
                    label: 'Dashboard'
                },
                resolve: {
                    runningTrips: function(TripService) {
                        return TripService.getRunningTrips();
                    },
                    drivers: function(MessagingService) {
                        return MessagingService.getDrivers();
                    }
                },
                data: {
                    requireLogin: true
                }
            })
            .state('createTrip', {
                url: '/trip',
                redirectTo: 'createTrip.tripTemplates',
                templateUrl: 'app/createTrip/createTrip.html',
                controller: 'CreateTripController',
                controllerAs: 'trip',
                ncyBreadcrumb: {
                    label: 'Create Trip'
                },
                data: {
                    requireLogin: false
                },
                params: { lastStop: null, stopToEdit: null, toThisTrip: false, stopIndex: null, driver: null, templateFlag: null }
            })
            .state('createTrip.tripTemplates', {
                url: '/tripTemplates',
                templateUrl: 'app/createTrip/tripTemplates/tripTemplates.html',
                controller: 'TripTemplatesController',
                controllerAs: 'template',
                ncyBreadcrumb: {
                    label: 'Trip Templates'
                },
                resolve: {
                    tripTemplates: function(CreateTripService) {
                        return CreateTripService.getTripTemplates();
                    }
                }
            })
            .state('createTrip.addStop', {
                url: '/addStop',
                templateUrl: 'app/createTrip/addStop/addStop.html',
                controller: 'AddStopController',
                controllerAs: 'stop',
                ncyBreadcrumb: {
                    label: 'Add Stop'
                },
                params: { lastStop: null, stopToEdit: null, toThisTrip: false, stopIndex: null, driver: null, templateFlag: null }
            })
            .state('createTrip.addAppointment', {
                url: '/addAppointment',
                templateUrl: 'app/createTrip/addAppointment/addAppointment.html',
                controller: 'AddAppointmentController',
                controllerAs: 'appt',
                ncyBreadcrumb: {
                    label: 'Add Appointment'
                },
                params: { timeToAdd: null, stopIndex: null, driver: null, templateFlag: null }
            })
            .state('createTrip.addService', {
                url: '/addService',
                templateUrl: 'app/createTrip/addService/addService.html',
                controller: 'AddServiceController',
                controllerAs: 'serv',
                ncyBreadcrumb: {
                    label: 'Add Service'
                },
                params: { driver: null, stopIndex: null, templateFlag: null }
            })
            .state('createTrip.addBilling', {
                url: '/addBilling',
                templateUrl: 'app/createTrip/addBilling/addBilling.html',
                controller: 'AddBillingController',
                controllerAs: 'bill',
                ncyBreadcrumb: {
                    label: 'Add Billing'
                },
                params: {
                    driver: null,
                    templateFlag: null
                }
            })
            .state('createTrip.review', {
                url: '/review',
                templateUrl: 'app/createTrip/review/review.html',
                controller: 'ReviewController',
                controllerAs: 'review',
                ncyBreadcrumb: {
                    label: 'Review Trip'
                },
                resolve: {
                    drivers: function(MessagingService) {
                        return MessagingService.getDrivers();
                    }
                },
                params: { driver: null, templateFlag: null }
            })
            .state('createTrip.edit', {
                url: '/:id',
                abstract: true,
                templateUrl: 'app/createTrip/edit/edit.html',
                controller: 'EditController',
                controllerAs: 'review',
                ncyBreadcrumb: {
                    label: 'Edit Trip'
                },
                resolve: {
                    tripStatus: function(CreateTripService, $stateParams) {
                        return CreateTripService.loadTrip($stateParams.id)
                    },
                    drivers: function(MessagingService) {
                        return MessagingService.getDrivers();
                    }
                }
            })
            .state('createTrip.edit.common', {
                url: '',
                views: {
                    'main': {
                        templateUrl: 'app/createTrip/edit/default/default.html',
                        controller: 'DefaultController',
                        controllerAs: 'review',
                    },
                    'header-button': {
                        template: '<a ui-sref="createTrip.addStop({toThisTrip:true,driver:review.driver, stopToEdit: null})" class="btn btn-success pull-right">Add Stop &nbsp;<span class="glyphicon glyphicon-plus"></span></a>'
                    }
                },

                ncyBreadcrumb: {
                    label: 'Edit Trip'
                }
            })
            .state('createTrip.edit.stop', {
                url: '/:stopId',
                views: {
                    'main': {
                        templateUrl: 'app/createTrip/edit/stopReview/stopReview.html',
                        controller: 'StopReviewController',
                        controllerAs: 'stop',
                    },
                    'header-button': {
                        templateUrl: 'app/createTrip/edit/stopReview/headerButton.html',
                        controller: 'StopReviewHeaderButtonController',
                        controllerAs: 'button',
                    }
                },
                ncyBreadcrumb: {
                    label: 'Stop Details'
                },
                resolve: {
                    stop: function(CreateTripService, $stateParams, tripStatus) {
                        return CreateTripService.getStopInTrip($stateParams.stopId)
                    }
                }
            })
            .state('admin', {
                url: '/admin',
                redirectTo: 'driver',
                templateUrl: 'app/admin/admin.html',
                controller: 'AdminController',
                controllerAs: 'admin',
                ncyBreadcrumb: {
                    label: 'Admin'
                },
                data: {
                    requireLogin: true
                },
                resolve: {

                }
            })
            .state('driver', {
                parent: 'admin',
                url: '/driver',
                templateUrl: 'app/admin/driver/driver.html',
                controller: 'AdminDriverController',
                controllerAs: 'driver',
                data: {
                    requireLogin: true
                },
                resolve: {
                    drivers: function(AdminDriverService) {
                        return AdminDriverService.getDrivers();
                    }
                },
                ncyBreadcrumb: {
                    label: 'Manage Drivers'
                }
            })
            .state('details', {
                parent: 'driver',
                redirectTo: 'viewProfile',
                url: '/:driverId',
                onEnter: function($uibModal, $state) {
                    var modalInstance = $uibModal.open({
                        animation: true,
                        templateUrl: 'app/popups/adminDriverDetails/adminDriverDetails.html',
                        controller: 'AdminDriverDetailsController',
                        controllerAs: 'details',
                        size: 'lg',
                        backdrop: 'static',
                        resolve: {
                            driverId: function($stateParams) {
                                return $stateParams.driverId;
                            }
                        }
                    });
                },
                data: {}
            })
            .state('viewProfile', {
                url: '/profile',
                parent: 'details',
                views: {
                    'detailsView@': {
                        templateUrl: 'app/popups/adminDriverDetails/viewProfile/viewProfile.html',
                        controller: 'ViewProfileController',
                        controllerAs: 'view',
                        resolve: {
                            driverData: function($stateParams, drivers) {
                                for (var i = 0; i < drivers.data.data.length; i++) {
                                    if (drivers.data.data[i].driver.id == $stateParams.driverId) {
                                        return drivers.data.data[i];
                                    }
                                }
                            },
                            profile: function(ViewProfileService, $stateParams) {
                                return ViewProfileService.getProfile($stateParams.driverId);
                            }

                        }
                    }
                }
            })
            .state('viewTrips', {
                url: '/trips',
                parent: 'details',
                views: {
                    'detailsView@': {
                        templateUrl: 'app/popups/adminDriverDetails/viewTrips/viewTrips.html',
                        controller: 'ViewTripController',
                        controllerAs: 'viewTrip',
                        resolve: {
                            driverRunningTrips: function(ViewTripService, $stateParams) {
                                return ViewTripService.getRunningTrips($stateParams.driverId);
                            },
                            driverInfo: function(ViewTripService, $stateParams) {
                                return ViewTripService.getDriverInfo($stateParams.driverId);
                            }
                        }
                    }
                }
            })
            .state('admin.customer', {
                url: '/customer',
                templateUrl: 'app/admin/customer/customer.html',
                controller: 'AdminCustomerController',
                controllerAs: 'customer',
                data: {
                    requireLogin: true
                },
                ncyBreadcrumb: {
                    label: 'Manage Customers'
                }
            })
            .state('admin.tripTemplates', {
                url: '/tripTemplates',
                templateUrl: 'app/admin/tripTemplates/tripTemplates.html',
                controller: 'TripTemplatesController',
                controllerAs: 'template',
                ncyBreadcrumb: {
                    label: 'Trip Templates'
                },
                resolve: {
                    tripTemplates: function(CreateTripService) {
                        return CreateTripService.getTripTemplates();
                    }
                }
            })
            .state('fleet', {
                url: '/fleet',
                templateUrl: 'app/fleet/fleet.html',
                controller: 'FleetController',
                controllerAs: 'fleet',
                ncyBreadcrumb: {
                    label: 'Fleet View'
                },
                data: {
                    requireLogin: true
                },
                resolve: {
                    messagingDrivers: function(MessagingService) {
                        return MessagingService.getDrivers();
                    },
                    getAllDrivers: function(FleetService) {
                        return FleetService.getDrivers();
                    },
                    getRecentEvents: function(FleetService) {
                        return FleetService.getEvents();
                    },
                    getRecentMessages: function(FleetService) {
                        return FleetService.getMessages();
                    }
                }
            })
            .state('messaging', {
                url: '/messaging',
                templateUrl: 'app/messaging/messaging.html',
                controller: 'MessagingController',
                controllerAs: 'msg',
                ncyBreadcrumb: {
                    label: 'Messaging'
                },
                data: {
                    requireLogin: true
                },
                resolve: {
                    drivers: function(MessagingService) {
                        return MessagingService.getDrivers();
                    }
                }
            })
            .state('messaging.private', {
                url: '/:id',
                templateUrl: 'app/messaging/private/privateChat.html',
                controller: 'PrivateChatController',
                controllerAs: 'chat',
                ncyBreadcrumb: {
                    label: 'Private Chat'
                },
                resolve: {
                    unreadMessages: function(MessagingService, $stateParams) {
                        return MessagingService.markMessagesRead($stateParams.id);
                    }
                }
            })
            .state('allTrips', {
                url: '/allTrips',
                redirectTo: 'allTrips.newTrips',
                templateUrl: 'app/allTrips/allTrips.html',
                controller: 'AllTripsController',
                controllerAs: 'all',
                ncyBreadcrumb: {
                    label: 'All Trips'
                },
                data: {
                    requireLogin: true
                },
                resolve: {
                    drivers: function(MessagingService) {
                        return MessagingService.getDrivers();
                    }
                }
            })
            .state('allTrips.newTrips', {
                url: '/newTrips',
                templateUrl: 'app/allTrips/newTrips/newTrips.html',
                controller: 'NewTripsController',
                controllerAs: 'all',
                ncyBreadcrumb: {
                    label: 'New Trips'
                },
                resolve: {
                    newTrips: function(TripService) {
                        return TripService.getNewTrips();
                    }
                },
                data: {
                    requireLogin: true
                }
            })
            .state('allTrips.runningTrips', {
                url: '/runningTrips',
                templateUrl: 'app/allTrips/runningTrips/runningTrips.html',
                ncyBreadcrumb: {
                    label: 'Running Trips'
                },
                controller: 'RunningTripsController',
                controllerAs: 'running',
                resolve: {
                    runningTrips: function(TripService) {
                        return TripService.getRunningTrips();
                    }
                }
            })
            .state('allTrips.awaitingResponses', {
                url: '/awaitingResponses',
                templateUrl: 'app/allTrips/awaitingResponse/awaitingResponses.html',
                ncyBreadcrumb: {
                    label: 'Awaiting Response'
                },
                controller: 'AwaitingResponseController',
                controllerAs: 'awaiting',
                resolve: {
                    awaitingResponses: function(TripService) {
                        return TripService.getAwaitingResponses();
                    }
                }
            })
            .state('allTrips.completedTrips', {
                url: '/completedTrips',
                templateUrl: 'app/allTrips/completedTrips/completedTrips.html',
                ncyBreadcrumb: {
                    label: 'Completed Trips'
                },
                controller: 'CompletedTripsController',
                controllerAs: 'completed',
                resolve: {
                    completedTrips: function(TripService) {
                        return TripService.getCompletedTrips();
                    }
                }
            })
            .state('allTrips.acceptedTrips', {
                url: '/acceptedTrips',
                templateUrl: 'app/allTrips/acceptedTrips/acceptedTrips.html',
                ncyBreadcrumb: {
                    label: 'Accepted Trips'
                },
                controller: 'AcceptedTripsController',
                controllerAs: 'accepted',
                resolve: {
                    acceptedTrips: function(TripService) {
                        return TripService.getAcceptedTrips();
                    }
                }
            })
            .state('allTrips.rejectedTrips', {
                url: '/rejectedTrips',
                templateUrl: 'app/allTrips/rejectedTrips/rejectedTrips.html',
                ncyBreadcrumb: {
                    label: 'Rejected Trips'
                },
                controller: 'RejectedTripsController',
                controllerAs: 'rejected',
                resolve: {
                    rejectedTrips: function(TripService) {
                        return TripService.getRejectedTrips();
                    }
                }
            });
        $urlRouterProvider.otherwise('/login');
    }

})();
