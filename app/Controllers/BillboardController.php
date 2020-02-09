<?php namespace Controllers;


class BillboardController extends Controller
{

    public function initializeRoutes()
    {
        $this->get("/babillard", "renderBillboard");
    }

    public function renderBillboard() {
        return $this->render("billboard/billboard");
    }
}