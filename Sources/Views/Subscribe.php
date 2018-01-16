<?php
# @Author: Maxime Dolet <Bleacks>
# @Date:   2018-01-03T22:44:53+01:00
# @Email:  maximed.contact@gmail.com
# @Last modified by:   bleacks
# @Last modified time: 2018-01-16T16:25:12+01:00

Namespace Sources\Views;

/**
 * Wraps all actions related to the Subscribe page
 * @method __construct()
 * @method getContent()
 */
class Subscribe extends View
{

    /**
     * Constructor for the Subscribe page
     */
    public function __construct()
    {

    }

    /**
     * Generates HTML code when sending get via Subscribe page
     * Automatically called by function __call
     * @return string HTML content of this specific page
     */
    public function getContent()
    {
		# TODO: Ajouter le support pour un tableau d'arguments
		# TODO: Ajouter la possiblité de fournir des options supplémentaires
		$formContent = parent::inputField($this->id, 'text', 'first', 'Prénom', 'Maxime');
		$formContent .= parent::inputField($this->id, 'text', 'last', 'Nom', 'Dolet');
		$formContent .= parent::inputField($this->id, 'date', 'birth', 'Date de naissance', '1995-09-14');
		$formContent .= parent::inputField($this->id, 'tel', 'phone', 'Téléphone', '1234567890');
		$formContent .= parent::inputField($this->id, 'mail', 'mail', 'Email', 'maxime.dolet8@etu.univ-lorraine.fr');
		$formContent .= parent::inputField($this->id, 'password', 'pass', 'Mot de passe', 'max1409');

		$content = parent::form('subscribe', $formContent, 'post');

        return $content;
    }

	/**
	 * Generates HTML code when sending succesfull post request via Subscribe page
	 * Automatically called by function __call
	 * @return string HTML content of this specific page
	 */
	public function postContent()
	{
		$content = '
		<h1>Inscription effectuée avec succès</h1>
		<p>Vous pouvez à présent vous connecter et payer vos frais d\'inscription</p>';
		return $content;
	}

	/**
	 * Generates HTML code when sending unsuccesfull post request via Subscribe page
	 * Automatically called by function __call
	 * @return string HTML content of this specific page
	 */
	public function errorContent()
	{
		$content = '
		<h1>Problème lors de l\'inscription</h1>
		<p>Votre adresse mail est déjà utilisée</p>';
		return $content;
	}
}

?>
