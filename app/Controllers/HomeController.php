<?php namespace Controllers;

use Models\Utilities\WebScraper;

class HomeController extends Controller
{
    public function initializeRoutes()
    {
        $this->get("/accueil", "renderHome");
    }

    public function renderHome() {
        $surveillance = new WebScraper();
        $response = file_get_contents("http://api.openweathermap.org/data/2.5/weather?q=Sorel-Tracy&appid=8189ecba738e207c8ecc8f5a0930a807");
        return $this->render('home', [
            "title" => "õsec - Accueil",
            "surveillance" => $surveillance->getSurveillance(),
            "weather" => json_decode($response),
            "danger" => true
        ]);
    }

    public function index()
    {
        return $this->render('example', ["currentDate" => date('Y-m-d')]);
    }
}
