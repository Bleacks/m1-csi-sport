<?php
# @Author: Maxime Dolet <Bleacks>
# @Date:   2018-01-03T22:44:36+01:00
# @Email:  maximed.contact@gmail.com
# @Last modified by:   bleacks
# @Last modified time: 2018-01-16T16:46:25+01:00

Namespace Sources\Views;

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

	/** Used to keep count of elements' id on the page */
	protected $id = 1;

    /** Color displayed on main elements (Primary color as Material Design describes it) */
	const PRIMARY_COLOR = 'teal lighten-1';

	/** Color displayed on secondary elements  (secondary color as Material Design describes it) */
	const SECONDARY_COLOR = 'orange lighten-1';

	/** Pages listed on website and accessible
	* Grouped by role
	* Sorted by acces right
	* Contains URI and associated name in Nav Bar */
	const ACCESSIBLE_PAGES = array(
		'Visitor'	=> array(
			0 => array('Connect', 'Connexion'),
			1 => array('Subscribe', 'Inscription'),
			2 => array('Activity', 'Activité des salles')
		),
		'Unpayed'	=> array(
			array('Disconnect', 'Déconnexion')
		),
		'User'		=> array(
			array('Planning', 'Planning'),
			array('History', 'Historique'),
			array('Activity', 'Activité'),
			array('Subscriptions', 'Abonnements'),
			array('Disconnect', 'Déconnexion')
		),
		'Coach'		=> array(
			array('Requests', 'Requêtes'),
			array('Activity', 'Activité'),
			array('Disconnect', 'Déconnexion')
		),
        'Employee'	=> array(
			array('Activity', 'Activité'),
			array('Disconnect', 'Déconnexion')
        ),
        'Admin' 	=> array(
			array('Activity', 'Activité'),
			array('Disconnect', 'Déconnexion')
		)
	);

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

		# TODO: Voir pour ajouter les scripts Materialize
		# FIXME: Changer le nom du site
		# TODO: Utile ? <base href="/m1-csi-sport/" />

		$page = '<!DOCTYPE html>
		<html>
		   <head>
			  <!--Initialize environment-->
			  <title>Salle de sport</title>
			  <META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">

			  <!--Let browser know website is optimized for mobile-->
			  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
		   </head>

		   <body class="loading">
			  '. $header
			   . '
			   <main>
				   <div class="container row">
				   '
				   . $content
				   . '
				   </div>
			   </main>
			   '
			   . $footer .'
		   </body>
		</html>';

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
        if (method_exists($this, $arguments[0])) {
        	$function = array($this, $arguments[0]);
            $content = call_user_func_array($function, $arguments);
            return $this->wrapPage($content);
        }
    }

	/**
	 * Generates HTML code of an input field using the given information
	 * @param  int	  $id    Id of the input field
	 * @param  string $type  Type of the input field
	 * @param  string $name  Name of the input field
	 * @param  string $label Label next to this input field
	 * @param  string $value Default value of this input field
	 * @return string        HTML code of the input field
	 */
	public function inputField(&$id, $type, $name, $label, $value = '')
	{
		if ($value != '')
			$value = ' value="'. $value .'" ';

		# TODO: Modifier pour pouvoir ajouter plusieurs inputs au même row (utiliser array + nbparam)
		$input =  '
		<div class="row">
			<div class="input-field col s6">
			  <input id="'. $id .'" type="'. $type .'" '.$value.' name="'. $name .'" required class="validate">
			  <label for="'. $id .'">'. $label .'</label>
		  	</div>
		</div>';

		$id++;
		return $input;
	}

	/**
	 * Generates HTML code of a form using the given informations
	 * @param  string $name    name of the form
	 * @param  string $content content of the form
	 * @param  string $method  method used on submit of the form
	 * @param  string $action  optional action of the form
	 * @return string          HTML code of the form
	 */
	public function form($name, $content, $method, $action = NULL)
	{
		# TODO: Voir si le paramètre action est vraiment utile, sinon le retirer
		if (isset($action))
			$action = 'action="'. $action .'"';

		$content = '
		<div class="row">
			<form class="col s12" enctype="application/json" method="'. $method .'" '. $action .'>
			    '. $content .'
				<input type="submit" value="Envoyer">
			</form>
		</div>';

        return $content;
	}
}

?>
