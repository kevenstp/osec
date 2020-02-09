<?php


namespace Models\Brokers;

use stdClass;

class FloodBroker extends BaseBroker
{


    public function findAll(): array
    {
        return $this->select('
            SELECT *
            FROM Flood flood           
        ');
    }

    public function findById(int $id)
    {
        return $this->select('
            SELECT *
            FROM Flood flood
            WHERE id = ?
        ', [$id]);
    }

    public function insert(stdClass $stdClass): string
    {
        $this->query('
            INSERT INTO Flood (waterLevel) 
            VALUES (?)
        ', [$stdClass->waterLevel]);
        return $this->getDatabase()->getLastInsertedId();
    }

    public function update(stdClass $stdClass): string
    {
        $this->query('
            UPDATE Flood flood 
            SET flood.waterLevel=?
            WHERE flood.id=?
        ', [$stdClass->waterLevel, $stdClass->id]);
        return $stdClass->id;
    }

    public function delete(int $id)
    {
        $this->query('DELETE FROM Flood WHERE id = ?', [$id]);
    }
}