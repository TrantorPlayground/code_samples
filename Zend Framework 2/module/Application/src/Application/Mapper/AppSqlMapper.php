<?php
namespace Application\Mapper;

use Zend\Filter\Word\UnderscoreToCamelCase;
use Zend\Filter\Word\CamelCaseToUnderscore;
use Zend\Validator\File\Size;
use Zend\Validator\File\Extension;
use Zend\Filter\File\Rename;
use Zend\File\Transfer\Adapter\Http;
use Imagine\Gd\Imagine;
use Imagine\Image\Box;
use Application\Entity\News;
use Zend\Mail;
use Zend\Mime\Message as MimeMessage;
use Zend\Mime\Part as MimePart;
use Zend\Mail\Transport\Smtp;
use Zend\Mail\Transport\SmtpOptions;

class AppSqlMapper implements AppSqlMapperInterface
{

    protected $orm;

    /**
     *
     * @param
     *            doctrine entity manager $orm
     */
    public function __construct($orm)
    {
        $this->orm = $orm;
        $this->httpadapter = new Http();
    }

    /**
     * Mapper function to save news using Doctrine 2!
     * 
     * @see \Application\Mapper\AppSqlMapperInterface::saveNews()
     */
    public function saveNews($data)
    {
        $news = new News();
        $news->setTitle($data['title']);
        $users = $this->orm->getRepository('Application\Entity\Users')->find($data['users_id']);
        $news->setUsers($users);
        $news->setNewsText($data['news_text']);
        $news->setPhoto($data['photo']);
        $news->setCreatedAt(new \DateTime(date('Y-m-d')));
        $news->setModifiedAt(new \DateTime(date('Y-m-d')));
        $news->setReporterEmail($users->getEmail());
        $this->orm->persist($news);
        $this->orm->flush();
        return $news;
    }

    /**
     * Method to get news by id using Doctrine 2!
     * 
     * @see \Application\Mapper\AppSqlMapperInterface::getNews()
     */
    public function getNews($id = NULL)
    {
        if ($id) {
            return $this->orm->getRepository('Application\Entity\News')->findBy([
                'users' => $id
            ], [
                'id' => 'DESC'
            ]);
        }
        return $this->orm->getRepository('Application\Entity\News')->findBy([], [
            'id' => 'DESC'
        ],10,0);
    }

    /**
     * Method to decamelize string!
     * 
     * @see \Application\Mapper\AppSqlMapperInterface::decamelize()
     */
    public function decamelize($word)
    {
        $filter = new CamelCaseToUnderscore();
        
        return $filter->filter($word);
    }

    /**
     * Method to camelize string!
     * 
     * @see \Application\Mapper\AppSqlMapperInterface::camelize()
     */
    public function camelize($word)
    {
        $filter = new UnderscoreToCamelCase();
        
        return $filter->filter($word);
    }

    /**
     * Mapper function to upload any file on server including saving thumbnails if file type
     * is image using Imagine plugin. Checking thumbSizes array which will only be passed 
     * if uploaded file is image!
     * 
     * @see \Application\Mapper\AppSqlMapperInterface::uploadFiles()
     */
    public function uploadFiles($params)
    {
        $filesize = new Size($params['size']);
        
        $extension = new Extension($params['ext']);
        
        $this->httpadapter->setValidators(array(
            $filesize,
            $extension
        ), $params['files']['name']);
        
        if ($this->httpadapter->isValid()) {
            $filter = new Rename(array(
                "target" => $params['path'] . str_replace(' ', '_', $params['files']['name']),
                "randomize" => true
            ));
            $uploadedFile = $filter->filter($params['files']);
            $result = array(
                'success' => true,
                'filename' => basename($uploadedFile['tmp_name'])
            );
            chmod($params['path'] . basename($uploadedFile['tmp_name']), 0755);
            if (! empty($params['deleteImage']) && file_exists($params['path'] . $params['deleteImage'])) {
                unlink($params['path'] . $params['deleteImage']);
                // delete thumbnails
                if (isset($params['thumbSizes'])) {
                    $this->deleteThumbnails($params['path'], $params['deleteImage'], $params['thumbSizes']);
                }
            }
            
            if (isset($params['thumbnails']) && $params['thumbnails'] == true && isset($params['thumbSizes'])) {
                $this->resizeImages($params['path'], $result['filename'], $params['thumbSizes']);
            }
        } else {
            $result = array(
                'success' => false,
                'error_messages' => $this->httpadapter->getMessages()
            );
        }
        
        return $result;
    }

    /**
     * Method to resize images!
     * 
     * @param type $path
     * @param type $filename
     * @param type $thumbSizes
     */
    public function resizeImages($path, $filename, $thumbSizes)
    {
        $imagine = new Imagine();
        if (! empty($thumbSizes)) {
            foreach ($thumbSizes as $width => $height) {
                $image = $imagine->open($path . $filename);
                if (! is_dir($path . 'thumbnails')) {
                    mkdir($path . 'thumbnails');
                }
                if (! is_dir($path . 'thumbnails/' . $width . 'x' . $height)) {
                    mkdir($path . 'thumbnails/' . $width . 'x' . $height);
                }
                $image->resize(new Box($width, $height))->save($path . 'thumbnails/' . $width . 'x' . $height . '/' . $filename);
            }
        }
    }

    /**
     * Method to delete thumbnails!
     * 
     * @param type $path
     * @param type $filename
     * @param type $thumbSizes
     */
    public function deleteThumbnails($path, $filename, $thumbSizes)
    {
        if (! empty($thumbSizes)) {
            foreach ($thumbSizes as $width => $height) {
                if (file_exists($path . 'thumbnails/' . $width . 'x' . $height . '/' . $filename)) {
                    unlink($path . 'thumbnails/' . $width . 'x' . $height . '/' . $filename);
                }
            }
        }
    }
    
    /**
     * Method to send email!
     * 
     * @param type $htmlMarkup
     * @param type $to
     * @param type $recieverName
     * @param type $subject
     * @param type $from
     * @param type $senderName
     * @return boolean
     */
    public function sendEmail($htmlMarkup, $to, $recieverName, $subject, $from = NULL, $senderName = NULL)
    {
        $transport = new Smtp();
        $options = new SmtpOptions(array(
            'host' => 'mail.test.com',
            'connection_class' => 'login',
            'connection_config' => array(
                'username' => 'SMTP_USERNAME_WILL_BE_HERE',
                'password' => 'SMTP_PASSWORD_WILL_BE_HERE'
            ),
            'port' => '26'
        ));
        $htmlPart = new MimePart($htmlMarkup);
        $htmlPart->type = "text/html";
    
        $body = new MimeMessage();
        $body->setParts(array(
            $htmlPart
        ));
    
        $mail = new Mail\Message();
        $mail->setFrom($from, $senderName);
        $mail->addTo($to, $recieverName);
        $mail->setSubject($subject);

        $mail->setBody($body);
        $mail->getHeaders()->addHeaderLine('MIME-Version', '1.0');
        
        $transport->setOptions($options);
        $transport->send($mail);
        
        return true;
    }
}