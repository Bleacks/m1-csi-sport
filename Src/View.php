<?php
# @Author: Maxime Dolet <Bleacks>
# @Date:   2018-01-03T22:44:36+01:00
# @Email:  maximed.contact@gmail.com
# @Last modified by:   Bleacks
# @Last modified time: 2018-01-04T01:28:18+01:00


Namespace Src;

/**
 * Generic class for all Views
 * Wraps all common methods for page creation
 * All views inherits this class
 * @method wrapPage($content)
 * @method header()
 * @method footer()
 * @method __call($method, $arguments)
 */
abstract class View
{

    /** @var string Method called by the automatic page wrapper __call */
    private const METHOD = 'getContent';

    /**
     * Method called before each code return to the Controller
     * Used to wrap page content with header footer and common content
     * @param string $content Content of the page
     * @return string Final page with header footer and navbar
     */
    protected function wrapPage($content)
    {
        $header = $this->header();
        $footer = $this->footer();

        $page = $header .'
          <p>'. $content .'</p>'
        . $footer;

        return $page;
    }

    /**
     * Generates header common to all pages
     * @return string header of the website
     */
    private function header()
    {
        $header = "header";
        return $header;
    }

    /**
     * Generates footer common to all pages
     * @return string footer of the website
     */
    private function footer()
    {
        $footer = "footer";
        return $footer;
    }

    /**
     * Automatically called for each page creation
     * @param string $method Method failed to call
     * @param string $arguments Args of the associated method
     * @return string HTML code of the entire page
     */
    public function __call($method, $arguments) {
        if (method_exists($this, View::METHOD)) {
            $function = array($this, View::METHOD);
            $content = call_user_func_array($function, $arguments);
            return $this->wrapPage($content);
        }
    }
}

?>
