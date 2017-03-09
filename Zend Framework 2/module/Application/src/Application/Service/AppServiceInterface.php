<?php
namespace Application\Service;

interface AppServiceInterface
{

    public function saveNews($data);

    public function getNews($id = NULL);

    public function uploadFiles($params);

    public function decamelize($word);

    public function camelize($word);
    
    public function sendEmail($htmlMarkup, $to, $recieverName, $subject, $from = NULL, $senderName = NULL);
}