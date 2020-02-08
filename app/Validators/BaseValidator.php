<?php namespace Models\Validators;

use Zephyrus\Application\Form;

abstract class BaseValidator
{
    public abstract function exist(string $username): bool;

    /**
     * @var Form
     */
    protected $form;

    public function __construct(Form $form)
    {
        $this->form = $form;
    }

    public function getForm(): Form
    {
        return $this->form;
    }

    public function verify($key = ''): bool
    {
        if ($key !== '') {
            $this->verifyExistence($key);
        }
        return $this->form->verify();
    }

    public function getErrorMessages(): array
    {
        return $this->form->getErrorMessages();
    }

    private function verifyExistence($key) {
        if ($this->exist($key)) {
            $this->form->addError($key, "Key: ($key) already exist");
            return false;
        }
        return true;
    }

    public function rebuildFiles($inputName): array
    {
        $file = $this->form->getFields()[$inputName];
        if (sizeof($file['name']) > 1) {
            $fileStd = array((object) [
                'name',
                'type',
                'tmp_name',
                'error',
                'size'
            ]);
            $newInputNames = array();
            for ($i = 0; $i < count($file['name']); ++$i) {
                $fileStd[$i] = [
                    'name' => $file['name'][$i],
                    'type' => $file['type'][$i],
                    'tmp_name' => $file['tmp_name'][$i],
                    'error' => $file['error'][$i],
                    'size' => $file['size'][$i]
                ];
                $newInputNames[$i] = $inputName . 'Multi' . $i;
                $this->form->addField($newInputNames[$i], $fileStd[$i]);
            }
            return $newInputNames;
        }
        return array($inputName);
    }
}