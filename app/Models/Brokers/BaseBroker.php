<?php


namespace Models\Brokers;

use Models\Brokers\Broker;
use Models\Brokers\Findable;
use Models\Brokers\Manipulable;

abstract class BaseBroker extends Broker implements Findable, Manipulable
{

    protected function load(array $row)
    {
        //?
        // TODO: Implement load() method.
    }
}