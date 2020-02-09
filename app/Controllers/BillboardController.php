<?php


namespace Controllers;


use Models\Brokers\BillboardBroker;

class BillboardController extends Controller
{

    public function initializeRoutes()
    {
        $this->get("/babillard", "renderBillboard");
        $this->get("/babillard/creation", ""); //todo
    }

    public function renderBillboard()
    {
        $broker = new BillboardBroker();
        $posts = $broker->findAll();
        return $this->render("billboard/billboard",
            [
                "posts" => $posts
            ]);
    }
}