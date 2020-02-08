<?php namespace Controllers;


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
        
    }
}