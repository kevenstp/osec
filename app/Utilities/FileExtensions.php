<?php


namespace Models\Utils;


use stdClass;

class FileExtensions
{


    public static function getProgrammingExtensions(): array
    {
        return ['java', 'php', 'c', 'cpp', 'zip', 'css', 'sql', 'html', 'txt', 'lightbox', 'py', 'rb', 'xml', 'svg', 'cs', 'pug', 'scss', 'jade', 'pdf'];
    }

    public static function getImageExtensions(): array
    {
        return ['jpg', 'jpeg', 'png', 'gif', 'raw', 'svg', 'heic', 'webp', 'psd', 'bmp', 'heif', 'indd', 'ai', 'eps', 'pdf'];
    }

    public static function getSyntaxColoration(): array
    {
        return [
            ['value' => 'txt', 'name' => 'TXT'],
            ['value' => 'css', 'name' => 'CSS'],
            ['value' => 'bash', 'name' => 'BASH'],
            ['value' => 'c', 'name' => 'C'],
            ['value' => 'cpp', 'name' => 'C++'],
            ['value' => 'csharp', 'name' => 'C#'],
            ['value' => 'html', 'name' => 'HTML'],
            ['value' => 'java', 'name' => 'JAVA'],
            ['value' => 'javascript', 'name' => 'JS'],
            ['value' => 'json', 'name' => 'JSON'],
            ['value' => 'kotlin', 'name' => 'KOTLIN'],
            ['value' => 'objectivec', 'name' => 'OBJECTIVE-C'],
            ['value' => 'php', 'name' => 'PHP'],
            ['value' => 'pug', 'name' => 'PUG'],
            ['value' => 'python', 'name' => 'PYTHON'],
            ['value' => 'sas', 'name' => 'SAS'],
            ['value' => 'sass', 'name' => 'SASS'],
            ['value' => 'scss', 'name' => 'SCSS'],
            ['value' => 'sql', 'name' => 'SQL'],
            ['value' => 'swift', 'name' => 'SWIFT']
        ];
    }
}