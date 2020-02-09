<?php namespace Models\Brokers;


use Models\BaseBroker;
use stdClass;

class UserBroker extends BaseBroker
{

    public function findAll(): array
    {
        return $this->select("SELECT * FROM `User`", []);
    }

    public function findById($id)
    {
        return $this->selectSingle("SELECT * FROM `User` WHERE id=?", [$id]);
    }

    public function findByEmail($email)
    {
        return $this->selectSingle("SELECT * FROM `User` WHERE primaryMailAddress=?", [$email]);
    }

    public function insert($user): string
    {
        $sql = "INSERT INTO `User` (id, firstname, lastname, role, birthDate, homePhoneNumber, cellPhoneNumber, workPhoneNumber, primaryMailAddress)
                VALUES (DEFAULT, ?, ?, ?, ?, ?, ?, ?, ?)";
        $this->query($sql, [
           $user->firstname,
           $user->lastname,
           $user->role,
           $user->birthDate,
           $user->homePhoneNumber,
           $user->cellPhoneNumber,
           $user->workPhoneNumber,
           $user->primaryMailAddress
        ]);
        return $this->getDatabase()->getLastInsertedId();
    }

    public function insertWithAddress($user)
    {
        $this->insert($user);
        //$sql = "INSERT INTO ";
    }

    public function update(stdClass $user): string
    {
        $sql = "UPDATE `User` SET id=?, firstname=?, lastname=?, role=?, birthDate=?, homePhoneNumber=?, cellPhoneNumber=?, workPhoneNumber=?, primaryMailAddress=? WHERE id=?";
        $this->query($sql, [
            $user->firstname,
            $user->lastname,
            $user->role,
            $user->birthDate,
            $user->homePhoneNumber,
            $user->cellPhoneNumber,
            $user->workPhoneNumber,
            $user->primaryMailAddress,
            $user->id
        ]);
        return $user->id;
    }

    public function delete($id)
    {
        $this->query("DELETE * FROM `User` WHERE id=?", [$id]);
    }
}