<?php
# @Author: Maxime Dolet <Bleacks>
# @Date:   2018-01-03T22:44:53+01:00
# @Email:  maximed.contact@gmail.com
# @Last modified by:   bleacks
# @Last modified time: 2018-01-14T18:30:29+01:00

Namespace Sources\Views;

/**
 * Wraps all actions related to the Connect page
 * @method __construct()
 * @method getContent()
 */
class Connect extends View
{

    /**
     * Constructor for the Connect page
     */
    public function __construct()
    {

    }

    /**
     * Generates HTML code when sending get via Connect page
     * @return string $content HTML content of this specific page
     */
    public function getContent()
    {
        $content = "Voici la page de connexion";
        return $content;
    }
}

?>
