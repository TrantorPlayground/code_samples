<?php
/**
 * Zend Framework (http://framework.zend.com/)
 *
 * @link      http://github.com/zendframework/ZendSkeletonApplication for the canonical source repository
 * @copyright Copyright (c) 2005-2014 Zend Technologies USA Inc. (http://www.zend.com)
 * @license   http://framework.zend.com/license/new-bsd New BSD License
 */

namespace Application\Controller;

use Zend\Mvc\Controller\AbstractActionController;
use Zend\View\Model\ViewModel;
use Application\Service\AppServiceInterface;

class IndexController extends AbstractActionController
{
    protected $app = null;
    
    public function __construct(AppServiceInterface $appService)
    {
        $this->app = $appService;
    }
    /**
     * Action to get html for news listing after getting the data from app service!
     * @return ViewModel
     */
    public function indexAction()
    {
        $data = [
            'news' => $this->app->getNews()
        ];
        return new ViewModel($data);
    }
}
