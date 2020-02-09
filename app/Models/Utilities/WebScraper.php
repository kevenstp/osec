<?php namespace Models\Utilities;

use http\Env\Response;
use Http\Message\ResponseFactory;

class WebScraper
{
    public function __WebScraper()
    {

    }

    private function getDOM(string $url) : \DOMDocument
    {
        libxml_use_internal_errors(true);
        $dom = new \DOMDocument();
        $dom->loadHTMLFile($url);
        return $dom;
    }

    /**
     *  Surveillance de la crue des eaux;
     */

    public function getSurveillance()
    {
        $url = "https://geoegl.msp.gouv.qc.ca/adnv2/";
        $dom = $this->getDOM($url);
        $rows = $this->getRows($dom);
        return $rows;
    }

    private function getRows(\DOMDocument $dom) : \stdClass
    {
        $result = array();
        $items = $this->fetchTableRows($dom);
        $objects = array_chunk($items, 8);
        foreach($objects as $object) {
            array_push($result, $this->createRow($object));
        }
        return (object) $result;
    }

    private function createRow($row) : array
    {
        $attributes = array("Plan d'eau", "Lieu d'observation", "État",
            "Tendance", "Variable hydrologique", "SIM", "Dernière mesure", "Numéro de station" );
        $result = array();
        for($i = 0; $i < count($row); ++$i) {
            $result[$attributes[$i]] = $row[$i]->textContent;
        }
        return $result;
    }

    private function fetchTableRows( \DOMDocument $dom) : array {
        $items = iterator_to_array($dom->getElementsByTagName('td'));
        array_shift($items);
        return $items;
    }
}
