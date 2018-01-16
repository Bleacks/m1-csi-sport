<?php
# @Author: Maxime Dolet <Bleacks>
# @Date:   2018-01-03T22:44:36+01:00
# @Email:  maximed.contact@gmail.com
# @Last modified by:   bleacks
# @Last modified time: 2018-01-16T21:16:07+01:00

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
			  
			  <!--Import Google Icon Font-->
			  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

			  <!--Import materialize.css-->
			  <link type="text/css" rel="stylesheet" href="../../materialize/css/materialize.min.css" media="screen,projection">

			  <!--Import personnal CSS File-->
			  <link type="text/css" rel="stylesheet" href="../../materialize/css/footer.css" media="screen,projection">

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
			   <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.4.min.js"></script>
			   <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/jquery-ui.min.js"></script>
			   <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.98.2/js/materialize.min.js"></script>
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
        $header = $this->navBar();
        return $header;
    }

    /**
     * Generates footer common to all pages
     * @return string footer of the website
     */
    private function footer()
    {
        $footer = '
  <footer class="page-footer '.Self::PRIMARY_COLOR.'">
  	<div class="container">
      	<div class="row">
  			<div class="col l6 s12">
  				<h5 class="flow-text white-text">Salle de sport</h5>
  				<p class="grey-text text-lighten-4">Desciption</p>
  			</div>

  			<div class="col l4 offset-l2 s12">
  				<h5 class="white-text">Collaborateurs</h5>
  				<ul hidden>
  					<li><a class="grey-text text-lighten-3" href="#!">Maxime Dolet</a></li>
  					<li><a class="grey-text text-lighten-3" href="#!">Benoit Cante</a></li>
  					<li><a class="grey-text text-lighten-3" href="#!">Nicolas Calley</a></li>
  					<li><a class="grey-text text-lighten-3" href="#!">Abdoulaye Diallo</a></li>
  				</ul>
  			</div>
  		</div>
  	</div>

  	<div class="footer-copyright">
  		<div class="container">
  			© 2017 Copyright Text
  			<a class="grey-text text-lighten-4 right" href="https://www.list.lu/">LIST</a>
  		</div>
  	</div>
  </footer>';
        return $footer;
    }

	/**
	 * Generates global navbar of the website
	 * @return string HTML Code of the navBar
	 */
	private function navBar()
	{
		$navBarContent = '';
		$pages = array();

		if (isset($_SESSION['right']) && array_key_exists($_SESSION['right'], ACCESSIBLE_PAGES)){
			$pages = ACCESSIBLE_PAGES[$_SESSION['right']];
		}
		else {
			$pages = ACCESSIBLE_PAGES['Visitor'];
		}

		foreach ($pages as $page) {
			$navBarContent .= '
			<li>
				<a class="flow-text" href='.$page[0].'>'
				.$page[1].'</a>
			</li>
			';
		}

		$navBar = '
<header>
	<nav class="'.Self::PRIMARY_COLOR.'">
    	<div class="nav-wrapper">
      		<a href="/" class="brand-logo">Salle de sport</a>
			<a href="#" data-activates="mobile-demo" class="button-collapse"><i class="material-icons">menu</i></a>
			<ul id="nav-mobile" class="right hide-on-med-and-down">
			'. $navBarContent .'
			</ul>
		</div>
	</nav>
</header>';

		return $navBar;
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
				<button id="send" class="btn waves-effect waves-light" type="submit" onclick="'.$onclickHandler.'">
					<input type="submit">
			   		<i class="material-icons right">send</i>
			   	</button>
			</form>
		</div>';

        return $content;
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
}

?>
