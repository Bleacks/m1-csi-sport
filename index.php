<?php
# @Author: Maxime Dolet <Bleacks>
# @Date:   2018-01-03T21:26:03+01:00
# @Email:  maximed.contact@gmail.com
# @Last modified by:   bleacks
# @Last modified time: 2018-01-16T21:08:34+01:00

/* Memento HTTP

200 : Success

401 : Unauthorized (unauthenticated)
403 : Access denied
404 : Not found
405 : Method not allowed
409 : Conflict

422 : Unprocessable entry
424 : Method failure
429 : Too many request

500 : Internal server error
*/

######
# Imports
######

Require_once "vendor/autoload.php";

Use Slim\App;
Use Psr\Http\Message\ServerRequestInterface;
Use Psr\Http\Message\ResponseInterface;
Use Sources\Controller;
Use Sources\DBConnectors\MainDBConnector;


######
# Global constants declaration
######

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

/** Method called by the automatic page wrapper __call */
const GET_METHOD = 'getContent';

/** Method called by the automatic page wrapper __call */
const POST_METHOD = 'postContent';

/** Method called by the automatic page wrapper __call */
const ERROR_METHOD = 'errorContent';


######
# Functions declaration
######

/**
 * Middleware which verifies that the asked URI can be accessed with the actual account and associated rights
 * Redirects the user to a default URI otherwise
 * @param  ServerRequestInterface $request
 * @param  ResponseInterface      $response
 * @param  Callable               $next
 * @return ResponseInterface      Status code and page
 */
function verifyURIAccessibility(ServerRequestInterface $request, ResponseInterface $response, Callable $next)
{
	$url = $request->getUri()->getPath();
	$path = $request->getUri()->getBasePath().'/Connect';
	# FIXME: Ajouter le support pour les URI complexes /*/*
	$code = 404;
	$right = 'Visitor';

	if (strpos($url, '/') !== false)
		$url = explode('/', $url)[1];

	if (isset($_SESSION['right']))
		$right = $_SESSION['right'];

	if (array_key_exists($right, ACCESSIBLE_PAGES))
	{
		foreach (ACCESSIBLE_PAGES[$right] as $value) {
			if ($value[0] == $url)
				return $next($request, $response);
		}
	}
	else {

	}
	return $response->withRedirect($path, $code);
}


######
# Main execution
######

session_start();


// Initalisaton de Slim
$app = new App([
    'settings' => [
        'determineRouteBeforeAppMiddleware' => true,
        'addContentLengthHeader' => false,
        'displayErrorDetails' => true
    ]
]);

// Liaison avec le Middleware
$app->add(function($request, $response, $next) {
	$res = verifyURIAccessibility($request, $response, $next);
	return $response;
});

/*
Exemple générique de traitement d'une page
[URL] : Url de la page depuis la racine du site : "tes/trucs/perso/m1-csi-sport/[URL]"
Les deux paramètres suivants sont nécessaires au fonctionnement de Slim
$app->get('/[URL]', function (ServerRequestInterface $request, ResponseInterface $response)
{
    // $code = $controller->welcomePage(); IMPOSSIBLE
    // Ici le contexte n'est plus celui de 'index.php' mais celui de
        // la fonction anonyme passée en paramètre à Slim
        // il faut donc utiliser le SINGLETON
    $controller = Controller::getController();

    // Corps de la fonction
    // Appel de la fonction du controleur qui doit gérer l'action à effectuer
    $page = $controller->welcomePage();


    // Pour le debug
    // var_dump($code);

    // On retourne le code HTML de la page
    // Éventuellement le code d'erreur associé (Défaut 200 : succès)
    return [CODE_HTML, [CODE_RETOUR_HTTP]] (cf. Documentation #RTFM)
});
*/

// Génération du handler de la page d'accueil
$app->get('/', function (ServerRequestInterface $request, ResponseInterface $response)
{
    $controller = Controller::getController();
    $page = $controller->welcomePage(GET_METHOD);
    return $page;
});

// Génération du handler de la page de connexion
$app->get('/Connect', function (ServerRequestInterface $request, ResponseInterface $response)
{
    $controller = Controller::getController();
    $page = $controller->connectPage(GET_METHOD);
    return $page;
});

// Génération du handler de la page d'accueil
$app->get('/Subscribe', function(ServerRequestInterface $request, ResponseInterface $response)
{
    $controller = Controller::getController();
    $page = $controller->subscribePage(GET_METHOD);
    return $page;
});

# FIXME: Finir le post de Subscribe
$app->post('/Subscribe', function(ServerRequestInterface $request, ResponseInterface $response)
{
	$post = $request->getParsedBody();

	# TODO: Trouver un moyen de factoriser l'obtention du connecteur
	$connector = MainDBConnector::getInstance();

	$res = $connector->subscribeUser($post);

	$controller = Controller::getController();
	$page = $response->getBody();

	if ($res)
	{
		$page->write($controller->subscribePage(POST_METHOD));
		$response = $response->withStatus(200);
	} else
	{
		$page->write($controller->subscribePage(ERROR_METHOD));
		$response = $response->withStatus(409);
	}

    return $response;
});

# TODO: Possibilité de mettre une alerte sur une séance pour un adhérent
# TODO: Vérifier avant chaque action que l'utilisateur en cours à bien les droits suffisants

// Nécessaire pour que l'API Slim puisse fonctionner
$app->run();

?>
