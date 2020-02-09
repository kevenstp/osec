<?php namespace Controllers;

use Models\Item;

class GuideController extends Controller
{

    public function initializeRoutes()
    {
        $this->get("/guide", "/guideRendering");
    }

    public function guideRendering()
    {

    }

}
