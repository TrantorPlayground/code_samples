<?php
namespace Auth\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Auth\Controller\AuthController;
class AuthControllerFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator){
        $realservicelocator = $serviceLocator->getServiceLocator();
        $appService = $realservicelocator->get('Application\Service\AppServiceInterface');
        $orm = $realservicelocator->get('Doctrine\ORM\EntityManager');
        return new AuthController($appService,$orm);
    }
}