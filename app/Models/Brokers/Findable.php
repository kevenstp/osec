<?php


namespace Models\Brokers;


interface Findable
{
    public function findAll(): array;
    public function findById(int $id);
}