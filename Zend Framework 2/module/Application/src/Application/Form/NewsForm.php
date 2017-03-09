<?php
namespace Application\Form;

use Zend\Form\Form;

class NewsForm extends Form
{

    public function __construct()
    {
        parent::__construct();
        
        $this->setAttribute('method', 'post');
        $this->setAttribute('id', 'newsForm');
        $this->setAttribute('class','default-form');
        $this->setAttribute('enctype', 'multipart/form-data');
        
        $this->add(array(
            'name' => 'title',
            'attributes' => array(
                'type' => 'text',
                'placeholder' => 'Title',
                'class' => 'form-control'
            ),
            'options' => array(
                'label' => 'Title',
                
            ),
        ));
        
        $this->add(array(
            'name' => 'news_text',
            'type' => 'Zend\Form\Element\Textarea',
            'attributes' => array(
                
                'placeholder' => 'News Text',
                'class' => 'form-control'
            )
        ));
        
        $this->add(array(
            'name' => 'photo',
            'attributes' => array(
                'type' => 'file',
                'placeholder' => 'Upload Photo',
                'id' => 'photo'
            )
        ));
        
        $this->add(array(
            'name' => 'submit',
            'attributes' => array(
                'type' => 'submit',
                'value' => 'Save',
                'id' => 'submitbutton',
                'class' => 'btn btn-primary'
            )
        ));
    }
}