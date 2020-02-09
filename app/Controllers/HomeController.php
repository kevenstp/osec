<?php namespace Controllers;

use Utilities\WebScraper;

class HomeController extends Controller
{
    public function initializeRoutes()
    {
        $this->get("/accueil", "renderHome");
    }

    public function renderHome() {
        $surveillance = new WebScraper();
        return $this->render('home', [
            "title" => "õsec - Accueil",
            "surveillance" => $surveillance->getSurveillance()
        ]);
    }

    public function index()
    {
        return $this->render('example', ["currentDate" => date('Y-m-d')]);
    }
}
