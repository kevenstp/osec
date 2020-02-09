<?php namespace Controllers;

use Models\Utilities\Weather;
use Models\Utilities\WebScraper;

class HomeController extends Controller
{
    public function initializeRoutes()
    {
        $this->get("/accueil", "renderHome");
    }

    public function renderHome() {
        $surveillance = new WebScraper();
        $weatherData = json_decode(file_get_contents("http://api.openweathermap.org/data/2.5/weather?q=Shawinigan&appid=8189ecba738e207c8ecc8f5a0930a807"));
        $weatherData->image = $this->getWeatherStatus($weatherData);
        return $this->render('home', [
            "title" => "õsec - Accueil",
            "surveillance" => $surveillance->getSurveillance(),
            "weather" => $weatherData,
            "danger" => true
        ]);
    }

    public function index()
    {
        return $this->render('example', ["currentDate" => date('Y-m-d')]);
    }

    private function getWeatherStatus($weatherData) {
        $weatherStatusArray = Weather::getWeatherStatus();
        foreach($weatherStatusArray as $status) {
            if($status['value'] == $weatherData->weather[0]->main) {
                if ($status['value'] == "Clear") {
                    return (date("H") < "17" && date("H") > "4") ? $status['imagePath'] : '/assets/weathers/night.svg';
                }
                return $status['imagePath'];
            }
        }
        return '/assets/weathers/weather.svg';
    }
}
