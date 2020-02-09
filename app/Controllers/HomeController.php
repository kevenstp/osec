<?php namespace Controllers;

use Models\Item;

class HomeController extends Controller
{

    public function initializeRoutes()
    {
        $this->get("/accueil", "renderHome");
    }

    public function renderHome() {
        $surveillance = WebScraper::getSurveillance();
        return $this->render('home', [
            "title" => "õsec - Accueil",
            "surveillance" => $surveillance
        ]);
    }

    public function index()
    {
        return $this->render('example', ["currentDate" => date('Y-m-d')]);
    }
}
