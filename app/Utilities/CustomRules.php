<?php namespace Utilities;

use Zephyrus\Application\Rule;

class CustomRules
{

    public static function datetimeLocal(string $errorMessage = ""): Rule
    {
        return new Rule(function ($value) {
            return preg_match("/^(-?(?:[1-9][0-9]*)?[0-9]{4})-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):([0-5][0-9])$/", $value);
        }, $errorMessage);
    }

    public static function programmingFileExtension(string $errorMessage = ""): Rule
    {
        return Rule::fileExtension($errorMessage, FileExtensions::getProgrammingExtensions());
    }

    public static function imageFileExtension(string $errorMessage = ""): Rule
    {
        return Rule::fileExtension($errorMessage, FileExtensions::getImageExtensions());
    }

    public static function colorHexadecimal(string $errorMessage = ""): Rule
    {
        return new Rule(function ($value) {
            return preg_match('/#([[:xdigit:]]{3}){1,2}\b/', $value);
        }, $errorMessage);
    }

    public static function maleOrFemale(string $errorMessage = "")
    {
        return new Rule(function ($value) {
            return preg_match('/^(m|M|f|F|Male|male|Female|female)$/', $value);
        }, $errorMessage);
    }
}