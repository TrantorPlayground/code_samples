<?php
namespace Application\Service;

use Application\Mapper\AppSqlMapperInterface;

class AppService implements AppServiceInterface
{

    protected $mapper;

    public function __construct(AppSqlMapperInterface $mapper)
    {
        $this->mapper = $mapper;
    }

    public function saveNews($data)
    {
        return $this->mapper->saveNews($data);
    }

    public function getNews($id = NULL)
    {
        return $this->mapper->getNews($id);
    }

    public function uploadFiles($params)
    {
        return $this->mapper->uploadFiles($params);
    }

    public function decamelize($word)
    {
        return $this->mapper->decamelize($word);
    }

    public function camelize($word)
    {
        return $this->mapper->camelize($word);
    }
    
    public function sendEmail($htmlMarkup, $to, $recieverName, $subject, $from = 'from email address', $senderName = 'Newsstand App')
    {
        return $this->mapper->sendEmail($htmlMarkup, $to, $recieverName, $subject, $from, $senderName);
    }
}