<?php namespace Controllers;


use Zephyrus\Network\Response;

class LoginController extends Controller
{

    public function render($page, $args = []): Response
    {
        $args['title'] = 'Login';
        return parent::render('authentication/' . $page, $args);
    }

    public function initializeRoutes()
    {
        $this->get("/", "renderLogin");
        $this->get("/inscription", "renderRegister");
        $this->post("/connexion", "connectUser");
        $this->post("/inscription", "registerUser");
    }

    public function renderLogin()
    {
        return $this->render("login", ["title" => "õsec - Authentification"]);
    }

    public function connectUser()
    {

    }

    public function renderRegister()
    {
        return $this->render("register", ["title" => "õsec - Inscription"]);
    }
}