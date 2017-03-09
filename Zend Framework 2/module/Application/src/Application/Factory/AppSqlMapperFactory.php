<?php
namespace Application\Factory;

use Application\Mapper\AppSqlMapper;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class AppSqlMapperFactory implements FactoryInterface
{

    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator            
     *
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $orm = $serviceLocator->get('Doctrine\ORM\EntityManager');
        return new AppSqlMapper($orm);
    }
}