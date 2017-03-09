<?php
namespace Application\Controller;

use Zend\Mvc\Controller\AbstractActionController;
use Zend\View\Model\ViewModel;
use Application\Service\AppServiceInterface;
use Application\Form\NewsForm;
use Application\Form\NewsFormFilter;
use DOMPDFModule\View\Model\PdfModel;

class NewsController extends AbstractActionController
{

    protected $app = null;

    protected $orm = null;

    public function __construct(AppServiceInterface $appService, $orm)
    {
        $this->app = $appService;
        $this->orm = $orm;
    }

    /**
     * Override, check for login etc
     *
     * @param \Zend\Mvc\MvcEvent $e
     */
    public function onDispatch(\Zend\Mvc\MvcEvent $e)
    {
        if (! $this->zfcUserAuthentication()->hasIdentity()) {
            return $this->redirect()->toRoute('zfcuser/login');
        }
    
        return parent::onDispatch($e);
    }
    
    /**
     * Get news entered by particular user!
     * 
     * @return ViewModel
     */
    public function indexAction()
    {
        $data = [];
        if ($this->zfcUserAuthentication()->hasIdentity()) {
            $data = [
                'news' => $this->app->getNews($this->zfcUserAuthentication()
                    ->getIdentity()
                    ->getId())
            ];
        }
        return new ViewModel($data);
    }

    /**
     * Create news!
     * 
     * @return ViewModel
     */
    public function createAction()
    {
        $result = [];
        $request = $this->getRequest();
        $form = new NewsForm();
        
        $inputFilter = new NewsFormFilter();
        $form->setInputFilter($inputFilter);
        
        if (! $request->isPost()) {
            return new ViewModel([
                'form' => $form
            ]);
        }
        
        $form->setData($request->getPost());
        
        if ($form->isValid()) {
            $validatedData = $form->getData();
            $files = $request->getFiles()->toArray();
            if (! $files['photo']['error']) {
                $fileName = $this->app->uploadFiles(array(
                    'path' => 'public/uploads/news/',
                    'files' => $files['photo'],
                    'size' => array(
                        'min' => 10
                    ),
                    'ext' => array(
                        'extension' => array(
                            'jpg',
                            'png',
                            'jpeg',
                            'gif'
                        )
                    ),
                    'thumbnails' => true,
                    'thumbSizes' => array(
                        120 => 120
                    )
                ));
                if (! $fileName['success']) {
                    $result = array(
                        'error' => true,
                        'exception_message' => $fileName['error_messages']
                    );
                } else {
                    // save news here
                    $validatedData['photo'] = $fileName['filename'];
                    $validatedData['users_id'] = $this->zfcUserAuthentication()
                        ->getIdentity()
                        ->getId();
                    $this->app->saveNews($validatedData);
                    return $this->redirect()->toRoute('news');
                }
            }
        } else {
            $result = array(
                'error' => true,
                'exception_message' => $form->getMessages()
            );
        }
        $view = new ViewModel(array_merge(array(
            'form' => $form
        ), $result));
        $view->setTemplate('application/news/create');
        return $view;
    }

    /**
     * Delete news, check if user is authorized to delete news, if yes then 
     * redirect to news listing page otherwise throw error message!
     * 
     * @return type
     */
    public function deleteNewsAction()
    {
        try {
            $request = $this->params();
            $news_id = $request->fromRoute('id');
            $userId = $this->zfcUserAuthentication()
                ->getIdentity()
                ->getId();
            $news = $this->orm->getRepository('Application\Entity\News')->find($news_id);
            if ($news->getUsers()->getId() == $userId) {
                $this->orm->remove($news);
                $this->orm->flush();
                $this->flashMessenger()->addSuccessMessage('News deleted successfully!');
            } else {
                $this->flashMessenger()->addWarningMessage('You are not authorized to delete this news!');
            }
        } catch (\Exception $e) {
            $this->flashMessenger()->addErrorMessage($e->getMessage());
        }
        return $this->redirect()->toRoute('news');
    }

    /**
     * ZF action to view individual news!
     * 
     * @return ViewModel
     */
    public function viewNewsAction()
    {
        try {
            $request = $this->params();
            $news_id = $request->fromRoute('id');
            $news = $this->orm->getRepository('Application\Entity\News')->find($news_id);
            return new ViewModel([
                'news' => $news
            ]);
        } catch (\Exception $e) {
            $this->flashMessenger()->addErrorMessage($e->getMessage());
        }
    }

    /**
     * Action to generate PDF for news!
     * 
     * @return PdfModel
     */
    public function generatePdfAction()
    {
        $request = $this->params();
        $news_id = $request->fromRoute('id');
        $news = $this->orm->getRepository('Application\Entity\News')->find($news_id);
        $pdf = new PdfModel();
        $pdf->setVariables([
            'news' => $news
        ]);
        
        $pdf->setTemplate('application/news/view-news');
        $pdf->setOption("filename", str_replace(' ', '_', $news->getTitle()));
        return $pdf;
    }

    /**
     * ZF2 action to render RSS feed!
     * 
     */
    public function rssFeedsAction()
    {
        $feed = new \Zend\Feed\Writer\Feed;
        $feed->setTitle('My Newsstand');
        $feed->setLink('http://my.news.app');
        $feed->setFeedLink('http://my.news.app', 'atom');
        $feed->addAuthor(array(
            'name'  => 'Test',
            'email' => 'test@gmail.com',
            'uri'   => BASE_URL,
        ));
        $feed->setDateModified(time());
        $feed->addHub(BASE_URL);
        
        $entry = $feed->createEntry();
        $entry->setTitle('Top 10 Latest News');
        $entry->setLink(BASE_URL);
        $entry->addAuthor(array(
            'name'  => 'Test',
            'email' => 'test@gmail.com',
            'uri'   => BASE_URL,
        ));
        $entry->setDateModified(time());
        $entry->setDateCreated(time());
        $entry->setDescription('This RSS feed includes latest 10 news articles');
        $entry->setContent(
            'I am not writing the article. The example is long enough as is ;).'
        );
        $feed->addEntry($entry);
        
        $out = $feed->export('atom');
                
        echo $out;
    }
}