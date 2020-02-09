<?php


namespace Models\Brokers;


use stdClass;

class FormBroker extends BaseBroker
{


    public function findAll(): array
    {
        return $this->select('
            SELECT *
            FROM Form form           
        ');
    }

    public function findById(int $id)
    {
        return $this->select('
            SELECT *
            FROM Form form
            WHERE id = ?
        ', [$id]);
    }

    public function insert(stdClass $param): string
    {

        return $this->getDatabase()->getLastInsertedId();
    }

    public function update(stdClass $stdClass): string
    {
        //todo
        return $stdClass->id;
    }

    public function delete(int $id)
    {
        $this->query('DELETE FROM Form WHERE id = ?', [$id]);
    }
}