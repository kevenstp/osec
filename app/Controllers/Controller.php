<?php namespace Controllers;

use Zephyrus\Network\Response;

abstract class Controller extends SecurityController
{
    private $args;
    private $page;

    public function render($page, $args = []): Response
    {
        $this->args = $args;
        $this->page = $page;
        $this->setDefaultTitle("õsec");
        $this->setDefaultDanger(false);
        return parent::render($this->page, $this->args);
    }

    public function before()
    {
        parent::before();
    }

    private function setDefaultTitle($title)
    {
        if (!key_exists('title', $this->args)) {
            $this->args['title'] = $title;
        }
    }

    private function setDefaultDanger($danger)
    {
        if (!key_exists('danger', $this->args)) {
            $this->args['danger'] = $danger;
        }
    }
}