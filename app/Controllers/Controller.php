<?php


namespace Controllers;


use Zephyrus\Network\Response;

abstract class Controller extends SecurityController
{
    public function render($page, $args = []): Response
    {
        return parent::render($page, $args);
    }

    public function before()
    {
        parent::before();
    }
}