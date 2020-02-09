<?php namespace Controllers;


class LoginController extends Controller
{

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