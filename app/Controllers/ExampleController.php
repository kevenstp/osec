<?php namespace Controllers;

use Models\Item;

class ExampleController extends Controller
{

    public function initializeRoutes()
    {
        $this->get("/", "index");
        $this->get("/items", "jsonTest");
    }

    public function index()
    {
        return $this->render('example', ["currentDate" => date('Y-m-d')]);
    }

    public function jsonTest()
    {
        $items = $this->buildItems();
        return $this->json($items);
    }

    /**
     * @return Item[]
     */
    private function buildItems(): array
    {
        $items = [];
        $item = new Item();
        $item->setId(1);
        $item->setName("Batarang");
        $item->setPrice(10.50);
        $items[] = $item;

        $item = new Item();
        $item->setId(2);
        $item->setName("Captain America Shield");
        $item->setPrice(400);
        $items[] = $item;

        $item = new Item();
        $item->setId(3);
        $item->setName("Thor Hammer");
        $item->setPrice(700);
        $items[] = $item;
        return $items;
    }
}
