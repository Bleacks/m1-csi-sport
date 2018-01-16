<?php
# @Author: Maxime Dolet <Bleacks>
# @Date:   2018-01-03T21:26:03+01:00
# @Email:  maximed.contact@gmail.com
# @Last modified by:   bleacks
# @Last modified time: 2018-01-16T16:46:24+01:00

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

# TODO: Revoir le fonctionnement pour réunir ACCESSIBLE_PAGES de View avec ces array
/** Lists all accessible pages for visitor users */
const PUBLIC_URI_ARRAY = array(
	'Connect',
	'Subscribe',
	'Activity',
	'Kill',
	'Test',
	'/'
);

# TODO: Faire la documentation
# TODO: Voir avec Benoit pour le niveau des droits (retourne un int pour les fonctions)
const RIGHTS = array(
	'Visitor'
);

/** Lists all accessible pages for authentified users */
const PRIVATE_URI_ARRAY = array('Disconnect');

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
function verifyURIAccessibility(ServerRequestInterface $request, $response, $next)
{
	if (isset($request) && isset($response) && isset($next))
	{
		$url = $request->getUri()->getPath();
		# $path = $request->getUri()->getBasePath().'/Connect'; # TODO: Comprendre
		$path = $request->getUri()->getBasePath().'/Connect';
		$code = 404;

		if (strpos($url, '/') !== false)
			$url = explode('/', $url)[0];

		if (in_array($url, PRIVATE_URI_ARRAY))
		{
			$db = Database::getInstance();
			if (isset($_SESSION['token']))
			{
				if ($db->verifyConnectionToken($_SESSION['token']))
				{
					return $next($request, $response);
				} else
				{
					unset($_SESSION['token']);
				}
			}
			$_SESSION['url'] = $request->getUri()->getPath();

			$code = 403;
		} else
		{
			# TODO: Voir pour changer par une page not found générique intégrée au site
			if (in_array($url, PUBLIC_URI_ARRAY))
				return $next($request, $response);
			else
				$path = $request->getUri()->getBasePath();
		}
		$response = $response->withRedirect($path, $code);
	}
	return $response;
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
/*$app->add(function($request, $response, $next) {
	#var_dump(array($request, $response, $next));
	var_dump(verifyURIAccessibility($request, $response, $next));
	var_dump(text());
	#return $response;
});*/

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
