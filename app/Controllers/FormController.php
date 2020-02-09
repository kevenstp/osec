<?php namespace Controllers;


use Zephyrus\Network\Response;

class FormController extends Controller
{

    public function render($page, $args = []): Response
    {
        $args['title'] = 'Réclamation';
        return parent::render('forms/' . $page, $args);
    }

    public function initializeRoutes()
    {
        $this->get("/form", "renderForm");
        $this->post("/form", "createForm");

    }

    public function renderForm()
    {
        return $this->render("form");
    }

    public function createForm()
    {
        $form = $this->buildForm();
        
    }
}