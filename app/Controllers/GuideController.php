<?php namespace Controllers;


class GuideController extends Controller
{

    public function initializeRoutes()
    {
        $this->get("/guide", "renderGuide");
    }

    public function renderGuide() {
        return $this->render("/guide/guide");
    }
}