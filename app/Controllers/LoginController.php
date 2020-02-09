<?php namespace Controllers;


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
        $user = (object)$this->buildForm()->getFields();

        if ($user->password == $user->confirmPassword) {
            Flash::error("Les mots de passes doivent concorder.");
            return $this->redirect("/");
        }

        $userBroker = new UserBroker();

        if ($userBroker->findByEmail($user->email)) {
            Flash::error("Courriel déjà utilisé.");
            return $this->redirect("/");
        }

        $user->role = "resident";
        $user->birthDate = null;
        $user->homePhoneNumber = null;
        $user->cellPhoneNumber = null;
        $user->workPhoneNumber = null;
        $user->id = $userBroker->insert($user);

    }
}