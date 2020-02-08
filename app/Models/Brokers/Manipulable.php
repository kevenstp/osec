<?php


namespace Models\Brokers;


use stdClass;

interface Manipulable
{
    public function insert(stdClass $stdClass): string;
    public function update(stdClass $stdClass, $id): string;
    public function delete(int $id);
}