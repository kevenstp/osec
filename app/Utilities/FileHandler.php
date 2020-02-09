<?php namespace Utilities;

use DateTime;
use stdClass;
use Zephyrus\Application\Flash;
use Zephyrus\Security\Cryptography;
use ZipArchive;

class FileHandler
{

    private $uploader;
    private $serverPath;
    private $fileName;
    private $fileNames;
    private $error;
    private $inputName;
    private $DIRECTORY = 2;
    private $FILE = 1;
    private $nodes = array();

    public function sendFile(string $serverPath, $inputName, $error = ''): ?stdClass
    {
        $this->error = $error;
        $this->inputName = $inputName;
        $this->serverPath = $serverPath;
        return $this->send();
    }

    public function sendFiles(string $serverPath, $inputName, $error = ''): ?array
    {
        $this->error = $error;
        $this->inputName = $inputName;
        $this->serverPath = $serverPath;
        return $this->sendMultiple();
    }

    public function sendFileOrFiles($path, $inputName, $multiple = true): ?array
    {
        if ($multiple) {
            return $files = $this->sendFiles($path, $inputName);
        }
        return array($this->sendFile($path, $inputName));
    }

    public static function removeFiles(array $files)
    {
        foreach ($files as $file) {
            Uploader::removeFile($file);
        }
    }

    public static function removeFile($path)
    {
        unlink($path);
    }

    public static function removeFilesWithStd(array $files)
    {
        foreach ($files as $file) {
            if (self::fileExist($file->path)) {
                Uploader::removeFileWithStd($file);
            }
        }
    }

    public static function deletePreviousZip($tempFileDurationInSeconds = 300) {
        $dateTime = new DateTime();
        $now = $dateTime->getTimestamp();
        $filesToDelete = scandir(getcwd());
        foreach ($filesToDelete as $file) {
            if (filemtime($file) + $tempFileDurationInSeconds >= $now) {
                $extension = pathinfo($file, PATHINFO_EXTENSION);
                if ($extension === "zip") {
                    unlink(getcwd() . "/" . $file);
                }
            }
        }
    }

    public static function fileExist($path, $fileName = '')
    {
        return Uploader::fileExist($path, $fileName);
    }

    private function send(): ?stdClass
    {
        $this->fileName = Cryptography::randomString(8);
        return $this->uploadToServer();
    }

    private function sendMultiple(): ?array {
        $this->fileNames = array();
        for ($i = 0; $i < Uploader::getMultiFileCount($this->inputName); ++$i) {
            $fileName = Cryptography::randomString(8);
            //self::fileExist($this->serverPath . $this->fileName);
            array_push($this->fileNames, $fileName);
        }
        return $this->uploadMultiToServer();
    }

    private function uploadMultiToServer(): ?array
    {
        $uploader = $this->uploader();
        $resultFiles = $uploader->uploadMulti($this->inputName, $this->fileNames, $this->serverPath);
        return $resultFiles;
    }

    private function uploadToServer(): ?stdClass
    {
        $uploader = $this->uploader();
        if (!$uploader->upload($this->inputName, $this->fileName, $this->serverPath)) {
            Flash::warning($this->error);
            if (file_exists($this->fileName)) {
                $uploader->removeFile($this->serverPath, $this->fileName);
            }
            return null;
        }
        return $uploader->getResultFile();
    }

    private function uploader(): Uploader
    {
        if (!$this->uploader == null) {
            return $this->uploader;
        }
        return new Uploader($this->serverPath);
    }

    public function readZip($zipFileName)
    {
        $zip = zip_open($zipFileName);
        if ($zip) {
            $this->getRoot($zipFileName);
            while ($zip_entry = zip_read($zip)) {
                $node = zip_entry_name($zip_entry);
                if (substr($node, -1) == '/')  {
                    $this->nodeInPath($node, $this->DIRECTORY);
                } else {
                    $this->nodeInPath($node, $this->FILE);
                }
                if (zip_entry_open($zip, $zip_entry) && substr($node, -1) != '/') {
                    $this->writeContent(zip_entry_read($zip_entry, zip_entry_filesize($zip_entry)));
                    zip_entry_close($zip_entry);
                }
            }
            zip_close($zip);
            return $this->nodes;
        }
    }

    private function nodeInPath($node, $type)
    {
        $path = explode("/", $node);
        $ext = explode(".", $node);
        $level = count($path) - $type;
        array_push($this->nodes, [ "level" => $level,
            "name" => $path[count($path)-$type],
            "ext" => (count($ext) == 2)? $ext[1] : "",
            "connectTo" => ($level != 1) ?$path[count($path)-$type-1] : $this->nodes[0]['name'],
            "content" => "" ]);
    }

    private function writeContent($content)
    {
        $this->nodes[count($this->nodes)-1]["content"] = utf8_encode($content);
    }

    private function getRoot($zipFileName)
    {
        $arr = explode('/', $zipFileName);
        $rootName = explode('.', end($arr))[0];
        array_push($this->nodes, [ "level" => 0,
            "name" => $rootName,
            "ext" => "",
            "connectTo" => "",
            "content" => "" ]);
    }

    public function readSingleFileContent($filePath) {
        $readFile = fopen($filePath, "r");
        $content = file_get_contents($filePath);
        fclose($readFile);
        return $content;
    }

    public static function zip(array $files, $resultName = '')
    {
        if ($resultName == '') {
            $resultName = Cryptography::randomString(8) . '.zip';
        }
        return self::createZip($files, $resultName);
    }

    private static function createZip($files, $resultName) {
        $zip = new ZipArchive;
        if ($zip->open($resultName, ZipArchive::CREATE) === TRUE) {
            foreach ($files as $file) {
                $zip->addFile($file->path, basename($file->path));
            }
        }
        $fileName = $zip->filename;
        $zip->close();
        return $fileName;
    }

    private static function buildZipHeader($tempFile) {
        return $tempFile;
    }
}