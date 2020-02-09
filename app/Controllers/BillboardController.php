<?php


namespace Controllers;


class BillboardController extends Controller
{

    public function initializeRoutes()
    {
        $this->get("/babillard", "renderBillboard");
        $this->get("/babillard/creation", ""); //todo
    }

    public function renderBillboard()
    {
        return $this->render("billboard/billboard");
    }
}