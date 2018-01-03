<?php
# @Author: Maxime Dolet <Bleacks>
# @Date:   2018-01-03T22:44:53+01:00
# @Email:  maximed.contact@gmail.com
# @Last modified by:   Bleacks
# @Last modified time: 2018-01-04T01:26:20+01:00

Namespace Src;

/*
Template class for all Views (pages)
One class for each different URL
Generic TODO: Edit
*/

/**
 * Wraps all actions related to the [Page] page
 * @method __construct()
 * @method getContent()
 */
class TemplateView extends View
{

    /**
     * Constructor for the [Page] page
     */
    public function __construct()
    {

    }

    /**
     * Generates HTML code when sending get via [Page] page
     * @return string $content HTML content of this specific page
     */
    public function getContent()
    {
        $content = "[Change]";
        return $content;
    }
}

?>
