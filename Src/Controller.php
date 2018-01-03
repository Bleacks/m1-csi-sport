<?php
# @Author: Maxime Dolet <Bleacks>
# @Date:   2018-01-03T21:38:13+01:00
# @Email:  maximed.contact@gmail.com
# @Last modified by:   Bleacks
# @Last modified time: 2018-01-04T01:11:44+01:00

Namespace Src;

/**
* Controller of the website
* Links Database ans Views to index.php
* @method __construct()
* @method getController()
* @method welcomePage()
*/
class Controller
{
    /** @var Controller Singleton */
    private static $instance;

    /**
     * Private constructor of the Singleton
     */
    private function __construct()
    {

    }

    /**
     * Used to retrieve the unique instance of Controller (Singleton)
     * @return Controller Singleton
     */
    public function getController()
    {
        if (is_null(self::$instance))
            self::$instance = new Controller();
        return self::$instance;
    }

    /**
     * Creates and return the entire welcome page
     * @return string HTML code
     */
    public function welcomePage()
    {
        $view = new Welcome();
        $page = $view->getPage($content);
        return $page;
    }
}

?>
