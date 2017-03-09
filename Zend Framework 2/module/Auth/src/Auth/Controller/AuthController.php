<?php
namespace Auth\Controller;

use Zend\Mvc\Controller\AbstractActionController;
use Zend\View\Model\ViewModel;
use Application\Entity\Users;
use Application\Service\AppServiceInterface;

class AuthController extends AbstractActionController
{

    protected $app = null;
    
    protected $orm = null;
    
    public function __construct(AppServiceInterface $appService, $orm)
    {
        $this->app = $appService;
        $this->orm = $orm;
    }
    
    /**
     * Zf2 custom action to show email template page, not applicable for live environment!
     * @return ViewModel
     */
    public function indexAction()
    {
        //We can also send email when on live using following custom function
        //$this->app->sendEmail($htmlMarkup, $to, $recieverName, $subject, $from = NULL, $senderName = NULL);
        $this->flashMessenger()->addErrorMessage('Email verification is pending.');
        $request = $this->params();
        $user_id = $request->fromRoute('id');
        $users = new Users();
        $user = $this->orm->find($users, $user_id);
        return new ViewModel([
            'name' => $user->getFirstname() .' '.$user->getLastname(),
            'token' => $user->getToken()
        ]);
    }
    
    /**
     * ZF2 action to verify email via token!
     * 
     * @return type
     */
    public function verifyEmailAction(){
        $request = $this->params();
        $token = $request->fromRoute('token');
        if($token){
            $user = $this->orm->getRepository('Application\Entity\Users')->findOneBy(['token' => $token]);
            $user->setStatus(1);
            $user->setToken(NUll);
            $this->orm->persist($user);
            $this->orm->flush();
            
            $this->flashMessenger()->addSuccessMessage('Email verification successful, you can login now!');
        }
        return $this->redirect()->toRoute('zfcuser/login');
    }
}