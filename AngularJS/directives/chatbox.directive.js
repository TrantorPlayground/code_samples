(function () {
    'use strict';

    angular
        .module('fleetComm')
        .directive('chatBoxWindow', chatBoxWindow);

    /** @ngInject */
    function chatBoxWindow() {
        var directive = {
            restrict: 'E',
            templateUrl: 'app/fleet/chatbox/chatbox.html',
            scope: {
                boxid: '@',
                boxname: '@',
                firstname: '@',
                lastname: '@'
            },
            controller: ChatBoxController,
            controllerAs: 'chatbox',
            bindToController: true,
            link: function (scope, el) {
                el.click(function () {
                    //hide animation on click
                    scope.chatbox.unreadMsgs = 0;
                })
            }
        };
        return directive;

        /** @ngInject */
        function ChatBoxController(Chatbox, MessagingService, UserService, ngAudio, $timeout, toastr, $scope, AppSettings) {
            var outgoingSound = ngAudio.load("assets/sounds/outgoing.mp3");
            var vm = this;
            vm.name = this.boxname;
            vm.selectedDriverId = this.boxid;
            vm.firstName = this.firstname;
            vm.lastName = this.lastname;
            vm.user = UserService.getCurrentUser();
            vm.imgUrl = AppSettings.imgUrl;

            if (vm.selectedDriverId) {

                vm.driver = MessagingService.drivers[vm.selectedDriverId];
                if (vm.driver) {
                    vm.driver.unreadMessages = 0;
                    vm.loadOlder = function () {
                        if (!vm.isLoading && vm.driver.hasMore) {
                            vm.loading = true;
                            MessagingService.getMessages(vm.selectedDriverId, vm.driver.currentPage).success(function (result) {
                                if (result.data.length > 0) {
                                    var msgs = [];
                                    for (var i = 0; i < result.data.length; i++) {
                                        msgs.push(result.data[i]);
                                    }
                                    $timeout(function () {
                                        vm.driver.olderMessages.unshift.apply(vm.driver.olderMessages, msgs);
                                        vm.driver.currentPage++;
                                        vm.loading = false;
                                    }, 1000)
                                } else {
                                    vm.driver.hasMore = false;
                                }
                            }).error(function () {
                                vm.loading = false;
                            })
                        }
                    }
                    if (vm.driver.olderMessages.length == 0) {
                        vm.loadOlder();
                    }
                    $scope.$watchCollection(angular.bind(this, function () {
                        return this.driver.olderMessages;
                    }), function (newVal, oldval) {
                        vm.unreadMsgs = newVal.length - oldval.length;
                    });
                }
            }

            vm.close_popup = function (id) {
                Chatbox.close_popup(id)
            }

            vm.sendMessage = function () {
                if (!vm.messageToSend)
                    return;
                var message = {};

                message.messageData = {
                    text: vm.messageToSend
                }
                message.sender = {
                    id: vm.user.id
                }
                message.receiver = {
                    id: vm.boxid
                }

                MessagingService.sendMessage(message).success(function (response) {
                    if (response) {
                        vm.driver.olderMessages.push(response.data);
                        vm.messageToSend = '';
                        outgoingSound.play();
                    } else
                        toastr.error("An Error has occured, Please check your internet connection", 'Error');
                }).error(function () {
                    toastr.error("An Error has occured, Please check your internet connection", 'Error');
                })
            }
        }
    }

})();
