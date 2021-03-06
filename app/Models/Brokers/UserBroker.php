<?php namespace Models\Brokers;


use stdClass;

class UserBroker extends BaseBroker
{

    public function findAll(): array
    {
        return $this->select("SELECT * FROM `User`", []);
    }

    public function findById(int $id)
    {
        return $this->selectSingle("SELECT * FROM `User` WHERE id=?", [$id]);
    }

    public function findByEmail($email)
    {
        return $this->selectSingle("SELECT * FROM `User` WHERE email=?", [$email]);
    }

    public function insert(stdClass $user): string
    {
        $sql = "INSERT INTO `User` (id, firstname, lastname, role, birthDate, homePhoneNumber, cellPhoneNumber, workPhoneNumber, email, password)
                VALUES (DEFAULT, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        $this->query($sql, [
           $user->firstname,
           $user->lastname,
           $user->role,
           $user->birthDate,
           $user->homePhoneNumber,
           $user->cellPhoneNumber,
           $user->workPhoneNumber,
           $user->email,
           $user->password
        ]);
        return $this->getDatabase()->getLastInsertedId();
    }

    public function insertHome($userId, $homeId)
    {
        $this->query("INSERT INTO UserHome (userId, homeId) VALUES (?, ?)", [$userId, $homeId]);
    }

    public function update(stdClass $user): string
    {
        $sql = "UPDATE `User` SET id=?, firstname=?, lastname=?, role=?, birthDate=?, homePhoneNumber=?, cellPhoneNumber=?, workPhoneNumber=?, email=?, password=? WHERE id=?";
        $this->query($sql, [
            $user->firstname,
            $user->lastname,
            $user->role,
            $user->birthDate,
            $user->homePhoneNumber,
            $user->cellPhoneNumber,
            $user->workPhoneNumber,
            $user->email,
            $user->password,
            $user->id
        ]);
        return $user->id;
    }

    public function delete(int $id)
    {
        $this->query("DELETE * FROM `User` WHERE id=?", [$id]);
    }
}