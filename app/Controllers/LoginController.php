<?php namespace Controllers;


use Models\Brokers\HomeBroker;
use Zephyrus\Application\Session;
use Zephyrus\Network\Response;

use Models\Brokers\CityBroker;
use Models\Brokers\UserBroker;
use Zephyrus\Application\Flash;
use Zephyrus\Security\Cryptography;

class LoginController extends Controller
{

    public function render($page, $args = []): Response
    {
        $args['title'] = 'Login';
        return parent::render('authentication/' . $page, $args);
    }

    public function initializeRoutes()
    {
        $this->get("/", "renderLogin");
        $this->get("/inscription", "renderRegister");
        $this->post("/connexion", "connectUser");
        $this->post("/inscription", "registerUser");
    }

    public function renderLogin()
    {
        return $this->render("login", ["title" => "õsec - Authentification"]);
    }

    public function connectUser()
    {
        $userBroker = new UserBroker();
        $form = (object)$this->buildForm()->getFields();
        $user = $userBroker->findByEmail($form->email);
        if(!is_null($user) && Cryptography::verifyHash($form->password, $user->password)) {
            Session::getInstance()->set("userId", $user->id);
            return $this->redirect("/accueil");
        }

        Flash::error("Authentification invalide");
        return $this->redirect("/");
    }

    public function renderRegister()
    {
        $cityBroker = new CityBroker();

        return $this->render("register", [
            "title" => "õsec - Inscription",
            "cities" => $cityBroker->findAll()
        ]);
    }

    public function registerUser()
    {
        $form = (object)$this->buildForm()->getFields();

        if ($form->password != $form->confirmPassword) {
            Flash::error("Les mots de passes doivent concorder.");
            return $this->redirect("/inscription");
        }

        $userBroker = new UserBroker();

        if (!is_null($userBroker->findByEmail($form->email))) {
            Flash::error("Courriel déjà utilisé.");
            return $this->redirect("/inscription");
        }

        $form->password = Cryptography::hash($form->password);
        $form->role = "resident";
        $form->birthDate = null;
        $form->homePhoneNumber = null;
        $form->cellPhoneNumber = null;
        $form->workPhoneNumber = null;
        $userId = $userBroker->insert($form);

        $homeBroker = new HomeBroker();

        $form->floodId = null;
        $form->postOfficeBox = null;

        $homeId = $homeBroker->insert($form);

        $userBroker->insertHome($userId, $homeId);


        Flash::success("Compte créé avec succès");

        return $this->redirect('/');
    }
}