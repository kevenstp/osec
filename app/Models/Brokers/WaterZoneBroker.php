<?php


namespace Models\Brokers;


use Models\BaseBroker;
use stdClass;

class WaterZoneBroker extends BaseBroker
{


    public function findAll(): array
    {
        return $this->select('
            SELECT *
            FROM WaterZone waterZone           
        ');
    }

    public function findById(int $id)
    {
        return $this->select('
            SELECT *
            FROM WaterZone waterZone
            WHERE id = ?
        ', [$id]);
    }

    public function insert(stdClass $stdClass): string
    {
        $this->query('
            INSERT INTO WaterZone (name, waterLevel) 
            VALUES (?, ?)
        ', [$stdClass->name, $stdClass->waterLevel]);
        return $this->getDatabase()->getLastInsertedId();
    }

    public function update(stdClass $stdClass): string
    {
        $this->query('
            UPDATE WaterZone waterZone 
            SET waterZone.name = ?, waterZone.waterLevel=?
            WHERE waterZone.id=?
        ', [$stdClass->name, $stdClass->waterLevel, $stdClass->id]);
        return $stdClass->id;
    }

    public function delete(int $id)
    {
        $this->query('DELETE FROM WaterZone WHERE id = ?', [$id]);
    }
}