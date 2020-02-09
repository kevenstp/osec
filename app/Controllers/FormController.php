<?php namespace Controllers;


use Models\Brokers\FormBroker;

class FormController extends Controller
{

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
        $broker = new FormBroker();
        $broker->insert((object) $form->getFields());
        return $this->redirect("/acceuil");
    }
}