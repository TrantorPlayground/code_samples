<?php
namespace Auth;

use Zend\ModuleManager\ModuleManager;
use Application\Entity\Users;
use Zend\Mvc\MvcEvent;
use Zend\Http\Response as HttpResponse;
class Module
{
    public function getConfig()
    {
        return include __DIR__ . '/config/module.config.php';
    }

    public function init(ModuleManager $moduleManager)
    {
        $sharedEvents = $moduleManager->getEventManager()->getSharedManager();
        $sharedEvents->attach('ZfcUser', 'dispatch', function($e) {
            // This event will only be fired when an ActionController under the ZfcUser namespace is dispatched.
            $controller = $e->getTarget();
            $controller->layout('layout/layout');
        }, 100);
    }
    /**
     * ZF2 events, user login and register events!
     * @param MvcEvent $e
     */
    public function onBootstrap(MvcEvent $e)
    {
        $events = $e->getApplication()->getEventManager()->getSharedManager();
        $fm = $e->getApplication()->getServiceManager()->get('ControllerPluginManager')->get('FlashMessenger');
        $orm    = $e->getApplication()->getServiceManager()->get('Doctrine\ORM\EntityManager');
        $mvcEvent = $e;
        $events->attach('ZfcUser\Form\Login','init', function($e) {
            $form = $e->getTarget();
            $form->setAttribute('class', 'default-form');
            $form->get('identity')->setAttribute('class', 'form-control')->setAttribute('placeholder', 'Email');
            $form->get('credential')->setAttribute('class', 'form-control')->setAttribute('placeholder', 'Password');
            $form->get('submit')->setAttribute('class', 'btn btn-primary full-width')->setLabel('Login');
        });
        
        $events->attach('ZfcUser\Form\Register','init', function($e) {
            $form = $e->getTarget();
            $form->setAttribute('class', 'default-form');
            $form->add(array(
                'name' => 'firstname',
                'attributes' => array(
                    'type'  => 'text',
                    'placeholder' => 'Firstname',
                    'class' => 'form-control'
                ),
            ),['priority' => 5]);
            $form->add(array(
                'name' => 'lastname',
                'attributes' => array(
                    'type'  => 'text',
                    'placeholder' => 'Lastname',
                    'class' => 'form-control'
                ),
            ),['priority' => 4]);
            $form->get('email')->setAttribute('class', 'form-control')->setAttribute('placeholder', 'Email');
            $form->get('password')->setAttribute('class', 'form-control')->setAttribute('placeholder', 'Password');
            $form->get('passwordVerify')->setAttribute('class', 'form-control')->setAttribute('placeholder', 'Confirm Password');
            $form->get('submit')->setAttribute('class', 'btn btn-primary full-width')->setLabel('Register');
        });

        $events->attach('ZfcUser\Form\RegisterFilter','init', function($e) {
            $filter = $e->getTarget();
            $filter->add(array(
                'name'       => 'firstname',
                'required'   => true
            ));
            $filter->add(array(
                'name'       => 'lastname',
                'required'   => true
            ));
        });
            
        //on register event
        $events->attach('ZfcUser\Service\User', 'register', function($e) use($fm) {
            $user = $e->getParam('user');  // User account object
            $form = $e->getParam('form');  // Form object
            // Perform your custom action here
            $user->setCreatedAt(new \DateTime(date('Y-m-d h:i:s')));
            $user->setModifiedAt(new \DateTime(date('Y-m-d h:i:s')));
            $randomToken = md5(uniqid(mt_rand() * 1000000, true));
            $user->setToken(urlencode($randomToken));
            $fm->addSuccessMessage('Registration successful, please try to login now, you will be redirected to email template page');
        });

        //on login event
        $events->attach('ZfcUser\Authentication\Adapter\AdapterChain', 'authenticate', function($e) use($fm,$orm,$mvcEvent) {
            $userId = $e->getParam('identity');
            if($userId){
                $users = new Users();
                $user = $orm->find($users, $userId);
                //$user = $orm->getRepository(Users::class)->findOneBy(array('email' => 'manu.sharma1222@gmail.com'));
                if(!$user->getStatus()){
                    $fm->addErrorMessage('Email verification is pending.');
                    //$uri = $mvcEvent->getRouter()->assemble([], ['name' => 'zfcuser/login']);
                    $response = $mvcEvent->getResponse() ? $mvcEvent->getResponse() : new HttpResponse();
                    $response->getHeaders()->addHeaderLine('Location', '/user/email/template/'.$userId);
                    $response->setStatusCode(302);
                    $mvcEvent->setResponse($response);
                    $mvcEvent->setResult($response);
                    return $response;
                }
            }
        });
    }
    public function getAutoloaderConfig()
    {
        return array(
            'Zend\Loader\StandardAutoloader' => array(
                'namespaces' => array(
                    __NAMESPACE__ => __DIR__ . '/src/' . __NAMESPACE__,
                ),
            ),
        );
    }
}
