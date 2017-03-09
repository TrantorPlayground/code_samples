<?php
namespace Application\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Application\Controller\IndexController;
class IndexControllerFactory implements FactoryInterface
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
        return new IndexController($appService);
    }
}