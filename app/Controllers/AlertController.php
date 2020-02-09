<?php namespace Controllers;

use Models\Brokers\FormBroker;
use Zephyrus\Application\Session;
use Zephyrus\Network\Response;

class AlertController extends Controller
{

    public function render($page, $args = []): Response
    {
        $args['title'] = 'Alerte';
        return parent::render('alert/' . $page, $args);
    }

    public function initializeRoutes()
    {
        $this->get("/alerte", "renderAlert");
        $this->get("/alerte/sse", "sendSSE");
    }

    public function renderAlert()
    {

        return $this->render("alert");
    }

    public function sendSSE()
    {
        return $this->sseStreaming(function (){
            //$broker = new NotificationBroker();
            $userID = Session::getInstance()->read("id");
            //$count = $broker->getNotificationNumber($userID)[0]->c;
            $count = 1;
            return ['count' => $count];
        });
    }
}