<?php namespace Models\Utilities;


class Weather
{
    public static function getWeatherStatus(): array
    {
        return [
            ['value' => 'Thunderstorm', 'imagePath' => '/assets/weathers/thunder.svg'],
            ['value' => 'Drizzle', 'imagePath' => '/assets/weathers/cloudy.svg'],
            ['value' => 'Rain', 'imagePath' => '/assets/weathers/rainy-7.svg'],
            ['value' => 'Snow', 'imagePath' => '/assets/weathers/snowy-6.svg'],
            ['value' => 'Clear', 'imagePath' => '/assets/weathers/day.svg'],
            ['value' => 'Clouds', 'imagePath' => '/assets/weathers/cloudy.svg']
        ];
    }
}