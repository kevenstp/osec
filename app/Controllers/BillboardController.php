<?php


namespace Controllers;


class BillboardController extends Controller
{

    public function initializeRoutes()
    {
        $this->get("/babillard", "renderBillboard");
        $this->get("/babillard/{id}", "renderPostIt");
        $this->get("/babillard/creation", ""); //todo
    }

    public function renderPostIt($id) {
        return $this->render("billboard/post-it-detail");
    }

    public function renderBillboard()
    {
        return $this->render("billboard/billboard");
    }
}