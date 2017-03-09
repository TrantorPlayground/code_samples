<?php
/**
 * Zend Framework (http://framework.zend.com/)
 *
 * @link      http://github.com/zendframework/ZendSkeletonApplication for the canonical source repository
 * @copyright Copyright (c) 2005-2014 Zend Technologies USA Inc. (http://www.zend.com)
 * @license   http://framework.zend.com/license/new-bsd New BSD License
 */
//https://github.com/Eye4web/Eye4webZfcUserBan/blob/master/src/Eye4web/ZfcUser/Ban/Module.php
//http://en.leandrosilva.info/tutorial-zf2-doctrine-zfcuser-los/

return array(
    'router' => array(
        'routes' => array(
            'verify_user' => array(
                'type'    => 'Literal',
                'options' => array(
                    'route'    => '/user/email/template',
                    'defaults' => array(
                        '__NAMESPACE__' => 'Auth\Controller',
                        'controller'    => 'Auth',
                        'action'        => 'index',
                    ),
                ),
                'may_terminate' => true,
                'child_routes' => array(
                    'default' => array(
                        'type'    => 'Segment',
                        'options' => array(
                            'route'    => '/[:id]',
                            'constraints' => array(
                                'controller' => '[a-zA-Z][a-zA-Z0-9_-]*',
                                'id'     => '[a-zA-Z0-9_-]*'
                            ),
                            'defaults' => array(
                            ),
                        ),
                    ),
                ),
            ),
            'confirm_email' => array(
                'type'    => 'Literal',
                'options' => array(
                    'route'    => '/user/verify/email',
                    'defaults' => array(
                        '__NAMESPACE__' => 'Auth\Controller',
                        'controller'    => 'Auth',
                        'action'        => 'verify-email',
                    ),
                ),
                'may_terminate' => true,
                'child_routes' => array(
                    'default' => array(
                        'type'    => 'Segment',
                        'options' => array(
                            'route'    => '/[:token]',
                            'constraints' => array(
                                'controller' => '[a-zA-Z][a-zA-Z0-9_-]*'
                            ),
                            'defaults' => array(
                            ),
                        ),
                    ),
                ),
            ),
        ),
    ),
    'controllers' => array(
        'invokables' => array(
            
        ),
        'factories' => [
            'Auth\Controller\Auth' => 'Auth\Factory\AuthControllerFactory'
        ]
    ),
    'view_manager' => array(
        'template_path_stack' => array(
            'zfc-user' => __DIR__ . '/../view',
        ),
    ),
    'service_manager' => [
        'aliases' => [
            'Zend\Authentication\AuthenticationService' => 'zfcuser_auth_service'
        ]
    ],
);
