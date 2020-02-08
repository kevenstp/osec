<?php namespace Models\Utils;

use stdClass;
use Zephyrus\Application\Rule;

class Uploader
{

    private $uploadDirectory;
    private $size;
    private $inputName;
    private $targetFile;
    private $FILES;
    private $indexes;

    public function __construct($directory = '/data')
    {
        $this->uploadDirectory = ROOT_DIR . $directory;
    }

    public static function fileExist($path, string $fileName): bool
    {
        return file_exists($path . $fileName);
    }

    public function upload($inputName, $hash, $directory = ''): bool
    {
        $this->inputName = $inputName;
        $this->FILES = $_FILES;
        $extension = $this->getExtension();
        $targetFile = self::getUploadDirectory($directory) . $hash . '.' . $extension;
        if ($extension == '') {
            return false;
        }
        move_uploaded_file($this->getTempFileName(), $targetFile);
        $this->size = $this->FILES[$inputName]['size'];
        $this->targetFile = $targetFile;
        return true;
    }



    public function uploadForMulti($inputName, $index, $hash, $directory = '')
    {
        $this->inputName = $inputName;
        $extension = $this->getExtensionWithIndex($index);
        $targetFile = self::getUploadDirectory($directory) . $hash . '.' . $extension;
        if ($extension == '') {
            return null;
        }
        move_uploaded_file($this->getTempFileNameWithIndex($index), $targetFile);
        $value = $this->FILES[$index]['size'];
        if (is_array($value)) {
            $this->size = $this->FILES[$index]['size'][$index];
        } else {
            $this->size = $this->FILES[$index]['size'];
        }
        $this->targetFile = $targetFile;
        return $targetFile;
    }

    public function uploadMulti($inputName, $hashFileNames, $directory = ''): array
    {
        $files = array();
        $this->rebuildFiles($inputName);
        $indexes = $this->indexes;
        if (sizeof($hashFileNames) != 0) {
            for ($i = 0; $i < sizeof($indexes); ++$i) {
                $file = $this->uploadForMulti($inputName, $indexes[$i], $hashFileNames[$i], $directory);
                if ($file != null) {
                    array_push($files, $this->getResultFileMultiple());
                }
            }
        }
        return $files;
    }

    public function getResultFile(): stdClass
    {
        if (is_array($this->size)) {
            $this->size = $this->size[0];
        }
        return (object) [
            "size" => $this->size,
            "path" => $this->targetFile,
            "type" => $this->getExtension()
        ];
    }

    public function getResultFileMultiple(): stdClass
    {
        return (object) [
            "size" => $this->size,
            "path" => $this->targetFile,
            "type" => $this->getExtensionWithIndex(0)
        ];
    }

    public function getUploadDirectory(string $directory = ''): string
    {
        return $directory === '' ? $directory = $this->uploadDirectory : $directory = ROOT_DIR . $directory;
    }

    public static function getMultiFileCount($inputName): int
    {
        if (is_array($_FILES[$inputName]['name'])) {
            return count(array_filter($_FILES[$inputName]['name']));
        }
        return 1;
    }

    public static function removeFile($directory, $fileName = '')
    {
        if (unlink(ROOT_DIR . $directory . $fileName)) {
            //file has been deleted
        }
    }

    public static function removeFileWithStd($file)
    {
        if (unlink($file->path)) {
            //file has been deleted
        }
    }

    public static function getProjectDirectory(string $directory): string
    {
        return ROOT_DIR . $directory;
    }

    private function rebuildFiles($inputName): array
    {
        $file = $_FILES[$inputName];
        if (sizeof($file['name']) > 1) {
            $indexes = array();
            for ($i = 0; $i < count($file['name']); ++$i) {
                $fileStd = [
                    'name' => $file['name'][$i],
                    'type' => $file['type'][$i],
                    'tmp_name' => $file['tmp_name'][$i],
                    'error' => $file['error'][$i],
                    'size' => $file['size'][$i]
                ];
                $indexes[$i] = $i;
                $this->FILES[$i] = $fileStd;
            }
            $this->indexes = $indexes;
            return $indexes;
        } else if (sizeof($file['name']) == 1) {
            $this->indexes = array();
            $this->indexes[0] = 0;
            $array = array($file);
            $this->FILES = $array;
            return $array;
        }
        return array();
    }

    private function getRealFileName(): string
    {
        $value = $this->FILES[$this->inputName]['name'];
        if (is_array($value)) {
            return $value[0];
        }
        return $value;
    }

    private function getRealFileNameWithIndex($index): string
    {
        $value = $this->FILES[$index]['name'];
        if (is_array($value)) {
            return $value[0];
        }
        return $value;
    }

    private function getTempFileName(): string
    {
        $value = $this->FILES[$this->inputName]['tmp_name'];
        if (is_array($value)) {
            return $value[0];
        }
        return $value;
    }

    private function getTempFileNameWithIndex($index): string
    {
        $value = $this->FILES[$index]['tmp_name'];
        if (is_array($value)) {
            return $value[0];
        }
        return $value;
    }

    private function getExtension(): string
    {
        return pathinfo($this->getRealFileName(), PATHINFO_EXTENSION);
    }

    private function getExtensionWithIndex($index): string
    {
        return pathinfo($this->getRealFileNameWithIndex($index), PATHINFO_EXTENSION);
    }
}