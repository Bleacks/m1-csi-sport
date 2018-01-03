<?php
# @Author: Maxime Dolet <Bleacks>
# @Date:   2018-01-03T21:26:03+01:00
# @Email:  maximed.contact@gmail.com
# @Last modified by:   Bleacks
# @Last modified time: 2018-01-04T01:31:38+01:00

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

require_once "vendor/autoload.php";

use Slim\App;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Message\ResponseInterface;
use Src\Controller;

// Initalisaton de Slim
$app = new App([
    'settings' => [
        'determineRouteBeforeAppMiddleware' => true,
        'addContentLengthHeader' => false,
        'displayErrorDetails' => true
    ]
]);

// Si on veut utiliser les cookies de connexion
// session_start();

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
    $page = $controller->welcomePage();
    return $page;
});

// Nécessaire pour que l'API Slim puisse fonctionner
$app->run();

?>
