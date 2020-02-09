<?php


namespace Models\Brokers;


use Models\BaseBroker;
use stdClass;

class CityBroker extends BaseBroker
{


    public function findAll(): array
    {
        return $this->select('
            SELECT *
            FROM City city           
        ');
    }

    public function findById(int $id)
    {
        return $this->select('
            SELECT *
            FROM City city
            WHERE id = ?
        ', [$id]);
    }

    public function insert(stdClass $stdClass): string
    {
        $this->query('
            INSERT INTO City (name, province, weatherTimestamp) 
            VALUES (?,?, ?)
        ', [$stdClass->name, $stdClass->province, $stdClass->weatherTimestamp]);
        return $this->getDatabase()->getLastInsertedId();
    }

    public function update(stdClass $stdClass): string
    {
        $this->query('
            UPDATE City city 
            SET city.name=?, city.province=?, city.weatherTimestamp=?
            WHERE city.id=?
        ', [$stdClass->name, $stdClass->province, $stdClass->weatherTimestamp, $stdClass->id]);
        return $stdClass->id;
    }

    public function delete(int $id)
    {
        $this->query('DELETE FROM City WHERE id = ?', [$id]);
    }
}