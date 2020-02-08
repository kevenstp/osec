<?php namespace Controllers;


class LoginController extends Controller
{

    public function initializeRoutes()
    {
        $this->get("/", "renderLogin");
        $this->get("/connexion", "connectUser");
    }

    public function renderLogin()
    {
        return $this->render("login", ["title" => "õsec"]);
    }
}