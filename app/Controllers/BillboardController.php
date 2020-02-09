<?php


namespace Controllers;


use Models\Brokers\BillboardBroker;
use Models\Brokers\UserBroker;
use Zephyrus\Application\Session;

class BillboardController extends Controller
{

    public function initializeRoutes()
    {
        $this->get("/babillard", "renderBillboard");
        $this->post("/babillard/creation", "createPost");
        $this->get("/babillard/{id}", "renderPostIt");
    }

    public function renderPostIt($id) {
        return $this->render("billboard/post-it-detail");
    }

    public function renderBillboard()
    {
        $broker = new BillboardBroker();
        $userBroker = new UserBroker();
        $posts = $broker->findAll();

        foreach ($posts as $post) {
            $post->user = $userBroker->findById($post->userId);
        }

        return $this->render("billboard/billboard",
            [
                "posts" => $posts
            ]);
    }

    public function createPost()
    {
        $note = (object)$this->buildForm()->getFields();
        $note->userId = Session::getInstance()->read("userId");

        $billboardBroker = new BillboardBroker();
        $billboardBroker->insert($note);

        return $this->redirect("/babillard");
    }
}