<?php


namespace Models\Brokers;


use stdClass;

class WeatherBroker extends BaseBroker
{


    public function findAll(): array
    {
        return $this->select('
            SELECT *
            FROM Weather weather           
        ');
    }

    public function findById(int $id)
    {
        return $this->select('
            SELECT *
            FROM Weather weather
            WHERE `timestamp` = ?
        ', [$id]);
    }

    public function insert(stdClass $stdClass): string
    {
        //todo
        return $this->getDatabase()->getLastInsertedId();
    }

    public function update(stdClass $stdClass): string
    {
        //todo
        return $stdClass->id;
    }

    public function delete(int $timestamp)
    {
        $this->query('DELETE FROM Weather WHERE `timestamp` = ?', [$timestamp]);
    }
}