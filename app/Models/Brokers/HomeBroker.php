<?php


namespace Models\Brokers;


use stdClass;

class HomeBroker extends BaseBroker
{

    public function findAll(): array
    {
        return $this->select('
            SELECT *
            FROM Home home           
        ');
    }

    public function findById(int $id)
    {
        return $this->select('
            SELECT *
            FROM Home home
            WHERE id = ?
        ', [$id]);
    }

    public function insert(stdClass $stdClass): string
    {
        $this->query('
            INSERT INTO Home (address, floodId, cityId, postalCode, postOfficeBox) 
            VALUES (?, ?, ?, ?, ?)
        ', [$stdClass->address, $stdClass->floodId, $stdClass->cityId, $stdClass->postalCode, $stdClass->postOfficeBox]);
        return $this->getDatabase()->getLastInsertedId();
    }

    public function update(stdClass $stdClass): string
    {
        $this->query('
            UPDATE Home home 
            SET home.address = ?, home.floodId = ?, home.cityId = ?, home.postalCode = ?, home.postalCode = ?
            WHERE home.id=?
        ', [$stdClass->address, $stdClass->floodId, $stdClass->cityId, $stdClass->postalCode, $stdClass->postOfficeBox, $stdClass->id]);
        return $stdClass->id;
    }

    public function delete(int $id)
    {
        $this->query('DELETE FROM Home WHERE id = ?', [$id]);
    }
}