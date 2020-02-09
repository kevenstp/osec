<?php


namespace Models\Brokers;


use Models\BaseBroker;
use stdClass;

class BillboardBroker extends BaseBroker
{

    public function findAll(): array
    {
        return $this->select('
            SELECT *
            FROM BillboardPost
        ');
    }

    public function findById(int $id)
    {
        return $this->selectSingle('
            SELECT * 
            FROM BillboardPost bp 
            WHERE bp.id = ?
            ' ,[$id]);
    }

    public function insert(stdClass $stdClass): string
    {
        $this->query('
            INSERT INTO BillboardPost (id, userId, content, datetime) 
            VALUES (NULL, ?, ?, CURRENT_TIMESTAMP);
            ', [$stdClass->id, $stdClass->content]);
    }

    public function update(stdClass $stdClass): string
    {
        $this->query('
            UPDATE BillboardPost 
            SET content = ?, datetime = CURRENT_TIMESTAMP 
            WHERE BillboardPost.id = ?;
            ',[$stdClass->id]);
    }

    public function delete(int $id)
    {
        $this->query('DELETE FROM BillboardPost WHERE id = ?', [$id]);
    }
}