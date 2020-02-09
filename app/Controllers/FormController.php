<?php namespace Controllers;

use Models\Brokers\FormBroker;
use Zephyrus\Network\Response;

class FormController extends Controller
{

    public function render($page, $args = []): Response
    {
        $args['title'] = 'Réclamation';
        return parent::render('claims/' . $page, $args);
    }

    public function initializeRoutes()
    {
        $this->get("/form", "renderForm");
        $this->post("/form", "createForm");
        $this->get("/reclamations", "renderClaims");
        $this->get("/reclamation/demande", "renderClaimForm");
        $this->get("/reclamation/{id}", "renderClaimState");
    }

    public function renderClaimState($id) {
        return $this->render("claim-state");
    }

    public function renderClaims() {
        return $this->render("claim-list");
    }

    public function renderClaimForm() {
        return $this->render("claim-form");
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