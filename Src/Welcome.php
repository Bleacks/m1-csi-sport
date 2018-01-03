<?php
# @Author: Maxime Dolet <Bleacks>
# @Date:   2018-01-03T23:13:43+01:00
# @Email:  maximed.contact@gmail.com
# @Last modified by:   Bleacks
# @Last modified time: 2018-01-04T01:26:12+01:00

Namespace Src;

/**
 * Wraps all actions related to the Welcome page
 * @method __construct()
 * @method getContent()
 */
class Welcome extends View
{

    /**
     * Constructor for the Welcome page
     */
    public function __construct()
    {

    }

    /**
    * Generates HTML code when sending get via welcome page
    * @return string $content HTML content of this specific page
    */
    public function getContent()
    {
        $content = "Bienvenue dans notre salle de sport";
        return $content;
    }
}

?>
