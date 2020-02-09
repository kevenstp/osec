<?php namespace Controllers;

use Models\Brokers\FormBroker;
use Zephyrus\Application\Session;
use Zephyrus\Network\Response;

class ProfileController extends Controller
{

    public function render($page, $args = []): Response
    {
        $args['title'] = 'õsec - Compte';
        return parent::render('profile/' . $page, $args);
    }

    public function initializeRoutes()
    {
        $this->post("/compte", "redirectManagement");
        $this->get("/gestion-du-compte", "renderProfile");
    }

    public function redirectManagement()
    {
        return $this->redirect("/gestion-du-compte");
    }

    public function renderProfile()
    {
        return $this->render("profile");
    }
}