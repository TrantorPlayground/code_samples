<?php
namespace Application\Mapper;

interface AppSqlMapperInterface
{
    /**
     * It will save news using Doctrine 2.
     * 
     * @param array $data
     */
    public function saveNews($data);

    /**
     * Get News by id or top 10 news in desc order using Doctrine 2.
     * @param string $id
     */
    public function getNews($id = NULL);

    /**
     * Upload any type of files!
     * 
     * @param unknown $params
     */
    public function uploadFiles($params);
    
    /**
     * Decamelize any word!
     * 
     * @param string $word
     */
    public function decamelize($word);

    /**
     * Camelize any word!
     *
     * @param string $word
     */
    public function camelize($word);
    
    /**
     * Send email using smtp!
     * 
     * @param HTML $htmlMarkup
     * @param string $to
     * @param string $recieverName
     * @param string $subject
     * @param string $from
     * @param string $senderName
     */
    public function sendEmail($htmlMarkup, $to, $recieverName, $subject, $from = NULL, $senderName = NULL);
}