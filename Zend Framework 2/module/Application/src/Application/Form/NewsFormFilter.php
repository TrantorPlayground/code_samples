<?php
namespace Application\Form;

use Zend\InputFilter\InputFilter;

class NewsFormFilter extends InputFilter
{

    public function __construct()
    {
        $this->add(array(
            'name' => 'title',
            'required' => true,
            'validators' => array(
                array(
                    'name' => 'not_empty',
                    'options' => array(
                        'messages' => array(
                            \Zend\Validator\NotEmpty::IS_EMPTY => 'Please enter title!'
                        )
                    )
                )
            ),
        ));
        
        $this->add(array(
            'name' => 'news_text',
            'required' => true,
            'validators' => array(
                array(
                    'name' => 'not_empty',
                    'options' => array(
                        'messages' => array(
                            \Zend\Validator\NotEmpty::IS_EMPTY => 'Please enter news text!'
                        )
                    )
                )
            ),
        ));
    }
}